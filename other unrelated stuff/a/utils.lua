function clear()
  puffs_this_world = 0
  levels_this_world = 0

  --groups_exist = false
  letters_exist = false
  if not doing_past_turns then
    replay_playback = false
    replay_playback_turns = nil
    replay_playback_string = nil
    replay_playback_turn = 1
    replay_playback_time = love.timer.getTime()
    replay_playback_interval = 0.3
    old_replay_playback_interval = 0.3
    replay_pause = false
    replay_string = ""
  end
  rhythm_time = love.timer.getTime()
  rhythm_interval = 1
  rhythm_queued_movement = {0, 0, "wait"}
  new_units_cache = {}
  undoing = false
  successful_brite_cache = nil
  next_level_name = ""
  win_sprite_override = {}
  level_destroyed = false
  last_input_time = nil
  most_recent_key = nil
  just_moved = true
  should_parse_rules_at_turn_boundary = false
  should_parse_rules = true
  graphical_property_cache = {}
  initializeGraphicalPropertyCache()
  debug_values = {}
  rng_cache = {}
  reset_count = 0
  last_move = nil
  particles = {}
  units = {}
  units_by_id = {}
  units_by_name = {}
  units_by_tile = {}
  units_by_layer = {}
  backers_cache = {}
  empties_by_tile = {}
  outerlvl = nil
  still_converting = {}
  portaling = {}
  zomb_undos = {}
  rules_effecting_names = {}
  referenced_objects = {}
  referenced_text = {}
  undo_buffer = {}
  infcount = 0
  complexcount = 0
  destroycount = 0
  update_undo = true
  max_layer = 1
  max_unit_id = 0
  max_temp_id = 0
  max_mouse_id = 0
  first_turn = true
  cursor_convert = nil
  cursor_converted = false
  mouse_X = love.mouse.getX()
  mouse_Y = love.mouse.getY()
  last_clicks = {}
  mouse_oldX = mouse_X
  mouse_oldY = mouse_Y
  drag_units = {}
  cursors = {}
  cursors_by_id = {}
  shake_dur = 0
  shake_intensity = 0.5
  current_turn = 0
  current_move = 0
  
  --za warudo needs a lot
  timeless = false
  time_destroy = {}
  time_delfx = {}
  time_sfx = {}
  timeless_split = {}
  timeless_win = {}
  timeless_unwin = {}
  timeless_reset = false
  timeless_replay = false
  timeless_crash = false
  timeless_yote = {}
  firsttimestop = true
  thicc_units = {}

  --if scene == game then
  if load_mode == "play" then
    createMouse_direct(love.mouse.getX(), love.mouse.getY())
  end
  --createMouse_direct(20, 20)

  currently_winning = false
  music_fading = false
  won_this_session = false
  level_ending = false
  win_size = 0

  tile_grid = {}
  
  for i,page in ipairs(selector_grid_contents) do
    tile_grid[i] = {}
    for j,tile_name in ipairs(page) do
      if j then
        tile_grid[i][j-1] = tile_name
      else
        tile_grid[i][j-1] = nil
      end
    end
  end

  if not doing_past_turns then
    change_past = false
    past_playback = false
    all_moves = {}
    past_rules = {}
    past_ends = {}
  end
  
  card_for_id = {}

  love.mouse.setCursor()
end

function pastClear()
  if stopwatch ~= nil then
    stopwatch.visible = false
  end
  should_parse_rules = true
  doing_past_turns = false
  past_playback = false
  past_rules = {}
  cutscene_tick = tick.group()
end

function metaClear()
  rules_with = nil
  rules_with_unit = nil
  level_tree = {}
  playing_world = false
  parent_filename = nil
  stay_ther = nil
  surrounds = nil
  pastClear()
end

function initializeGraphicalPropertyCache()
  local properties_to_init = -- list of properties that require the graphical cache
  {
    "flye", "slep", "stelth", "colrful", "delet", "xwx", "rave" -- miscelleaneous graphical effects
  }
  for name,_ in pairs(overlay_props) do -- add overlays
    table.insert(properties_to_init, name)
  end
  for i = 1, #properties_to_init do
    local prop = properties_to_init[i]
    if (graphical_property_cache[prop] == nil) then graphical_property_cache[prop] = {} end
  end
end

function loadMap()
  --no longer necessary, we now lazy initialize these
  --[[for x=0,mapwidth-1 do
    for y=0,mapheight-1 do
      units_by_tile[x + y * mapwidth] = {}
    end
  end]]
  local has_missing_levels = false
  local rects = {}
  local extra_units = {}
  for _,mapdata in ipairs(maps) do
    local version = mapdata.info.version
    local map = mapdata.data

    local offset = {x = 0, y = 0}
    if mapdata.info.width < mapwidth then
      offset.x = math.floor((mapwidth / 2) - (mapdata.info.width / 2))
    end
    if mapdata.info.height < mapheight then
      offset.y = math.floor((mapheight / 2) - (mapdata.info.height / 2))
    end
    table.insert(rects, {x = offset.x, y = offset.y, w = mapdata.info.width, h = mapdata.info.height})

    if version == 0 or version == nil then
      if map == nil then
        map = {}
        for x=1,mapwidth do
          for y=1,mapheight do
            table.insert(map, {})
          end
        end
      end
      for i,v in ipairs(map) do
        local tileid = i-1
        local x = tileid % mapwidth
        local y = math.floor(tileid / mapwidth)
        for _,id in ipairs(v) do
          local new_unit = createUnit(id, x, y, 1)
        end
      end
    elseif version >= 1 and version <= 3 then
      local pos = 1
      while pos <= #map do
        if version == 1 then
          local tile, x, y, dir
          tile, x, y, dir, pos = love.data.unpack(PACK_UNIT_V1, map, pos)
          createUnit(tile, x + offset.x, y + offset.y, dir)
        elseif version == 2 or version == 3 then
          local id, tile, x, y, dir, specials
          id, tile, x, y, dir, specials, pos = love.data.unpack(version == 2 and PACK_UNIT_V2 or PACK_UNIT_V3, map, pos)
          local unit = createUnit(tile, x + offset.x, y + offset.y, dir, false, id)
          local spos = 1
          while spos <= #specials do
            local k, v
            k, v, spos = love.data.unpack(PACK_SPECIAL_V2, specials, spos)
            unit.special[k] = v
          end
        end
      end
    else
      local ok = nil
      ok, map = serpent.load(map)
      if (ok ~= true) then
        print("Serpent error while loading:", ok, fullDump(map))
      end
      local floodfill = {}
      local objects = {}
      local lvls = {}
      local locked_lvls = {}
      local created = {}
      local pre_created = {}
      local dofloodfill = scene ~= editor
      for _,unit in ipairs(map) do
        id, tile, x, y, dir, specials, color = unit.id, unit.tile, unit.x, unit.y, unit.dir, unit.special, unit.color
        x = x + offset.x
        y = y + offset.y
        
        --track how many puffs and levels exist in this world (have to do this separately so we count hidden levels etc)
        if specials.level then
          levels_this_world = levels_this_world + 1
          if readSaveFile{"levels", specials.level, "won"} then
            puffs_this_world = puffs_this_world + 1
          end
        end
        
        if scene == editor and specials.level then
          if not love.filesystem.getInfo(getWorldDir() .. "/" .. specials.level .. ".bab") then
            has_missing_levels = true
            print("missing level: " .. specials.level)
            local search = searchForLevels(getWorldDir(), specials.name, true)
            if #search > 0 then
              print("    - located: " .. search[1].file)
              specials.level = search[1].file
              specials.name = search[1].data.name
            else
              print("    - could not locate!")
            end
          end
        end
        if not dofloodfill then
          local unit = createUnit(tile, x, y, dir, false, id, nil, color)
          unit.special = specials
        elseif tile == "lvl" then
          if readSaveFile{"levels", specials.level, "seen"} then
            specials.visibility = "open"
            local tfs = readSaveFile{"levels", specials.level, "transform"}
            for i,t in ipairs(tfs or {tile}) do
              if i == 1 then
                local unit = createUnit(t, x, y, dir, false, id, nil, color)
                unit.special = deepCopy(specials)
                if readSaveFile{"levels", specials.level, "won"} or readSaveFile{"levels", specials.level, "clear"} then
                  table.insert(floodfill, {unit, 1})
                end
              else
                table.insert(extra_units, {t, x, y, dir, color, deepCopy(specials)})
              end
            end
            created[id] = true
          elseif specials.visibility == "open" or specials.visibility == "locked" or specials.visibility == nil then
            local unit = createUnit(tile, x, y, dir, false, id, nil, color)
            unit.special = specials
            if specials.visibility == "open" then
              created[id] = true
            else
              pre_created[id] = unit
            end
          end
          table.insert(objects, {id, tile, x, y, dir, specials, color})
        elseif tile == "lin" then
          if specials.visibility ~= "hidden" then
            local unit = createUnit(tile, x, y, dir, false, id, nil, color)
            unit.special = specials
            created[id] = true
          end
          table.insert(objects, {id, tile, x, y, dir, specials, color})
        else
          if specials.level then
            if readSaveFile{"levels", specials.level, "seen"} then
              specials.visibility = "open"
            end
            local tfs = readSaveFile{"levels", specials.level, "transform"}
            for i,t in ipairs(tfs or {tile}) do
              if i == 1 then
                local unit = createUnit(t, x, y, dir, false, id, nil, color)
                unit.special = specials
              else
                table.insert(extra_units, {t, x, y, dir, color, deepCopy(specials)})
              end
            end
          else
            local unit = createUnit(tile, x, y, dir, false, id, nil, color)
            unit.special = specials
          end
        end
      end
      
      --now check if we should grant clear/complete
      if (level_puffs_to_clear > 0 and puffs_this_world >= level_puffs_to_clear) then
        writeSaveFile(true, {"levels", level_filename, "clear"})
      end
      if (levels_this_world > 0 and puffs_this_world >= levels_this_world) then
        writeSaveFile(true, {"levels", level_filename, "complete"})
      end
      
      if dofloodfill then
        while #floodfill > 0 do
          local u, ptype = unpack(table.remove(floodfill, 1))
          local orthos = {[-1] = {}, [0] = {}, [1] = {}}
          for a = 0,1 do -- 0 = ortho, 1 = diag
            for i = #objects,1,-1 do
              local v = objects[i] -- {id, tile, x, y, dir, specials, color}
              local dx = u.x-v[3]
              local dy = u.y-v[4]
              if (((dx == -1 or dx == 1) and (dy == -a or dy == a)) or ((dx == -a or dx == a) and (dy == -1 or dy == 1)))
              and (a == 0 or (not orthos[dx][0] and not orthos[0][dy])) then
                orthos[dx][dy] = true
                if not created[v[1]] then
                  if v[2] == "lvl" then
                    if ptype ~= 2 then
                      local unit = pre_created[v[1]] or createUnit(v[2], v[3], v[4], v[5], false, v[1], nil, v[7])
                      created[v[1]] = true
                      unit.special = v[6]
                      if ptype == 1 then
                        unit.special.visibility = "open"
                        table.insert(floodfill, {unit, 2})
                      elseif ptype == 3 then
                        unit.special.visibility = "open"
                      end
                    elseif ptype == 2 and not table.has_value(locked_lvls, v) then
                      table.insert(locked_lvls, v)
                      table.insert(floodfill, {{x = v[3], y = v[4]}, 2})
                    end
                  elseif (ptype == 1 or ptype == 3) and v[2] == "lin" and (not v[6].pathlock or v[6].pathlock == "none") then
                    local unit = pre_created[v[1]] or createUnit(v[2], v[3], v[4], v[5], false, v[1], nil, v[7])
                    created[v[1]] = true
                    unit.special = v[6]
                    table.insert(floodfill, {unit, 3})
                  end
                end
              end
            end
          end
        end
        for _,v in ipairs(locked_lvls) do
          if not created[v[1]] then
            local unit = pre_created[v[1]] or createUnit(v[2], v[3], v[4], v[5], false, v[1], nil, v[7])
            created[v[1]] = true
            unit.special = v[6]
          end
        end
      end
    end
  end
  for x=0,mapwidth-1 do
    for y=0,mapheight-1 do
      local in_bounds = false
      for _,rect in ipairs(rects) do
        if x >= rect.x and x < rect.x + rect.w and y >= rect.y and y < rect.y + rect.h then
          in_bounds = true
          break
        end
      end
      if not in_bounds then
        createUnit("bordr", x, y, 1)
      end
    end
  end
  for _,t in ipairs(extra_units) do
    local unit = createUnit(t[1], t[2], t[3], t[4], false, nil, nil, t[5])
    unit.specials = t[6]
  end
  if (load_mode == "play") then
    initializeOuterLvl()
    initializeEmpties()
    loadStayTher()
    if (not unit_tests) then
      writeSaveFile(true, {"levels", level_filename, "seen"})
    end
  end
  if has_missing_levels then
    print(colr.red("\nLEVELS MISSING - PLEASE CHECK & SAVE!"))
  end
  
  --I don't know why, but this is slower by a measurable amount (70-84 seconds for example).
  --[[groups_exist = letters_exist
  if not groups_exist then
    for _,group_name in ipairs(group_names) do
      if units_by_name["txt_"..group_name] then
        groups_exist = true
        break
      end
    end
  end]]
  
  unsetNewUnits()
end

function loadStayTher()
  if stay_ther ~= nil then
    for _,unit in ipairs(stay_ther) do
      local newunit = createUnit(unit.tile, unit.x, unit.y, unit.dir)
      newunit.special = unit.special
    end
  end
end

function initializeOuterLvl()
  outerlvl = createUnit("lvl", -999, -999, 1, nil, nil, true)
end

function initializeEmpties()
  --TODO: other ways to make a text_no1 could be to have a text_text_no1 but that seems contrived that you'd have text_text_no1 but not text_no1?
  --text_her counts because it looks for no1, I think. similarly we could have text_text_her but again, contrived
  if ((not letters_exist) and (not units_by_name["txt_no1"]) and (not units_by_name["txt_every3"]) and (not units_by_name["txt_her"])) then return end
  for x=0,mapwidth-1 do
    for y=0,mapheight-1 do
      local tileid = x + y * mapwidth
      empties_by_tile[tileid] = createUnit("no1", x, y, (((tileid - 1) % 8) + 1), nil, nil, true)
    end
  end
end

function compactIds()
  units_by_id = {}
  for i,unit in ipairs(units) do
    unit.id = i
    units_by_id[i] = unit
  end
  max_unit_id = #units + 1
end

