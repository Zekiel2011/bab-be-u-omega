leveltree = {}
leveltree_id = {}

function sublevel(name,lnum,ltype)
	MF_alert("sublevel " .. name .. ", " .. tostring(lnum) .. ", " .. tostring(ltype))
	
	local id = #leveltree + 1
	local parentid = #leveltree
	local oldnum = ""
	
	local oldparent = leveltree[parentid] or ""
	local delafterthis = 0
	
	generaldata2.strings[PREVIOUSLEVEL] = oldparent
	MF_store("save",generaldata.strings[WORLD],"Previous",name)
	
	if (parentid > 0) then
		local treechanged = false
		
		local removethis = {}
		
		for i,v in pairs(leveltree) do
			if (v == name) then
				delafterthis = i
				
				id = i
				parentid = i-1
				
				oldnum = leveltree_id[i]
			end
			
			if (delafterthis > 0) and (i > delafterthis) then
				table.insert(removethis, i)
				--[[
				table.remove(leveltree, i)
				table.remove(leveltree_id, i)
				]]--
				treechanged = true
			end
		end
		
		for i,v in ipairs(removethis) do
			MF_alert("Removed " .. tostring(v) .. " from leveltree. (" .. tostring(leveltree[v]) .. ", " .. tostring(leveltree_id[v]))
			leveltree[v] = nil
			leveltree_id[v] = nil
		end
		
		if treechanged then
			MF_store("save",generaldata.strings[WORLD],"Previous",oldparent)
		end
	end
	
	generaldata.strings[CURRLEVEL] = name
	leveltree[id] = name
	
	if (oldnum == "") then
		if (lnum ~= nil) then
			leveltree_id[id] = getlevelid(lnum,ltype,name)
			-- MF_alert("Leveltree_id at " .. tostring(id) .. " set to " .. tostring(leveltree_id[id]) .. " (A)")
			
			latestleveldetails["lnum"] = lnum
			latestleveldetails["ltype"] = ltype
		else
			leveltree_id[id] = "dummy"
			-- MF_alert("Leveltree_id at " .. tostring(id) .. " set to " .. tostring(leveltree_id[id]) .. " (B)")
		end
	else
		leveltree_id[id] = oldnum
		-- MF_alert("Leveltree_id at " .. tostring(id) .. " set to " .. tostring(leveltree_id[id]) .. " (C)")
	end
	
	if (oldparent ~= nil) then
		generaldata.strings[PARENT] = oldparent
	else
		generaldata.strings[PARENT] = ""
	end
	
	generaldata.strings[LEVELNUMBER_NAME] = getlevelnumber()
end

function uplevel()
	local id = #leveltree
	local parentid = #leveltree - 1
	
	local oldlevel = generaldata.strings[CURRLEVEL]
	generaldata2.strings[PREVIOUSLEVEL] = oldlevel
	MF_store("save",generaldata.strings[WORLD],"Previous",oldlevel)
	latestleveldetails = {lnum = -1, ltype = -1}
	
	if (id == 0) then
		MF_alert("Already at map root")
		
		if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) and (editor.values[INEDITOR] == 0) then
			MF_end_single()
			MF_credits(1)
		end
	end
	
	if (parentid > 1) then
		generaldata.strings[PARENT] = leveltree[parentid - 1]
	else
		generaldata.strings[PARENT] = ""
	end
	
	if (id > 1) then
		generaldata.strings[CURRLEVEL] = leveltree[parentid]
	else
		generaldata.strings[CURRLEVEL] = ""
	end
	
	table.remove(leveltree, id)
	table.remove(leveltree_id, id)
	
	return oldlevel
end

function changelevel(newlevel,lnum,ltype,resetleveltree_)
	local id = #leveltree
	local parentid = #leveltree - 1
	
	local oldlevel = generaldata.strings[CURRLEVEL]
	
	local resetleveltree = resetleveltree_ or false
	
	if resetleveltree then
		leveltree = {}
		leveltree_id = {}
		
		id = 1
		parentid = 0
	end
	
	if (id == 0) then
		MF_alert("Already at map root")
	end
	
	if (id > 0) then
		leveltree[id] = newlevel
		leveltree_id[id] = getlevelid(lnum,ltype,newlevel)
		-- MF_alert("Leveltree_id at " .. tostring(id) .. " set to " .. tostring(leveltree_id[id]) .. " (D)")
		latestleveldetails["lnum"] = lnum
		latestleveldetails["ltype"] = ltype
	end

	generaldata.strings[CURRLEVEL] = newlevel
	
	return oldlevel
end

function handlecustomparent(levelid)
	local id = #leveltree
	
	if (id > 1) then
		uplevel()
	end
	
	local oldlevel = changelevel(levelid,0,0)
	
	return oldlevel
end

function collapseleveltree()
	local id = #leveltree
	
	local clevel = leveltree[id]
	local clevelname = leveltree_id[id]
	
	leveltree = {}
	leveltree_id = {}
	
	table.insert(leveltree, clevel)
	table.insert(leveltree_id, clevelname)
	
	generaldata.strings[CURRLEVEL] = clevel
	generaldata.strings[PARENT] = ""
	generaldata.strings[LEVELNUMBER_NAME] = ""
	
	--MF_alert("collapsed")
end

function resetleveltree()
	leveltree = {}
	leveltree_id = {}
	
	generaldata.strings[CURRLEVEL] = ""
	generaldata.strings[PARENT] = ""
	generaldata.strings[LEVELNUMBER_NAME] = ""
end

