old_rules_with = {}
old_rules_with = {}

function clearRules()
  local temp = {}
  if timeless and full_rules then
    addUndo({"timeless_rules", rules_with, full_rules})
    if rules_with["zawarudo"] then
      for _,text in ipairs(getAllText()) do
        if hasProperty(text, "zawarudo") then
          text.zawarudo = true
        else
          text.zawarudo = false
        end
      end
    end
    for _,rule in ipairs(full_rules) do
      if not rule.hide_in_list then
        local any_timeless = false
        for _,unit in ipairs(rule.units) do
          if unit.zawarudo then
            any_timeless = true
            break
          end
        end
        if not any_timeless then
          table.insert(temp, rule)
        end
      end
    end
  end
  full_rules = temp
  
  old_rules_with = rules_with
  rules_with = {}
  rules_with_unit = {}
  not_rules = {}
  protect_rules = {}

  max_not_rules = 0
  portal_id = ""

  --text and level basically already exist, so no need to be picky.
  addBaseRule("txt","be","wurd")
  addBaseRule("txt","be","goawaypls")
  addBaseRule("lvl","be","nogo")
  --TODO: This will need to be automatic on levels with letters/combined words, since a selectr/bordr might be made in a surprising way, and it will need to have its implicit rules apply immediately.
  if (units_by_name["selctr"] or units_by_name["txt_selctr"] or units_by_name["lin"] or units_by_name["txt_lin"] or units_by_name["txt_pathz"]) then
    addBaseRule("selctr","be","curse")
    addBaseRule("selctr","be","shy...")
    --[[addBaseRule("selctr","be","u")
    addBaseRule("selctr","liek","pathz")
    addBaseRule("lvl","be","pathz",{name = "unlocked"})
		addBaseRule("lin","be","pathz",{name = "unlocked"})
    addBaseRule("selctr","be","flye")
    addBaseRule("selctr","be","shy...")]]
  end
  if (units_by_name["bordr"] or units_by_name["txt_bordr"]) then
    addBaseRule("bordr","be","nogo")
    addBaseRule("bordr","be","tall")
    addBaseRule("bordr","be","anti tall")
    addBaseRule("bordr","be","tranparnt")
  end
  addBaseRule("bordr","be","nodrag") --it's important for this to be outside the check bc you can get mous outside level without bordr existing
  if units_by_name["this"] then
    --have to do this now for the same reason we have to do it for "txt" - poor timing
    rules_effecting_names["this"] = true
    addBaseRule("this","be","goawaypls")
    addBaseRule("this","be","wurd")
  end

  if not doing_past_turns then
    past_rules = {}
  else
    for id,past_rule in pairs(past_rules) do
      if past_rule.turn > current_move then
        addRule(past_rule.rule)
      end
    end
  end

  rules_effecting_names["txt"] = true

  has_new_rule = false
end