--[[
  First and third arguments can be:
    unit, string, nil
  Second argument can be:
    string

  Unit argument will check conditions for that unit, and match rules using its name
  Both nil and "?" act as a wildcard, however a nil wildcard will only check units & return the argument as a unit
  Return value changes depending on how many arguments are nil
  Example:
    Rules:
    BAB BE U - FLOG BE =) - ROC BE KEEK - KEEK GOT MEEM

    Units:
    [BAB] [FLOG] [KEEK] [MEEM]

    matchesRule(bab unit,"be","u") => {BAB BE U}
    - Returns the matching "BAB BE U" rule, as it checks the unit's name

    matchesRule("bab","be","?") => {BAB BE U}
    - Same result, as the U property matches the wildcard

    matchesRule(nil,"be","?") => {{BAB BE U, bab unit}, {FLOG BE =), flog unit}}
    - The rule for ROC is not returned because no ROC exists, however the others do

    matchesRule("?","be",nil) => {{ROC BE KEEK, keek unit}}
    - The first two rules are not returned because properties have no matching units

    matchesRule(nil,"?",nil) => {{KEEK GOT MEEM, keek unit, meem unit}}
    - Both KEEK and MEEM units exist and GOT matches the wildcard, so it returns both units in order
  
  Note that the rules returned are full rules, formatted like: {{subject,verb,object,{preconds,postconds}}, {ids}} 
]]
function matchesRule(rule1,rule2,rule3,stopafterone,debugging)
  if (debugging) then
    print("matchesRule arguments:"..tostring(rule1)..","..tostring(rule2)..","..tostring(rule3))
  end
  
  local nrules = {} -- name
  local fnrules = {} -- fullname
  local rule_units = {}

  local function getnrule(o,i)
    if type(o) == "table" then
      local name
      local fullname
      if o.class == "unit" then
        name = o.name
        if o.fullname ~= o.name then
          fullname = o.fullname
        end
      elseif o.class == "cursor" then
        name = "mous"
      end
      nrules[i] = name
      if fullname then
        fnrules[i] = fullname
      end
      rule_units[i] = o
    else
      if o ~= "?" then
        nrules[i] = o
      end
    end
  end

  getnrule(rule1,1)
  nrules[2] = rule2
  getnrule(rule3,3)
  
  --if nrules[1] ~= nil and nrules[3] ~= "boring" and #matchesRule(rule1,"be","boring",true) > 0 then return {} end

  if (debugging) then
    for x,y in ipairs(nrules) do
      print("in nrules:"..tostring(x)..","..tostring(y))
    end
  end

  local ret = {}

  local find = 0
  local find_arg = 0
  if (rule1 == nil and rule3 ~= nil) or (rule1 ~= nil and rule3 == nil) then
    find = 1
    if rule1 == nil then
      find_arg = 1
    elseif rule3 == nil then
      find_arg = 3
    end
  elseif rule1 == nil and rule3 == nil then
    find = 2
  end

  local rules_list

  --there are more properties than there are nouns, so we're more likely to miss based on a property not existing than based on a noun not existing
  rules_list = rules_with[(nrules[2] ~= "be" and nrules[2]) or nrules[3] or nrules[1] or nrules[2]] or {}
  mergeTable(rules_list, rules_with[fnrules[3] or fnrules[1]] or {})

  if (debugging) then
    print ("found this many rules:"..tostring(#rules_list))
  end
  if #rules_list > 0 then
    for _,rules in ipairs(rules_list) do
      local rule = rules.rule
      if (debugging) then
        for i=1,3 do
          print("checking this rule,"..tostring(i)..":"..tostring(rule[ruleparts[i] ].name))
        end
      end
      local result = true
      for i=1,3 do
        local name = rule[ruleparts[i]].name
        --special case for stuff like 'group be x' - if we are in that group, we do match that rule
        --we also need to handle groupn't
        --seems to not impact performance much?
        local pre_match = false
        if rule_units[i] ~= nil then
          if name == "themself" and i == 3 and rule_units[1] then
            pre_match = rule_units[1] == rule_units[i]
          elseif name == "themselfn't" and i == 3 and rule_units[1] then
            pre_match = rule_units[1] ~= rule_units[i]
          elseif group_sets[name] and group_sets[name][rule_units[i] ] then
            pre_match = true
          else
            if rule_units[i].type == "object" and group_names_set_nt[name] then
              local nament = name:sub(1, -4)
              if not group_sets[nament][rule_units[i] ] then
                pre_match = true
              end
            end
          end
        end
        if not (pre_match) then
          if nrules[i] ~= nil and nrules[i] ~= name and (fnrules[i] == nil or (fnrules[i] ~= nil and fnrules[i] ~= name)) then
            if (debugging) then
              print("false due to nrules/fnrules mismatch")
            end
            result = false
          end
        end
      end
      --don't test conditions until the rule fully matches
      if result then
        for i=1,3,2 do
          if rule_units[i] ~= nil then
            if not testConds(rule_units[i], rule[ruleparts[i]].conds, rule_units[1]) then
              if (debugging) then
                print("false due to cond", i)
              end
              result = false
            else
              --check that there isn't a verbn't rule - edge cases where this might happen: text vs specific text, group vs unit. This is slow (15% longer unit tests, 0.1 second per unit test) but it fixes old and new bugs so I think we just have to suck it up.
              if rules_with[rule.verb.name.."n't"] ~= nil and #matchesRule(rule_units[i], rule.verb.name.."n't", rule.object.name, true) > 0 then
                result = false
              end
              --boring check. stopafterone is to make sure there's no infloops since i have no clue how anything actually works
              if not stopafterone and rules_with["boring"] and #matchesRule(rule_units[i],"be","boring",true)>0 and not (rules_with[rule.verb.name.."n'tn't"] and #matchesRule(rule_units[i], rule.verb.name.."n'tn't", rule.object.name, true)>0) then
                result = false
              end
            end
          end
        end
      end
      if result then
        if (debugging) then
          print("matched: " .. dump(rule) .. " | find: " .. find, nrules[1], fnrules[1], rule.subject.name, rule.subject.fullname)
        end
        if find == 0 then
          table.insert(ret, rules)
          if stopafterone then return ret end
        elseif find == 1 then
          local object_units = {}
          if find_arg == 3 and rule_units[1] and rule[ruleparts[find_arg]].name == "themself" then
            object_units = {rule_units[1]}
          elseif find_arg == 3 and rule_units[1] and rule[ruleparts[find_arg]].name == "themselfn't" then
            for _,unit in ipairs(units) do
              if unit ~= rule_units[1] and unit ~= outerlvl and unit.fullname ~= "no1" and unit.fullname ~= "bordr" then
                table.insert(object_units, unit)
              end
            end
          else
            object_units = findUnitsByName(rule[ruleparts[find_arg]].name)
          end
          for _,unit in ipairs(object_units) do
            local cond
            if testConds(unit, rule[ruleparts[find_arg]].conds, rule_units[1]) then
              --check that there isn't a verbn't rule - edge cases where this might happen: text vs specific text, group vs unit. This is slow (15% longer unit tests, 0.1 second per unit test) but it fixes old and new bugs so I think we just have to suck it up.
              if rules_with[rule.verb.name.."n't"] ~= nil and #matchesRule(unit, rule.verb.name.."n't", rule.object.name, true) > 0 then
              else
                table.insert(ret, {rules, unit})
                if stopafterone then return ret end
              end
            end
          end
        elseif find == 2 then
          local found1, found2
          for _,unit1 in ipairs(findUnitsByName(rule.subject)) do
            local object_units = {}
            if rule.object.name == "themself" then
              object_units = {unit1}
            elseif rule.object.name == "themselfn't" then
              for _,unit in ipairs(units) do
                if unit ~= unit1 and unit ~= outerlvl and unit.fullname ~= "no1" and unit.fullname ~= "bordr" then
                  table.insert(object_units, unit)
                end
              end
            else
              object_units = findUnitsByName(rule.object)
            end
            for _,unit2 in ipairs(object_units) do
              if testConds(unit1, rule.subject.conds, unit1) and testConds(unit2, rule.object.conds, unit1) then
                table.insert(ret, {rules, unit1, unit2})
                if stopafterone then return ret end
              end
            end
          end
        end
      end
    end
  end

  return ret
end

function boringAndNotCheck(unit, effect)
  if hasRule(unit, "ben't", effect) then return false end
  if not rules_with["boring"] or effect == "boring" then return true end
  if hasProperty(unit,"boring") then return hasRule(unit,"ben'tn't",effect) end
  return true
end

function getUnitsWithEffect(effect, return_rule)
  local result = {}
  local result_rules = {}
  local gotten = {}
  local rules = matchesRule(nil, "be", effect)
  --print ("h:"..tostring(#rules))
  for _,dat in ipairs(rules) do
    local unit = dat[2]
    if not unit.removed and boringAndNotCheck(unit, effect) then
      table.insert(result, unit)
      table.insert(result_rules, dat[1])
      gotten[unit] = true
    end
  end
  
  local rules = matchesRule(nil, "giv", effect)
  for _,rule in ipairs(rules) do
    local unit = rule[2]
    if not unit.removed then
      for _,other in ipairs(getUnitsOnTile(unit.x, unit.y, {exclude = unit, thicc = thicc_units[unit]})) do
        if not gotten[other] and sameFloat(unit, other) and ignoreCheck(other, unit) and boringAndNotCheck(other, effect) then
          table.insert(result, other)
          table.insert(result_rules, rule[1])
          gotten[other] = true
        end
      end
    end
  end
  
  local has_lvl_giv, lvl_giv_rule = hasRule(outerlvl, "giv", effect, true)
  if has_lvl_giv then
    for _,unit in ipairs(units) do
      if not gotten[unit] and inBounds(unit.x, unit.y) and ignoreCheck(unit, outerlvl) and boringAndNotCheck(unit, effect) then
        table.insert(result, unit)
        table.insert(result_rules, lvl_giv_rule)
      end
    end
  end
  
  if rules_with["rp"] then
    for i,unit in ipairs(result) do
      local isrp = matchesRule(nil,"rp",unit)
      for _,ruleparent in ipairs(isrp) do
        local mimic = ruleparent[2]
        if not gotten[mimic] and not hasRule(mimic,"ben't",effect) then
          gotten[mimic] = true
          table.insert(result,mimic)
          table.insert(result_rules, result_rules[i])
        end
      end
    end
    local therp = matchesRule(nil,"rp","the")
    for _,ruleparent in ipairs(therp) do
      local the = ruleparent[1].rule.object.unit
      local tx = the.x+dirs8[the.dir][1]
      local ty = the.y+dirs8[the.dir][2]
      local mimic = ruleparent[2]
      local stuff = getUnitsOnTile(tx,ty)
      for _,unit in ipairs(stuff) do
        local has_prop, prop_rule = hasProperty(unit,effect,true)
        if has_prop and not hasRule(mimic,"ben't",effect) then
          table.insert(result,mimic)
          table.insert(result_rules,prop_rule)
          break
        end
      end
    end
  end
  
  return result, (return_rule and result_rules or nil)
end

function getUnitsWithEffectAndCount(effect)
  local result = {}
  local rules = matchesRule(nil, "be", effect)
  --print ("h:"..tostring(#rules))
  for _,dat in ipairs(rules) do
    local unit = dat[2]
    if not unit.removed and boringAndNotCheck(unit, effect) then
      --[[if result[unit.id] == nil then
        result[unit.id] = 0
      end]]
      result[unit.id] = (result[unit.id] or 0) + 1
    end
  end
  
  local rules = matchesRule(nil, "giv", effect)
  for _,rule in ipairs(rules) do
    local unit = rule[2]
    if not unit.removed then
      for _,other in ipairs(getUnitsOnTile(unit.x, unit.y, {exclude = unit, thicc = thicc_units[unit]})) do
        if sameFloat(unit, other) and ignoreCheck(other, unit) and boringAndNotCheck(other, effect) then
          --[[if result[other.id] == nil then
            result[other.id] = 0
          end]]
          result[other.id] = (result[unit.id] or 0) + 1
        end
      end
    end
  end
  
  if hasRule(outerlvl, "giv", effect) then
    for _,unit in ipairs(units) do
      if inBounds(unit.x, unit.y) and ignoreCheck(unit, outerlvl) and boringAndNotCheck(unit, effect) then
        if result[unit.id] == nil then
          result[unit.id] = 0
        end
        result[unit.id] = result[unit.id] + 1
      end
    end
  end
  
  if rules_with["rp"] then
    for unit,count in pairs(result) do
      unit = units_by_id[unit] or cursors_by_id[unit]
      local isrp = matchesRule(nil,"rp",unit)
      for _,ruleparent in ipairs(isrp) do
        local mimic = ruleparent[2]
        if not mimic.removed and not hasRule(mimic,"ben't",effect) then
          result[mimic.id] = count
        end
      end
    end
    local therp = matchesRule(nil,"rp","the")
    for _,ruleparent in ipairs(therp) do
      local the = ruleparent[1].rule.object.unit
      local tx = the.x+dirs8[the.dir][1]
      local ty = the.y+dirs8[the.dir][2]
      local mimic = ruleparent[2]
      local stuff = getUnitsOnTile(tx,ty)
      for _,unit in ipairs(stuff) do
        if hasProperty(unit,effect) and not hasRule(mimic,"ben't",effect) then
          result[mimic.id] = countProperty(unit,effect)
        end
      end
    end
  end
  return result
end
function getUnitsWithEffectAndCountAndAnti(effect)
  local result = getUnitsWithEffectAndCount(effect)
  local anti = getUnitsWithEffectAndCount("anti "..effect)

  for unit,amt in pairs(anti) do
    result[unit] = (result[unit] or 0) - amt
  end
  return result
end

function getUnitsWithRuleAndCount(rule1, rule2, rule3)
  local result = {}
  local rules = matchesRule(rule1, rule2, rule3)
  --print ("h:"..tostring(#rules))
  for _,dat in ipairs(rules) do
    local unit = dat[2]
    if not unit.removed then
      if result[unit.id] == nil then
        result[unit.id] = 0
      end
      result[unit.id] = result[unit.id] + 1
    end
  end
  if rules_with["rp"] then
    for unit,count in pairs(result) do
      unit = units_by_id[unit] or cursors_by_id[unit]
      local isrp = matchesRule(nil,"rp",unit)
      for _,ruleparent in ipairs(isrp) do
        local mimic = ruleparent[2]
        if not mimic.removed and not hasRule(mimic,rule2.."n't",rule3) then
          result[mimic.id] = count
        end
      end
    end
    local therp = matchesRule(nil,"rp","the")
    for _,ruleparent in ipairs(therp) do
      local the = ruleparent[1].rule.object.unit
      local tx = the.x+dirs8[the.dir][1]
      local ty = the.y+dirs8[the.dir][2]
      local mimic = ruleparent[2]
      local stuff = getUnitsOnTile(tx,ty)
      for _,unit in ipairs(stuff) do
        if hasRule(unit,rule2,rule3) and not hasRule(mimic,rule2.."n't",rule3) then
          result[mimic.id] = countProperty(unit,effect)
        end
      end
    end
  end
  return result
end


function hasRule(rule1,rule2,rule3, return_rule)
  if rules_with["boring"] and rule3 ~= "boring" and #matchesRule(rule1,"be","boring",true) > 0 then return false end
  local matches = matchesRule(rule1,rule2,rule3, true)
  if #matches > 0 then return true, (return_rule and matches[1] or nil) end
  if not rules_with["rp"] then return false end
  if #matchesRule(rule1,rule2.."n't",rule3, true) > 0 then return false end
  local isrp = matchesRule(rule1,"rp",nil)
  for _,ruleparent in ipairs(isrp) do
    local mimic = ruleparent[2]
    local matches = matchesRule(mimic,rule2,rule3, true)
    if #matches > 0 then return true, (return_rule and matches[1] or nil) end
  end
  return false
end

function validEmpty(unit)
  return #unitsByTile(unit.x, unit.y) == 0
end

function findUnitsByName(name)
  if group_names_set_nt[name] then
    local everything_else_list = findUnitsByName(name:sub(1, -4))
    local everything_else_set = {}
    for _,unit in ipairs(everything_else_list) do
      everything_else_set[unit] = true
    end
    local result = {}
    for _,unit in ipairs(units) do
      if unit.type == "object" and not everything_else_set[unit] then
        table.insert(result, unit)
      end
    end
    return result
  elseif name == "mous" then
    return cursors
  elseif group_lists[name] ~= nil then
    return group_lists[name]
  elseif name == "no1" then
    local result = {}
    for _,unit in ipairs(units_by_name["no1"]) do
      if validEmpty(unit) then
        table.insert(result, unit)
      end
    end
    return result
  else
    return units_by_name[name] or {}
  end
end

function hasProperty(unit,prop,return_rule)
  if not rules_with[prop] and prop ~= "?" then return false end
  if rules_with["boring"] and prop ~= "boring" and hasProperty(unit,"boring") then return false end
  if unit and unit.fullname == "babby" and prop == "thicc" and not hasRule(unit, "be", "notranform") then return false end
  local has_be_rule, be_rule = hasRule(unit, "be", prop, true)
  if has_be_rule then return true, (return_rule and be_rule or nil) end
  if type(unit) ~= "table" then return false end
  if not rules_with["giv"] then return false end
  if hasRule(unit, "ben't", prop) then return false end
  if unit == outerlvl then return false end
  if unit and unit.class == "mous" then return false end
  if unit then
    local has_lvl_giv, lvl_giv_rule = hasRule(outerlvl, "giv", prop)
    if has_lvl_giv then return true, lvl_giv_rule end
    for _,other in ipairs(getUnitsOnTile(unit.x, unit.y, {exclude = unit, thicc = thicc_units[unit]})) do
      local givs = matchesRule(other, "giv", prop)
      if #givs > 0 and sameFloat(unit, other) and ignoreCheck(unit, other) then
        return true, (return_rule and givs[1] or nil)
      end
    end
  else
    local has_lvl_giv, lvl_giv_rule = hasRule(outerlvl, "giv", prop)
    if has_lvl_giv then return true, lvl_giv_rule end
    for _,ruleparent in ipairs(matchesRule(nil, "giv", prop)) do
      for _,other in ipairs(ruleparent.units) do
        if #getUnitsOnTile(other.x, other.y, {exclude = unit, checkmous = true, thicc = thicc_units[unit]}) > 0 and sameFloat(unit, other) then
          return true, (return_rule and ruleparent or nil)
        end
      end
    end
  end
  return false
end
function hasPropertyOrAnti(unit,prop,return_rule)
  if prop == "?" then return hasProperty(unit,prop,return_rule) end
  return hasProperty(unit,prop,return_rule) or hasProperty(unit,"anti "..prop,return_rule)
end

function countProperty(unit, prop, ignore_flye)
  if not rules_with[prop] and prop ~= "?" then return 0 end
  local result = #matchesRule(unit,"be",prop)
  --if rules_with["boring"] and prop ~= "boring" and hasProperty(unit,"boring") then return 0 end
  --if hasRule(unit, "ben't", prop) then return 0 end
  if not rules_with["giv"] then return result end
  if unit == outerlvl then return result end
  if unit and unit.class == "mous" then return result end
  result = result + #matchesRule(outerlvl, "giv", prop)
  if unit then
    for _,other in ipairs(getUnitsOnTile(unit.x, unit.y, {exclude = unit, checkmous = true, thicc = thicc_units[unit]})) do
      if ignoreCheck(unit, other) and (ignore_flye or sameFloat(unit, other)) then
        result = result + #matchesRule(other, "giv", prop)
      end
    end
  else -- I don't think anything uses this? it doesn't seem very useful at least, but I guess it's functional?
    for _,ruleparent in ipairs(matchesRule(nil, "giv", prop)) do
      for _,other in ipairs(ruleparent.units) do
        if ignoreCheck(unit, other) and (ignore_flye or sameFloat(unit, other)) then
          result = result + #getUnitsOnTile(other.x, other.y, {exclude = other, checkmous = true, thicc = countProperty(other,"thicc")})
        end
      end
    end
  end
  return result
end

function hasU(unit)
  for _,prop in ipairs{"u","utoo","utres","y'all","w","you"} do
    if hasProperty(unit,prop) or hasProperty(unit,"anti "..prop) then
      return true
    end
  end
  return false
end

function getUs()
  local yous = {}
  for _,prop in ipairs{"u","utoo","utres","y'all","w","you"} do
    mergeTable(yous,getUnitsWithEffect(prop))
    mergeTable(yous,getUnitsWithEffect("anti "..prop))
  end
  return yous
end

--to prevent infinite loops where a set of rules/conditions is self referencing
withrecursion = {}

function testConds(unit, conds, compare_with, first_unit) --cond should be a {condtype,{object types},{cond_units}}
  local first_unit = first_unit or unit
  local endresult = true
  for _,cond in ipairs(conds or {}) do
    local condtype = cond.name
    
    if condtype:starts("anti ") and anti_word_replacements[condtype:sub(6,-1)] then
      condtype = anti_word_replacements[condtype:sub(6,-1)]
    end
    
    local lists = {} -- for iterating
    local sets = {} -- for checking

    local count = 1
    if ( condtype:sub(-3) and tonumber( condtype:sub(-3) ) ) then
      count = tonumber( condtype:sub(-3) )
      condtype = condtype:sub(0,-4)
    end --a lot of things don't actually work with count yet, but hey

    if condtype:starts("that") then
      lists = cond.others or {} -- using "lists" to store the names, since THAT doesn't allow nesting, and we need the name for hasRule
    elseif cond.others then
      for _,other in ipairs(cond.others) do
        local list = {}
        local set = {}

        local function addUnit(otherunit)
          if not set[otherunit] then
            if testConds(otherunit, other.conds, unit, first_unit) then
              table.insert(list, otherunit)
              set[otherunit] = true
            end
          end
        end

        if other.name == "lvl" then -- probably have to account for group/every1 here too, maybe more
          addUnit(outerlvl)
        elseif other.name == "themself" then
          addUnit(first_unit)
        elseif other.name == "every1" or other.name == "every2" or other.name == "every3" then
          for _,name in ipairs(referenced_objects) do
            for _,nya in ipairs(findUnitsByName(name)) do
              addUnit(nya)
            end
          end
          if other.name == "every2" or other.name == "every3" then
            for _,nya in ipairs(findUnitsByName("txt")) do
              addUnit(nya)
            end
          end
          if other.name == "every3" then
            for _,name in ipairs(special_objects) do
              for _,nya in ipairs(findUnitsByName(name)) do
                addUnit(nya)
              end
            end
          end
        elseif group_lists[other.name] then
          for _,nya in ipairs(group_lists[other.name]) do
            addUnit(nya)
          end
        else
          for _,otherunit in ipairs(findUnitsByName(other.name)) do -- findUnitsByName handles mous and no1 already
            addUnit(otherunit)
          end
        end
        table.insert(lists, list)
        table.insert(sets, set)
      end
    end
    
    local result = true
    local cond_not = false
    
    if condtype:starts("anti ") and anti_word_reverses[condtype:sub(6,-1)] then
      condtype = condtype:sub(6,-1)
      cond_not = not cond_not
    end
    
    if condtype:ends("n't") then
      condtype = condtype:sub(1, -4)
      cond_not = not cond_not
    end

    local x, y = unit.x, unit.y

    local old_withrecursioncond = withrecursion[cond]
    
    withrecursion[cond] = true
    if (old_withrecursioncond) then
      result = false
    elseif condtype:starts("that") then
      result = true
      local verb = condtype:sub(5)
      for _,param in ipairs(lists) do -- using "lists" to store the names, since THAT doesn't allow nesting, and we need the name for hasRule
        local word = param.unit
        local wx = word.x
        local wy = word.y
        local wdir = word.dir
        local wdx = dirs8[wdir][1]
        local wdy = dirs8[wdir][2]
        if param.name == "her" then
          if unit.x ~= wx+wdx or unit.y ~= wy+wdy then
            result = false
          end
        elseif param.name == "thr" then
          local wtx,wty = wx+wdx,wy+wdy
          local stopped = false
          while not stopped do
            if canMove(unit,wdx,wdy,wdir,{start_x = wtx, start_y = wty}) then
              wdx,wdy,wdir,wtx,wty = getNextTile(word, wdx, wdy, wdir, nil, wtx, wty)
            else
              stopped = true
            end
          end
          if unit.x ~= wtx or unit.y ~= wty then
            result = false
          end
        elseif param.name == "rithere" then
          if unit.x ~= wx or unit.y ~= wy then
            result = false
          end
        else
          if not hasRule(unit,verb,param.name) then
            if not (param.name == unit.fullname and hasProperty(unit,"notranform")) then
              result = false
              break
            end
          end
        end
      end
    elseif condtype == "w/fren" then
      if unit == outerlvl then
        for _,other in ipairs(sets) do
          local found = 0
          for _,fren in ipairs(units) do
            if inBounds(fren.x,fren.y) and other[fren] then
              found = found+1
              if found >= count then break end
            end
          end
          if found < count then
            result = false
            break
          end
        end
        --something something surrounds maybe?
        --[[if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
          --use surrounds to remember what was around the level
          for __,on in ipairs(surrounds[0][0]) do
            if nameIs(on, param) then
              table.insert(others, on)
            end
          end]]
        for _,other in ipairs(lists) do
          if #other == 0 then
            result = false
            break
          end
        end
      else
        local frens = getUnitsOnTile(x, y, {exclude = unit, checkmous = true, thicc = thicc_units[unit]})
        for _,other in ipairs(sets) do
          if other[outerlvl] then
            if not inBounds(unit.x,unit.y) or count > 1 then
              result = false
            end
          else
            local found = 0
            for _,fren in ipairs(frens) do
              if other[fren] then
                found = found+1
                if found >= count then break end
              end
            end
            if found < count then
              result = false
              break
            end
          end
        end
      end
    elseif condtype:ends("arond") then
      --Vitellary: Deliberately ignore the tile we're on. This is different from baba.
      local others = {}
      for i=-1,1 do
        others[i] = {}
        for j=-1,1 do
          others[i][j] = {}
        end
      end
      for ndir=1,8 do
        local nx, ny = dirs8[ndir][1], dirs8[ndir][2]
        if unit == outerlvl then
          if surrounds ~= nil and surrounds_name == level_name then
            --use surrounds to remember what was around the level
            for __,on in ipairs(surrounds[nx][ny]) do -- this part hasn't been updated, but it's not important yet
              if nameIs(on, param) then
                others[nx][ny] = on
              end
            end
          end
        else
          local dx, dy, dir, px, py = getNextTile(unit, nx, ny, ndir)
          others[nx][ny] = getUnitsOnTile(px, py, {checkmous = true, thicc = thicc_units[unit]})
        end
      end
      local found_set = {}
      for i=1,8 do
        if (condtype == "arond") or (condtype == "ortho arond" and i%2==1) or (condtype == "diag arond" and i%2==0)
        or (condtype == dirs8_by_name[i].." arond") or (condtype == "spin"..i.." arond") then
          local nx,ny
          if (condtype == "spin"..i.." arond") then
            local j = (i+unit.dir+7)%8+1
            nx,ny = dirs8[j][1],dirs8[j][2]
          else
            nx,ny = dirs8[i][1],dirs8[i][2]
          end
          for _,set in ipairs(sets) do
            if not found_set[set] then
              for _,other in ipairs(others[nx][ny]) do
                if set[other] then
                  found_set[set] = true
                  break
                end
              end
            end
          end
        end
      end
      for _,set in ipairs(sets) do
        if not found_set[set] then
          result = false
          break
        end
      end
      -- also needs levelsurrounds support
    elseif condtype:ends("meow") then
      --This is all 8 directions in a straight beam, unless it hits a tranparn't or bordr.
      local found_set = {}
      for i=1,8 do
        if (condtype == "meow") or (condtype == "ortho meow" and i%2==1) or (condtype == "diag meow" and i%2==0)
        or (condtype == dirs8_by_name[i].." meow") or (condtype == "spin"..i.." meow") then
          local dx,dy
          local dir = i
          if (condtype == "spin"..i.." meow") then
            local j = (i+unit.dir+7)%8+1
            dx,dy = dirs8[j][1],dirs8[j][2]
          else
            dx,dy = dirs8[i][1],dirs8[i][2]
          end
          local tx,ty = unit.x,unit.y

          for d=1,100 do
            dx,dy,dir, tx, ty = getNextTile(unit, dx, dy, dir, false, tx, ty)
            
            local units = getUnitsOnTile(tx,ty)
            for _,unitd in ipairs(units) do
              if hasProperty(unitd,"tranparnt") or unitd.name == bordr then
                goto continue
              end --tranparen't stops it, and it's false for the tile with the tranparn't
            end
            for _,set in ipairs(sets) do
              if not found_set[set] then
                for _,other in ipairs(units) do
                  if set[other] then
                    found_set[set] = true
                    break
                  end
                end
              end
            end --set for

          end
        end --main if
        ::continue::
      end
      for _,set in ipairs(sets) do
        if not found_set[set] then
          result = false
          break
        end
      end

    elseif condtype == "seenby" then
      local others = {}
      for ndir=1,8 do
        local nx, ny = dirs8[ndir][1], dirs8[ndir][2]
        if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
          --use surrounds to remember what was around the level
          for __,on in ipairs(surrounds[nx][ny]) do -- this part hasn't been updated, but it's not important yet
            if nameIs(on, param) then
              table.insert(others, on)
            end
          end
        else
          local dx, dy, dir, px, py = getNextTile(unit, nx, ny, ndir)
          mergeTable(others, getUnitsOnTile(px, py, {checkmous = true, thicc = thicc_units[unit]}))
        end
      end
      if unit == outerlvl then --basically turns into sans n't BUT the unit has to be looking inbounds as well!
        for _,param in ipairs(params) do
          local found = 0
          local others = findUnitsByName(param)
          for _,on in ipairs(others) do
            if inBounds(on.x + dirs8[on.dir][1], on.y + dirs8[on.dir][2]) then
              found = found+1
              if found >= count then break end
            end
          end
          if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
            --use surrounds to remember what was around the level
            for nx=-1,1 do
              for ny=-1,1 do
                for __,on in ipairs(surrounds[nx][ny]) do
                  if nameIs(on, param) and nx + dirs8[on.dir][1] == 0 and ny + dirs8[on.dir][2] == 0 then
                    found = found+1
                    if found >= count then break end
                  end
                end
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      else
        for _,set in ipairs(sets) do
          local found = 0
          for _,other in ipairs(others) do
            if set[other] then
              local dx, dy, dir, px, py = getNextTile(other, dirs8[other.dir][1], dirs8[other.dir][2], other.dir)
              if px == unit.x and py == unit.y then
                found = found+1
                if found >= count then break end
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      end
    elseif condtype == "lookat" then
      --TODO: look at dir, ortho, diag, surrounds
      if unit ~= outerlvl then
        local dx, dy, dir, px, py = getNextTile(unit, dirs8[unit.dir][1], dirs8[unit.dir][2], unit.dir)
        local frens = getUnitsOnTile(px, py, {name = param, checkmous = true, thicc = thicc_units[unit]})
        for i,other in ipairs(sets) do
          local isdir = false
          if cond.others[i].name == "ortho" then
            isdir = true
            if (unit.dir % 2 == 0) then
              result = false
              break
            end
          elseif cond.others[i].name == "diag" then
            isdir = true
            if (unit.dir % 2 == 1) then
              result = false
              break
            end
          elseif cond.others[i].name:starts("spin") then
            isdir = true
            if (cond.others[i].name ~= "spin8") then
              result = false
              break
            end
          else
            for j = 1,8 do
              if cond.others[i].name == dirs8_by_name[j] then
                isdir = true
                if unit.dir ~= j then
                  result = false
                  break
                end
              end   
            end
          end
          if not isdir then
            if other[outerlvl] then
              if not inBounds(px,py) then
                result = false
                break
              end
            else
              local found = 0
              for _,fren in ipairs(frens) do
                if other[fren] then
                  found = found+1
                  if found >= count then break end
                end
              end
              if found < count then
                result = false
                break
              end
            end
          end
        end
      else --something something surrounds
        result = false
      end
    elseif condtype == "lookaway" then
      --TODO: look at dir, ortho, diag, surrounds
      if unit ~= outerlvl then
        local dx, dy, dir, px, py = getNextTile(unit, -dirs8[unit.dir][1], -dirs8[unit.dir][2], unit.dir)
        local frens = getUnitsOnTile(px, py, {name = param, checkmous = true, thicc = thicc_units[unit]})
        for _,other in ipairs(sets) do
          if other[outerlvl] then
            local dx, dy, dir, px, py = getNextTile(unit, dirs8[unit.dir][1], dirs8[unit.dir][2], unit.dir)
            if inBounds(px,py) then
              result = false
              break
            end
          else
            local found = 0
            for _,fren in ipairs(frens) do
              if other[fren] then
                found = found+1
                if found >= count then break end
              end
            end
            if found < count then
              result = false
              break
            end
          end
        end
      else --something something surrounds
        result = false
      end
    elseif condtype == "behind" then
      if result then result = sideCond(unit,sets,params,count,{{-1,-1}}) end
      --[[local others = {}
      for ndir=1,8 do
        local nx, ny = dirs8[ndir][1], dirs8[ndir][2]
        if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
          --use surrounds to remember what was around the level
          for __,on in ipairs(surrounds[nx][ny]) do -- this part hasn't been updated, but it's not important yet
            if nameIs(on, param) then
              table.insert(others, on)
            end
          end
        else
          local dx, dy, dir, px, py = getNextTile(unit, nx, ny, ndir)
          mergeTable(others, getUnitsOnTile(px, py, {checkmous = true, thicc = thicc_units[unit]}))
        end
      end
      if unit == outerlvl then --basically turns into sans n't BUT the unit's rear has to be looking inbounds as well!
        for _,param in ipairs(params) do
          local found = 0
          local others = findUnitsByName(param)
          for _,on in ipairs(others) do
            if inBounds(on.x + -dirs8[on.dir][1], on.y + -dirs8[on.dir][2]) then
              found = found+1
              if found >= count then break end
            end
          end
          if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
            --use surrounds to remember what was around the level
            for nx=-1,1 do
              for ny=-1,1 do
                for __,on in ipairs(surrounds[nx][ny]) do
                  if nameIs(on, param) and nx + -dirs8[on.dir][1] == 0 and ny + -dirs8[on.dir][2] == 0 then
                    found = found+1
                    if found >= count then break end
                  end
                end
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      else
        for _,set in ipairs(sets) do
          local found = 0
          for _,other in ipairs(others) do
            if set[other] then
              local dx, dy, dir, px, py = getNextTile(other, -dirs8[other.dir][1], -dirs8[other.dir][2], other.dir)
              if px == unit.x and py == unit.y then
                found = found+1
                if found >= count then break end
              else
                -- print(unit.x, unit.y)
                -- print(px, py)
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      end]]
    elseif condtype == "beside" then
      --if result then result = sideCond(unit,sets,params,count,{{-1,1},{1,-1}}) end
      local others = {}
      for ndir=1,8 do
        local nx, ny = dirs8[ndir][1], dirs8[ndir][2]
        if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
          --use surrounds to remember what was around the level
          for __,on in ipairs(surrounds[nx][ny]) do -- this part hasn't been updated, but it's not important yet
            if nameIs(on, param) then
              table.insert(others, on)
            end
          end
        else
          local dx, dy, dir, px, py = getNextTile(unit, nx, ny, ndir)
          mergeTable(others, getUnitsOnTile(px, py, {checkmous = true, thicc = thicc_units[unit]}))
        end
      end
      if unit == outerlvl then --basically turns into sans n't BUT the unit's side has to be looking inbounds as well!
        for _,param in ipairs(params) do
          local found = 0
          local others = findUnitsByName(param)
          for _,on in ipairs(others) do
            if inBounds(on.x - dirs8[on.dir][2], on.y + dirs8[on.dir][1]) or inBounds(on.x + dirs8[on.dir][2], on.y - dirs8[on.dir][1]) then
              found = found+1
              if found >= count then break end
            end
          end
          if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
            --use surrounds to remember what was around the level
            for nx=-1,1 do
              for ny=-1,1 do
                for __,on in ipairs(surrounds[nx][ny]) do
                  if nameIs(on, param) and ((nx - dirs8[on.dir][2] == 0 and ny + dirs8[on.dir][1] == 0) or (nx + dirs8[on.dir][2] == 0 and ny - dirs8[on.dir][1] == 0)) then
                    found = found+1
                    if found >= count then break end
                  end
                end
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      else
        for _,set in ipairs(sets) do
          local found = 0
          for _,other in ipairs(others) do
            if set[other] then
              local dx, dy, dir, px, py = getNextTile(other, dirs8[other.dir][2], -dirs8[other.dir][1], other.dir)
              local dx, dy, dir, qx, qy = getNextTile(other, -dirs8[other.dir][2], dirs8[other.dir][1], other.dir)
              if px == unit.x and py == unit.y or qx == unit.x and qy == unit.y then
                found = found+1
                if found >= count then break end
              end
            end
          end
          if found < count then
            result = false
            break
          end
        end
      end--]]
    elseif condtype == "sans" then
      for _,other in ipairs(lists) do
        if #other > count or #other == count and other[1] ~= unit then
          result = false
          break
        end
      end
    elseif condtype == "frenles" then
      if unit == outerlvl then --no longer by definition, since you can technically have the rules be oob!
        local found = false
        for _,fren in ipairs(units) do
          if inBounds(fren.x,fren.y) then
            found = true
            break
          end
        end
        if found then result = false end
      else
        local others = getUnitsOnTile(unit.x, unit.y, {exclude = unit, thicc = thicc_units[unit]})
        if #others > 0 then
          result = false
        end
      end
    elseif condtype == "wait..." then
      result = last_move ~= nil and last_move[1] == 0 and last_move[2] == 0 and #last_clicks == 0
    elseif condtype == "mayb" then
      local cond_unit = cond.unit
      --add a dummy action so that undoing happens
      if (#undo_buffer > 0 and #undo_buffer[1] == 0) then
        addUndo({"dummy"})
      end
      rng = deterministicRng(unit, cond.unit)
      result = (rng*100) < threshold_for_dir[cond.unit.dir]
    elseif condtype == "an" then
      local cond_unit = cond.unit
      --add a dummy action so that undoing happens
      if (#undo_buffer > 0 and #undo_buffer[1] == 0) then
        addUndo({"dummy"})
      end
      rng = deterministicRandom(unit.fullname, cond.unit)
      result = unit.id == rng
    elseif condtype == "lit" then
      --TODO: make it so if there are many lit objects then you cache FoV instead of doing many individual LoSes
      -- result = false
      -- if (successful_brite_cache ~= nil) then
      --   local cached = units_by_id[successful_brite_cache]
      --   if cached ~= nil and hasProperty(cached, "brite") and hasLineOfSight(cached, unit) then
      --     result = true
      --   end
      -- end
      -- if not result then
      --   --I am tempted to make it so N levels of BRITE can penetrate N-1 layers of OPAQUE but this mechanic would be too... opaque :drum:
      --   local others = getUnitsWithEffect("brite")
      --   for _,on in ipairs(others) do
      --     if hasLineOfSight(on, unit) then
      --       successful_brite_cache = on.id
      --       result = true
      --       break
      --     end
      --   end
      -- end
      if not ignoreCheck(unit,nil,"brite") or not ignoreCheck(unit,nil,"torc") then
        result = false
      elseif unit == outerlvl then
        local lights = getUnitsWithEffect("brite")
        mergeTable(lights,getUnitsWithEffect("torc"))
        local lit = false
        for _,light in ipairs(lights) do
          if inBounds(light.x,light.y) and sameFloat(light,outerlvl) then
            lit = true
            break
          end
        end
        result = lit
      else
        if inBounds(unit.x,unit.y) then
          if (lightcanvas == nil) then calculateLight() end
          local pixelData = lightcanvas:newImageData(1, 1, unit.x*32+15, unit.y*32+15, 2, 2)
          local r1 = pixelData:getPixel(0, 0)
          local r2 = pixelData:getPixel(0, 1)
          local r3 = pixelData:getPixel(1, 0)
          local r4 = pixelData:getPixel(1, 1)
          result = (r1+r2+r3+r4 >= 2)
        else result = false end
      end
    elseif condtype == "corekt" then
      if not unit.blocked then
        result = unit.active
      else
        result = false
      end
    elseif condtype == "rong" then
      result = unit.blocked
    elseif condtype == "timles" then
      result = timeless
    elseif condtype == "clikt" then
      result = false
      if last_click_button == 1 then
        for _,click in ipairs(last_clicks) do
          if click.x == unit.x and click.y == unit.y then
            result = true
          end
        end
      end
    elseif condtype == "anti clikt" then
      result = false
      if last_click_button == 2 then
        for _,click in ipairs(last_clicks) do
          if click.x == unit.x and click.y == unit.y then
            result = true
          end
        end
      end
    elseif main_palette_for_colour[condtype] then
      if unit.fullname == "no1" then
        result = false
      elseif unit.rave or unit.colrful then
        result = true
      else
        local has_flag = false
        local matched_flag = false
        for flag,overlay in pairs(overlay_props) do
          if unit[flag] then
            has_flag = true
            if table.has_value(overlay.colors, condtype) then
              matched_flag = true
              break
            end
          end
        end
        if has_flag then
          result = matched_flag
        else
          result = matchesColor(getUnitColors(unit), condtype)
        end
      end
    elseif condtype == "the" then
      local the = cond.unit
      
      local tx = the.x
      local ty = the.y
      local dir = the.dir
      local dx = dirs8[dir][1]
      local dy = dirs8[dir][2]
      
      dx,dy,dir,tx,ty = getNextTile(the,dx,dy,dir)
      result = ((unit.x == tx) and (unit.y == ty))
    elseif condtype == "deez" then
      local deez = cond.unit
      
      local tx = deez.x
      local ty = deez.y
      local dir = deez.dir
      local dx = dirs8[dir][1]
      local dy = dirs8[dir][2]

      local already_checked = {}
      local found = false

      while not already_checked[tx..","..ty..":"..dir] do
        already_checked[tx..","..ty..":"..dir] = true
        
        dx,dy,dir,tx,ty = getNextTile(deez,dx,dy,dir,nil,tx,ty)

        if not inBounds(tx, ty) then
          break
        elseif unit.x == tx and unit.y == ty then
          found = true
          break
        end
      end

      if not found then
        result = false
      end
    elseif condtype == "letter_custom" then
      local letter = cond.unit

      if unit.special.customletter ~= letter.special.customletter then
        result = false
      else
        print(unit.special.customletter)
      end
    elseif condtype == "inner" then
      if unit == outerlvl then
        result = false
      end
    elseif condtype == "unlocked" then
      if unit.name == "lvl" and unit.special.visibility ~= "open" then
        result = false
      end
      if unit.name == "lin" and unit.special.pathlock and unit.special.pathlock ~= "none" then
        result = false
      end
    elseif condtype == "wun" then
      local name = unit.special.level or level_filename
      result = readSaveFile{"levels",name,"won"}
    elseif condtype == "past" then
      if cond_not then
        result = doing_past_turns
      else
        result = false
      end
    elseif condtype == "samefloat" then
      result = sameFloat(unit, compare_with)
    elseif condtype == "samepaint" then
      result = matchesColor(getUnitColors(unit), getUnitColors(compare_with))
    elseif condtype == "sameface" then
      result = unit.dir == compare_with.dir
    elseif condtype == "anti samefloat" then
      result = sameFloat(unit, compare_with,nil,true)
    --[[elseif condtype == "anti samepaint" then
      local opposites = {
        reed = "cyeann",
        orang = "bleu",
        yello = "purp",
        grun = "pinc",
        cyeann = "reed",
        bleu = "orang",
        purp = "yello",
        pinc = "grun",
        whit = "blacc",
        graey = "graey",
        blacc = "whit",
        brwn = "cyeann"
      }]]
    elseif condtype == "anti sameface" then
      result = unit.dir == dirAdd(compare_with.dir,4)
    elseif condtype == "oob" then
      result = not inBounds(unit.x,unit.y)
    elseif condtype == "offgrid" then
      result = not ((math.floor(unit.x)==unit.x) and (math.floor(unit.y)==unit.y)) 
    elseif condtype == "alt" then
      result = #undo_buffer % 2 == 1
    else
      print("unknown condtype: " .. condtype)
      result = false
    end

    if cond_not then
      result = not result
    end
    if not result then
      endresult = false
    end
    
    withrecursion[cond] = old_withrecursioncond
  end
  return endresult
end

--this is used 3 times now so i figure it's about time to split it into its own function
function sideCond(unit,sets,params,count,dirs_)
  local result = true
  local others = {}
  for ndir=1,8 do
    local nx, ny = dirs8[ndir][1], dirs8[ndir][2]
    if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
      --use surrounds to remember what was around the level
      for __,on in ipairs(surrounds[nx][ny]) do -- this part hasn't been updated, but it's not important yet
        if nameIs(on, param) then
          table.insert(others, on)
        end
      end
    else
      local dx, dy, dir, px, py = getNextTile(unit, nx, ny, ndir)
      mergeTable(others, getUnitsOnTile(px, py, {checkmous = true, thicc = thicc_units[unit]}))
    end
  end
  if unit == outerlvl then --basically turns into sans n't BUT the unit's rear has to be looking inbounds as well!
    for _,param in ipairs(params) do
      local found = 0
      local others = findUnitsByName(param)
      for _,on in ipairs(others) do
        for ___,dirm in ipairs(dirs_) do
          if not inBounds(on.x + dirm[1]*dirs8[on.dir][1], on.y + dirm[2]*dirs8[on.dir][2]) then goto cont end
        end
        found = found+1
        if found >= count then break end
        ::cont::
      end
      if unit == outerlvl and surrounds ~= nil and surrounds_name == level_name then
        --use surrounds to remember what was around the level
        for nx=-1,1 do
          for ny=-1,1 do
            for __,on in ipairs(surrounds[nx][ny]) do
              if not nameIs(on, param) then goto cont end
              for ___,dirm in ipairs(dirs_) do
                if not (nx + dirm[1]*dirs8[on.dir][1] == 0 and ny + dirm[2]*dirs8[on.dir][2] == 0) then goto cont end
              end
              found = found+1
              if found >= count then break end
              ::cont::
            end
          end
        end
      end
      if found < count then
        result = false
        break
      end
    end
  else
    for _,set in ipairs(sets) do
      local found = 0
      for _,other in ipairs(others) do
        if set[other] then
          for ___,dirm in ipairs(dirs_) do
            local dx, dy, dir, px, py = getNextTile(other, dirm[1]*dirs8[other.dir][1], dirm[2]*dirs8[other.dir][2], other.dir)
            if px == unit.x and py == unit.y then
              found = found+1
              if found >= count then goto next end
              break
            end
          end
        end
      end
      ::next::
      if found < count then
        result = false
        break
      end
    end
  end
  return result
end

function hasLineOfSight(brite, lit)
  if not sameFloat(brite, lit) or not ignoreCheck(lit, brite, "brite") or not ignoreCheck(lit, nil, "torc") then
    return false
  end
  if (rules_with["tranparnt"] == nil) then
    return true
  end
  --https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
  local x0, y0, x1, y1 = brite.x, brite.y, lit.x, lit.y
  local dx = x1 - x0
  local dy = y1 - y0
  if (dx == 0 and dy == 0) then return true end
  if (math.abs(dx) > math.abs(dy)) then
    local derr = math.abs(dy / dx)
    local err = 0
    local y = y0
    local found_opaque = false
    for x = x0, x1, sign(dx) do
      if found_opaque then return false end
      if x ~= x0 or y ~= y0 then
        for _,v in ipairs(getUnitsOnTile(x, y)) do
          if hasProperty(v, "tranparnt") and ignoreCheck(brite, v, "tranparnt") then
            found_opaque = true
            break
          end
        end
      end
      err = err + derr
      if err >= 0.5 then
        y = y + sign(dy)
        err = err - 1
      end
    end
  elseif (math.abs(dy) > math.abs(dx)) then
    local derr = math.abs(dx / dy)
    local err = 0
    local x = x0
    local found_opaque = false
    for y = y0, y1, sign(dy) do
      if found_opaque then return false end
      if x ~= x0 or y ~= y0 then
        for _,v in ipairs(getUnitsOnTile(x, y)) do
          if hasProperty(v, "tranparnt") and not ignoreCheck(brite, v, "tranparnt") then
            found_opaque = true
            break
          end
        end
      end
      err = err + derr
      if err >= 0.5 then
        x = x + sign(dx)
        err = err - 1
      end
    end
  else --both equal
    local x = x0
    local found_opaque = false
    for y = y0, y1, sign(dy) do
      if x ~= x0 or y ~= y0 then
        if found_opaque then return false end
        for _,v in ipairs(getUnitsOnTile(x, y)) do
          if hasProperty(v, "tranparnt") and not ignoreCheck(brite, v, "tranparnt") then
            found_opaque = true
            break
          end
        end
      end
      x = x + sign(dx)
    end
  end
  return true
end

lightcanvas = nil
temp_lightcanvas = nil
lightcanvas_width = 0
lightcanvas_height = 0

torc_angles = {20,30,45,60,75,90,120,150,180,225,270,315,360}
function calculateLight()
  lights_ignored_opaque = {}
  if lightcanvas_width ~= mapwidth or lightcanvas_height ~= mapheight then
    lightcanvas = love.graphics.newCanvas(mapwidth*32, mapheight*32)
    temp_lightcanvas = love.graphics.newCanvas(mapwidth*32, mapheight*32)
    lightcanvas_height = mapheight
    lightcanvas_width = mapwidth
  end
  local brites = getUnitsWithEffect("brite")
  local torcs = getUnitsWithEffect("torc")
  if (#brites == 0 and #torcs == 0) then
    love.graphics.setCanvas(lightcanvas)
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setCanvas()
    return
  end
  local opaques = getUnitsWithEffect("tranparnt")
  if (#opaques == 0 and #brites ~= 0) then
    love.graphics.setCanvas(lightcanvas)
    love.graphics.clear(1, 1, 1, 1)
    love.graphics.setCanvas()
    return
  end
  love.graphics.setCanvas(lightcanvas)
  love.graphics.clear(0, 0, 0, 1)
  for _,unit in ipairs(brites) do
    love.graphics.setCanvas(temp_lightcanvas)
    love.graphics.clear(1, 1, 1, 1)
    drawShadows(unit, opaques)
    love.graphics.setCanvas(lightcanvas)
    love.graphics.setBlendMode("add", "premultiplied")
    love.graphics.draw(temp_lightcanvas)
    love.graphics.setBlendMode("alpha")
  end
  for _,unit in ipairs(torcs) do
    love.graphics.setCanvas(temp_lightcanvas)
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setColor(1, 1, 1, 1)
    local width = torc_angles[countProperty(unit,"torc")]
    if width then
      local facing = (1-unit.dir) * 45
      local cx = unit.x*32+16
      local cy = unit.y*32+16
      local ex = mapwidth*32
      local ey = mapheight*32
      local angle1 = (math.rad(facing - width/2)+math.pi*2) % (math.pi*2)
      local angle2 = (math.rad(facing + width/2)+math.pi*2) % (math.pi*2)
      local ur = math.atan2(unit.y+0.5, mapwidth-unit.x-0.5)
      local ul = math.atan2(unit.y+0.5, -unit.x-0.5)
      local dl = math.atan2(unit.y-mapheight+0.5, -unit.x-0.5)+math.pi*2
      local dr = math.atan2(unit.y-mapheight+0.5, mapwidth-unit.x-0.5)+math.pi*2
      if angle1 < ur or angle1 > dr then
        if angle2 < ur or angle2 > dr then
          love.graphics.polygon("fill", cx, cy, ex, cy+math.tan(angle1)*(cx-ex), ex, cy+math.tan(angle2)*(cx-ex))
        elseif angle2 < ul then
          love.graphics.polygon("fill", cx, cy, ex, cy+math.tan(angle1)*(cx-ex), ex, 0, cx+cy/math.tan(angle2), 0)
        elseif angle2 < dl then
          love.graphics.polygon("fill", cx, cy, ex, cy+math.tan(angle1)*(cx-ex), ex, 0, 0, 0, 0, cy+math.tan(angle2)*cx)
        else
          love.graphics.polygon("fill", cx, cy, ex, cy+math.tan(angle1)*(cx-ex), ex, 0, 0, 0, 0, ey, cx-(ey-cy)/math.tan(angle2), ey)
        end
      elseif angle1 < ul then
        if angle2 < ur or angle2 > dr then
          love.graphics.polygon("fill", cx, cy, cx+cy/math.tan(angle1), 0, 0, 0, 0, ey, ex, ey, ex, cy+math.tan(angle2)*(cx-ex))
        elseif angle2 < ul then
          love.graphics.polygon("fill", cx, cy, cx+cy/math.tan(angle1), 0, cx+cy/math.tan(angle2), 0)
        elseif angle2 < dl then
          love.graphics.polygon("fill", cx, cy, cx+cy/math.tan(angle1), 0, 0, 0, 0, cy+math.tan(angle2)*cx)
        else
          love.graphics.polygon("fill", cx, cy, cx+cy/math.tan(angle1), 0, 0, 0, 0, ey, cx-(ey-cy)/math.tan(angle2), ey)
        end
      elseif angle1 < dl then
        if angle2 < ur or angle2 > dr then
          love.graphics.polygon("fill", cx, cy, 0, cy+math.tan(angle1)*cx, 0, ey, ex, ey, ex, cy+math.tan(angle2)*(cx-ex))
        elseif angle2 < ul then
          love.graphics.polygon("fill", cx, cy, 0, cy+math.tan(angle1)*cx, 0, ey, ex, ey, ex, 0, cx+cy/math.tan(angle2), 0)
        elseif angle2 < dl then
          love.graphics.polygon("fill", cx, cy, 0, cy+math.tan(angle1)*cx, 0, cy+math.tan(angle2)*cx)
        else
          love.graphics.polygon("fill", cx, cy, 0, cy+math.tan(angle1)*cx, 0, ey, cx-(ey-cy)/math.tan(angle2), ey)
        end
      else
        if angle2 < ur or angle2 > dr then
          love.graphics.polygon("fill", cx, cy, cx-(ey-cy)/math.tan(angle1), ey, ex, ey, ex, cy+math.tan(angle2)*(cx-ex))
        elseif angle2 < ul then
          love.graphics.polygon("fill", cx, cy, cx-(ey-cy)/math.tan(angle1), ey, ex, ey, ex, 0, cx+cy/math.tan(angle2), 0)
        elseif angle2 < dl then
          love.graphics.polygon("fill", cx, cy, cx-(ey-cy)/math.tan(angle1), ey, ex, ey, ex, 0, 0, 0, 0, cy+math.tan(angle2)*cx)
        else
          love.graphics.polygon("fill", cx, cy, cx-(ey-cy)/math.tan(angle1), ey, cx-(ey-cy)/math.tan(angle2), ey)
        end
      end
    else
      love.graphics.clear(1, 1, 1, 1)
    end
    drawShadows(unit, opaques)
    love.graphics.setCanvas(lightcanvas)
    love.graphics.setBlendMode("add", "premultiplied")
    love.graphics.draw(temp_lightcanvas)
    love.graphics.setBlendMode("alpha")
  end
  love.graphics.setCanvas()
end

function drawShadows(source, opaques)
  love.graphics.setColor(0, 0, 0, 1)
  for _,opaque in ipairs(opaques) do
    local sourceX = source.x*32+16
    local sourceY = source.y*32+16
    local closeX = (opaque.x*32) + (opaque.x<source.x and 32 or 0)
    local farX = (opaque.x*32) + (opaque.x>=source.x and 32 or 0)
    local edgeX = (opaque.x>=source.x and mapwidth*32 or 0)
    local closeY = (opaque.y*32) + (opaque.y<source.y and 32 or 0)
    local farY = (opaque.y*32) + (opaque.y>=source.y and 32 or 0)
    local edgeY = (opaque.y>=source.y and mapheight*32 or 0)
    if lights_ignored_opaque[source.id .. ":" ..opaque.id] == nil then
      lights_ignored_opaque[source.id .. ":" ..opaque.id] = not ignoreCheck(source, opaque, "tranparnt")
    end
    if lights_ignored_opaque[source.id .. ":" ..opaque.id] then
      -- the flood of light is unstoppable
    elseif opaque.x == source.x and opaque.y == source.y then
      love.graphics.clear(0, 0, 0, 1)
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.rectangle("fill", closeX, closeY, 32, 32)
      return -- no light escapes this, no need to check other farther opaques from this light source
    elseif opaque.x == source.x then
      local diag2 = sourceX + (farX-sourceX)/(closeY-sourceY)*(edgeY-sourceY)
      local diag1 = sourceX + (closeX-sourceX)/(closeY-sourceY)*(edgeY-sourceY)
      -- love.graphics.polygon("fill", farX, farY, closeX, farY, closeX, closeY, diag1, edgeY, diag2, edgeY, farX, closeY)
      love.graphics.polygon("fill", closeX, farY, closeX, closeY, diag1, edgeY, farX, edgeY, farX, farY)
      love.graphics.polygon("fill", farX, edgeY, diag2, edgeY, farX, closeY)
    elseif opaque.y == source.y then
      local diag2 = sourceY + (farY-sourceY)/(closeX-sourceX)*(edgeX-sourceX)
      local diag1 = sourceY + (closeY-sourceY)/(closeX-sourceX)*(edgeX-sourceX)
      -- love.graphics.polygon("fill", farX, farY, closeX, farY, edgeX, diag1, edgeX, diag2, closeX, closeY, farX, closeY)
      love.graphics.polygon("fill", farX, closeY, closeX, closeY, edgeX, diag1, edgeX, farY, farX, farY)
      love.graphics.polygon("fill", edgeX, farY, edgeX, diag2, closeX, farY)
    else
      local diagX = sourceX + (closeX-sourceX)/(farY-sourceY)*(edgeY-sourceY) -- using triangle math here
      local diagY = sourceY + (closeY-sourceY)/(farX-sourceX)*(edgeX-sourceX) -- (not trigonometry, the other one)
      local cornerX = (edgeX > 0) and math.max(diagX, edgeX) or math.min(diagX, edgeX)
      local cornerY = (edgeY > 0) and math.max(diagY, edgeY) or math.min(diagY, edgeY)
      love.graphics.polygon("fill", farX, farY, closeX, farY, diagX, edgeY, cornerX, cornerY, edgeX, diagY, farX, closeY)
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
end

threshold_for_dir = {50, 0.01, 0.1, 1, 2, 5, 10, 25}

function deterministicRandom(fullname, cond)
  --have to adjust #undo_buffer by 1 during undoing since we're in the process of rewinding to the previous turn
  local key = fullname..","..tostring(cond.x)..","..tostring(cond.y)..","..tostring(cond.dir)..","..tostring(undoing and #undo_buffer - 1 or #undo_buffer)
  if rng_cache[key] == nil then
    local arbitrary_unit_key = math.random()
    local arbitrary_unit = units_by_name[fullname][math.floor(arbitrary_unit_key*#units_by_name[fullname])+1]
    rng_cache[key] = arbitrary_unit.id
  end
  return rng_cache[key]
end

function deterministicRng(unit, cond)
  --have to adjust #undo_buffer by 1 during undoing since we're in the process of rewinding to the previous turn
  local key = unit.name..","..tostring(unit.x)..","..tostring(unit.y)..","..tostring(unit.dir)..","..tostring(cond.x)..","..tostring(cond.y)..","..tostring(cond.dir)..","..tostring(undoing and #undo_buffer - 1 or #undo_buffer)
  if rng_cache[key] == nil then
     rng_cache[key] = math.random()
  end
  return rng_cache[key]
end

function inBounds(x,y,getting)
  if getting then
    return x >= 0 and x < mapwidth and y >= 0 and y < mapheight
  end
  if not selector_open then
    if x >= 0 and x < mapwidth and y >= 0 and y < mapheight then
      local borders = getUnitsOnTile(x,y)
      if borders ~= nil then
        for _,unit in ipairs(borders) do
          if unit.name == "bordr" then
            return false
          end
        end
      end
      return true
    else
      return false
    end
  else
    return x >=0 and x < tile_grid_width and y >= 0 and y < tile_grid_height
  end
end

function inScreen(x,y)
  local xmin,xmax,ymin,ymax = getCorners()
  
  return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

function getCorners()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local xmin,ymin = screenToGameTile(1,1)
  local xmax,ymax = screenToGameTile(width-1,height-1)
  
  return xmin,xmax,ymin,ymax
end

function removeFromTable(t, obj)
  if not t then
    return
  end
  for i,v in ipairs(t) do
    if v == obj then
      table.remove(t, i)
      return
    end
  end
end

function rotate(dir)
  return (dir-1 + 2) % 4 + 1
end

function rotate8(dir)
  return (dir-1 + 4) % 8 + 1
end

function nameIs(unit,name)
  return unit.name == name or unit.fullname == name or (group_sets[name] and group_sets[name][unit])
end

function tileHasUnitName(name,x,y)
  for _,v in ipairs(unitsByTile(x, y)) do
    if nameIs(v, name) then
      return true
    end
  end
end

function getUnitsOnTile(x,y,o)
  o = o or {}
  local name = o.name
  local not_destroyed = o.not_destroyed
  local exclude = o.exclude
  local checkmous = o.checkmous
  local thicc = o.thicc or 0
  
  local result = {}
  --[[for _,unit in ipairs(unitsByTile(x, y)) do
    if unit ~= exclude then
      if not not_destroyed or (not_destroyed and not unit.removed) then
        if not name or (name and nameIs(unit, name)) then
          table.insert(result, unit)
        end
      end
    end
  end]]
  for i=0,thicc do
    for j=0,thicc do
      for _,unit in ipairs(unitsByTile(x+i,y+j)) do
        if unit ~= exclude then
          if not not_destroyed or (not_destroyed and not unit.removed) then
            if not name or (name and nameIs(unit, name)) then
              table.insert(result, unit)
            end
          end
        end
      end
    end
  end
  --If we care about no1 and the tile is empty, find the no1 that's there.
  if (name == "mous") or checkmous then
    for _,cursor in ipairs(cursors) do
      if cursor ~= exclude then
        if not not_destroyed or (not_destroyed and not cursor.removed) then
          if cursor.x == x and cursor.y == y then
            table.insert(result, cursor)
          end
        end
      end
    end
  end
  if (#unitsByTile(x, y) == 0 and (name == "no1" or name == nil) and inBounds(x, y, true) and empties_by_tile[x + y * mapwidth] ~= exclude) then
    table.insert(result, empties_by_tile[x + y * mapwidth])
  end
  return result
end

function getCursorsOnTile(x, y, not_destroyed, exclude)
  local result = {}
  for _,cursor in ipairs(cursors) do
    if cursor ~= exclude then
      if not not_destroyed or (not_destroyed and not cursor.removed) then
        if cursor.x == x and cursor.y == y then
          table.insert(result, cursor)
        end
      end
    end
  end
  return result
end

function copyTable(t, l_)
  if t == nil then return t end
  local l = l_ or 0
  local new_table = {}
  for k,v in pairs(t) do
    if type(v) == "table" and l > 0 then
      new_table[k] = copyTable(v, l - 1)
    else
      new_table[k] = v
    end
  end
  return new_table
end

function deepCopy(o)
  if type(o) == "table" then
    local new_table = {}
    for k,v in pairs(o) do
      new_table[k] = deepCopy(v)
    end
    return new_table
  else
    return o
  end
end

function lerp(a,b,t) return (1-t)*a + t*b end

function fullDump(o, r, fulldump)
  if type(o) == 'table' and (not r or r > 0) then
    local s = '{'
    local first = true
    if not fulldump and o["new"] ~= nil then --abridged print for table
      o = {fullname = o.textname, id = o.id, x = o.x, y = o.y, dir = o.dir}
    end
    for k,v in pairs(o) do
      if not first then
        s = s .. ', '
      end
      local nr = nil
      if r then
        nr = r - 1
      end
      if type(k) ~= 'number' then
        s = s .. tostring(k) .. ' = ' .. fullDump(v, nr)
      else
        s = s .. fullDump(v, nr)
      end
      first = false
    end
    return s .. '}'
  elseif type(o) == 'string' then
    return '"' .. o .. '"'
  else
    return tostring(o)
  end
end

function dump(o, fulldump)
  if type(o) == 'table' then
    local s = '{'
    local cn = 1
    if #o ~= 0 then
      for _,v in ipairs(o) do
        if cn > 1 then s = s .. ',' end
        s = s .. dump(v, fulldump)
        cn = cn + 1
      end
    else
      if not fulldump and o["new"] ~= nil then --abridged print for table
        local tbl = {fullname = o.textname, id = o.id, x = o.x, y = o.y, dir = o.dir}
        for k,v in pairs(tbl) do
           if cn > 1 then s = s .. ',' end
          s = s .. tostring(k) .. ' = ' .. dump(v, fulldump)
          cn = cn + 1
        end
      else
        for k,v in pairs(o) do
          if cn > 1 then s = s .. ',' end
          s = s .. tostring(k) .. ' = ' .. dump(v, fulldump)
          cn = cn + 1
        end
      end
    end
    return s .. '}'
  elseif type(o) == 'string' then
    return '"' .. o .. '"'
  else
    return tostring(o)
  end
end

function hslToRgb(h, s, l, a)
  local r, g, b

  if s == 0 then
      r, g, b = l, l, l -- achromatic
  else
      function hue2rgb(p, q, t)
          if t < 0   then t = t + 1 end
          if t > 1   then t = t - 1 end
          if t < 1/6 then return p + (q - p) * 6 * t end
          if t < 1/2 then return q end
          if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
          return p
      end

      local q
      if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
      local p = 2 * l - q

      r = hue2rgb(p, q, h + 1/3)
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, h - 1/3)
  end

  return {r, g, b} --a removed cus unused
end

function addParticles(ptype,x,y,color,count)
  if doing_past_turns and not do_past_effects then return end
  
  if not settings["particles_on"] then return end

  if unit_tests then return end

  local particle_colors = {}
  if type(color[1]) ~= "table" then
    if #color == 2 then
      particle_colors = {getPaletteColor(color[1], color[2])}
    else
      particle_colors = {color[1]/255, color[2]/255, color[3]/255, (color[4] or 255)/255}
    end
  else
    for _,single_color in ipairs(color) do
      if #single_color == 2 then
        table.insert_range(particle_colors, {getPaletteColor(single_color[1], single_color[2])})
      else
        table.insert_range(particle_colors, {single_color[1]/255, single_color[2]/255, single_color[3]/255, (single_color[4] or 255)/255})
      end
    end
  end
  
  if ptype == "infup" then
    local speed = (TILE_SIZE*mapheight)/672
    local ps = love.graphics.newParticleSystem(sprites["infparticle"])
    local px = (mapwidth*TILE_SIZE)/2
    local py = (mapheight*TILE_SIZE)
    ps:setPosition(px, py)
    ps:setSpread(math.pi/4)
    ps:setEmissionArea("uniform", (mapwidth*TILE_SIZE)/2, 2, 0)
    ps:setSizes(2, 1.8, 1.5, 1, 0)
    ps:setSpeed(450*speed, 600*speed)
    ps:setSpin(0, 3.5)
    ps:setLinearDamping(1)
    ps:setParticleLifetime(1)
    ps:setDirection(1.5*math.pi)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 20)
    table.insert(particles, ps)
  elseif ptype == "inf" then
    local ps = love.graphics.newParticleSystem(sprites["infparticle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(3)
    ps:setEmissionArea("uniform", TILE_SIZE/3, TILE_SIZE/3, 0, true)
    ps:setSizes(1, 1, 1, 1, 0.75, 0)
    ps:setSpeed(300)
    ps:setLinearDamping(5)
    ps:setParticleLifetime(1, 1.2)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 20)
    table.insert(particles, ps)
  elseif ptype == "destroy" then
    local ps = love.graphics.newParticleSystem(sprites["circle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("uniform", TILE_SIZE/3, TILE_SIZE/3, 0, true)
    ps:setSizes(0.15, 0.15, 0.15, 0)
    ps:setSpeed(50)
    ps:setLinearDamping(5)
    ps:setParticleLifetime(0.25)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 20)
    table.insert(particles, ps)
  elseif ptype == "rule" then
    local ps = love.graphics.newParticleSystem(sprites["circle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("borderrectangle", TILE_SIZE/3, TILE_SIZE/3, 0, true)
    ps:setSizes(0.1, 0.1, 0.1, 0)
    ps:setSpeed(50)
    ps:setLinearDamping(4)
    ps:setParticleLifetime(0.25)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "bonus" then
    --print("sparkle !!")
    local ps = love.graphics.newParticleSystem(sprites["sparkle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0.8)
    ps:setEmissionArea("uniform", TILE_SIZE / 2, TILE_SIZE / 2, 0, true)
    ps:setSizes(0.40, 0.40, 0.40, 0)
    ps:setSpeed(30)
    ps:setLinearDamping(2)
    ps:setParticleLifetime(0.6)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "unwin" then
    local ps = love.graphics.newParticleSystem(sprites["sparkle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0.4)
    ps:setEmissionArea("uniform", TILE_SIZE*3/4, TILE_SIZE*3/4, 0, true)
    ps:setSizes(0.40, 0.40, 0.40, 0)
    ps:setSpeed(-40)
    ps:setLinearDamping(2)
    ps:setParticleLifetime(0.6)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "nxt" then
    local ps = love.graphics.newParticleSystem(sprites["sparkle"])
    local px = (x + 0.25) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0.5)
    ps:setEmissionArea("uniform", TILE_SIZE / 2, TILE_SIZE / 2, 0, false)
    ps:setSizes(0.40, 0.40, 0.40, 0)
    ps:setSpeed(30)
    ps:setLinearDamping(2)
    ps:setParticleLifetime(0.6)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "love" then
    local ps = love.graphics.newParticleSystem(sprites["luv"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("borderrectangle", TILE_SIZE/3, TILE_SIZE/3, 0, true)
    ps:setSizes(0.5, 0.5, 0.5, 0)
    ps:setSpeed(20)
    ps:setParticleLifetime(1)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "thonk" then
    local ps = love.graphics.newParticleSystem(sprites["wut"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("borderrectangle", TILE_SIZE/3, TILE_SIZE/3, 0, true)
    ps:setSizes(0.7, 0.7, 0.7, 0)
    ps:setSpeed(math.random(10,20))
    ps:setParticleLifetime(math.random(1,2))
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "slep" then
    local ps = love.graphics.newParticleSystem(sprites["letter_z"])
    local px = (x + 1) * TILE_SIZE
    local py = y * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("borderrectangle", 0, 0, 0, true)    
    ps:setSizes(0.5, 0.5, 0.5, 0)
    ps:setSpeed(10)
    ps:setLinearAcceleration(0,-50)
    ps:setParticleLifetime(2)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "sing" then
    local ps = love.graphics.newParticleSystem(sprites["noet"])
    local px = (x + 1) * TILE_SIZE
    local py = y * TILE_SIZE
    ps:setPosition(px, py)
    ps:setSpread(0)
    ps:setEmissionArea("borderrectangle", 0, 0, 0, true)    
    ps:setSizes(0.5, 0.5, 0.5, 0)
    ps:setSpeed(10)
    ps:setLinearAcceleration(0,-50)
    ps:setParticleLifetime(2)
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 10)
    table.insert(particles, ps)
  elseif ptype == "movement-puff" then
    local ps = love.graphics.newParticleSystem(sprites["circle"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    local size = 0.2
    ps:setPosition(px, py)
    ps:setSpread(0.3)
    ps:setEmissionArea("borderrectangle", TILE_SIZE/4, TILE_SIZE/4, 0, true)
    ps:setSizes(size, size, size, 0)
    ps:setSpeed(math.random(30, 40))
    ps:setLinearDamping(5)
    ps:setParticleLifetime(math.random(0.50, 1.10))
    ps:setColors(unpack(particle_colors))
    ps:start()
    ps:emit(count or 1)
    table.insert(particles, ps)
  elseif ptype == "sing" then
    local ps = love.graphics.newParticleSystem(sprites["noet"])
    local px = (x + 0.5) * TILE_SIZE
    local py = (y + 0.5) * TILE_SIZE
    local size = 0.2
    -- insert particles here
  end
end

function screenToGameTile(x, y, partial)
  if scene.getTransform then
    local transform = scene.getTransform()
    local mx,my = transform:inverseTransformPoint(x,y)
    local tilex = mx / TILE_SIZE
    local tiley = my / TILE_SIZE
    if not partial then
      tilex = math.floor(tilex)
      tiley = math.floor(tiley)
    end
    return tilex, tiley
  end
  return nil,nil
end

function gameTileToScreen(x,y)
  if scene.getTransform then
  	local screenx = (x * TILE_SIZE)
    local screeny = (y * TILE_SIZE)
    local transform = scene.getTransform()
    local mx,my = transform:transformPoint(screenx,screeny)
    return mx, my
  end
  return nil,nil
end

function getHoveredTile()
  if not cursor_converted then
    return screenToGameTile(love.mouse.getX(), love.mouse.getY())
  end
end

function eq(a,b)
  if type(a) == "table" or type(b) == "table" then
    if type(a) ~= "table" or type(b) ~= "table" then
      return false
    end
    local result = true
    if #a == #b then
      for i,v in pairs(a) do
        if v ~= b[i] then
          result = false
          break
        end
      end
    else
      result = false
    end
    return result
  else
    return a == b
  end
end

function pointInside(px_,py_,x,y,w,h,t)
  local px, py = px_, py_
  if t then
    px, py = t:inverseTransformPoint(px, py)
  end
  return px > x and px < x+w and py > y and py < y+h
end

function mouseOverBox(x,y,w,h,t)
  for i,pos in ipairs(getMousePositions()) do
    if pointInside(pos.x, pos.y, x, y, w, h, t) then
      return true
    end
  end
  return false
end

function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h*6, s, l
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m),(g+m),(b+m),a
end

function string.starts(str, start)
  return str:sub(1, #start) == start
end

function string.ends(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

function table.has_value(tab, val)
  for index, value in ipairs(tab) do
      if value == val then
          return true
      end
  end

  return false
end

function mergeTable(t, other)
  if other ~= nil then
    for k,v in pairs(other) do
      if type(k) == "number" then
        if not table.has_value(t, v) then
          table.insert(t, v)
        end
      else
        if t[k] ~= nil then
          if type(t[k]) == "table" and type(v) == "table" then
            mergeTable(t[k], v)
          end
        else
          t[k] = v
        end
      end
    end
  end
  return t
end

function mergeTable(t, other)
  if other ~= nil then
    for k,v in pairs(other) do
      if type(k) == "number" then
        if not table.has_value(t, v) then
          table.insert(t, v)
        end
      else
        if t[k] ~= nil then
          if type(t[k]) == "table" and type(v) == "table" then
            mergeTable(t[k], v)
          end
        else
          t[k] = v
        end
      end
    end
  end
  return t
end

function table.insert_range(t, other)
  for _,v in ipairs(other) do
    table.insert(t, v)
  end
  return t
end

function fullScreen()
  if not fullscreen then
    if not love.window.isMaximized( ) then
      winwidth, winheight = love.graphics.getDimensions( )
    end
    love.window.setMode(0, 0, {borderless=false})
    love.window.maximize( )
    fullscreen = true
  elseif fullscreen then
    love.window.setMode(winwidth, winheight, {borderless=false, resizable=true, minwidth=705, minheight=510})
    love.window.maximize()
    love.window.restore()
    fullscreen = false
  end
  settings["fullscreen"] = fullscreen
  saveAll()
  if scene ~= editor then
    scene.buildUI()
  end
end

function defaultSetting()
  for i in pairs(defaultsettings) do
    settings[i] = defaultsettings[i]
  end
end

function saveAll()
  love.filesystem.write("Settings.bab", json.encode(settings))
end

function debugDisplay(key, val)
  debug_values[key] = val
end

function keyCount(t)
  local count = 0
  for k,v in pairs(t) do
    count = count + 1
  end
  return count
end

function clamp(x, min_, max_)
  if x < min_ then
    return min_
  elseif x > max_ then
    return max_
  end
  return x
end

function getNearestPointInPerimeter(l,t,w,h,x,y)
  local r, b = l+w, t+h

  x, y = clamp(x, l, r), clamp(y, t, b)

  local dl, dr, dt, db = math.abs(x-l), math.abs(x-r), math.abs(y-t), math.abs(y-b)
  local m = math.min(dl, dr, dt, db)

  if m == dt then return x, t end
  if m == db then return x, b end
  if m == dl then return l, y end
  return r, y
end

function sign(x)
  if (x > 0) then
    return 1
  elseif (x < 0) then
    return -1
  end
  return 0
end

function countFlye(unit)
  return countProperty(unit, "flye", true) - countProperty(unit, "anti flye", true)
end
function sameFloat(a, b, ignorefloat, anti)
  if ignorefloat then
    return true
  elseif anti then
    local tallCheck = function(a,b)
      return (hasProperty(a, "tall", true) and countFlye(b) <= 0) or (hasProperty(a, "anti tall", true) and countFlye(b) >= 0)
    end
    return (-countFlye(a) == countFlye(b)) or tallCheck(a,b) or tallCheck(b,a)
  else
    local tallCheck = function(a,b)
      return (hasProperty(a, "tall", true) and countFlye(b) >= 0) or (hasProperty(a, "anti tall", true) and countFlye(b) <= 0)
    end
    return (countFlye(a) == countFlye(b)) or tallCheck(a,b) or tallCheck(b,a)
  end
end

function ignoreCheck(unit, target, property)
  if not rules_with["wont"] and not rules_with["ignor"] then
    return true
  elseif unit == target then
    if hasRule(unit,"ignor","themself") then
      return false
    else
      return true
    end
  elseif target and (hasRule(unit,"ignor",target) or hasRule(unit,"ignor",outerlvl)) and (not property or (not hasRule(unit,"wontn't",property))) then
    return false
  elseif property and (hasRule(unit,"wont",property)) and (not target or (not hasRule(unit,"ignorn't",target))) then
    return false
  end
  return true
end

function getPaletteColor(x, y, name_)
  local palette = palettes[name_ or current_palette] or palettes["default"]
  local pixelid = x + y * palette.sprite:getWidth()
  if palette[pixelid] then
    return palette[pixelid][1], palette[pixelid][2], palette[pixelid][3], palette[pixelid][4]
  else
    return 1, 1, 1, 1
  end
end

function getUIScale()
  local width = love.graphics.getWidth()
  if width < DEFAULT_WIDTH then
    return 1/math.ceil(DEFAULT_WIDTH / width)
  elseif width > DEFAULT_WIDTH then
    return math.floor(width / DEFAULT_WIDTH)
  else
    return 1
  end
end

function clearGooi()
  gooi.closeDialog()
  for k, v in pairs(gooi.components) do
    gooi.removeComponent(gooi.components[k])
  end
end

function getCombinations(t, param_)
-- t = {{tile1 words}, {tile2 words}, (until out of text)}
-- places the list of words into a full table of phrases (amount of words) long, {{11,21,31,41},{11,21,31,42},{11,21,32,41},...}
  local param = param_ or {}
  local ret = param.ret or {}
  local i = param.i or 1
  if t[i] then
    for _,v in ipairs(t[i]) do
      local current = copyTable(param.current or {})
      table.insert(current, v)
      if t[i+1] then
        getCombinations(t, {i = i+1, current = current, ret = ret})
      else
        table.insert(ret, current)
      end
    end
  end
  if i == 1 then
    return ret
  end
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function filter(xs, p)
  local newxs = {}
  for _,x in ipairs(xs) do
    if p(x) then table.insert(newxs, x) end
  end
  return newxs
end

function getAbsolutelyEverythingExcept(except)
  local result = {}

  --four special objects
  if "mous" ~= except then
    table.insert(result, "mous")
  end
  if "lvl" ~= except then
    table.insert(result, "lvl")
  end
  if "no1" ~= except then
    table.insert(result, "no1")
  end
  --don't specify generic text if it's already a type of text
  if not except:starts("txt") then
    table.insert(result, "txt")
  end
  
  for i,ref in ipairs(referenced_objects) do
    if ref ~= except and (ref ~= "this" or not except:starts("this")) then
      table.insert(result, ref)
    end
  end
  
  if (except ~= "txt") then
    for i,ref in ipairs(referenced_text) do
      --TODO: BEN'T text being returned here causes a stack overflow. Prevent it until a better solution is found.
      if ref ~= except and not ref:ends("n't") then
        table.insert(result, ref)
      end
    end
  end

  --print(dump(result))
  return result
end

function getEverythingExcept(except)
  local result = {}

  local ref_list = referenced_objects
  if except:starts("txt_") then
    ref_list = referenced_text
  end

  for i,ref in ipairs(ref_list) do
    --TODO: BEN'T text being returned here causes a stack overflow. Prevent it until a better solution is found.
    if ref ~= except and not ref:ends("n't") then
      table.insert(result, ref)
    end
  end
  
  --print(except)
  --print(dump(result))
  return result
end

function renameDir(from, to, cur_)
  if from == to then
    return
  end
  local cur = cur_ or ""
  love.filesystem.createDirectory(to .. cur)
  for _,file in ipairs(love.filesystem.getDirectoryItems(from .. cur)) do
    if love.filesystem.getInfo(from .. cur .. "/" .. file, "directory") then
      renameDir(from, to, cur .. "/" .. file)
    else
      love.filesystem.write(to .. cur .. "/" .. file, love.filesystem.read(from .. cur .. "/" .. file))
      love.filesystem.remove(from .. cur .. "/" .. file)
    end
  end
  love.filesystem.remove(from .. cur)
end

function deleteDir(dir)
  for _,file in ipairs(love.filesystem.getDirectoryItems(dir)) do
    if love.filesystem.getInfo(dir .. "/" .. file, "directory") then
      deleteDir(dir .. "/" .. file)
    else
      love.filesystem.remove(dir .. "/" .. file)
    end
  end
  love.filesystem.remove(dir)
end

function setRainbowModeColor(value, brightness)
  brightness = brightness or 0.5

  if rainbowmode and not spookmode then
    love.graphics.setColor(hslToRgb(value%1, brightness, brightness, .9))
  end
end

function shakeScreen(dur, intensity)
  if doing_past_turns and not do_past_effects or not settings["shake_on"] then return end
  shake_dur = dur+shake_dur/4
  shake_intensity = shake_intensity + intensity/2
end

function startTest(name)
  perf_test = {
    name = name,
    time = love.timer.getTime()
  }
end

function endTest()
  local time = love.timer.getTime() - perf_test.time
  print(perf_test.name .. ": " .. time .. "s")
end

function loadLevels(levels, mode, level_objs, xwx)
  if #levels == 0 then
    return
  end
  
  --setup stay ther
  stay_ther = nil
  if (rules_with ~= nil) and not xwx then
    stay_ther = {}
    local isstayther = getUnitsWithEffect("stayther")
    for _,unit in ipairs(isstayther) do
      table.insert(stay_ther, unit)
    end
  end
  
  --setup surrounds
  surrounds = nil
  if (level_objs ~= nil) then
    surrounds = {}
    for i = -1,1 do
      surrounds[i] = {}
      for j = -1,1 do
        surrounds[i][j] = {}
        for _,lvl in ipairs(level_objs) do
          for __,stuff in ipairs(getUnitsOnTile(lvl.x+i,lvl.y+j,{exclude = lvl})) do
            table.insert(surrounds[i][j], stuff)
          end
        end
      end
    end
  end

  local dir = "levels/"
  if world ~= "" then dir = getWorldDir() .. "/" end

  maps = {}

  mapwidth = 0
  mapheight = 0
  --if we're entering a level object, then the level we were in is the parent
  parent_filename = level_objs ~= nil and level_filename or nil
  level_name = nil
  level_filename = nil

  for _,level in ipairs(levels) do
    local split_name = split(level, "/")

    local data
    if split_name[#split_name] ~= "{DEFAULT}" then
      data = json.decode(love.filesystem.read(dir .. level .. ".bab"))
    else
      data = json.decode(default_map)
    end
    level_compression = data.compression or "zlib"
    local loaddata = love.data.decode("string", "base64", data.map)
    local mapstr = loadMaybeCompressedData(loaddata)

    loaded_level = not new

    if not level_name then
      level_name = data.name
    else
      level_name = level_name .. " & " .. data.name
    end
    
    if not level_filename then
      level_filename = level
    else
      level_filename = level_filename .. "|" .. level
    end
    
    level_name = level_name:sub(1, 100)
    level_author = data.author or ""
    level_extra = data.extra or false
    current_palette = data.palette or "default"
    map_music = data.music or "bab be u them"
    mapwidth = math.max(mapwidth, data.width)
    mapheight = math.max(mapheight, data.height)
    map_ver = data.version or 0
    level_parent_level = data.parent_level or ""
    level_next_level = data.next_level or ""
    level_is_overworld = data.is_overworld or false
    level_puffs_to_clear = data.puffs_to_clear or 0
    level_background_sprite = data.background_sprite or ""

    if map_ver == 0 then
      table.insert(maps, {data = loadstring("return " .. mapstr)(), info = data, file = level})
    else
      table.insert(maps, {data = mapstr, info = data, file = level})
    end

    icon_data = getIcon(dir .. level)

    table.remove(split_name)
    sub_worlds = split_name
  end

  if mode == "edit" then
    new_scene = editor
    if #maps == 1 and levels[1] ~= default_map then
      last_saved = maps[1].data
    else
      last_saved = nil
    end
  else
    surrounds_name = level_name
    new_scene = game
  end
end

function getMousePositions()
  if scene ~= game then
    return {{x = love.mouse.getX(), y = love.mouse.getY()}}
  else
    local t = {}
    for i,cursor in ipairs(cursors) do
      table.insert(t, {x = cursor.screenx, y = cursor.screeny})
    end
    return t
  end
end

function unsetNewUnits()
  for unit,_ in pairs(new_units_cache) do
    unit.new = false
  end
  for _,unit in ipairs(cursors) do
    unit.new = false
  end
  new_units_cache = {}
end

function timecheck(unit,verb,prop)
  local zw_pass = false
  if timeless then
    if hasProperty(unit,"zawarudo") then
      zw_pass = true
    elseif hasProperty(outerlvl,"zawarudo") and not hasRule(unit,"ben't","zawarudo") then
      zw_pass = true
    elseif verb and prop then
      local rulecheck = matchesRule(unit,verb,prop)
      for _,ruleparent in ipairs(rulecheck) do
        for i=1,#ruleparent.rule.subject.conds do
          if ruleparent.rule.subject.conds[i][1] == "timles" then
            zw_pass = true
          end
        end
      end
    end
  else
    zw_pass = not hasProperty(unit,"anti zawarudo")
  end
  local rhythm_pass = false
  if rules_with["rythm"] then
    if hasProperty(unit,"rythm") then
      rhythm_pass = true
    elseif hasProperty(outerlvl,"rythm") and not hasRule(unit,"ben't","rythm") then
      rhythm_pass = true
    end
    rhythm_pass = rhythm_pass == doing_rhythm_turn -- xnor
  else
    rhythm_pass = true
  end
  return zw_pass and rhythm_pass
end
function timecheckAntiP(unit,verb,prop)
  return timecheck(unit,verb,prop) or timecheck(unit,verb,"anti "..prop)
end
function timecheckAntiV(unit,verb,prop)
  return timecheck(unit,verb,prop) or timecheck(unit,"anti "..verb,prop)
end

function timecheckUs(unit)
  if timecheck(unit) then return true end
  local to_check = {"u","utoo","utres","y'all","you","w"}
  for _,prop in ipairs(to_check) do
    local rulecheck = matchesRule(unit,"be",prop)
    for _,ruleparent in ipairs(rulecheck) do
      for i=1,#ruleparent.rule.subject.conds do
        if ruleparent.rule.subject.conds[i][1] == "timles" then
          return true
        end
      end
    end
    rulecheck = matchesRule(unit,"be","anti "..prop)
    for _,ruleparent in ipairs(rulecheck) do
      for i=1,#ruleparent.rule.subject.conds do
        if ruleparent.rule.subject.conds[i][1] == "timles" then
          return true
        end
      end
    end
  end
  return false
end

function fillTextDetails(sentence, old_sentence, orig_index, word_index)
  --print(#old_sentence, orig_index, word_index)
  --changes a sentence of pure text into a valid sentence.
  --print("what we started with:",dump(sentence))
  local ret = {}
  local w = 0
  for _,word in ipairs(sentence) do
    --print("sentence: "..fullDump(sentence))
    --print(text_list[word], old_sentence)
    local newname = text_list[word].name
    if newname:starts("txt_") then
      newname = newname:sub(5)
    end
    table.insert(ret,{type = text_list[word].typeset or {object = true}, name = newname, unit=old_sentence[orig_index].unit})
    w = w+1
  end
  for i=orig_index+1,(word_index-1) do --extra ellipses for the purposes of making sure the parser gets it properly.
    --print("aa:",old_sentence[i])
    table.insert(ret,{type = text_list["..."].typeset or {object = true}, name = "...", unit=old_sentence[i].unit})
  end
  return ret
end

function addTables(source, to_add)
  --adds to_add to the end of source. Seperate from table.insert because this adds multiple entries. Also returns itself.
  for _,x in ipairs(to_add) do
    table.insert(source, x)
  end
  return source
end

--[[function dumpOfProperty(table, searchterm)
  -- a dump that's easier to search through.
  local ret = ""
  for _,first in pairs(table) do
    for _,second in pairs(first) do
      for key,param in pairs(second) do
        if key == searchterm then
          ret = ret..", "..fullDump(param)
        end
      end
    end
  end
  return "{"..string.sub(ret,3).."}"
end]]

function pcallNewShader(code)
  local libstatus, liberr = pcall(function() love.graphics.newShader(code) end)

  if libstatus then
    return love.graphics.newShader(code)
  else
    print(colr.yellow("⚠ failed to create new shader: "..liberr))
    return nil
  end
end

function pcallSetShader(shader)
  if shader ~= nil then
    love.graphics.setShader(shader)
  end
end

function loadMaybeCompressedData(loaddata)
  local mapstr = nil
  if pcall(function() mapstr = love.data.decompress("string", "zlib", loaddata) end) then
    return mapstr
  else
    return loaddata
  end
end

function extendReplayString(movex, movey, key)
  if (not unit_tests) then
    replay_string = replay_string..tostring(movex)..","..tostring(movey)..","..tostring(key)
    if key == "drag" then
      for _,unit in ipairs(drag_units) do
        replay_string = replay_string..":"..unit.id.."@"..unit.x.."@"..unit.y
      end
    end
    if (units_by_name["txt_mous"] ~= nil or rules_with["mous"] ~= nil) then
      local cursor_table = {}
      for _,cursor in ipairs(cursors) do
        table.insert(cursor_table, {cursor.x, cursor.y})
      end
      replay_string = replay_string..","..love.data.encode("string", "base64", serpent.line(cursor_table))
    end
    replay_string = replay_string..";"
  end
end

local last_save_file_name = nil
local last_save_file = nil

function writeSaveFile(value, arg)
  --e.g. writeSaveFile(true, {"levels", "new level", "won"})
  if (unit_tests) then return false end
  save = {}
  local filename = world
  if (world == "" or world == nil) then
    filename = "levels"
  end
  filename = "profiles/"..profile.name.."/"..filename..".savebab"
  
  --cache save file until filename changes
  if (last_save_file_name ~= filename) then
    --print("changing in write:", filename, last_save_file_name)
    last_save_file_name = filename
      if love.filesystem.read(filename) ~= nil then
      save = json.decode(love.filesystem.read(filename))
    end
    last_save_file = save
  else
    save = last_save_file
  end
  
  if #arg > 0 then
    local current = save
    for i,category in ipairs(arg) do
      if i == #arg then break end
      if current[category] == nil then
        current[category] = {}
      end
      current = current[category]
    end
    current[arg[#arg]] = value
    love.filesystem.write(filename, json.encode(save))
  end
  return true
end

function readSaveFile(arg)
  --e.g. readSaveFile({"levels", "new level", "won"})
  if (unit_tests) then return nil end
  save = {}
  local filename = world
  if (world == "" or world == nil) then
    filename = "levels"
  end
  filename = "profiles/"..profile.name.."/"..filename..".savebab"
  
  --cache save file until filename changes
  if (last_save_file_name ~= filename) then
    --print("changing in read:", filename, last_save_file_name)
    last_save_file_name = filename
      if love.filesystem.read(filename) ~= nil then
      save = json.decode(love.filesystem.read(filename))
    end
    last_save_file = save
  else
    save = last_save_file
  end
  
  local current = save
  for i,key in ipairs(arg) do
    if current[key] == nil then return nil end
    current = current[key]
  end
  return current
end

function loadWorld(default)
  local new_levels = {}
  level_tree = readSaveFile{"level_tree"} or split(default, ",")
  for _,level in ipairs(level_tree) do
    if not love.filesystem.getInfo(getWorldDir() .. "/" .. level .. ".bab") then
      level_tree = split(default, ",")
      writeSaveFile(level_tree, {"level_tree"})
      break
    end
  end
  new_levels = level_tree[1]
  table.remove(level_tree, 1)
  if type(new_levels) ~= "table" then
    new_levels = {new_levels}
  end
  in_world = true
  loadLevels(new_levels, "play")
end

function saveWorld()
  local new_tree = deepCopy(level_tree)
  table.insert(new_tree, 1, getMapEntry())
  writeSaveFile(new_tree, {"level_tree"})
end

function getMapEntry()
  if #maps == 1 then
    return maps[1].file or maps[1].info.name
  else
    local t = {}
    for _,map in ipairs(maps) do
      table.insert(t, map.file or map.info.name)
    end
    return t
  end
end

function addBaseRule(subject, verb, object, subjcond)
  local subjectname = subject:starts("this") and "this" or "txt_"..subject
  local objectname = object:starts("this") and "this" or "txt_"..object
  addRule({
    rule = {
      subject = {
        name = subject,
        conds = {subjcond},
        type = (getTile(subjectname) or getTile("txt_bab")).typeset,
      },
      verb = {
        name = verb,
        type = (getTile(verb) or getTile("txt_be")).typeset,
      },
      object = {
        name = object,
        type = (getTile(objectname) or getTile("txt_bab")).typeset,
      }
    },
    units = {},
    dir = 1,
    hide_in_list = true
  })
end

function addRuleSimple(subject, verb, object, units, dir)
  -- print(subject.name, verb.name, object.name)
  -- print(subject, verb, object)
  local subjectname = subject[1] or subject.name or ""
  subjectname = subjectname:starts("this") and "this" or "txt_"..subjectname
  local objectname = object[1] or object.name or ""
  objectname = objectname:starts("this") and "this" or "txt_"..objectname
  addRule({
    rule = {
      subject = getTableWithDefaults(copyTable(subject), {
        name = subject[1],
        conds = subject[2],
        type = (getTile(subjectname) or getTile("txt_bab")).typeset,
      }),
      verb = getTableWithDefaults(copyTable(verb), {
        name = verb[1],
        type = (getTile("txt_"..(verb[1] or verb.name or "")) or getTile("txt_be")).typeset,
      }),
      object = getTableWithDefaults(copyTable(object), {
        name = object[1],
        conds = object[2],
        type = (getTile(objectname) or getTile("txt_bab")).typeset,
      })
    },
    units = units,
    dir = dir
  })
end


group_lists = {}
group_sets = {}

function updateGroup(n)
  --if not groups_exist then return end
  local n = n or 0
  local changed = false
  for _,group in ipairs(group_names) do
    local list = {}
    local set = {}
    if group_subsets[group] then
      for _,subset in ipairs(group_subsets[group]) do
        if group_sets[subset] then
          for unit,v in pairs(group_sets[subset]) do
            set[unit] = v
          end
        end
      end
    end
    if (rules_with[group] ~= nil) then
      local rules = matchesRule(nil, "be", group)
      for _,rule in ipairs(rules) do
        local unit = rule[2]
        --by doing it this way, conds has already been tested, etc
        set[unit] = true
      end
      local rulesnt = matchesRule(nil, "ben't", group)
      for _,rule in ipairs(rulesnt) do
        local unit = rule[2]
        set[unit] = nil
      end
    end
    for unit,_ in pairs(set) do
      table.insert(list, unit)
    end
    local old_size = #(group_lists[group] or {})
    group_lists[group] = list
    group_sets[group] = set
    if #group_lists[group] ~= old_size then
      changed = true
    end
  end
  if changed then
    if n >= 1000 then
      print("group infinite loop! (1000 attempts to update list)")
      destroyLevel("infloop")
    else
      updateGroup(n+1)
    end
  end
end

function namesInGroup(group)
  local result = {}
  local tbl = copyTable(referenced_objects)
  mergeTable(tbl, referenced_text)
  table.insert(tbl, "lvl");
  table.insert(tbl, "mous");
  table.insert(tbl, "no1");
  table.insert(tbl, "bordr");
  for _,v in ipairs(tbl) do
    local group_membership = matchesRule(v, "be", group);
    for _,r in ipairs(group_membership) do
      if (#(r.rule.subject.conds) == 0) then
        table.insert(result, v)
      else
        for _,u in ipairs(units_by_name[v] or {v}) do
          if testConds(u, r.rule.subject.conds) then
            table.insert(result, v)
            break
          end
        end
      end
    end
  end
  return result
end

function serializeRule(rule)
  local result = ""
  result = result..serializeUnit(rule.subject, true)
  result = result..serializeWord(rule.verb)
  result = result..serializeUnit(rule.object, true) -- there's no reason for separate serializeClass/Property since the structure is the same
  return result
end

function serializeUnit(unit, outer)
  local prefix = ""
  local infix = ""
  local name = serializeWord(unit)
  if not unit.conds then
    return name
  end
  for i,cond in ipairs(unit.conds) do
    if not cond.others or #cond.others == 0 then
      prefix = prefix..serializeWord(cond)
    else
      infix = infix..serializeWord(cond)
      local infix_other = ""
      for j,other in ipairs(cond.others) do
        infix_other = infix_other..serializeUnit(other)
        infix_other = infix_other.."& "
      end
      infix_other = infix_other:sub(1,-3) -- remove last &
      infix = infix..infix_other.."& "
    end
  end
  infix = infix:sub(1,-3) -- remove last &
  local full = prefix..name..infix
  if not outer and full:find("&", 1) then
    full = "("..full..")"
  end
  return full
end

function serializeWord(word)
  if word.unit and hasProperty(word.unit, "stelth") then return "" end
  local name = word.unit and word.unit.display or word.name
  while name:starts("txt_") do
    name = name:sub(5).." txt"
  end
  return name.." "
end

function unitsByTile(x, y)
  if units_by_tile[x] == nil then
    units_by_tile[x] = {}
  end
  if units_by_tile[x][y] == nil then
    units_by_tile[x][y] = {}
  end
  --print(x, y, fullDump(units_by_tile[x][y]))
  return units_by_tile[x][y]
end

anagram_finder = {}
anagram_finder.enabled = false
-- anagram_finder.advanced = false
function anagram_finder.run()
  local letters = {}
  local multi = {}
  for _,unit in ipairs(units_by_name["txt"]) do
    if unit.typeset.letter then
      if #unit.textname == 1 then
        letters[unit.textname] = (letters[unit.textname] or 0) + 1
      else
        table.insert(multi, unit.textname)
      end
    end
  end
  anagram_finder.words = {}
  for _,tile in ipairs(tiles_list) do
    if tile.is_text and not tile.typeset.letter then
      local word = tile.txtname
      local letters = copyTable(letters)
      local multi = copyTable(multi)
      local not_match = false
      for i = #multi,1,-1 do -- multi in middle
        local new = word:gsub(multi[i],"|") -- | instead of nothing so that you can't have another multi span the gap, e.g. frgoen - go = fren
        if new ~= word then
          word = new
          table.remove(multi, i)
        end
      end
      for i = #multi,1,-1 do -- multi at end
        local m = multi[i]
        local found = false
        for j = #m,1,-1 do
          local s = m:sub(1,j)
          if word:ends(s) then
            word = word:sub(1, #word-j).."|"
            found = true
            break
          end
        end
        if found then
          table.remove(multi, i)
          break
        end
      end
      for i = #multi,1,-1 do -- multi at start
        local m = multi[i]
        local found = false
        for j = 1,#m do
          local s = m:sub(j)
          if word:starts(s) then
            word = "|"..word:sub(#s+1)
            found = true
            break
          end
        end
        if found then
          table.remove(multi, i)
          break
        end
      end
      for i = 1, #word do
        local l = word:sub(i,i)
        if l ~= "|" then -- represents a multiletter that has been accounted for already
          if letters[l] and letters[l] > 0 then
            letters[l] = letters[l] - 1
          else
            not_match = true
            break
          end
        end
      end
      if not not_match then
        table.insert(anagram_finder.words, tile.txtname)
      end
    end
  end
end

function drawCustomLetter(text, x, y, rot, sx, sy, ox, oy)
  love.graphics.push()
  love.graphics.translate(x or 0, y or 0)
  love.graphics.rotate(rot or 0)
  love.graphics.scale(sx or 1, sy or 1)
  love.graphics.translate(-(ox or 0), -(oy or 0))
  for i,q in ipairs(custom_letter_quads[#(text or "-")]) do
    local quad, dx, dy = unpack(q)
    local char = text:sub(i,i)
    if char == "*" then char = "asterisk" end
    love.graphics.draw(sprites["letters_"..char] or sprites["wut"], quad, dx, dy)
  end
  love.graphics.pop()
end

function getPastConds(conds)
  local result = false
  local new_conds = {}
  for _,cond in ipairs(conds) do
    if cond.name == "past" then
      result = true
    else
      table.insert(new_conds, cond)
    end
  end
  return result, new_conds
end

function jprint(str)
  if just_moved then
    print(str)
  end
end

function getTheme()
  if not settings["themes"] then return "default" end
  if cmdargs["theme"] then
    if cmdargs["theme"] ~= "" then
      return cmdargs["theme"]
    end
  else
    local month = tonumber(os.date("%m"))
    local day = tonumber(os.date("%d"))
    
    if month == 10 and day == 31 then
      return "halloween"
    elseif (month == 12 and day > 24) or (month == 01 and day < 6) then
      return "christmas"
    end
  end
  
  return menu_palette
end

function getTableWithDefaults(o, default)
  o = o or {}
  for k,v in pairs(default) do
    if o[k] == nil then o[k] = v end
  end
  return o
end

function buildOptions()
  if global_menu_state == "audio" then
    scene.addOption("master_vol", "master volume", {{"25%", 0.25}, {"50%", 0.5}, {"75%", 0.75}, {"100%", 1}})
    scene.addOption("music_on", "music", {{"on", true}, {"off", false}})
    scene.addOption("music_vol", "music volume", {{"25%", 0.25}, {"50%", 0.5}, {"75%", 0.75}, {"100%", 1}})
    scene.addOption("sfx_on", "sound", {{"on", true}, {"off", false}})
    scene.addOption("sfx_vol", "sound volume", {{"25%", 0.25}, {"50%", 0.5}, {"75%", 0.75}, {"100%", 1}})
    scene.addButton("back", function() global_menu_state = "none"; scene.buildUI() end)
  elseif global_menu_state == "video" then
    scene.addOption("int_scaling", "integer scaling", {{"on", true}, {"off", false}})
    scene.addOption("particles_on", "particle effects", {{"on", true}, {"off", false}})
    scene.addOption("shake_on", "shakes", {{"on", true}, {"off", false}})
    scene.addOption("scribble_anim", "animated scribbles", {{"on", true}, {"off", false}})
    scene.addOption("light_on", "lighting", {{"on", true}, {"off", false}})
    scene.addOption("lessflashing", "reduce flashes", {{"on", true}, {"off", false}})
    scene.addOption("grid_lines", "grid lines", {{"on", true}, {"off", false}})
    scene.addOption("mouse_lines", "mouse lines", {{"on", true}, {"off", false}})
    scene.addOption("stopwatch_effect", "stopwatch effect", {{"on", true}, {"off", false}})
    scene.addOption("fullscreen", "screen mode", {{"windowed", false}, {"fullscreen", true}}, function() fullScreen() end)
    scene.addOption("babafont", "use Baba Is You font", {{"off", false}, {"on", true}})
    if scene == menu then
      scene.addOption("scroll_on", "menu background scroll", {{"on", true}, {"off", false}})
      scene.addOption("menu_anim", "menu animations", {{"on", true}, {"off", false}})
    end
    scene.addOption("themes", "menu themes", {{"on", true}, {"off", false}})
    scene.addButton("back", function() global_menu_state = "none"; scene.buildUI() end)
  elseif global_menu_state == "editor" then
    scene.addOption("print_to_screen", "log print()s to screen", {{"on", true}, {"off", false}})
    scene.addOption("unfinished_words", "unfinished words in editor", {{"on", true}, {"off", false}})
    scene.addOption("infomode", "display object info", {{"on", true}, {"off", false}})
    scene.addButton("back", function() global_menu_state = "none"; scene.buildUI() end)
  elseif global_menu_state == "misc" then
    scene.addOption("input_delay", "input delay", {{"0", 0}, {"50", 50}, {"100", 100}, {"125", 125}, {"150 (default)", 150}, {"200", 200}})
    scene.addOption("focus_pause", "pause on defocus", {{"on", true}, {"off", false}})
    scene.addOption("autoupdate", "autoupdate (experimental)", {{"on", true}, {"off", false}})
    scene.addButton("back", function() global_menu_state = "none"; scene.buildUI() end)
  elseif global_menu_state == "misc2" then
    scene.addOption("contrast", "High contrasted colors", {{"on", true}, {"off", false}})
    scene.addButton("back", function() global_menu_state = "none"; scene.buildUI() end)
  else
    scene.addButton("audio options", function() global_menu_state = "audio"; scene.buildUI() end)
    scene.addButton("video options", function() global_menu_state = "video"; scene.buildUI() end)
    scene.addButton("editor options", function() global_menu_state = "editor"; scene.buildUI() end)
    scene.addButton("miscelleaneous options", function() global_menu_state = "misc"; scene.buildUI() end)
    scene.addButton("more miscelleaneous options", function() global_menu_state = "misc2"; scene.buildUI() end)
    scene.addButton("reset to default settings", function ()
      ui.overlay.confirm({
        text = "Reset all settings to default?",
        okText = "Yes",
        cancelText = "Cancel",
        ok = function()
          defaultSetting()
          scene.buildUI()
        end}
      )
    end)
    if scene == menu then
      scene.addButton("delete save data", function ()
        ui.overlay.confirm({
          text = "Delete save data?\nLÖVE will restart\n\n(WARNING: Data cannot be restored)",
          okText = "Yes",
          cancelText = "Cancel",
          ok = function()
            deleteDir("profiles")
            love.event.quit("restart")
          end}
        )
      end)
    end
    scene.addButton("back", function() options = false; scene.buildUI() end)
  end
end

function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function selectLastLevels()
  local cursors = getUnitsWithEffect("curse")
  if #cursors == 0 then return end

  local last_selected = readSaveFile{"levels", level_filename, "selected"} or {}
  if type(last_selected) ~= "table" then
    last_selected = {last_selected}
  end
  
  for i,level in ipairs(last_selected) do
    local selctr = cursors[((i-1)%#cursors)+1]
    for _,unit in ipairs(units) do
      if unit.special.level == level then
        moveUnit(selctr, unit.x, unit.y, nil, true)
      end
    end
  end
end

function getWorldDir(include_sub_worlds)
  if world == "" then
    return "levels"
  else
    local dir = world_parent .. "/" .. world
    if include_sub_worlds and #sub_worlds > 0 then
      dir = dir .. "/" .. table.concat(sub_worlds, "/")
    end
    return dir
  end
end

function searchForLevels(dir, search, exact)
  local results = {}
  local files = love.filesystem.getDirectoryItems(dir)

  for _,file in ipairs(files) do
    local info = love.filesystem.getInfo(dir .. "/" .. file)
    if info then
      if info.type == "directory" then
        for _,level in ipairs(searchForLevels(dir .. "/" .. file, search, exact)) do
          table.insert(results, {file = file .. "/" .. level.file, data = level.data})
        end
      elseif file:ends(".bab") then
        local name = file:sub(1, -5)
        local data = json.decode(love.filesystem.read(dir .. "/" .. file))
        local found = false
        if (not search) or (exact and name == search) or (not exact and string.find(name, search)) then
          found = true
        elseif (not search) or (exact and data.name == search) or (not exact and string.find(data.name, search)) then
          found = true
        end
        if found then
          table.insert(results, {file = name, data = data})
        end
      end
    end
  end

  return results
end

-- i was originally making this to use .icon as an alternate icon format for official world saving but i figured out how to save pngs directly so this is a tiny function that serves almost no purpose now and also this comment is really long if you don't have wrapping then your scrollbar is huge now you're welcome
function getIcon(path)
  if love.filesystem.getInfo(path .. ".png") then
    return love.graphics.newImage(path .. ".png")
  end
end

-- logic for how this function works:
-- nil checks (both nil -> true, one nil -> false)
-- loop for colors in a if there are multiple
-- loop for colors in b if there are multiple
-- actually compare the color
function matchesColor(a, b, exact)
  if not a ~= not b then return false end
  if not a and not b then return true end
  if type(a) == "table" and type(a[1]) ~= "number" then
    for _,c in ipairs(a) do
      if matchesColor(c, b, exact) then return true end
    end
    return false
  end
  if type(b) == "table" and type(b[1]) ~= "number" then
    for _,c in ipairs(b) do
      if matchesColor(a, c, exact) then return true end
    end
    return false
  end
  if exact then
    if type(a) == "string" then
      a = main_palette_for_colour[a]
    end
    if type(b) == "string" then
      b = main_palette_for_colour[b]
    end
    if #a == 2 and #b == 2 then
      return a[1] == b[1] and a[2] == b[2]
    end
    -- just in case
    if #a == 3 then
      a = getPaletteColor(unpack(a))
    end
    if #b == 3 then
      b = getPaletteColor(unpack(a))
    end
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
  else
    if type(a) == "table" then
      if #a == 2 then
        a = colour_for_palette[a[1]][a[2]]
      else
        return false -- I don't want to deal with this right now
      end
    end
    if type(b) == "table" then
      if #b == 2 then
        b = colour_for_palette[b[1]][b[2]]
      else
        return false -- I don't want to deal with this right now
      end
    end
    return a == b
  end
end

function overlayFromFlagProp(prop_name)
  local overlay = "flog/" .. string.sub(prop_name, 5)
  return overlay
end

function execute(command)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()

  return result
end

function addTile(tile)
  tile.types = tile.types or {"object"}
  tile.painted = tile.painted or {true}
  tile.rotate = tile.rotate or false
  tile.portal = tile.portal or false
  tile.wobble = tile.wobble or false
  tile.sprite_transforms = tile.sprite_transforms or {}
  tile.features = tile.features or {}
  tile.tags = tile.tags or {}
  tile.alias = tile.alias or {}
  tile.old_names = tile.old_names or {}

  tile.nt = tile.nt or false
  tile.meta = tile.meta or 0

  if tile.is_text == nil then
    tile.is_text = tile.name:starts("txt_") or tile.name:starts("letter_")
  end

  if tile.convertible == nil then
    tile.convertible = true
  end

  tile.layer = tile.layer or (tile.is_text and 20 or 1)
  tile.txtname = tile.txtname or (tile.is_text and tile.name:sub(5) or tile.name)

  if not tile.display then
    tile.display = tile.txtname

    if tile.nt then
      tile.display = tile.display .. " n't"
    end

    for i = 1, tile.meta do
      tile.display = tile.display .. " txt"
    end
  end

  tile.typeset = {}
  for _,type in ipairs(tile.types) do
    tile.typeset[type] = true
  end

  local relations = {}
  if tile.name:ends("n't") then
    table.insert(relations, tile.name:sub(1, -4))
    if tile.is_text then
      table.insert(relations, tile.txtname:sub(1, -4))
    end
  elseif tile.is_text then
    table.insert(relations, tile.txtname)
  end
  table.insert(relations, "txt_"..tile.name)
  for _,relation in ipairs(relations) do
    local other = tiles_list[relation]
    if other then
      if #tile.tags == 0 then
        for _,tag in ipairs(other.tags) do
          table.insert(tile.tags, tag)
        end
      end
      if #other.tags == 0 then
        for _,tag in ipairs(tile.tags) do
          table.insert(other.tags, tag)
        end
      end
    end
  end

  if not tile.pronouns then
    if not tile.is_text and table.has_value(tile.tags, "chars") then
      tile.pronouns = {"they", "them"}
    else
      tile.pronouns = {"it"}
    end
  end


  tiles_list[tile.name] = tile
  for _,old in ipairs(tile.old_names) do
    tiles_by_old_name[old] = tile
  end
  
  if tile.is_text and not tile.typeset.letter then
    local text_list = tile.wobble and wobble_text_list or text_list
    local text_in_tiles = tile.wobble and wobble_text_in_tiles or text_in_tiles

    text_list[tile.txtname] = tile
    text_in_tiles[tile.txtname] = tile.txtname

    for a,ali in ipairs(tile.alias) do
      text_in_tiles[ali] = tile.txtname
    end
  end

  if tile.typeset.group then
    addGroup(tile.txtname)
  end
  
  if tile.overlay then
    overlay_props[tile.txtname] = tile.overlay
  end

  return tile
end

function getTile(name, old)
  if tiles_list[name] then
    return tiles_list[name]
  end

  if old and tiles_by_old_name[name] then
    return tiles_by_old_name[name]
  end

  if name:ends("n't") then
    --print("making new tile: " .. name)

    local tile = getTile(name:sub(1, -4), old)
    if not tile then return nil end
    tile = deepCopy(tile)

    tile.name = tile.name .. "n't"
    tile.display = tile.display .. " n't"
    tile.sprite = tile.metasprite or tile.sprite
    tile.nt = true
    tile.pronouns = {"it"}
    tile.old_names = {}

    return addTile(tile)
  elseif name:starts("txt_") then
    --print("making new tile: " .. name)

    local tile = getTile(name:sub(5), old)
    if not tile then return nil end
    tile = deepCopy(tile)

    tile.name = "txt_" .. tile.name
    tile.display = tile.display .. " txt"
    tile.sprite = tile.metasprite or tile.sprite
    tile.types = {"object"}
    tile.thingify = nil
    tile.txtname = "txt_" .. tile.txtname
    tile.is_text = true
    tile.meta = tile.meta + 1
    tile.pronouns = {"it"}
    tile.old_names = {}
    if tile.layer < 20 then
      tile.layer = 20
    end

    return addTile(tile)
  end
end

local function addTry(try, str, extra)
  if extra then
    for i = 1, #try do
      local nya = str:gsub("%?",try[i])
      table.insert(try, i, nya)
      i = i + 1
    end
  else
    table.insert(try, 1, str)
  end
end

function getTileSprite(name, tile, o)
  local o = getTableWithDefaults(o, {wobble = 1, sleep = false})
  local try = o.try or {name}
  if tile then
    if name == "os" then
      local os = love.system.getOS()
      if os == "Windows" then
        addTry(try, "os_windous")
      elseif os == "OS X" or os == "iOS" then
        addTry(try, "os_mak")
      elseif os == "Linux" then
        addTry(try, "os_linx")
      elseif os == "Android" then
        addTry(try, "os_androd")
      end
    elseif name == "ui_gui" then
      local os = love.system.getOS()
      if os == "Windows" then
        addTry(try, "ui_win")
      elseif os == "OS X" or os == "iOS" then
        addTry(try, "ui_cmd")
      else
        addTry(try, "ui_win")
      end
    elseif name == "ui_cap" then
      if capslock then
        addTry(try, "ui_cap_on")
      else
        addTry(try, "ui_cap_off")
      end
    end

    if o.sleep then
      addTry(try, "?_slep", true)
    end

    if tile.wobble then
      local wobble_frame = anim_stage % 3 + 1
      addTry(try, "?_"..wobble_frame, true)
    end
  end
  for _,try_name in ipairs(try) do
    if sprites[try_name] then
      return sprites[try_name], try_name
    end
  end
  return sprites["wat"], "wat"
end

function getTileSprites(tile)
  local sprites = {}
  for i,sprite in ipairs(tile.sprite) do
    local _,name = getTileSprite(sprite, tile)
    sprites[i] = name
  end
  return sprites
end

function getTileColor(tile, index, override)
  if index then
    if override and tile.painted[index] then
      return deepCopy(override)
    else
      return deepCopy(tile.color[index])
    end
  else
    for i,color in ipairs(tile.color) do
      if tile.painted[i] then
        return getTileColor(tile, i, override)
      end
    end
    return deepCopy(tile.color[1])
  end
end

function getTileColors(tile, override)
  local colors = {}
  for i = 1, #tile.color do
    colors[i] = getTileColor(tile, i, override)
  end
  return colors
end

function getUnitSprite(name, unit)
  local try = {name}
  if unit then
    if unit.class == "cursor" then
      return name
    end
    -- lvl stuff
    if name == "lvl" and unit.special.visibility == "hidden" then
      addTry(try, "lvl_hidden")
    elseif name == "lvl" and (unit.special.visibility == "locked" or unit.special.visibility == nil) then
      addTry(try, "lvl_locked")
    elseif name == "lvl" and scene == game and unit.special.level and readSaveFile{"levels", unit.special.level, "won"} then
      addTry(try, "lvl_won")
    -- lin stuff
    elseif name == "lin" and unit.special.pathlock and unit.special.pathlock ~= "none" then
      addTry(try, "lin_gate")
    elseif name == "lin" and unit.special.visibility == "hidden" then
      addTry(try, "lin_hidden")
    -- misc
    elseif name == "txt/now" and doing_past_turns then
      addTry(try, "txt/latr")
    elseif name == "txt/themself" and scene == game and rules_with_unit[unit] then
      local pronoun
      for _,rules in ipairs(rules_with_unit[unit]) do
        local name = rules.rule.subject.name 
        if name:ends("n't") or name == "every1" or name == "every2" or name == "every3" or group_names_set[name] then
          pronoun = "them"
          break
        end
        local subject = rules.rule.subject.unit and getTile(rules.rule.subject.unit.textname)
        if subject then
          local new_pronoun
          if subject.pronouns and subject.pronouns[1] == "genderfluid" then
            local cycle_pronouns = {"them", "her", "it", "xem", "him", "hir"}
            new_pronoun = cycle_pronouns[(math.floor(love.timer.getTime()/0.18) + unit.tempid) % #cycle_pronouns + 1].."self"
          else
            new_pronoun = (subject.pronouns and (subject.pronouns[2] or subject.pronouns[1]) or "it").."self"
          end
          if pronoun and pronoun ~= new_pronoun then
            pronoun = "themself"
          else
            pronoun = new_pronoun
          end
          if pronoun == "themself" then break end
        else
          if pronoun and pronoun ~= "itself" then
            pronoun = "themself"
            break
          else
            pronoun = "itself"
          end
        end
      end
      pronoun = pronoun or "itself"
      addTry(try, "txt/"..pronoun)
    elseif name == "txt/themself_lower" and scene == game and rules_with_unit[unit] then
      local has_multiple = false
      local last_units
      for _,rules in ipairs(rules_with_unit[unit]) do
        local name = rules.rule.subject.name 
        if name:ends("n't") or name == "every1" or name == "every2" or name == "every3" or name == "lethers" or name == "numa" or name == "yuiy" or group_names_set[name] then
          has_multiple = true
          break
        elseif not last_units then
          last_units = rules.units
        elseif not eq(last_units, rules.units) then
          has_multiple = true
          break
        end
      end
      if has_multiple then
        addTry(try, "txt/themselves_lower")
      end
    end

    for type,name in pairs(unit.sprite_transforms) do
      if type == "inactive" then
        if not unit.active then
          addTry(try, name)
        end
      elseif type == "active" then
        if unit.active then
          addTry(try, name)
        end
      elseif table.has_value(unit.used_as, type) then
        addTry(try, name)
        break
      end
    end
  end

  return getTileSprite(name, unit and getTile(unit.tile), {
    try = try,
    wobble = unit and unit.frame or 0,
    sleep = unit and graphical_property_cache["slep"][unit]
  })
end

function getUnitSprites(unit)
  local sprites = {}
  for i,sprite in ipairs(unit.sprite) do
    local _,name = getUnitSprite(sprite, unit)
    sprites[i] = name
  end
  return sprites
end

function getUnitColor(unit, index, override_)
  local override = override_ or unit.color_override

  if unit.class == "cursor" then
    return index and unit.color[index] or unit.color[1]
  end
  
  if index then
    if not override and unit.name == "lin" and unit.special.pathlock and unit.special.pathlock ~= "none" then
      return {2, 2}
    elseif unit.sprite[i] == "detox" and graphical_property_cache["slep"][unit] ~= nil then
      return {1, 2}
    else
      return getTileColor(getTile(unit.tile), index, override)
    end
  else
    for i,color in ipairs(unit.color) do
      if unit.painted[i] then
        return getUnitColor(unit, i, override)
      end
    end
    return getUnitColor(getTile(unit.tile), 1, override)
  end
end

function getUnitColors(unit, override_)
  local colors = {}
  for i = 1, #unit.color do
    colors[i] = getUnitColor(unit, i, override_)
  end
  return colors
end

function drawTileSprite(tile, x, y, rotation, sx, sy, o)
  local o = getTableWithDefaults(copyTable(o or {}), {
    sprite = getTileSprites(tile),
    color = getTileColors(tile),
    painted = tile.painted,
    meta = tile.meta,
    nt = tile.nt,
    wobble = tile.wobble,
    really_smol = tile.name == "babby",
    lvl = tile.name == "lvl",
  })
  drawSprite(x, y, rotation, sx, sy, o)
end

function drawUnitSprite(unit, x, y, rotation, sx, sy, o)
  local brightness = 1

  if scene == game then
    if (hasRule(unit,"be","wurd") or hasRule(unit,"be","anti wurd")) and not unit.active and not level_destroyed and not (unit.fullname == "prop") then
      brightness = 0.33
    end
    if (unit.name == "steev") and not hasU(unit) then
      brightness = 0.33
    end
    if unit.name == "casete" and not hasProperty(unit, "nogo") then
      brightness = 0.5
    end
    if timeless and not hasProperty(unit,"zawarudo") and not (unit.type == "txt") then
      brightness = 0.33
    end
  end

  local o = getTableWithDefaults(copyTable(o or {}), {
    sprite = getUnitSprites(unit),
    color = getUnitColors(unit),
    painted = unit.painted,
    special = unit.special,
    overlay = unit.overlay,
    meta = unit.meta,
    nt = unit.nt,
    alpha = unit.draw.opacity,
    brightness = brightness,
    id = unit.id,
    frame = unit.frame,
    wobble = unit.wobble,
    delet = unit.delet,
    really_smol = unit.fullname == "babby",
    lvl = unit.fullname == "lvl",
  })
  drawSprite(x, y, rotation, sx, sy, o)
end

function drawSprite(x, y, rotation, sx, sy, o)
  local o = getTableWithDefaults(copyTable(o or {}), {
    sprite = {},
    color = {},
    painted = {},
    special = {},
    overlay = {},
    meta = 0,
    nt = false,
    alpha = 1,
    brightness = 1,
    id = 0,
    frame = x+y,
    wobble = false,
    anti_wobble = false,
    delet = false,
    really_smol = false,
    lvl = false,
  })

  local max_w, max_h = 0, 0
  local is_lvl = false

  for _,image in ipairs(o.sprite) do
    local sprite = sprites[image]
    max_w = math.max(max_w, sprite:getWidth())
    max_h = math.max(max_h, sprite:getHeight())
  end

  local function setColor(color, brightness)
    if #color == 3 then
      if color[1] then
        color = {color[1]/255, color[2]/255, color[3]/255, 1}
      else
        color = {1,1,1,1}
      end
    else
      local palette = current_palette
      if current_palette == "default" and o.wobble then
        palette = "baba"
      end
      color = {getPaletteColor(color[1], color[2], palette)}
    end

    local bg_color = {getPaletteColor(1, 0)}

    -- multiply brightness by darkened bg color
    for i,c in ipairs(bg_color) do
      if i < 4 then
        color[i] = (1 - o.brightness) * (bg_color[i] * 0.5) + o.brightness * color[i]
      end
    end

    love.graphics.setColor(color[1], color[2], color[3], color[4]*o.alpha)

    return color
  end

  local function drawSpriteMaybeOverlay(overlay, onlycolor, stretch)
    if overlay and stretch then
      love.graphics.setColor(1,1,1,1)
      local sprite = sprites[overlay]
      love.graphics.draw(sprite, x, y, rotation, max_w / TILE_SIZE, max_h / TILE_SIZE, sprite:getWidth() / 2, sprite:getHeight() / 2)
    else
      if overlay then
        local sprite = sprites[overlay]
        love.graphics.draw(sprite, x, y, rotation, sx, sy, sprite:getWidth() / 2, sprite:getHeight() / 2)
      else
        for i,image in ipairs(o.sprite) do
          setColor(o.color[i])
          if onlycolor or (#o.overlay > 0 and o.painted[i]) then
            love.graphics.setColor(1,1,1,1)
          end
          if not onlycolor or o.painted[i] then
            if image == "letter_custom" then
              --if #o.special.customletter == 1 then 
              if o.special.customletter and (#o.special.customletter > 1 or sprites["letter_"..o.special.customletter]) then
                drawCustomLetter(o.special.customletter, x, y, rotation, sx, sy, 16, 16)
              else
                local sprite = sprites["wut"]
                love.graphics.draw(sprites["wut"], x, y, rotation, sx, sy, sprite:getWidth() / 2, sprite:getHeight() / 2)
              end
            else
              local sprite = sprites[image]
              love.graphics.draw(sprite, x, y, rotation, sx, sy, sprite:getWidth() / 2, sprite:getHeight() / 2)
            end
          end
        end
      end
    end
  end

  love.graphics.push()
  if settings["max_wobble"] and not o.anti_wobble and not o.wobble and o.sprite[1] ~= "bordr" then
    local wobble_frame = (o.frame + anim_stage) % 3 + 1
    love.graphics.translate(x + max_w/TILE_SIZE/2, y + max_h/TILE_SIZE/2)
    if wobble_frame == 2 then
      love.graphics.rotate(math.rad(3))
      love.graphics.scale(1, 0.95)
    elseif wobble_frame == 3 then
      love.graphics.rotate(math.rad(-3))
      love.graphics.shear(-0.05, 0)
    end
    love.graphics.translate(-x - max_w/TILE_SIZE/2, -y - max_h/TILE_SIZE/2)
  end

  if (o.delet or spookmode) and (math.floor(love.timer.getTime() * 9) % 9 == 0) then -- if we're delet, apply the special shader to our object
    pcallSetShader(xwxShader)
    drawSpriteMaybeOverlay()
    love.graphics.setShader()
  else
    drawSpriteMaybeOverlay()
  end

  if o.lvl and (scene == editor or (scene ~= editor and o.special.visibility == "open")) then
    local first_color = o.color[1]
    for i,color in ipairs(o.color) do
      if o.painted[i] then
        first_color = color
        break
      end
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(rotation)
    love.graphics.translate(-x, -y)
    setColor(first_color)
    if (scene ~= editor and readSaveFile{"levels", o.special.level, "won"}) or (scene == editor and o.special.visibility ~= "open") then
      local r,g,b,a = love.graphics.getColor()
      love.graphics.setColor(r,g,b,a*0.4)
    end
    if not o.special.iconstyle or o.special.iconstyle == "number" then
      local num = tostring(o.special.number or 1)
      if #num == 1 then
        num = "0"..num
      end
      love.graphics.draw(sprites["levelicon_"..num:sub(1,1)], x+(4*sx), y+(4*sy), 0, sx, sy, max_w / 2, max_h / 2)
      love.graphics.draw(sprites["levelicon_"..num:sub(2,2)], x+(16*sx), y+(4*sy), 0, sx, sy, max_w / 2, max_h / 2)
    elseif o.special.iconstyle == "dots" then
      local num = tostring(o.special.number or 1)
      love.graphics.draw(sprites["levelicon_dots_"..num], x+(4*sx), y+(4*sy), 0, sx, sy, max_w / 2, max_h / 2)
    elseif o.special.iconstyle == "letter" then
      local num = o.special.number or 1
      local letter = ("abcdefghijklmnopqrstuvwxyz"):sub(num, num)
      love.graphics.draw(sprites["letter_"..letter], x, y, 0, sx*3/4, sy*3/4, max_w / 2, max_h / 2)
    elseif o.special.iconstyle == "other" then
      local sprite = sprites[o.special.iconname or "wat"] or sprites["wat"]
      love.graphics.draw(sprite, x, y, 0, sx*3/4, sy*3/4, sprite:getWidth() / 2, sprite:getHeight() / 2)
    end
    love.graphics.pop()
  end

  if #o.overlay > 0 then
    local function overlayStencil()
      pcallSetShader(mask_shader)
      drawSpriteMaybeOverlay(nil,true)
      if o.really_smol then
        love.graphics.translate(x, y)
        love.graphics.scale(0.75, 0.5)
        love.graphics.translate(-x, -y)
      end
      love.graphics.setShader()
    end
    for _,overlay in ipairs(o.overlay) do
      love.graphics.push()
      love.graphics.setColor(1, 1, 1)
      love.graphics.stencil(overlayStencil, "replace")
      local old_test_mode, old_test_value = love.graphics.getStencilTest()
      love.graphics.setStencilTest("greater", 0)
      love.graphics.setBlendMode("multiply", "premultiplied")
      drawSpriteMaybeOverlay("overlay/" .. overlay, false, true)
      love.graphics.setBlendMode("alpha", "alphamultiply")
      love.graphics.setStencilTest(old_test_mode, old_test_value)
      love.graphics.pop()
    end
  end

  love.graphics.pop()

  if o.meta > 0 then
    setColor{4, 1}
    local metasprite = o.meta > 2 and sprites["meta3"] or o.meta > 1 and sprites["meta2"] or sprites["meta1"]
    love.graphics.draw(metasprite, x, y, 0, sx, sy, max_w / 2, max_h / 2)
    if o.meta > 2 and sx == 1 and sy == 1 then
      --stroking black outline
      love.graphics.setColor(0,0,0,1)
      local xx = round(x)
      local yy = round(y)
      if (o.meta >= 10) then
        local font = fonts["metanumber"];
        love.graphics.printf(tostring(o.meta), font, xx+8+1, yy+6, 32, "left", r, sx, sy, 0, -3)
        love.graphics.printf(tostring(o.meta), font, xx+8-1, yy+6, 32, "left", r, sx, sy, 0, -3)
        love.graphics.printf(tostring(o.meta), font, xx+8, yy+6+1, 32, "left", r, sx, sy, 0, -3)
        love.graphics.printf(tostring(o.meta), font, xx+8, yy+6-1, 32, "left", r, sx, sy, 0, -3)
        setColor{4, 1}
        love.graphics.printf(tostring(o.meta), font, xx+8, yy+6, 32, "left", r, sx, sy, 0, -3)
      else
        local font = fonts["8bitoperator"];
        love.graphics.printf(tostring(o.meta), font, xx+8+1, yy+6-1, 32, "left")
        love.graphics.printf(tostring(o.meta), font, xx+8-1, yy+6-1, 32, "left")
        love.graphics.printf(tostring(o.meta), font, xx+8+1, yy+6+1, 32, "left")
        love.graphics.printf(tostring(o.meta), font, xx+8-1, yy+6+1, 32, "left")
        setColor{4, 1}
        love.graphics.printf(tostring(o.meta), font, xx+8, yy+6, 32, "left")
      end
      
    end
  end
  if o.nt then
    setColor{2, 2}
    local ntsprite = sprites["n't"]
    love.graphics.draw(ntsprite, x, y, 0, sx, sy, max_w / 2, max_h / 2)
  end
  if displayids then
    setColor{1, 4}
    love.graphics.printf(tostring(o.id), x-3, y-18, 32, "center")
  end
end

function addGroup(name, subset)
  if not group_names_set[name] then
    table.insert(group_names, name)
    table.insert(group_names_nt, name.."n't")
    group_names_set[name] = true
    group_names_set_nt[name.."n't"] = true
  end
  if subset then
    group_subsets[subset] = group_subsets[subset] or {}
    if not table.has_value(group_subsets[subset], name) then
      table.insert(group_subsets[subset], name)
    end
  end
end

function findNumber(unit1,unit2,unit3)
  -- Works assuming you're doing a check from the LEFT to the RIGHT. This means the first number given must be a number!
  -- If a later unit is not a number, it will simply end the number parsing there and immediately go on.
  -- Does not support custom letters because i'm bad.
  -- Second return number is the amount of digits that were valid, in case that's relevant.

  local findDigit = function(unit)
    --print(fullDump(unit))
    if unit and unit.type and unit.type.letter and unit.name then
      --print("name"..unit.name)
      return tonumber( unit.name )
    end
  end

  --if unit.special and unit.special.customletter then return tonumber(unit.special.customletter) end
  local t1 = findDigit(unit1)
  if not t1 then return nil end
  local t2 = findDigit(unit2)
  if not t2 then return t1,1 end
  local t3 = findDigit(unit3)
  if not t3 then return t1..t2,2 end

  return t1..t2..t3,3
end

function getUnitStr(unit)
  local str = unit.fullname
  if unit.color_override then
    str = str .. "|" .. table.concat(unit.color_override, ",")
  end
  return str
end

function loadMod()
  if love.filesystem.getInfo(getWorldDir(true).."/assets/lua/mod.lua") then
    local lua_dir = getWorldDir(true).."/assets/lua"
    local old_require_path = love.filesystem.getRequirePath()
    love.filesystem.setRequirePath(lua_dir.."/?.lua;"..lua_dir.."/?/init.lua")
    local mod = love.filesystem.load(lua_dir.."/mod.lua")()
    if type(mod) == "table" then
      loaded_mod = mod
      if mod.load then
        mod.load()
      end
      if mod.createTab then
        local grid = mod.createTab()
        local tab = #tile_grid + 1

        table.insert(selector_grid_contents, grid)
        tile_grid[tab] = {}
        for i,tile_name in ipairs(grid) do
          if i then
            tile_grid[tab][i-1] = tile_name
          else
            tile_grid[tab][i-1] = nil
          end
        end

        custom_selector_grid = grid
        custom_selector_tab = tab
      end
    end
    love.filesystem.setRequirePath(old_require_path)
  end
end

function unloadMod()
  if loaded_mod then
    if loaded_mod.unload() then
      loaded_mod.unload()
    end
    if custom_selector_tab then
      tile_grid[custom_selector_tab] = nil
      selector_grid_contents[custom_selector_tab] = nil
      if secret_miku_location and secret_miku_location[1] == custom_selector_tab then
        secret_miku_location = nil
      end
      custom_selector_grid = nil
      custom_selector_tab = nil
    end
    loaded_mod = nil
  end
end

function log(str)
  table.insert(logs, {str})
end
function log_error(str)
  table.insert(logs, {str, 'error'})
end
function log_debug(str)
  table.insert(logs, {str, 'debug'})
end