function rebuildleveltree(tree,tree_id)
	leveltree = {}
	leveltree_id = {}
	
	for i,v in ipairs(tree) do
		table.insert(leveltree, v)
	end
	
	for i,v in ipairs(tree_id) do
		table.insert(leveltree_id, v)
	end
	
	generaldata.strings[CURRLEVEL] = leveltree[#leveltree]
	generaldata.strings[PARENT] = ""
	
	if (#leveltree > 1) then
		generaldata.strings[PARENT] = leveltree[#leveltree - 1]
	end
	
	generaldata.strings[LEVELNUMBER_NAME] = getlevelnumber()
end

function refreshleveltree()
	if (#leveltree > 0) then
		for i,v in ipairs(leveltree) do
			local text = langtext(v) or "not found!"
			
			local lnum
			local ltype = 0
			
			if (latestleveldetails.lnum ~= nil) and (latestleveldetails.lnum >= 0) then
				lnum = latestleveldetails.lnum
			end
			
			if (latestleveldetails.ltype ~= nil) and (latestleveldetails.ltype >= 0) then
				ltype = latestleveldetails.ltype
			end
			
			leveltree_id[i] = getlevelid(lnum,ltype,v)
			
			if (generaldata.strings[LEVELFILE] == v) then
				generaldata.strings[LEVELNAME] = text
			end
		end
		
		generaldata.strings[LEVELNUMBER_NAME] = getlevelnumber()
	end
end

function storeleveltree(tree,tree_id)
	leveltree = {}
	leveltree_id = {}
	
	for i,v in ipairs(tree) do
		table.insert(leveltree, v)
		
		MF_alert(tostring(#tree) .. ", " .. tostring(#tree_id) .. ", " .. tostring(tree_id[i]))
		
		table.insert(leveltree_id, tree_id[i])
	end
	
	local current = leveltree[#leveltree]
	local parent = ""
	
	if (#leveltree > 1) then
		parent = leveltree[#leveltree - 1]
	end
	
	generaldata.strings[CURRLEVEL] = current
	generaldata.strings[PARENT] = parent
	
	local levelsurrounds = MF_read("save",generaldata.strings[WORLD],"levelsurrounds") or ""
	generaldata2.strings[LEVELSURROUNDS] = levelsurrounds
end

function getlevelnumber()
	local result = ""
	local nothing = false
	
	local id = leveltree_id[#leveltree_id]
	local id2 = leveltree_id[#leveltree_id - 1] or ""
	
	if (id2 == "<empty>") then
		id2 = ""
	end
	
	if (#leveltree_id == 1) then
		if (id == "???") or (id == "baba") then
			result = result .. id
		end
	elseif (#leveltree_id == 2) then
		if (id2 == "???") or (id2 == "baba") then
			result = result .. id2 .. "-"
		end
		
		result = result .. id
	elseif (string.len(id2) > 0) then
		result = result .. id2 .. "-" .. id
	else
		result = result .. id
	end
	
	if (id == "<empty>") then
		nothing = true
	end
	
	if (string.len(result) > 0) then
		result = langtext("level") .. " " .. result
	else
		result = langtext("level")
	end
	
	if nothing then
		result = " "
	end

	return result
end

function getlevelid(lnum,ltype,level)
	local result = ""
	
	local world = generaldata.strings[WORLD]
	MF_setfile("level","Data/Worlds/" .. world .. "/" .. level .. ".ld")
	local customid = MF_read("level","general","mapid")
	local langcustomid = ""
	
	if (world == generaldata.strings[BASEWORLD]) then
		langcustomid = MF_read("lang","texts",level .. "_mapid")
	else
		langcustomid = MF_read("lang","texts",world .. "_" .. level .. "_mapid")
	end
		
	if (string.len(langcustomid) > 0) then
		customid = langcustomid
	else
		MF_alert(world .. "_" .. level .. "_mapid doesn't exist")
	end
	
	if (string.len(customid) == 0) then
		if (ltype == 1) then
			local lookup = "abcdefghijklmnopqrstuvwxyz"
			
			result = string.sub(lookup, lnum+1, lnum+1)
		elseif (ltype == 2) then
			result = langtext("mapid_extra") .. " " .. tostring(lnum + 1)
		else
			result = tostring(lnum or "")
		end
	else
		result = customid
	end
	
	MF_setfile("level","Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. generaldata.strings[CURRLEVEL] .. ".ld")
	
	return result
end

function unlockeffect(dataid)
	local data = mmf.newObject(dataid)
	
	if (hiddenmap == nil) then
		local cursors = getunitswitheffect("select",nil,nil,nil,true)
		local cx,cy = 0,0
		
		if (#cursors > 0) then
			local cursorunit = cursors[1]
			cx = cursorunit.values[XPOS]
			cy = cursorunit.values[YPOS]
		end
		
		hiddenmap = {}
		hiddenmap.unlocks = {}
		hiddenmap.start = {cx,cy}
	end
	
	local start = hiddenmap.start
	local x = start[1]
	local y = start[2]
	
	data.values[UNLOCKTIMER] = data.values[UNLOCKTIMER] + 1
	local timer = data.values[UNLOCKTIMER]
	local unlock = data.values[UNLOCK]
	
	if (unlock == 2) then
		if (timer == 10) then
			MF_playsound("roll")
		end
		
		if (timer > 10) and (timer < 80) and (timer % 2 == 0) then
			particles("unlock",x,y,2,{2, 4})
		end
		
		--Aiemmin tässä oli 70 enemmän (jos haluat pitkän efektin)
		
		if (timer == 70) then
			generaldata.values[SHAKE] = 15
			
			if (data.values[MAPCLEAR] == 0) then
				generaldata.values[IGNORE] = 0
			end
			
			particles("smoke",x,y,20,{0, 3})
			
			local prizeid = MF_specialcreate("Prize")
			local prize = mmf.newObject(prizeid)
			
			prize.layer = 2
			prize.values[ONLINE] = 1
			prize.values[XPOS] = Xoffset + x * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
			prize.values[YPOS] = Yoffset + y * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
			prize.values[YVEL] = -20
			prize.scaleX = 0.1
			prize.scaleY = 0.1
			
			if (data.values[MAPCLEAR] == 1) then
				MF_playsound("clear")
			else
				MF_playsound("winnery_fast")
			end
			
			MF_playsound("pop3")
			MF_stopsound("roll")
			
			if (data.values[MAPCLEAR] == 1) then
				local winid1 = MF_specialcreate("Victorytext")
				local winid2 = MF_specialcreate("Victorytext_back")
				
				local wintext1 = mmf.newObject(winid1)
				local wintext2 = mmf.newObject(winid2)
				
				wintext2.layer = 2
				wintext1.layer = 2
				
				MF_setcolour(winid1,0,3)
				MF_setcolour(winid2,1,1)
				
				wintext1.x = screenw * 0.5
				wintext1.y = screenh * 0.5
				wintext1.direction = 1
				
				wintext2.x = screenw * 0.5
				wintext2.y = screenh * 0.5 + 4
				wintext2.direction = 1
				
				if (generaldata4.values[CUSTOMFONT] == 0) and (generaldata.strings[LANG] ~= "en") then
					wintext1.visible = false
					wintext2.visible = false
					
					displaybigtext("ingame_clear",{0,3,1,3},true)
				end
			end
		end
		
		if (timer == 110) then
			local hidden,hiddenmap_ = checkhidden(x,y)
			
			if hidden then
				hiddenmap = hiddenmap_
				hiddenmap.unlocks = {}
				hiddenmap.start = {x,y}				
				
				data.values[UNLOCK] = 3
				data.values[UNLOCKTIMER] = -25
				return
			end
		end
		
		local upoint = 130
		local ox,oy = 0,0
		
		local opensound = "whoosh_alt" .. tostring(math.random(1,5))
		if (matches ~= nil) then
			opensound = "intro_flower_" .. tostring(math.random(1,7))
		end
		
		if (timer == upoint) then
			ox = 0
			oy = -1
			local unlockables = findallhere(x+ox,y+oy)
			local found = false
			
			if (#unlockables > 0) then
				for i,unitid in ipairs(unlockables) do
					local unit = mmf.newObject(unitid)
					local pgate,preq = 0,0
					local pathid = MF_findpath_id(unitid)
					
					if (pathid ~= nil) then
						local path = mmf.newObject(pathid)
						pgate = path.values[PATH_GATE]
						preq = path.values[PATH_REQUIREMENT]
					end
					
					if (unit.values[COMPLETED] == 1) and ((pgate == 0) or (preq <= 0)) and (unit.flags[LEVEL_JUSTCONVERTED] == false) then
						unit.values[COMPLETED] = 2
						found = true
					end
				end
			end
			
			if found then
				particles("hot",x+ox,y+oy,10,{0, 3})
				MF_playsound(opensound)
			else
				timer = timer + 15
			end
		end
		
		if (timer == upoint + 15) then
			ox = -1
			oy = 0
			local unlockables = findallhere(x+ox,y+oy)
			local found = false
			
			if (#unlockables > 0) then
				for i,unitid in ipairs(unlockables) do
					local unit = mmf.newObject(unitid)
					local pgate,preq = 0,0
					local pathid = MF_findpath_id(unitid)
					
					if (pathid ~= nil) then
						local path = mmf.newObject(pathid)
						pgate = path.values[PATH_GATE]
						preq = path.values[PATH_REQUIREMENT]
					end
					
					if (unit.values[COMPLETED] == 1) and ((pgate == 0) or (preq <= 0)) and (unit.flags[LEVEL_JUSTCONVERTED] == false) then
						unit.values[COMPLETED] = 2
						found = true
					end
				end
			end
			
			if found then
				particles("hot",x+ox,y+oy,10,{0, 3})
				MF_playsound(opensound)
			else
				timer = timer + 15
			end
		end
		
		if (timer == upoint + 30) then
			ox = 0
			oy = 1
			local unlockables = findallhere(x+ox,y+oy)
			local found = false
			
			if (#unlockables > 0) then
				for i,unitid in ipairs(unlockables) do
					local unit = mmf.newObject(unitid)
					local pgate,preq = 0,0
					local pathid = MF_findpath_id(unitid)
					
					if (pathid ~= nil) then
						local path = mmf.newObject(pathid)
						pgate = path.values[PATH_GATE]
						preq = path.values[PATH_REQUIREMENT]
					end
					
					if (unit.values[COMPLETED] == 1) and ((pgate == 0) or (preq <= 0)) and (unit.flags[LEVEL_JUSTCONVERTED] == false) then
						unit.values[COMPLETED] = 2
						found = true
					end
				end
			end
			
			if found then
				particles("hot",x+ox,y+oy,10,{0, 3})
				MF_playsound(opensound)
			else
				timer = timer + 15
			end
		end
		
		if (timer == upoint + 45) then
			ox = 1
			oy = 0
			local unlockables = findallhere(x+ox,y+oy)
			local found = false
			
			if (#unlockables > 0) then
				for i,unitid in ipairs(unlockables) do
					local unit = mmf.newObject(unitid)
					local pgate,preq = 0,0
					local pathid = MF_findpath_id(unitid)
					
					if (pathid ~= nil) then
						local path = mmf.newObject(pathid)
						pgate = path.values[PATH_GATE]
						preq = path.values[PATH_REQUIREMENT]
					end
					
					if (unit.values[COMPLETED] == 1) and ((pgate == 0) or (preq <= 0)) and (unit.flags[LEVEL_JUSTCONVERTED] == false) then
						unit.values[COMPLETED] = 2
						found = true
					end
				end
			end
			
			if found then
				particles("hot",x+ox,y+oy,10,{0, 3})
				MF_playsound(opensound)
			end
		end
		
		if (timer == upoint + 50) then
			if (matches == nil) then
				if (data.values[MAPCLEAR] == 0) then
					data.values[UNLOCK] = 0
					data.values[UNLOCKTIMER] = 0
					generaldata.values[IGNORE] = 0
					hiddenmap = nil
				else
					data.values[MAPCLEAR] = 0
					data.values[UNLOCK] = 4
					data.values[UNLOCKTIMER] = -30
				end
			else
				data.values[UNLOCK] = 5
				data.values[UNLOCKTIMER] = 0
			end
		end
	elseif (unlock == 3) then
		local docheck = timer % 10
		
		if (docheck == 0) and (timer > 0) then
			local newstuff = {}
			local unlocks = {}
			local currtype = 0
			
			if (#hiddenmap > 0) then
				for i,v in ipairs(hiddenmap) do
					local unit = mmf.newObject(v)
					unit.values[COMPLETED] = math.max(unit.values[COMPLETED], 1)
					local ux,uy = unit.values[XPOS],unit.values[YPOS]
					
					if (unit.strings[UNITNAME] ~= "path") then
						--MF_savelevel(v, unit.values[COMPLETED])
						currtype = 0
					else
						--MF_savepath(v)
						table.insert(unlocks, {ux, uy})
						currtype = 1
					end
					
					MF_playsound("whoosh_quiet" .. tostring(math.random(1,5)))
					particles("glow",ux,uy,5,{1, 2})
					
					local th,things = checkhidden(ux,uy)
					
					if th then
						for c,d in ipairs(things) do
							local dunit = mmf.newObject(d)
							
							local addthis = false
							
							if ((dunit.strings[UNITNAME] ~= "path") and (currtype == 0)) or ((ux == x) and (uy == y)) then
								addthis = true
							elseif (dunit.strings[UNITNAME] == "path") and (currtype == 1) then
								addthis = true
								
								if (unit.strings[UNITNAME] == "path") and (unit.values[PATH_GATE] > 0) then
									addthis = false
								end
							end
							
							if addthis then
								table.insert(newstuff, d)
							end
						end
					end
				end
			end
			
			if (#hiddenmap.unlocks > 0) then
				for i,v in ipairs(hiddenmap.unlocks) do
					local ux,uy = v[1],v[2]
					unlocklevels(ux,uy,true)
				end
			end
			
			hiddenmap = {}
			hiddenmap.unlocks = {}
			hiddenmap.start = {x,y}
			
			if (#newstuff > 0) then
				for i,v in ipairs(newstuff) do
					table.insert(hiddenmap, v)
				end
			end
			
			if (#unlocks > 0) then
				for i,v in ipairs(unlocks) do
					table.insert(hiddenmap.unlocks, v)
				end
			end
			
			if (#newstuff == 0) and (#unlocks == 0) then
				hiddenmap = {}
				hiddenmap.unlocks = {}
				hiddenmap.start = {x,y}
				data.values[UNLOCK] = 2
				data.values[UNLOCKTIMER] = 110
			end
		end
	end	
end

function unlocklevels(x,y,visuals_,reveal_)
	local ox,oy = 0,0
	local visuals = false
	local reveal = false
	
	if (visuals_ ~= nil) then
		visuals = visuals_
	end
	
	if (reveal_ ~= nil) then
		reveal = reveal_
	end
	
	for a=1,4 do
		local ndrs = ndirs[a]
		ox = ndrs[1]
		oy = ndrs[2]
		
		local levels = findallhere(x+ox,y+oy)
		
		if (#levels > 0) then
			for i,v in ipairs(levels) do
				local unit = mmf.newObject(v)
				
				if (unit.values[COMPLETED] < 2) and (string.len(unit.strings[LEVELFILE]) > 0) then
					if (visuals == false) then
						if (unit.strings[UNITNAME] ~= "path") then
							MF_savelevel(v, 2)
							--MF_store("save",generaldata.strings[WORLD],unit.strings[LEVELFILE],"2")
						else
							if (unit.values[PATH_GATE] == 0) then
								MF_savepath(v, 3)
								--MF_alert("Saved path in hiddendata (3)")
							else
								MF_savepath(v, 1)
								--MF_alert("Saved path in hiddendata (1)")
							end
						end
					end
					
					if visuals or reveal then
						unit.values[COMPLETED] = 2
						
						if (unit.strings[UNITNAME] == "path") and (unit.values[PATH_GATE] > 0) then
							unit.values[COMPLETED] = 1
						end
					end
					
					if visuals then
						particles("hot",x+ox,y+oy,10,{0, 3})
						
						if (matches == nil) then
							MF_playsound("whoosh_alt" .. tostring(math.random(1,5)))
						else
							MF_playsound("intro_flower_" .. tostring(math.random(1,7)))
						end
					end
				end
			end
		end
	end
end

function checkhidden(x,y)
	local ox,oy = 0,0
	local result = {}
	local current = {}
	local hidden = false
	
	for a=1,4 do
		local ndrs = ndirs[a]
		ox = ndrs[1]
		oy = ndrs[2]
		
		local levels = findallhere(x+ox,y+oy,nil,true)
		
		if (#levels > 0) then
			for i,v in ipairs(levels) do
				local unit = mmf.newObject(v)
				
				if (unit.values[COMPLETED] == 0) and (string.len(unit.strings[LEVELFILE]) > 0) then
					table.insert(result, v)
					hidden = true
				end
			end
		end
	end
	
	return hidden,result
end

function prizeget(id)
	local unit = mmf.newObject(id)
	local x = math.floor((unit.x - Xoffset) / tilesize)
	local y = math.floor((unit.y - Yoffset) / tilesize)
	
	particles("glow",x,y,20,{0,3},1,0)
	MF_playsound("rule")
end

function hiddendata(x,y,reveal_)
	local more = true
	local reveal = false
	
	if (reveal_ ~= nil) then
		reveal = reveal_
	end
	
	local hiddens = {}
	local alreadydone = {}
	
	local cx,cy = x,y
	
	local currtype = 0
	
	while more do
		local id = cx + cy * roomsizex
		
		if (alreadydone[id] == nil) then
			local current = findallhere(cx,cy,nil,true)
			local current_gate = false
			
			if (#current > 0) then
				for i,v in ipairs(current) do
					local unit = mmf.newObject(v)
					
					if (unit.strings[UNITNAME] == "path") then
						currtype = 1
						
						if (unit.values[PATH_GATE] > 0) then
							current_gate = true
						end
						
						if (cx == x) and (cy == y) then
							current_gate = false
						end
					else
						currtype = 0
					end
				end
			end
			
			if (cx == x) and (cy == y) then
				currtype = -1
			end
			
			local hidden,result = checkhidden(cx,cy)
			
			if (#result > 0) then
				if (current_gate == false) then
					for i,v in ipairs(result) do
						local unit = mmf.newObject(v)

						table.insert(hiddens, {v, currtype})
					end
				end
			end
		end
		
		alreadydone[id] = 1
		
		if (#hiddens > 0) then
			local unitid = hiddens[1][1]
			local unit = mmf.newObject(unitid)
			currtype = hiddens[1][2]
			table.remove(hiddens, 1)
			
			if (unit.strings[UNITNAME] ~= "path") then
				if (currtype == 0) or (currtype == -1) then
					MF_savelevel(unitid, 1)
					cx,cy = unit.values[XPOS],unit.values[YPOS]
					
					if reveal then
						unit.values[COMPLETED] = 1
					end
				end
			else
				if (currtype == 1) or (currtype == -1) then
					if (unit.values[PATH_GATE] == 0) then
						MF_savepath(unitid, 3)
						--MF_alert("Saved path in hiddendata (3)")
					else
						MF_savepath(unitid, 1)
						--MF_alert("Saved path in hiddendata (1)")
					end
					cx,cy = unit.values[XPOS],unit.values[YPOS]
					
					unlocklevels(cx,cy,nil,reveal)
					
					if reveal then
						unit.values[COMPLETED] = 1
					end
				end
			end
		else
			more = false
		end
	end
end

function getleveltree()
	local result = ""
	
	if (#leveltree > 0) then
		for i,v in ipairs(leveltree) do
			if (i < #leveltree) then
				result = result .. v .. ","
			else
				result = result .. v
			end
		end
	else
		print("Leveltree is empty?")
	end
	
	return result
end

function getleveltree_id()
	local result = ""
	
	if (#leveltree_id > 0) then
		for i,v in ipairs(leveltree_id) do
			if (i < #leveltree_id) then
				result = result .. v .. ","
			else
				result = result .. v
			end
		end
	else
		print("Leveltree_id is empty?")
	end
	
	return result
end

function openlevels()
	local levels = {}
	
	for i,unit in ipairs(units) do
		if (string.len(unit.strings[U_LEVELFILE]) > 1) then
			table.insert(levels, unit.fixed)
		end
	end
	
	local gates = MF_findgates()
	for i,unitid in ipairs(gates) do
		table.insert(levels, unitid)
	end
	
	if (#levels > 0) then
		for i,unitid in ipairs(levels) do
			local unit = mmf.newObject(unitid)
			
			if (unit.values[COMPLETED] == 3) then
				local x,y = unit.values[XPOS],unit.values[YPOS]
				
				unlocklevels(x,y,nil,true)
				
				hiddendata(x,y,true)
			end
		end
	end
end

function addpath(id)
	local unitid = MF_create("path")
	local unit = mmf.newObject(unitid)
	
	local i = tostring(id)
	
	unit.values[ONLINE] = 1
	unit.values[XPOS] = tonumber(MF_read("level","paths",i .. "X")) or 0
	unit.values[YPOS] = tonumber(MF_read("level","paths",i .. "Y")) or 0
	unit.values[DIR] = tonumber(MF_read("level","paths",i .. "dir")) or 4
	unit.values[PATH_STYLE] = tonumber(MF_read("level","paths",i .. "style")) or 0
	unit.values[PATH_GATE] = tonumber(MF_read("level","paths",i .. "gate")) or 0
	unit.values[PATH_REQUIREMENT] = tonumber(MF_read("level","paths",i .. "requirement")) or 0
	
	local world = generaldata.strings[WORLD]
	local pathid = generaldata.strings[CURRLEVEL] .. "," .. tostring(unit.values[XPOS]) .. "," .. tostring(unit.values[YPOS])
	
	local completed_save = tonumber(MF_read("save",world,pathid)) or 0
	
	unit.values[COMPLETED] = math.max(unit.values[COMPLETED], completed_save)
	
	if (unit.values[PATH_STYLE] > 0) then
		unit.values[COMPLETED] = math.max(2, unit.values[COMPLETED])
	end
	
	unit.strings[PATH_OBJECT] = MF_read("level","paths",i .. "object")
	unit.strings[PATH_GATEOBJECT] = MF_read("level","paths",i .. "unlock")
	
	unit.x = Xoffset + unit.values[XPOS] * tilesize + tilesize * 0.5
	unit.y = Yoffset + unit.values[YPOS] * tilesize + tilesize * 0.5
	
	table.insert(paths, unitid)
end

function addspecial(id)
	local unitid = MF_create("specialobject")
	local unit = mmf.newObject(unitid)
	
	local i = tostring(id)
	
	unit.values[ONLINE] = 1
	unit.values[XPOS] = MF_read("level","specials",i .. "X")
	unit.values[YPOS] = MF_read("level","specials",i .. "Y")
	unit.strings[PATH_OBJECT] = MF_read("level","specials",i .. "data")
	
	unit.x = Xoffset + unit.values[XPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	unit.y = Yoffset + unit.values[YPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
end

function loadlevelcompletion()
	local world = generaldata.strings[WORLD]
	
	for i,unit in ipairs(units) do
		local level = unit.strings[LEVELFILE]
		if (string.len(level) > 0) then
			local completion = tonumber(MF_read("save",world,level)) or 0
			
			if (completion > 0) then
				unit.values[COMPLETED] = completion
			end
		end
	end
	
	for i,unitid in ipairs(paths) do
		local unit = mmf.newObject(unitid)
		local level = unit.strings[LEVELFILE]
		local x,y = unit.values[XPOS],unit.values[YPOS]
		
		if (string.len(level) > 0) then
			local completion = tonumber(MF_read("save",world,level .. "," .. tostring(x) .. "," .. tostring(y))) or 0
			
			if (completion > 0) then
				unit.values[COMPLETED] = completion
			end
		end
	end
end

function revealpaths(dataid)
	local gdata = mmf.newObject(dataid)
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	local removethesepaths = {}
	local removetheseunits = {}
	
	for i,unitid in ipairs(paths) do
		local unit = mmf.newObject(unitid)
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local status = unit.values[COMPLETED]
		
		if (status > 0) and (unit.values[PATH_TARGET] == 0) then
			local newid = MF_create(unit.strings[PATH_OBJECT])
			local new = mmf.newObject(newid)
			
			new.values[ONLINE] = 1
			new.values[XPOS] = unit.values[XPOS]
			new.values[YPOS] = unit.values[YPOS]
			new.x = Xoffset + new.values[XPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
			new.y = Yoffset + new.values[YPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
			new.values[DIR] = unit.values[DIR]
			new.values[COMPLETED] = 3 - math.min(unit.values[PATH_GATE], 1) * 2
			new.strings[LEVELFILE] = ""
			
			addunit(newid)
			
			unit.values[PATH_TARGET] = newid
			
			local prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
			local clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
			local bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
			local localprizes = tonumber(MF_read("save",world .. "_prize",level)) or 0
			
			if (new.strings[UNITTYPE] == "text") then
				updatecode = 1
			end
			
			--MF_alert(tostring(prizes) .. ", " .. tostring(clears) .. ", " .. tostring(unit.values[PATH_GATE]) .. ", " .. tostring(unit.values[PATH_REQUIREMENT]))
			
			if (unit.values[PATH_GATE] == 1) and (prizes >= unit.values[PATH_REQUIREMENT]) then
				if (status < 3) then
					new.values[COMPLETED] = -2
					new.values[A] = unit.values[PATH_REQUIREMENT]
					unit.values[COMPLETED] = 3
				else
					new.values[COMPLETED] = 3
					opengate(newid)
				end
			elseif (unit.values[PATH_GATE] == 2) and (clears >= unit.values[PATH_REQUIREMENT]) then
				if (status < 3) then
					new.values[COMPLETED] = -3
					new.values[A] = unit.values[PATH_REQUIREMENT]
					unit.values[COMPLETED] = 3
				else
					new.values[COMPLETED] = 3
					opengate(newid)
				end
			elseif (unit.values[PATH_GATE] == 3) and (bonus >= unit.values[PATH_REQUIREMENT]) then
				if (status < 3) then
					new.values[COMPLETED] = -4
					new.values[A] = unit.values[PATH_REQUIREMENT]
					unit.values[COMPLETED] = 3
				else
					new.values[COMPLETED] = 3
					opengate(newid)
				end
			elseif (unit.values[PATH_GATE] == 4) and (localprizes >= unit.values[PATH_REQUIREMENT]) then
				if (status < 3) then
					new.values[COMPLETED] = -5
					new.values[A] = unit.values[PATH_REQUIREMENT]
					unit.values[COMPLETED] = 3
				else
					new.values[COMPLETED] = 3
					opengate(newid)
				end
			end
			
			if (unit.values[PATH_GATE] == 0) then
				unit.flags[DEAD] = true
				table.insert(removetheseunits, unitid)
			end
			
			local newtest = mmf.newObject(newid)
			
			if (newtest ~= nil) then
				if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
					local newname = getname(new)
					
					local hidethis = hasfeature(newname,"is","hide",newid,x,y)
					
					if (hidethis ~= nil) then
						new.visible = false
					end
				end
				
				if (new.values[TILING] == 1) then
					dynamic(newid)
				end
			end
			
			table.insert(removethesepaths, i)
		end
	end
	
	local roffset = 0
	
	for a,b in ipairs(removethesepaths) do
		table.remove(paths, b - roffset)
		roffset = roffset + 1
	end
	
	for a,b in ipairs(removetheseunits) do
		MF_cleanremove(b)
	end
end

function opengate(unitid)
	local unit = mmf.newObject(unitid)
	
	local pathobject = editor.strings[PATH_OBJECT]
	local cpo,cpgo = MF_checkcustompathobject(unitid)
	
	if (#cpgo > 0) then
		pathobject = cpgo
	end
	
	local newid = MF_create(pathobject)
	local new = mmf.newObject(newid)
	
	new.values[ONLINE] = 1
	new.values[XPOS] = unit.values[XPOS]
	new.values[YPOS] = unit.values[YPOS]
	new.x = Xoffset + new.values[XPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	new.y = Yoffset + new.values[YPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	new.values[DIR] = unit.values[DIR]
	new.values[COMPLETED] = 3
	new.strings[LEVELFILE] = ""
	
	addunit(newid)
	
	if (new.values[TILING] == 1) then
		dynamic(newid)
	end
	
	delunit(unitid)
	MF_cleanremove(unitid)
end

function mapunlock(dataid)
	local data = mmf.newObject(dataid)
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	data.values[UNLOCKTIMER] = data.values[UNLOCKTIMER] + 1
	local timer = data.values[UNLOCKTIMER]
	local unlock = data.values[UNLOCK]
	
	if (unlock == 4) then
		if (timer == 5) then
			local unlocklevels = MF_read("level","general","unlocklevels") or ""
			local levels = MF_parsestring(unlocklevels)
			
			matches = {}
			matches.origin = level
			matches.previous = data.strings[1]
			
			for i,v in ipairs(levels) do
				if (string.len(v) > 0) then
					table.insert(matches, v)
				end
			end
		end
		
		if (timer == 10) and (#matches == 0) then
			generaldata.values[IGNORE] = 0
			data.values[MAPCLEAR] = 0
			data.values[UNLOCK] = 0
			data.values[UNLOCKTIMER] = 0
			hiddemap = nil
			matches = nil
		end
	end
	
	if (unlock == 4) or (unlock == 5) then
		if (matches ~= nil) then
			if (timer == 10) and (#matches > 0) then
				data.values[UNLOCK] = 5
				unlock = data.values[UNLOCK]
			end
		end
	end
	
	if (unlock == 5) then
		if (timer == -80) and (generaldata.values[MODE] == 0) and ((editor.values[INEDITOR] == 0) or (editor.values[INEDITOR] == 3)) then
			MF_playsound("roll")
		end
		
		if (timer > -80) and (timer < -20) and (timer % 2 == 0) and (generaldata.values[MODE] == 0) and ((editor.values[INEDITOR] == 0) or (editor.values[INEDITOR] == 3)) then
			for i,unit in ipairs(units) do
				if (unit.strings[LEVELFILE] == matches.origin) then
					local x,y = unit.values[XPOS],unit.values[YPOS]
					particles("unlock",x,y,2,{2, 4})
				end
			end
		end
		
		if (timer == -20) and (generaldata.values[MODE] == 0) and ((editor.values[INEDITOR] == 0) or (editor.values[INEDITOR] == 3)) then
			for i,unit in ipairs(units) do
				if (unit.strings[LEVELFILE] == matches.origin) then
					if (hiddenmap == nil) then
						hiddenmap = {}
						hiddenmap.unlocks = {}
					end
					
					hiddenmap.start = {unit.values[XPOS],unit.values[YPOS]}
					
					generaldata.values[SHAKE] = 15
					
					data.values[UNLOCK] = 2
					data.values[UNLOCKTIMER] = 71
					
					unit.direction = 16
					unit.values[COMPLETED] = 3
					
					local prizeid = MF_specialcreate("Prize")
					local prize = mmf.newObject(prizeid)
					
					MF_playsound_freq("winnery_fast",38000)
					MF_playsound("pop3")
					MF_stopsound("roll")
					
					local x,y = unit.values[XPOS],unit.values[YPOS]
					prize.layer = 2
					prize.values[ONLINE] = 1
					prize.values[XPOS] = Xoffset + x * tilesize + tilesize * 0.5
					prize.values[YPOS] = Yoffset + y * tilesize + tilesize * 0.5
					prize.values[YVEL] = -20
					prize.scaleX = 0.1
					prize.scaleY = 0.1
					prize.direction = 1

					particles("smoke",unit.values[XPOS],unit.values[YPOS],20,{0,3})
				end
			end
		end
		
		if (timer == 10) and (#matches == 0) then
			data.values[UNLOCK] = 6
			unlock = data.values[UNLOCK]
		end
		
		if (timer == 60) then
			generaldata.values[TRANSITIONREASON] = 10
			generaldata.values[TRANSITIONED] = 0
			MF_loop("transition",1)
		end
	end
	
	if (unlock == 6) then
		if (timer == 80) then
			generaldata.values[TRANSITIONREASON] = 10
			generaldata.values[TRANSITIONED] = 0
			MF_loop("transition",1)
		end
	end
	
	if (unlock == 5) or (unlock == 6) then
		if (generaldata.values[TRANSITIONED] == 1) and (generaldata.values[TRANSITIONREASON] == 10) and (generaldata.values[MODE] == 0) and ((editor.values[INEDITOR] == 0) or (editor.values[INEDITOR] == 3)) then
			local cursors = getunitswitheffect("select")
			
			for i,cursorunit in ipairs(cursors) do
				cursorunit.visible = false
			end
			
			mapunlock_transition(dataid,cursors)
		end
	end
end

function mapunlock_transition(dataid,cursors)
	local data = mmf.newObject(dataid)
	local cursor = mmf.newObject(cursorid)
	local world = generaldata.strings[WORLD]
	
	local PREVIOUS = 1
	
	local TRANSITION = 18
	local TRANSITIONREASON = 20
	
	local unlock = data.values[UNLOCK]
	
	if (unlock == 5) then
		for i,cursorunit in ipairs(cursors) do
			cursorunit.visible = false
		end
		
		generaldata.values[TRANSITION] = 0
		generaldata.values[TRANSITIONREASON] = 0

		generaldata.strings[CURRLEVEL] = matches[1]
		table.remove(matches, 1)
		
		data.values[UNLOCKTIMER] = -90
		
		clearunits()
		MF_loop("clear",1)
		MF_loop("new",1)
		
		for i,unit in ipairs(units) do
			if (unit.strings[LEVELFILE] == matches.origin) then
				unit.direction = 0
				unit.values[COMPLETED] = 2
			end
		end
	elseif (unlock == 6) then
		generaldata.values[TRANSITION] = 0
		generaldata.values[TRANSITIONREASON] = 0
		generaldata.values[IGNORE] = 0
		
		generaldata.strings[CURRLEVEL] = matches.origin
		
		for i,cursorunit in ipairs(cursors) do
			cursorunit.visible = true
		end
		
		data.strings[PREVIOUSLEVEL] = matches.previous
		
		clearunits()
		MF_loop("clear",1)
		MF_loop("new",1)
		
		data.values[UNLOCK] = 0
		data.values[UNLOCKTIMER] = 0
		data.values[MAPCLEAR] = 0
		
		matches = nil
	end
end

function getgates()
	gatelist = {}
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	generaldata.values[IGNORE] = 1
	
	for i,unit in ipairs(units) do
		if (unit.values[COMPLETED] < -1) then
			table.insert(gatelist, unit.fixed)
			local x,y = unit.values[XPOS],unit.values[YPOS]
			MF_store("save",world,level .. "," .. tostring(x) .. "," .. tostring(y),"3")
			
			hiddendata(x,y,false)
		end
	end
end

function gateunlock(dataid)
	local data = mmf.newObject(dataid)
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	data.values[UNLOCKTIMER] = data.values[UNLOCKTIMER] + 1
	local timer = data.values[UNLOCKTIMER]
	local unlock = data.values[UNLOCK]

	if (unlock == 7) then
		for i,unitid in ipairs(gatelist) do
			local unit = mmf.newObject(unitid)
			local x,y = unit.values[XPOS],unit.values[YPOS]
			
			if (timer == 10) then
				local gateobjs = MF_findgates()
				local gatetype = -1
				local gatereq = 0
				
				for i,v in ipairs(gateobjs) do
					local vunit = mmf.newObject(v)
					if (unitid == vunit.values[PATH_TARGET]) then
						gatetype = vunit.values[PATH_GATE]
						gatereq = vunit.values[PATH_REQUIREMENT]
					end
				end
				
				--MF_alert(tostring(unitid) .. ", " .. tostring(unit.values[A]) .. ", " .. tostring(gatetype))
				MF_gateeffect(unitid,gatereq,gatetype)
				MF_playsound("roll")
			end
			
			if (timer > 10) and (timer < 130) then
				if (timer % 20 == 0) then 
					if (unit.values[COMPLETED] == -2) then
						particles("bonus",x,y,2,{2, 4})
					elseif (unit.values[COMPLETED] == -3) then
						particles("bonus",x,y,2,{4, 2})
					elseif (unit.values[COMPLETED] == -4) then
						particles("bonus",x,y,2,{0, 3})
					elseif (unit.values[COMPLETED] == -5) then
						particles("bonus",x,y,2,{2, 4})
					end
				end
			elseif (timer == 130) then
				generaldata.values[SHAKE] = 20
				generaldata.values[IGNORE] = 0
				
				if (unit.values[COMPLETED] == -2) then
					particles("bonus",x,y,40,{2, 4})
				elseif (unit.values[COMPLETED] == -3) then
					particles("bonus",x,y,40,{4, 2})
				elseif (unit.values[COMPLETED] == -4) then
					particles("bonus",x,y,40,{0, 3})
				elseif (unit.values[COMPLETED] == -5) then
					particles("bonus",x,y,40,{2, 4})
				end
				
				data.values[UNLOCK] = 0
				data.values[UNLOCKTIMER] = 0
				unit.strings[U_LEVELFILE] = ""
				
				particles("unlock",x,y,20,{0,3})
				MF_playsound("gate")
				MF_stopsound("roll")
				
				local hidden = checkhidden(x,y)
				
				if hidden then
					data.values[UNLOCKTIMER] = 109
					data.values[UNLOCK] = 2
					
					hiddenmap = {}
					hiddenmap.unlocks = {}
					hiddenmap.start = {x,y}
				end
				
				opengate(unitid)
			end
		end
	end
end

function handlespecial(unitid,type,data)
	local unit = mmf.newObject(unitid)
	
	if (type == "controls") then
		local subtype = data[1]
		
		local gamepad = MF_profilefound()
		local gamepad_ = false
		if (gamepad ~= nil) then
			gamepad_ = true
		end
		
		if (generaldata2.values[BUTTONPROMPTTYPE] == 0) then
			gamepad_ = false
			gamepad = nil
		end
		
		if (gamepad == nil) or ((gamepad ~= nil) and (subtype ~= "right") and (subtype ~= "left") and (subtype ~= "up") and (subtype ~= "right2") and (subtype ~= "left2") and (subtype ~= "up2")) then
			local x = Xoffset + unit.values[XPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * spritedata.values[TILEMULT] * 0.5
			local y = Yoffset + unit.values[YPOS] * tilesize * spritedata.values[TILEMULT] + tilesize * spritedata.values[TILEMULT] * 0.5
			
			local xtile = unit.values[XPOS]
			local ytile = unit.values[YPOS]
			
			local finaltype = subtype
			
			if (gamepad == nil) or ((gamepad ~= nil) and (subtype ~= "down") and (subtype ~= "down2")) then
				createcontrolicon(finaltype,gamepad_,x,y,"InGame",nil,1,{xtile,ytile})
			elseif (gamepad ~= nil) and ((subtype == "down") or (subtype == "down2")) then
				if (subtype == "down2") then
					finaltype = "move2"
				else
					finaltype = "move"
				end
				createcontrolicon(finaltype,gamepad_,x,y,"InGame",nil,1,{xtile,ytile})
			end
			
			if (subtype ~= "right") and (subtype ~= "left") and (subtype ~= "up") and (subtype ~= "right2") and (subtype ~= "left2") and (subtype ~= "up2") then
				if (subtype == "down") and (gamepad == nil) then
					finaltype = "move"
				end
				
				if (subtype == "down2") and (gamepad == nil) then
					finaltype = "move2"
				end
				
				writetext(langtext(finaltype),0,x,y + tilesize * spritedata.values[TILEMULT] + 2,"InGame",true,1,true)
			end
		end
	elseif (type == "level") then
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local things = findallhere(x,y)
		
		local levelfile = data[1]
			
		MF_setfile("level","Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. levelfile .. ".ld")
		local levelname = MF_read("level","general","name")
		local leveltype = tonumber(MF_read("level","general","leveltype"))
		MF_setfile("level","Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. generaldata.strings[CURRLEVEL] .. ".ld")
		
		local leveltype_bool = false
		if (leveltype == 1) then
			for i,v in ipairs(leveltree) do
				if (v ~= generaldata.strings[LEVELFILE]) and (v == levelfile) then
					leveltype_bool = true
				end
			end
		end
		
		unit.flags[MAPLEVEL] = leveltype_bool
		
		for i,v in ipairs(things) do
			local level = mmf.newObject(v)
			
			if (level.className ~= "level") then
				level.strings[U_LEVELFILE] = levelfile
				level.strings[U_LEVELNAME] = levelname
				level.values[VISUALLEVEL] = tonumber(data[3])
				level.values[VISUALSTYLE] = tonumber(data[2])
				level.flags[MAPLEVEL] = leveltype_bool
				
				if (string.len(data[4]) > 0) then
					level.values[COMPLETED] = tonumber(data[4])
				end
				
				if (string.len(data[5]) > 0) and (string.len(data[6]) > 0) then
					level.strings[COLOUR] = data[5] .. "," .. data[6]
				end
				
				if (string.len(data[7]) > 0) and (string.len(data[8]) > 0) then
					level.strings[CLEARCOLOUR] = data[7] .. "," .. data[8]
				end
			end
		end
	elseif (type == "flower") then
		local flowerid = MF_specialcreate("Flower_center")
		local flower = mmf.newObject(flowerid)
		
		flower.strings[2] = "flower"
		flower.values[10] = 2
		flower.values[6] = 1
		flower.values[8] = tonumber(data[3])
		flower.x = unit.x
		flower.y = unit.y
		
		flower.strings[1] = data[1] .. ", " .. data[2]
	elseif (type == "art") then
		local artid = MF_specialcreate("Secret_art")
		local art = mmf.newObject(artid)
		
		art.x = unit.x + tilesize * 0.5
		art.y = unit.y - tilesize * 0.5
	elseif (type == "sign") then
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local things = findallhere(x,y)
		
		local fulltext = data[1] .. "=" .. data[2] .. "=" .. data[3]
		
		for i,v in ipairs(things) do
			local vunit = mmf.newObject(v)
			
			vunit.strings[UNITSIGNTEXT] = fulltext
		end
	elseif (type == "sign_lang") then
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local things = findallhere(x,y)
		
		local fulltext = langtext(data[1],true,true) .. "=" .. langtext(data[2],true,true) .. "=" .. langtext(data[3],true,true)
		
		for i,v in ipairs(things) do
			local vunit = mmf.newObject(v)
			
			vunit.strings[UNITSIGNTEXT] = fulltext
		end
	end
end

function checkmaplevel(unitid)
	local unit = mmf.newObject(unitid)
	
	for i,v in ipairs(leveltree) do
		if (v ~= generaldata.strings[LEVELFILE]) and (v == unit.strings[U_LEVELFILE]) then
			unit.flags[MAPLEVEL] = true
		end
	end
end

function gateindicatorcheck(x,y)
	local cursors = getunitswitheffect("select",nil,nil,nil,true)
	
	for i,unit in ipairs(cursors) do
		local x_ = unit.values[XPOS]
		local y_ = unit.values[YPOS]
		
		local dx = math.abs(x_ - x)
		local dy = math.abs(y_ - y)
		
		if (dx + dy <= 1) then
			return true
		end
	end
	
	return false
end

function rewritecontrolicontext(unitid)
	local unit = mmf.newObject(unitid)
	
	local x = Xoffset + unit.values[MISC_A] * tilesize * spritedata.values[TILEMULT] + tilesize * spritedata.values[TILEMULT] * 0.5
	local y = Yoffset + unit.values[MISC_B] * tilesize * spritedata.values[TILEMULT] + tilesize * spritedata.values[TILEMULT] * 0.5
	
	local finaltype = unit.strings[BUTTONNAME]
	
	if (finaltype == "down") then
		finaltype = "move"
	end
	
	writetext(langtext(finaltype),0,x,y + tilesize * spritedata.values[TILEMULT] + 2,"InGame",true,1,false)
end

function customending_win()
	MF_end_single()
	MF_credits(1)
end

function displaysigntext(x,y,ignore)
	if (ignore ~= nil) and ignore then
		return false
	end
	
	for i=-1,1 do
		for j=-1,1 do
			if (i == 0) or (j == 0) then
				local tileid = (x + i) + (y + j) * roomsizex
				
				if (unitmap[tileid] ~= nil) then
					local stuff = findfeatureat(nil,"is","you",x + i,y + j)
					
					if (stuff ~= nil) then
						return true
					elseif (featureindex["3d"] ~= nil) then
						stuff = findfeatureat(nil,"is","3d",x + i,y + j)
						
						if (stuff ~= nil) then
							return true
						end
					elseif (featureindex["you2"] ~= nil) then
						stuff = findfeatureat(nil,"is","you2",x + i,y + j)
						
						if (stuff ~= nil) then
							return true
						end
					end
				end
			end
		end
	end
	
	return false
end

function specialroomscale()
	local s = getspecialroomscale()
	
	if (s > 0) then
		spritedata.values[TILEMULT] = s
	end
end

function getspecialroomscale()
	local x = generaldata.values[ROOMSIZEX]
	local y = generaldata.values[ROOMSIZEY]
	
	if (x <= 5) and (y == 7) then
		return 2.244
	end
	
	if (x <= 16) and (y == 9) then
		return 2.244
	end
	
	if (x <= 22) and (y == 13) then
		return 1.544
	end
	
	if (x <= 24) and (y == 14) then
		return 1.46
	end
	
	if (x <= 29) and (y == 17) then
		return 1.3
	end
	
	if (x <= 31) and (y == 18) then
		return 1.14
	end
	
	if (y <= 6) then
		if (x == 8) then
			return 4.38
		end
	end
	
	if (y <= 7) then
		if (x == 19) then
			return 1.875
		elseif (x == 16) then
			return 2.24
		elseif (x == 13) then
			return 2.74
		elseif (x == 11) then
			return 3.24
		end
		
		if (y == 7) then
			if (x == 12) then
				return 2.88
			elseif (x >= 5) and (x <= 10) then
				return 2.88
			end
		end
	end
	
	if (y <= 8) then
		if (x == 24) then
			return 1.544
		elseif (x == 19) then
			return 1.875
		elseif (x == 16) then
			return 2.24
		end
	end
	
	if (y <= 9) then
		if (x == 24) then
			return 1.544
		elseif (x == 19) then
			return 1.875
		end
	end
	
	if (y <= 10) then
		if (x == 24) then
			return 1.544
		elseif (x == 19) then
			return 1.875
		elseif (x == 18) then
			return 2.0
		end
	end
	
	if (y <= 11) and (x == 24) then
		return 1.544
	end
	
	if (y <= 12) then
		if (x == 24) then
			return 1.544
		elseif (x == 22) then
			return 1.64
		end
	end
	
	if (y <= 13) then
		if (x == 24) then
			return 1.544
		elseif (x == 23) then
			return 1.544
		end
	end
	
	if (y <= 14) and (x == 26) then
		return 1.46
	elseif (y <= 16) and (x == 29) then
		return 1.3
	elseif (y <= 17) and (x == 30) then
		return 1.244
	elseif (y <= 18) and (x == 32) then
		return 1.144
	elseif (y <= 19) and (x == 34) then
		return 1.044
	end
	
	return 0
end