function getAllText()
  local hasCopied = false
  local result = {}
  --[[local result = units_by_name["txt"]
  if (result == nil) then result = {} end
  --remove ben't wurd text from result
  if rules_with["wurd"] ~= nil then
    result = copyTable(result)
    hasCopied = true
    for i = #result,1,-1 do
      if hasRule(result[i],"ben't","wurd") then
        table.remove(result, i)
      end
    end
  end]]
  
  local givers = {}
  
  if rules_with ~= nil and rules_with["giv"] ~= nil then
    for unit,_ in pairs(getUnitsWithRuleAndCount(nil, "giv", "wurd")) do
      table.insert(givers, units_by_id[unit] or cursors_by_id[unit])
    end
    for unit,_ in pairs(getUnitsWithRuleAndCount(nil, "giv", "anti wurd")) do
      table.insert(givers, units_by_id[unit] or cursors_by_id[unit])
    end
  end
  
  local function matchesGiver(unit, givers)
    for _,giver in ipairs(givers) do
      if giver ~= unit and giver.x == unit.x and giver.y == unit.y and sameFloat(unit, giver) then
        return true
      end
    end
    return false
  end
  
  if (#givers > 0) then
    for __,unit in ipairs(units) do
      if hasProperty(unit, "wurd") or hasProperty(unit,"anti wurd") or unit.name:starts("this") or matchesGiver(unit, givers) then
        if not hasCopied then
          result = copyTable(result)
          hasCopied = true
        end
        table.insert(result, unit)
      else
        unit.active = false
      end
    end
  else
    for name,_ in pairs(rules_effecting_names) do
      if units_by_name[name] then
        for __,unit in ipairs(units_by_name[name]) do
          if hasProperty(unit, "wurd") or hasProperty(unit, "anti wurd") or unit.name:starts("this") then
            if not hasCopied then
              result = copyTable(result)
              hasCopied = true
            end
            table.insert(result, unit)
          else
            unit.active = false
          end
        end
      end
    end
  end
  return result
end

function getTextOnTile(x, y)
  local result = {}
  --[[local result = getUnitsOnTile(x, y, "txt")
  --remove ben't wurd text from result
  if rules_with ~= nil and rules_with["wurd"] ~= nil then
    for i = #result,1,-1 do
      if hasRule(result[i],"ben't","wurd") then
        table.remove(result, i)
      end
    end
  end]]
  
  local givers = {}
  
  if rules_with ~= nil and rules_with["giv"] ~= nil then
    for __,unit in ipairs(getUnitsOnTile(x, y)) do
      if hasRule(unit, "giv", "wurd") or hasRule(unit, "giv", "anti wurd") then
        table.insert(givers, unit)
      end
    end
  end
  
  if (#givers > 0) then
    for __,unit in ipairs(getUnitsOnTile(x, y)) do
      if hasProperty(unit, "wurd") or hasProperty(unit, "anti wurd") or unit.name:starts("this") then
        table.insert(result, unit)
      else
        for _,giver in ipairs(givers) do
          if giver ~= unit and sameFloat(giver, unit) then
            table.insert(result, unit)
            break
          end
        end
      end
    end
  else
    for name,_ in pairs(rules_effecting_names) do
      for __,unit in ipairs(getUnitsOnTile(x, y, {name = name})) do
        if hasProperty(unit, "wurd") or hasProperty(unit, "anti wurd") or unit.name:starts("this") then
          table.insert(result, unit)
        end
      end
    end
  end
  
  return result
end

function parseRules(undoing)
  if timeless and not hasProperty("txt","zawarudo") then
    return
  end
  if (should_parse_rules) then
    should_parse_rules = false
    should_parse_rules_at_turn_boundary = false
  else
    return
  end
  
  local start_time = love.timer.getTime()
  
  clearRules()
  loop_rules = 0
  changed_reparsing_rule = true

  -- since txt is now inherently wurd, the rules table has to update with the base rules before we do any actual parsing
  postRules(true)
  
  --TODO: This works in non-contrived examples, but isn't necessarily robust - for example, if after reparsing, you add one word rule while subtracting another word rule, it'll think nothing has changed. The only way to be ABSOLUTELY robust is to compare that the exact set of parsing effecting rules hasn't changed.
  local function reparseRuleCounts()
    local props_table = {"wurd", "anti wurd", "poortoll", "goarnd", "mirrarnd", "ortho", "diag", "zawarudo", "rong", "slep"}
    local verbs_table = {"be", "giv"}
    local result = {}
    for _,prop in ipairs(props_table) do
      for __,verb in ipairs(verbs_table) do
        table.insert(result, #matchesRule(nil, verb, prop))
      end
    end
    --Text that ben't wurd is a special case.
    table.insert(result, #matchesRule(nil, "ben't", "wurd"))
    --txt/wurds ignoring a poor toll could cause parsing to change.
    table.insert(result, rules_with["poortoll"] and #matchesRule(nil, "ignor", nil) or 0)
    --RP can cause a parse effecting rule to be RP'd. (TODO: For mysterious reasons, this doesn't work with wurd.)
    table.insert(result, #matchesRule(nil, "rp", "?"))
    return result
  end
  
  local reparse_rule_counts = reparseRuleCounts()
  
  --Hack for OOB rules to make them not alias onto each other surprisingly: assume mapwidth is 100 or higher, so that different co-ordinates are different unless you go STUPIDLY out of bounds
  local mapwidth_hack = math.max(mapwidth, 100);
  
  while (changed_reparsing_rule) do
    changed_reparsing_rule = false
    loop_rules = loop_rules + 1
    if (loop_rules > 100) then
      destroyLevel("infloop")
      return
    end

    --refresh name/type/color of dittos in reading order (top to bottom)
    local dittos = units_by_name["txt_''"]
    if (dittos ~= nil) then
      table.sort(dittos, function(a, b) return a.y < b.y end ) 
      for _,unit in ipairs(dittos) do
        local dir = dirAdd(unit.rotatdir,-2)
        local dx, dy = dirs8[dir][1], dirs8[dir][2]
        local _, __, ___, x, y = getNextTile(unit,dx,dy,dir)
        local mimic = getTextOnTile(x,y)
        
        if #mimic == 1 then
          unit.textname = mimic[1].textname
          unit.typeset = mimic[1].typeset
          unit.color_override = getUnitColor(mimic[1])
        else
          unit.textname = "  "
          unit.typeset = {ditto = true}
          unit.color_override = {0,3}
        end
      end
    end
  
    local first_words = {}
    local been_first = {}
    for i=1,8 do
      been_first[i] = {}
    end
    
    local units_to_check = getAllText()
    
    if units_to_check then
      for _,unit in ipairs(units_to_check) do
        local x,y = unit.x,unit.y
        local dirs_to_check = {}
        if not rules_with["anti wurd"] or hasProperty(unit,"wurd") then
          mergeTable(dirs_to_check,{1,2,3})
        end
        if hasProperty(unit,"anti wurd") then
          mergeTable(dirs_to_check,{5,6,7})
        end
        for _,i in ipairs(dirs_to_check) do
          local dpos = dirs8[i]
          local ndpos = dirs8[rotate8(i)] --opposite direction

          local dx,dy = dpos[1],dpos[2]
          local ndx,ndy = ndpos[1],ndpos[2]
          
          local validrule = true
          
          if (i % 2 == 1) and hasRule(unit,"be","diag") and not hasRule(unit,"be","ortho") then
            validrule = false
          end
          
          if (i % 2 == 0) and (unit.wobble or hasRule(unit,"be","ortho")) and not hasRule(unit,"be","diag") then
            validrule = false
          end
          --print(tostring(x)..","..tostring(y)..","..tostring(dx)..","..tostring(dy)..","..tostring(ndx)..","..tostring(ndy)..","..tostring(#getUnitsOnTile(x+ndx, y+ndy, "txt"))..","..tostring(#getUnitsOnTile(x+dx, y+dy, "txt")))
          if (#getTextOnTile(x+ndx, y+ndy) == 0) and validrule then
            if not been_first[i][x + y * mapwidth_hack] then
              table.insert(first_words, {unit, i})
              been_first[i][x + y * mapwidth_hack] = true
            end
          end
        end
        if (loop_rules == 1) then
          unit.old_active = unit.active
        end
        local temp = rules_with
        rules_with = old_rules_with
        if not timeless or unit.zawarudo then
          unit.active = false
          unit.blocked = false
          unit.used_as = {}
        end
        rules_with = temp
      end
    end

    local final_rules = {}
    --local already_parsed = {}
    local first_words_count = #first_words
    for _,first in ipairs(first_words) do 
      local first_unit = first[1] -- {unit,direction}
      local last_unit = first[1]

      local dir = first[2]
      local x,y = first_unit.x, first_unit.y
      local dx,dy = dirs8[dir][1], dirs8[dir][2]

      local words = {}
      local been_here = {}

      local stopped = false
      while not stopped do
        if been_here[x + y * mapwidth_hack] == 2 then
          stopped = true
        else
          local new_words = {}
          local get_next_later = false

          local units = getTextOnTile(x, y)
          if #units > 0 then
            for _,unit in ipairs(units) do
              local validrule = true

              if ((dir == 1) or (dir == 3)) and hasRule(unit,"be","diag") and not hasRule(unit,"be","ortho") then
                validrule = false  
              end
              
              if (dir == 2) and (unit.wobble or hasRule(unit,"be","ortho")) and not hasRule(unit,"be","diag") then
                validrule = false
              end

              if validrule then
                local new_word = {}

                new_word.name = unit.textname
                new_word.type = unit.typeset
                new_word.unit = unit
                new_word.dir = dir

                last_unit = unit

                table.insert(new_words, new_word)
              end
            end

            if #new_words == 0 then
              stopped = true
            else
              table.insert(words, new_words)
            end
          else
            stopped = true
          end

          if not been_here[x + y * mapwidth_hack] then --can only go to each tile twice each first word; so that if we have a wrap/portal infinite loop we don't softlock
            been_here[x + y * mapwidth_hack] = 1
          else
            been_here[x + y * mapwidth_hack] = 2
          end

          dx, dy, dir, x, y = getNextTile(last_unit, dx, dy, dir)
        end
      end --while not stopped

      local sentences = getCombinations(words)
      if #sentences > 10 then
        --print(fullDump(words, 2))
      end

      for _,sentence in ipairs(sentences) do
        parseSentence(sentence, {been_first, first_words, final_rules, first}, dir) -- split into a new function located below to organize this slightly more
        if (#final_rules > 1000) then
          print("parseRules too complex! (1000 rules)")
          destroyLevel("plsdont")
          clearRules()
          return
        end
      end
    end
    
    clearRules()
    
    for _,final in ipairs(final_rules) do
      addRule(final)
    end
    
    postRules()
    
    local reparse_rule_counts_new = reparseRuleCounts()
    
    for i = 1,#reparse_rule_counts do
      if reparse_rule_counts[i] ~= reparse_rule_counts_new[i] then
        changed_reparsing_rule = true
        break
      end
    end
    
    reparse_rule_counts = reparse_rule_counts_new
    
    rules_effecting_names = {}
  
    populateRulesEffectingNames("?", "be", "wurd")
    populateRulesEffectingNames("?", "be", "anti wurd")
    populateRulesEffectingNames("?", "be", "poortoll")
    if (rules_with["goarnd"] or rules_with["mirrarnd"]) then
      rules_effecting_names["bordr"] = true
    end
  end
  
  shouldReparseRules()
  
  local end_time = love.timer.getTime()
  if not unit_tests then print("parseRules() took: "..tostring(round((end_time-start_time)*1000)).."ms") end
end

function parseSentence(sentence_, params_, dir) --prob make this a local function? idk
  -- print("parsing... "..fullDump(sentence_))
  local been_first = params_[1] --splitting up the params like this was because i was too lazy
  local first_words = params_[2] -- all of them are tables anyway, so it ends up referencing properly
  local final_rules = params_[3]
  local first = params_[4]
  local sentence = copyTable(sentence_, 1)
  --print(fullDump(sentence))

  for orig_index,word in ipairs(sentence) do
    --HACK: don't try to do letters parsing if we're singing
    if word.name == "sing" then break end
    if word.type and word.type["letter"] then --letter handling
      --print("found a letter"..orig_index)
      
      local new_word = ""
      local word_index = orig_index
      local letter = sentence[word_index]
      local prevletter = {}
      while letter.type["letter"] do --find out where the letters end, throw all of them into a string tho
        --here's how umlauts / colons work: for every letter that could be affected by the presence of a colon, special case it here
        --when special casing, change the name to include the umlaut / colon in it. then, later, don't count colons when adding to the string, since the letter already accounts for it
        --for the letter u, it always needs to check the tile above it, so we don't need to use prevletter, since the umlaut might not be in the rule directly
        --for letters relating to making a face, such as ":)", the colon needs to be the letter before it, so just before we change letter we store it as prevletter for the next letter to use
        --then, when we find something like a parantheses, we check the previous letter to see if it's a colon and if it was facing the right direction, and if it meets both of those, set the name of the unit to both
        --since this all happens per rule, crosswording should be unaffected
        --...doesn't work yet but that was my plan
        local unit = letter.unit
        local prevunit = prevletter.unit or {}
        local name = letter.name
        --turn flog be : ) (vertical) into flog be :) instead of flog be ..:)
        local speaking_bridges_hack = false
        if name == "custom" then name = letter.unit.special.customletter end
        if letter.name == "u" then
          local umlauts = getTextOnTile(unit.x,unit.y-1)
          for _,umlaut in ipairs(umlauts) do
            if umlaut.fullname == "letter_colon" and umlaut.dir == 3 and umlaut ~= prevunit then
              name = "..u"
            end
          end
        elseif letter.name == "e" then
          local umlauts = getTextOnTile(unit.x,unit.y-1)
          for _,umlaut in ipairs(umlauts) do
            if umlaut.fullname == "letter_colon" and umlaut.dir == 3 and umlaut ~= prevunit then
              name = "..e"
            end
          end
        --[[elseif letter.fullname == "letter_colon" and letter.dir == 3 then
          name = ".."]]--
        elseif prevunit.fullname == "letter_colon" and prevunit.dir == dir
        and (letter.name == "o" or letter.name == ")" or letter.name == "(") then
          name = ":"..letter.name
          speaking_bridges_hack = true
        end
        --[[elseif letter.name == "/" then
          if prevletter.name == ":" and prevunit.dir == dir then
            name = "tryagain"
          end
        elseif letter.name == ">" then
          if prevletter.name == ":" and prevunit.dir == dir then
            name = "nxt"
          end
        end]]
        
        if (speaking_bridges_hack) then
          new_word = new_word:sub(1, -3)
        end
        
        if name ~= ":" then
          new_word = new_word..name
        end
        
        prevletter = letter
        word_index = word_index + 1
        letter = sentence[word_index]
        --print("looping... "..new_word.." "..word_index)
        if letter == nil then break end --end of array ends up hitting this case
      end

      --parens hack - don't try to make letters out of a single parenthesis
      if not (new_word:len() < 2 and text_in_tiles[new_word] == nil) then
        local lsentences = findLetterSentences(new_word) --get everything valid out of the letter string (this should be [both], hmm)
        --[[if (#lsentences.start ~= 0 or #lsentences.endd ~= 0 or #lsentences.middle ~= 0 or #lsentences.both ~= 0) then
          print(new_word.." --> "..fullDump(lsentences))
        end]]

        local before_sentence = {}
        for i=1,orig_index-1 do
          table.insert(before_sentence,sentence[i])
        end
        local after_sentence = {}
        if word_index <= #sentence then
          for i=word_index,#sentence do
            table.insert(after_sentence,sentence[i])
          end
        end

        local pos_x = sentence[orig_index].unit.x
        local pos_y = sentence[orig_index].unit.y
        --print("coords: "..pos_x..", "..pos_y)

        local len = word_index-orig_index
        for _,s in ipairs(lsentences.middle) do
          local words = fillTextDetails(s, sentence, orig_index, word_index)
          parseSentence(words, params_, dir)
        end
        for _,s in ipairs(lsentences.start) do
          local words = fillTextDetails(s, sentence, orig_index, word_index)
          local before_copy = copyTable(before_sentence) --copying is required because addTables puts results in the first table
          addTables(before_copy, words)
          parseSentence(before_copy, params_, dir)
        end
        for _,s in ipairs(lsentences.endd) do
          local words = fillTextDetails(s, sentence, orig_index, word_index)
          addTables(words, after_sentence)
          parseSentence(words, params_, dir)
        end
        for _,s in ipairs(lsentences.both) do
          local words = fillTextDetails(s, sentence, orig_index, word_index)
          local before_copy = copyTable(before_sentence)
          addTables(words, after_sentence)
          addTables(before_copy, words)
          --print("end dump: "..dumpOfProperty(before_copy, "name"))
          parseSentence(before_copy, params_, dir)
        end

        parseSentence(before_sentence, params_, dir)
        parseSentence(after_sentence, params_, dir)
        return --no need to continue past this point, since the letters suffice
      end
    end
  end
  
  local function addUnits(list, set, root, dirs, mods)
    if root.unit and not set[root.unit] then
      table.insert(list, root.unit)
      set[root.unit] = true
      dirs[root.unit] = root.dir
      mods[root.unit] = mods[root.unit] or {}
      if root.conds then
        for _,cond in ipairs(root.conds) do
          addUnits(list, set, cond, dirs, mods)
        end
      end
      if root.others then
        for _,other in ipairs(root.others) do
          addUnits(list, set, other, dirs, mods)
        end
      end
      if root.mods then
        for _,mod in ipairs(root.mods) do
          if mod.unit then
            table.insert(mods[root.unit], mod.unit)
          end
          addUnits(list, set, mod, dirs, mods)
        end
      end
    end
  end

  -- print("just after letters:", dump(sentence))
  while (#sentence > 2) do
    local valid, words, rules, extra_words = parse(copyTable(sentence), dir)
    if not valid then -- probably not too great for performance, it'd be good to only do this if "lookat" etc is in the rule
      valid, words, rules, extra_words = parse(copyTable(sentence), dir, true) -- check lookat as a verb instead of a condition
    end
    --print(dump(state))

    if valid then
      for i,rule in ipairs(rules) do
        local list = {}
        local set = {}
        local dirs = {}
        local mods = {}
        for _,word in ipairs(extra_words) do
          addUnits(list, set, word, dirs, mods)
        end
        addUnits(list, set, rule.subject, dirs, mods)
        addUnits(list, set, rule.verb, dirs, mods)
        addUnits(list, set, rule.object, dirs, mods)
        local full_rule = {rule = rule, units = list, dir = dir, units_set = set, dirs = dirs, mods = mods}
        -- print(fullDump(full_rule))
        
        local add = false
        
        if not timeless then
          add = true
        else
          local temp = rules_with
          rules_with = old_rules_with
          for _,unit in ipairs(list) do
            if unit.zawarudo then
              add = true
              break
            end
          end
          rules_with = temp
        end
        
        for i = #final_rules,1,-1 do
          local other = final_rules[i]
          if other.dir == full_rule.dir then
            local subset = true
            for _,u in ipairs(other.units) do
              if (not full_rule.units_set[u] or (full_rule.dirs[u] ~= other.dirs[u]) or not eq(full_rule.mods[u], other.mods[u])) and not u.typeset["and"] then 
                subset = false
                break
              end
            end
            if subset then
              table.remove(final_rules, i)
            else
              local subset = true
              for _,u in ipairs(full_rule.units) do
                if (not other.units_set[u] or (full_rule.dirs[u] ~= other.dirs[u]) or not eq(full_rule.mods[u], other.mods[u])) and not u.typeset["and"] then
                  subset = false
                  break
                end
              end
              if subset then
                add = false
                break
              end
            end
          end
        end
        if add then
          table.insert(final_rules, full_rule)
        end
      end
      
      local last_word = sentence[#sentence - #words]
      table.insert(words, 1, last_word)
      sentence = words
    else
      table.remove(sentence, 1)
    end
  end
end

function addRule(full_rule)
  local rules = full_rule.rule
  local units = full_rule.units
  local dir = full_rule.dir

  local subject = rules.subject.name
  local verb = rules.verb.name
  local object = rules.object.name

  local subject_not = 0
  local verb_not = 0
  local object_not = 0
  
  local new_rule = false
  local rule_id = ""
  for _,unit in ipairs(units) do
    unit.active = true
    if not unit.old_active and not first_turn then
      addParticles("rule", unit.x, unit.y, getUnitColor(unit))
      new_rule = true
    end
    unit.old_active = unit.active
    rule_id = rule_id .. unit.id .. ","
  end
  has_new_rule = has_new_rule or new_rule
  
  if object:starts("anti ") and anti_word_replacements[object:sub(6,-1)] then
    rules.object.name = anti_word_replacements[object:sub(6,-1)]
    object = anti_word_replacements[object:sub(6,-1)]
  end
  
  if verb:starts("anti ") and anti_word_replacements[verb:sub(6,-1)] then
    rules.verb.name = anti_word_replacements[verb:sub(6,-1)]
    verb = anti_word_replacements[verb:sub(6,-1)]
  end
  
  if verb:starts("anti ") and anti_verb_mirrors[verb:sub(6,-1)] then
    subject = rules.object.name
    object = rules.subject.name
    local old_object = copyTable(rules.object)
    rules.object = copyTable(rules.subject)
    rules.subject = old_object
    rules.verb.name = verb:sub(6,-1)
  end
  
  if rule_id ~= "" and new_rule and not past_rules[rule_id] and not undoing then
    -- actually i dont know how rule stacking works ehehe
    local r1, subject_conds = getPastConds(rules.subject.conds or {})
    local r2, object_conds = getPastConds(rules.object.conds or {})
    if r1 or r2 then
      local new_rule = {rule = deepCopy(rules), units = {}, dir = 1}
      new_rule.rule.subject.conds = subject_conds
      new_rule.rule.object.conds = object_conds
      past_rules[rule_id] = {turn = current_move, rule = new_rule}
      change_past = true
    end
  end
  
  for _,unit in ipairs(units) do
    if (not rong and old_rules_with["rong"] ~= nil) then
      local temp = rules_with; rules_with = old_rules_with
      if hasProperty(unit, "rong") then
        for __,unit2 in ipairs(units) do
          unit2.blocked = true
          unit2.blocked_dir = full_rule.dirs and full_rule.dirs[unit2] or dir
        end
        rules_with = temp
        return
      end
      rules_with = temp
    end
  end

  --"x be sans" plays a megalovania jingle! but only if x is in the level.
  local play_sans_sound = false
  if new_rule then
    if verb == "be" and object == "sans" and units_by_name[subject] then
      play_sans_sound = true
    end
  end
  
  -- play the x be sans jingle!
  if play_sans_sound then
    playSound("babbolovania")
  end
  
  while subject:ends("n't") do subject, subject_not = subject:sub(1, -4), subject_not + 1 end
  while verb:ends("n't")    do verb,       verb_not =    verb:sub(1, -4),    verb_not + 1 end
  while object:ends("n't")  do object,   object_not =  object:sub(1, -4),  object_not + 1 end
	--print(subject, verb, object, subject_not, verb_not, object_not)

  if verb_not > 0 then
    verb = rules.verb.name:sub(1, -4)
  end

  --add used_as values for sprite transformations
  if rules.subject.unit and not rules.subject.unit.used_as["object"] then
    table.insert(rules.subject.unit.used_as, "object")
  end

  if rules.verb.unit and not rules.verb.unit.used_as["verb"] then
    table.insert(rules.verb.unit.used_as, "verb")
  end

  if rules.object.unit then
    local property = false
    local tile = getTile("txt_" .. verb)
    if tile and tile.typeset.verb_property then
      property = true
    end
    if property and not rules.object.unit.used_as["property"] then
      table.insert(rules.object.unit.used_as, "property")
    elseif not property and not rules.object.unit.used_as["object"] then
      table.insert(rules.object.unit.used_as, "object")
    end
  end
  
  --Special THIS check - if we write this be this or this ben't this, it should work like the tautology/paradox it does for other objects, even though they are TECHNICALLY different thises.
  if subject:starts("this") and object:starts("this") and subject_not == 0 and object_not == 0 and subject ~= object then
    addRuleSimple(rules.subject, rules.verb, {rules.subject.name, rules.object.conds}, units, dir)
    return
  end
  
  --Transform THE BE U into THE (prefix condition) EVERY2 BE U.
  --todo: add support for bordr
  if subject == "the" or subject == "deez" then
    rules.subject.conds = copyTable(rules.subject.conds) or {};
    table.insert(rules.subject.conds, rules.subject);
    addRuleSimple({"every2", rules.subject.conds}, rules.verb, rules.object, units, dir)
    return
  end

  if subject:find("letter_custom") and subject.unit then
    rules.subject.conds = copyTable(rules.subject.conds) or {};
    table.insert(rules.subject.conds, rules.subject);
  end
  if object:find("letter_custom") and object.unit then
    local tile = getTile("txt_"..verb)
    if tile and tile.typeset.verb_unit then
      rules.object.conds = copyTable(rules.object.conds) or {};
      table.insert(rules.object.conds, rules.object);
    end
  end
  
  if verb == "is" then
    local new_verb = copyTable(rules.verb)
    new_verb.name = "be"
    for i = 1, verb_not do
      new_verb.name = new_verb.name .. "n't"
    end
    addRuleSimple(rules.subject, new_verb, rules.object, units, dir)
  end

  if subject == "every1" then
    if subject_not % 2 == 1 then
      return
    else
      for _,v in ipairs(referenced_objects) do
        addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
      end
    end
  elseif subject == "every2" then
    if subject_not % 2 == 1 then
      return
    else
      for _,v in ipairs(referenced_objects) do
        addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
      end
      addRuleSimple({"txt", rules.subject.conds}, rules.verb, rules.object, units, dir)

      local copied_conds = copyTable(rules.subject.conds)
      table.insert(copied_conds, {name = "inner", type = {cond_prefix = true}, dir = rules.subject.dir})
      addRuleSimple({"lvl", copied_conds}, rules.verb, rules.object, units, dir)
    end
  elseif subject == "every3" then
    if subject_not % 2 == 1 then
      return
    else
      for _,v in ipairs(referenced_objects) do
        addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
      end
      addRuleSimple({"txt", rules.subject.conds}, rules.verb, rules.object, units, dir)
      for _,v in ipairs(special_objects) do
        addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
      end
    end
  elseif subject == "lethers" then
    for _,v in ipairs(referenced_text) do
      if subject_not % 2 == 1 then
        if not v:starts("letter_") then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      else
        if v:starts("letter_") then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      end
    end
  elseif subject == "numa" then
    for _,v in ipairs(referenced_text) do
      if subject_not % 2 == 1 then
        if v:starts("letter_") then
          for i = 1, 9, 1 do
            if v:ends(tostring(i)) then
              addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
            end
          end
        end
      else
        if v:starts("letter_") then
          if v:ends("_o") then
            addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
          end
          for i = 1, 9, 1 do
            if v:ends(tostring(i)) then
              addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
            end
          end
        end
      end
    end
  elseif subject == "toen" then
    for _,v in ipairs(referenced_text) do
      if subject_not % 2 == 1 then
        if not (v:ends("_sharp") or v:ends("_flat") or v == "letter_a" or v == "letter_b" or v == "letter_c" or v == "letter_d" or v == "letter_e" or v == "letter_f" or v == "letter_g") then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      else
        if v:ends("_sharp") or v:ends("_flat") or v == "letter_a" or v == "letter_b" or v == "letter_c" or v == "letter_d" or v == "letter_e" or v == "letter_f" or v == "letter_g" then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      end
    end
  elseif subject == "yuiy" then
    for _,v in ipairs(referenced_objects) do
      if subject_not % 2 == 1 then
        if not v:starts("ui_") then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      else
        if v:starts("ui_") then
          addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
        end
      end
    end
  elseif subject_not % 2 == 1 then
    if getTile(subject) or subject == "txt" then
      local new_subjects = getEverythingExcept(subject)
      for _,v in ipairs(new_subjects) do
        addRuleSimple({v, rules.subject.conds}, rules.verb, rules.object, units, dir)
      end
      return
    end
  end

  if object == "every1" then
    if object_not % 2 == 1 then
      return
    elseif verb ~= "be" and verb ~= "ben't" then
      --we'll special case x be every1 in convertUnit now
      for _,v in ipairs(referenced_objects) do
        addRuleSimple(rules.subject, rules.verb, {v, rules.object.conds}, units, dir)
      end
    end
  elseif object == "every2" then
    if object_not % 2 == 1 then
      return
    elseif verb ~= "be" and verb ~= "ben't" then
      for _,v in ipairs(referenced_objects) do
        addRuleSimple(rules.subject, rules.verb, {v, rules.object.conds}, units, dir)
      end
      addRuleSimple(rules.subject, rules.verb, {"txt", rules.object.conds}, units, dir)

      local copied_conds = copyTable(rules.object.conds)
      table.insert(copied_conds, {name = "inner", type = {cond_prefix = true}, dir = rules.object.dir})
      addRuleSimple(rules.subject, rules.verb, {"lvl", copied_conds}, units, dir)
    end
  elseif object == "every3" then
    if object_not % 2 == 1 then
      return
    elseif verb ~= "be" and verb ~= "ben't" then
      for _,v in ipairs(referenced_objects) do
        addRuleSimple(rules.subject, rules.verb, {v, rules.object.conds}, units, dir)
      end
      addRuleSimple(rules.subject, rules.verb, {"txt", rules.object.conds}, units, dir)
      for _,v in ipairs(special_objects) do
        addRuleSimple(rules.subject, rules.verb, {v, rules.object.conds}, units, dir)
      end
    end
  elseif object_not % 2 == 1 then
    if getTile(object) or object:starts("this") or object == "txt" or object == "mous" then
      local new_objects = {}
      --skul be skul turns into skul ben't skuln't - but this needs to apply even to special objects (specific text, txt, no1, lvl, mous).
      if verb == "be" and verb_not % 2 == 1 then
        new_objects = getAbsolutelyEverythingExcept(object)
      else
        new_objects = getEverythingExcept(object)
      end
      for _,v in ipairs(new_objects) do
        --print(fullDump(rules))
        addRuleSimple(rules.subject, rules.verb, {v, rules.object.conds}, units, dir)
      end
      --txt be txt needs to also apply for flog txt, bab txt, etc.
      if (object == "txt" and verb == "be" and verb_not % 2 == 1) then
        for i,ref in ipairs(referenced_text) do
          for _,v in ipairs(new_objects) do
            addRuleSimple({ref, rules.subject.conds}, rules.verb, {v, rules.object.conds}, units, dir)
          end
        end
      end
      return
    end
  end

  if verb_not > 0 then
    if (verb == "be") and (object == "notranform" or subject == object or (subject:starts("txt_") and object == "txt") or object == "themself") then
      verb_not = verb_not + 1
    end
    if not not_rules[verb_not] then
      not_rules[verb_not] = {}
      max_not_rules = math.max(max_not_rules, verb_not)
    end
    -- print("full_rule:", fullDump(full_rule))
    table.insert(not_rules[verb_not], full_rule)

    -- for specifically checking NOT rules
    table.insert(full_rules, {rule = {subject = rules.subject, verb = {name = verb .. "n't"}, object = rules.object}, units = units, dir = dir})
  elseif (verb == "be") and (subject == object or (subject:starts("txt_") and object == "txt") or object == "themself") and subject ~= "lvl" and object ~= "lvl" and subject ~= "sans" then
    --print("protecting: " .. subject .. ", " .. object)
    addRuleSimple(rules.subject, {"be"}, {"notranform", rules.object.conds}, units, dir)
  elseif object == "notranform" or (subject == "lvl" and object == "lvl") then -- no "n't" here, but still blocks other rules so we need to count it
    if not not_rules[1] then
      not_rules[1] = {}
      max_not_rules = math.max(max_not_rules, 1)
    end
    table.insert(not_rules[1], full_rule)
    table.insert(full_rules, full_rule)
  else
    table.insert(full_rules, full_rule)
  end
end

function postRules(no_sound)
  local all_units = {}
	
  -- Step 1:
  -- Block & remove rules if they're N'T'd out
  for n = max_not_rules, 1, -1 do
    if not_rules[n] then
      for _,rules in ipairs(not_rules[n]) do
        local rule = rules.rule -- rule = the current rule we're looking at
        local conds = {rule.subject.conds or {}, rule.object.conds or {}}

        local inverse_conds = {{},{}}
        for i=1,2 do
          for _,cond in ipairs(conds[i]) do
            local new_cond = copyTable(cond)
            if new_cond.name:ends("n't") then
              new_cond.name = new_cond.name:sub(1, -4)
            else
              new_cond.name = new_cond.name .. "n't"
            end
            table.insert(inverse_conds[i], new_cond)
          end
        end

        local has_conds = (#conds[1] > 0 or #conds[2] > 0)
        
        local specialmatch = 0
        if rule.verb.name == "be" and rule.object.name == "notranform" then -- "bab be bab" should cross out "bab be keek"
          specialmatch = 1
        elseif rule.verb.name == "ben't" and rule.object.name == rule.subject.name or rule.object.name == "notranform" then -- "bab be n't bab" and 'bab be n't notranform' should cross out "bab be bab" (bab be notranform)
          specialmatch = 2
        end

        local function blockRules(t)
          local blocked_rules = {}
          for _,frules in ipairs(t) do
            local frule = frules.rule -- frule = potential matching rule to cancel
            -- print(fullDump(frule))
            local fverb = frule.verb.name
            if specialmatch ~= 1 then
              fverb = fverb .. "n't"
            end
            -- print("frule:", fullDump(frule))
            if (frule.subject.name == rule.subject.name or (rule.subject.name == "txt" and frule.subject.name:starts("txt_"))) and fverb == rule.verb.name and (
              (specialmatch == 0 and frule.object.name == rule.object.name and frule.object.name ~= "her" and frule.object.name ~= "thr" and frule.object.name ~= "rit here") or
              (specialmatch == 1 and (frule.object.type.object) and not group_names_set[frule.object.name]) or -- was used for making notranform cancel x be tranz but we decided that was a dumb joke
              (specialmatch == 2 and frule.object.name == "notranform")
            ) then
              if has_conds then
                --print(fullDump(rule), fullDump(frule))
                for _,cond in ipairs(inverse_conds[1]) do
                  if not frule.subject.conds then frule.subject.conds = {} end
                  frule.subject = copyTable(frule.subject);
                  frule.subject.conds = copyTable(frule.subject.conds);
                  table.insert(frule.subject.conds, cond)
                end
                for _,cond in ipairs(inverse_conds[2]) do
                  if not frule.object.conds then frule.object.conds = {} end
                  frule.object = copyTable(frule.object);
                  frule.object.conds = copyTable(frule.object.conds);
                  table.insert(frule.object.conds, cond)
                end
              else
                table.insert(blocked_rules, frules)
              end
            end
          end

          for _,blocked in ipairs(blocked_rules) do
            for _,unit in ipairs(blocked.units) do
              unit.blocked = true
              unit.blocked_dir = blocked.dirs and blocked.dirs[unit] or blocked.dir
            end
            -- print("blocked:", fullDump(blocked))
            removeFromTable(t, blocked)
          end
        end

        if not_rules[n - 1] then
          blockRules(not_rules[n - 1])
        end
        blockRules(full_rules)

        mergeTable(all_units, rules.units)
      end
    end
  end

  -- Step 2:
  -- Add all remaining rules to lookup tables
  for _,rules in ipairs(full_rules) do
    local rule = rules.rule

    local subject, verb, object = rule.subject.name, rule.verb.name, rule.object.name

    if not rules_with[subject] then
      rules_with[subject] = {}
    end
    table.insert(rules_with[subject], rules)

    if not rules_with[verb] then
      rules_with[verb] = {}
    end
    if (verb ~= subject) then
      table.insert(rules_with[verb], rules)
    end

    if not rules_with[object] then
      rules_with[object] = {}
    end
    if (object ~= subject and object ~= verb) then
      table.insert(rules_with[object], rules)
    end

    for _,unit in ipairs(rules.units) do
      if not rules_with_unit[unit] then
        rules_with_unit[unit] = {}
      end
      table.insert(rules_with_unit[unit], rules)
    end

    mergeTable(all_units, rules.units)
  end

  -- Step 3:
  -- Unblock any units in an unblocked rule
  for _,unit in ipairs(all_units) do
    unit.blocked = false
  end

  if has_new_rule and not no_sound then
    playSound("rule", 0.5)
  end
end

function shouldReparseRules()
  if should_parse_rules then return true end
  local rules_to_check = {
    {"?","be","wurd"},
    {"?","be","anti wurd"},
    {"?","be","poortoll"},
    {"?","be","goarnd"},
    {"?","be","mirrarnd"},
    {"lvl","be","goarnd", true},
    {"lvl","be","mirrarnd", true},
    {"?","be","ortho"},
    {"?","be","diag"},
    {"?","ben't","wurd"},
    {"?","be","zawarudo"},
    {"?","be","rong"},
    {"?","be","slep"},
  }
  if rules_with["poortoll"] then
    table.insert(rules_to_check, {"?","ignor","?",true})
  end
  for _,rule in ipairs(rules_to_check) do
    if shouldReparseRulesIfConditionalRuleExists(unpack(rule)) then return true end
  end
  return false
end

function populateRulesEffectingNames(r1, r2, r3)
  local rules = matchesRule(r1, r2, r3)
  for _,rule in ipairs(rules) do
    local subject = rule.rule.subject.name
    if subject == "txt" or (subject:sub(1, 4) ~= "txt") then
      rules_effecting_names[subject] = true
    end
  end
  
  --hack for giv - parseRules every turn in case giv rule state changes
  if hasRule(r1, "giv", r3) then
    should_parse_rules_at_turn_boundary = true
  end
end

function shouldReparseRulesIfConditionalRuleExists(r1, r2, r3, even_non_wurd)
  local rules = matchesRule(r1, r2, r3)
  for _,rule in ipairs(rules) do
    local subject_cond = rule.rule.subject.conds or {}
    local subject = rule.rule.subject.name
    --We only care about conditional rules that effect text, specific text, wurd units and maybe portals too.
    --We can also distinguish between different conditions (todo).
    if (#subject_cond > 0 and (even_non_wurd or subject:starts("txt") or rules_effecting_names[subject])) then
      for _,cond in ipairs(subject_cond) do
        local cond_name = cond.name
        local params = cond.others or {}
        --TODO: This needs to change for condition stacking.
        --An infix condition that references another unit just dumps the second unit into rules_effecting_names (This is fine for all infix conditions, for now, but maybe not perpetually? for example sameFloat() might malfunction since the floatness of the other unit could change unexpectedly due to a SECOND conditional rule).
        if (#params > 0) then
          for _,param in ipairs(params) do
            --might be recursive. TODO: extend indefinitely?
            if (param.conds ~= nil) then
              for _,cond2 in ipairs(param.conds) do
                local params2 = cond2.others or {}
                if (#params2 > 0) then
                  for _,param2 in ipairs(params2) do
                    rules_effecting_names[param2.name] = true
                    if param2.name == "mous" then
                      should_parse_rules_at_turn_boundary = true
                    end
                  end
                end
              end
            end
            rules_effecting_names[param.name] = true
            if param.name == "mous" then
              should_parse_rules_at_turn_boundary = true
            end
          end
        else
          --Handle specific prefix conditions.
          --Frenles is hard to do since it could theoretically be triggered by ANY other unit. Instead, just make it reparse rules all the time, sorry.
          if cond_name == "frenles" or cond_name == "frenlesn't" then
            should_parse_rules = true
            return true
          elseif (cond_name == "corekt" or cond_name == "corektn't" or cond_name == "rong" or cond_name == "rongn't") then
            --nothing
          else
            --What are the others? WAIT... only changes at turn boundary. MAYBE can only change on turn boundary or if the unit or text moves (by definition these already reparse rules). AN only changes on turn boundary. COREKT/RONG can only change when text reparses anyway by definition, so it should never trigger it. TIMELES only changes at turn boundary. CLIKT only changes at turn boundary. Colours only change at turn boundary. So every other prefix condition, for now, just needs one check per turn, but new ones will need to be considered.
            should_parse_rules_at_turn_boundary = true
          end
          
          --TODO: How should a parse effecting THE rule work? Continual reparsing, like frenles?
          
          --As another edge to consider, what if the level geometry changes suddenly? Well, portals already trigger reparsing rules when they update, which is the only kind of external level geometry change. In addition, txt/wurds changing flye/tall surprisingly would already trigger rule reparsing since we checked those rules. But, what about a non-wurd changing flye/tall, allowing it to go through a portal, changing the condition of a different parse effecting rule? This can also happen with level be go arnd/mirr arnd turning on or off. parseRules should fire in such cases. So specifically for these cases, even though they aren't wurd/text, we do want to fire parseRules when their conditions change.
          
          --One final edge case to consider: MOUS, which just moves around on its own. This also triggers should_parse_rules_at_turn_boundary, since that's how often we care about MOUS moving.
        end
      end
    end
  end
  return false
end
