function loadtileset()
	for i,tile in pairs(tileslist) do
		local tiledata = tile.tile
		local vtiledata = tile.grid
		local colour = tile.colour
		
		if (tile.active ~= nil) then
			colour = tile.active
		end
		
		local x = tiledata[1]
		local y = tiledata[2]
		
		local vx,vy = x,y
		
		if (vtiledata ~= nil) then
			vx = vtiledata[1]
			vy = vtiledata[2]
		end
		
		local unitid = MF_create(i)
		local unit = mmf.newObject(unitid)
		
		unit.values[XPOS] = vx
		unit.values[YPOS] = vy
		
		unit.values[GRID_X] = x
		unit.values[GRID_Y] = y
		
		getmetadata(unit)
		
		unit.x = vx * tilesize + tilesize * 0.5
		unit.y = 0 - tilesize
		
		local tileid = tostring(x) .. "," .. tostring(y)
		
		unit.strings[GRID_TILE] = tileid
		
		unit.values[ONLINE] = 2
		unit.visible = false
		unit.layer = 2
		
		MF_setcolour(unitid, colour[1], colour[2])
	end
end

function editor_setunitmap()
	unitmap = {}
	unittypeshere = {}
	units = {}
end

function placetile(name_,x,y,z,dir_,loading_,conversion_,skipleveldialogue_,undoing_,dontadd_)
	local id = x + y * roomsizex
	
	local name = "error"
	
	local special = 0
	local skipleveldialogue = skipleveldialogue_ or false
	local dontadd = dontadd_ or false
	
	if (tileslist[name_] ~= nil) and (name_ ~= "level") then
		name = name_
	elseif (name_ == "level") then
		name = name_
		special = 1
	elseif (name_ == "path") then
		name = name_
		special = 2
	elseif (name_ == "specialobject") then
		name = name_
		special = 3
	else
		print("Error! Couldn't find object called " .. tostring(name_))
	end

	local dir = 3
	if (dir_ ~= nil) then
		dir = dir_
	end
	
	local loading = false
	local conversion = false
	local undoing = false
	
	if (loading_ ~= nil) then
		loading = loading_
	end
	
	if (conversion_ ~= nil) then
		conversion = conversion_
	end
	
	if (undoing_ ~= nil) then
		undoing = undoing_
	end

	local tile = tileslist[name]
	local unitid = MF_create(name)
	local unit = mmf.newObject(unitid)
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[LAYER] = z
	
	if (special == 1) then
		unit.values[LAYER] = 3
	elseif (special == 3) then
		unit.values[LAYER] = 4
	end
	
	if (special == 0) then
		unit.values[DIR] = dir
	end
	
	unit.x = Xoffset + x * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	unit.y = Yoffset + y * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
	unit.direction = unit.values[DIR] * 8
	
	unit.scaleX = 0.5 * spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
	unit.scaleY = 0.5 * spritedata.values[SPRITEMULT] * spritedata.values[TILEMULT]
	
	unit.values[ONLINE] = 3
	
	if (dontadd == false) then
		if (unitmap[id] == nil) then
			unitmap[id] = {}
		end
		
		if (unittypeshere[id] == nil) then
			unittypeshere[id] = {}
		end
		
		table.insert(unitmap[id], unitid)
	end
	
	local unitcount = #units + 1
	
	units[unitcount] = {}
	units[unitcount] = mmf.newObject(unitid)
	
	getmetadata(unit)
	
	if (changes[name] ~= nil) then
		dochanges(unitid)
	end
	
	if (string.sub(unit.strings[UNITNAME], 1, 10) == "text_text_") then
		unit.flags[META] = true
	end
	
	if (dontadd == false) then
		local uth = unittypeshere[id]
		local n = unit.strings[UNITNAME]
		if (uth[n] == nil) then
			uth[n] = 0
		end
		
		uth[n] = uth[n] + 1
		
		dynamic(unitid)
	end
	
	if (special == 0) and (tileslist[name] ~= nil) then
		updateunitcolour(unitid,true)

		if (loading == false) and (dontadd == false) then
			local layer = map[z]
			local tilepos = tile.tile
			layer:set(x,y,tilepos[1],tilepos[2])
			
			if (conversion == false) then
				MF_sublayer(0,x,y,dir)
			else
				MF_setsublayer(0,x,y,z,dir)
			end
		end
	end
	
	if (special == 1) then
		editor.values[EDITTARGET] = unitid
		unit.strings[U_LEVELFILE] = generaldata.strings[LEVELFILE]
		unit.strings[U_LEVELNAME] = generaldata.strings[LEVELNAME]
		
		local c = colours.level
		local c1,c2 = c[1],c[2]
		MF_setcolour(unitid, c1, c2)
		unit.strings[COLOUR] = tostring(c1) .. "," .. tostring(c2)
		unit.strings[CLEARCOLOUR] = tostring(c1) .. "," .. tostring(c2)
		
		if (skipleveldialogue == false) and (editor2.values[EDITORTOOL] == 0) then
			submenu("addlevel")
		else
			c1,c2 = 3,2
			MF_setcolour(unitid, c1, c2)
			unit.strings[COLOUR] = tostring(c1) .. "," .. tostring(c2)
			unit.strings[CLEARCOLOUR] = tostring(c1) .. "," .. tostring(c2)
			unit.strings[U_LEVELFILE] = "nothing"
		end
	elseif (special == 2) then
		unit.values[PATH_STYLE] = editor.values[PATHSTYLE]
		unit.values[PATH_GATE] = editor.values[PATHGATE]
		unit.values[PATH_REQUIREMENT] = editor.values[PATHREQUIREMENT]
		unit.strings[PATHOBJECT] = editor.strings[PATHOBJECT]
	elseif (special == 3) then
		--T�nne jotain?
	end
	
	if (loading == false) and (conversion == false) and (undoing == false) and (dontadd == false) then
		addundo_editor("placetile",{name,x,y,z,dir})
	end
	
	return unitid
end

function copytile(data,unitid)
	local unit = mmf.newObject(unitid)
	local dunit = mmf.newObject(data)
	
	local name = unit.strings[UNITNAME]
	local realname = unit.className
	
	if (tileslist[realname] ~= nil) then
		local tiledata = tileslist[realname]
		local tile = tiledata.tile
		local grid = tiledata.grid
		
		if (grid ~= nil) then
			dunit.values[XPOS] = grid[1]
			dunit.values[YPOS] = grid[2]
		else
			dunit.values[XPOS] = tile[1]
			dunit.values[YPOS] = tile[2]
		end
		dunit.strings[NAME] = realname
		
		dunit.values[ACTUALX] = tile[1]
		dunit.values[ACTUALY] = tile[2]
	end
end

function removetile(unitid,x,y,notilemap_,noundo_,nodelete_)
	local id = x + y * roomsizex
	
	local unit = mmf.newObject(unitid)
	local n = unit.strings[UNITNAME]
	local z = unit.values[LAYER]
	
	--MF_alert("Removing " .. tostring(n) .. " at " .. tostring(x) .. ", " .. tostring(y) .. "(ID: " .. tostring(unitid) .. ")")
	
	if (unitmap[id] ~= nil) then
		for a,b in ipairs(unitmap[id]) do
			--MF_alert(tostring(b) .. " here")
			if (b == unitid) then
				--MF_alert("Removed " .. tostring(b))
				table.remove(unitmap[id], a)
			end
		end
	end
	
	if (unittypeshere[id] ~= nil) then
		local uth = unittypeshere[id]
		
		if (uth[n] ~= nil) then
			uth[n] = uth[n] - 1
			
			if (uth[n] == 0) then
				uth[n] = nil
			end
		end
	end
	
	local noundo = noundo_ or false
	
	if (noundo == false) then
		addundo_editor("removetile",{unit.className,x,y,z,unit.values[DIR]})
	end
	
	for i,unit in pairs(units) do
		if (unit.fixed == unitid) then
			table.remove(units, i)
		end
	end
	
	local nodelete = nodelete_ or false
	
	if (nodelete == false) then
		MF_cleanremove(unitid)
	end
	
	if inbounds(x,y,1) then
		dynamicat(x,y)
	end
	
	local notilemap = notilemap_ or false
	
	if (x >= 0) and (y >= 0) and (x < roomsizex) and (y < roomsizey) and (notilemap == false) and (z <= 2) then
		local layer = map[z]
		layer:unset(x,y)
	end
end

function editor_removeeverytile(obj)
	local removethese = {}
	
	for i,unit in ipairs(units) do
		if (unit.className == obj) then
			table.insert(removethese, {unit.fixed, unit.values[XPOS], unit.values[YPOS]})
		end
	end
	
	for i,v in ipairs(removethese) do
		removetile(v[1], v[2], v[3])
	end
end

function changetile(name,x,y,z,dir,unitid)
	local tiletoremove = mmf.newObject(unitid)
	
	if (tiletoremove.strings[UNITNAME] == "level") and (name == "level") then
		if (editor2.values[EDITORTOOL] == 0) then
			editor.values[EDITTARGET] = unitid
			editor2.values[MENU_YPOS] = 0
			submenu("addlevel")
			MF_leveldata(unitid)
			MF_menubackground(1)
		end
	elseif (tiletoremove.strings[UNITNAME] == "path") and (name == "path") then
		if (editor2.values[EDITORTOOL] == 0) then
			editor.values[EDITTARGET] = unitid
			submenu("setpath",1)
			MF_menubackground(1)
			MF_cursorvisible(0)
		end
	elseif (tiletoremove.strings[UNITNAME] == "specialobject") and (name == "specialobject") then
		if (editor2.values[EDITORTOOL] == 0) then
			editor.values[EDITTARGET] = unitid
			editor.values[EDITORDELAY] = 5
			editor.values[NAMETARGET] = 19
			MF_setnamegiving(tiletoremove.strings[6])
			MF_loop("givename",1)
			editor2.values[8] = 1
		end
	else
		removetile(unitid,x,y)
		placetile(name,x,y,z,dir)
	end
end

function buttonposition(unitid,id)
	local offset = tilesize * 3
	
	local unit = mmf.newObject(unitid)
	
	local rsize = roomsizex * tilesize
	local tsize = tilesize * 1.5
	
	rsize = math.floor(rsize / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = Xoffset + tilesize + x * tsize
	unit.y = Yoffset + offset + tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.scaleX = 1.5
	unit.scaleY = 1.5
	
	MF_setcolour(unitid, 1, 1)
end

function writename(name)
	local xoffset = screenw * 0.5
	local yoffset = tilesize * 2.5
	
	MF_letterclear("nametext")
	writetext(name,0,xoffset,yoffset,"nametext",true,nil,nil,nil,nil,nil,nil,true)
end

function levelname_old(name,ox_,oy_)
	local ox = ox_ or 0
	local oy = oy_ or 0
	
	local xoffset = screenw * 0.5 + ox * f_tilesize
	local yoffset = f_tilesize * 1.5 + oy * f_tilesize

	writetext(name,-1,xoffset,yoffset,"leveltext",true,nil,nil,nil,nil,nil,nil,true)
end

function createlist(id,name,folder,menuname,buttontype)
	local x = screenw * 0.5
	local y = tilesize * 5.5 + tilesize * id
	createbutton(folder,x,y,2,16,1,string.lower(name),menuname,3,2,buttontype)
end

function createlevellist(menuid,page_,search_)
	local world = generaldata.strings[WORLD]
	local path = "Data/Worlds/" .. world .. "/"
	local levels_ = MF_filelist(path,"*.l")
	local r_i = tonumber(MF_read("world","levels","rolling_levelid")) or 0
	
	local targetlevel = editor3.strings[PREVLEVELFILE]
	
	local search = search_ or ""
	local pagelimit = 24
	
	local levels = {}
	local levels_l = {}
	local levels_m = {}
	local levelsdata = {}
	local levels_id = {}
	local levels_l_id = {}
	local levels_m_id = {}
	
	local sorting_types = editor2.values[SORTING_TYPES]
	local sorting = editor2.values[SORTING]
	
	for i,v in ipairs(levels_) do
		local ldfile = v .. "d"
		local lname = string.sub(v, 1, string.len(v) - 2)
		
		MF_setfile("level",path .. ldfile)
		
		local n = MF_read("level","general","name")
		local nid = string.lower(n .. tostring(i))
		local t = tonumber(MF_read("level","general","leveltype")) or 0
		
		local lid = MF_read("level","general","levelid")
		local id = ""
		
		if (type(lid) == "number") and (lid <= r_i) then
			id = tostring(r_i - (tonumber(lid) or 0)) .. nid
		else
			id = tostring(lid) .. nid
		end
		
		local valid = true
		if (string.len(search) > 0) then
			if (string.find(string.lower(n), string.lower(search)) == nil) then
				valid = false
			end
		end
		
		if valid then
			if (sorting == 1) then
				levelsdata[nid] = {v, t, lname, n}
			elseif (sorting == 0) then
				levelsdata[id] = {v, t, lname, n}
			end
			
			table.insert(levels, nid)
			table.insert(levels_id, id)
			
			if (t == 0) then
				table.insert(levels_l, nid)
				table.insert(levels_l_id, id)
			elseif (t == 1) then
				table.insert(levels_m, nid)
				table.insert(levels_m_id, id)
			end
		end
	end
	
	if (sorting == 1) then
		if (sorting_types == 0) then
			table.sort(levels)
		elseif (sorting_types == 1) then
			table.sort(levels_m)
			table.sort(levels_l)
		end
	elseif (sorting == 0) then
		if (sorting_types == 0) then
			table.sort(levels_id)
			
			levels = levels_id
		elseif (sorting_types == 1) then
			table.sort(levels_m_id)
			table.sort(levels_l_id)
			
			levels_m = levels_m_id
			levels_l = levels_l_id
		end
	end
	
	if (sorting_types == 1) then
		levels = {}
		
		for i,v in ipairs(levels_m) do
			table.insert(levels, v)
		end
		
		for i,v in ipairs(levels_l) do
			table.insert(levels, v)
		end
	end
	
	local page = page_ or 0
	
	if (string.len(targetlevel) > 0) then
		for i,v in ipairs(levels) do
			local ldata = levelsdata[v]
			
			if (ldata[3] == targetlevel) then
				page = math.floor(math.max(0,i-1) / pagelimit)
				editor3.values[PAGE] = page
				break
			end
		end
	end
	
	editor3.strings[PREVLEVELFILE] = ""
	
	local total = #levels
	local maxpages = math.floor((total-1) / pagelimit)
	
	page = math.min(maxpages, page)
	
	local limit_min,limit_max = 0,24
	
	limit_min = page * pagelimit + 1
	limit_max = math.min((page + 1) * pagelimit, total)
	local id = 0
	
	--MF_alert(tostring(limit_min) .. " - " .. tostring(limit_max))
	
	local menustruct = {}
	local thismenustruct = {}
	local by_ = 0
	
	if (limit_max > 0) then
		for i=limit_min,limit_max do
			local nid = levels[i]
			local data = levelsdata[nid]
			local v = data[1]
			local name = data[4]
			local lfile = v
			local ldfile = v .. "d"
			local filename = string.sub(v, 1, string.len(v) - 2)
			local iconfile = filename .. ".png"
			
			--MF_alert(iconfile)
			
			local buttonid = MF_create("Editor_levelbutton")
			local button = mmf.newObject(buttonid)
			
			button.strings[BUTTONFUNC] = filename
			button.strings[BUTTONID] = menuid
			button.strings[BUTTONNAME] = name
			button.layer = 2
			
			local leveltype = data[2]
			
			local bx,by = levelbutton_positioning(button,id)
			
			if (by_ ~= by) then
				table.insert(menustruct, thismenustruct)
				thismenustruct = {}
				by_ = by
			end
			
			table.insert(thismenustruct, {filename, "bigcursor"})
			
			if (i == limit_max) and (#thismenustruct > 0) then
				table.insert(menustruct, thismenustruct)
				thismenustruct = {}
			end
			
			if (leveltype == 1) then
				button.animSet = 2
				button.strings[UI_CUSTOMCOLOUR] = "4,0"
				MF_setcolour(buttonid,4,0)
			end
			
			if MF_findfile(path .. iconfile) then
				local thumbid = MF_specialcreate("Editor_thumbnail_level")
				local thumb = mmf.newObject(thumbid)
				thumb.values[ONLINE] = buttonid
				thumb.strings[BUTTONID] = menuid
				thumb.layer = 2
				thumb.scaleX = 0.35
				thumb.scaleY = 0.65
				MF_thumbnail_loadimage(thumbid,0,id,path .. iconfile)
			end
			
			id = id + 1
		end
	end
	
	MF_setfile("level","Data/Temp/temp.ld")
	
	return total,maxpages,menustruct,page
end

function levelbutton_positioning(unit,id)
	local offset = f_tilesize * 6
	local multiplier = 4
	
	local rsize_ = math.floor(screenw / f_tilesize) * f_tilesize
	local tsize = f_tilesize * multiplier
	
	local rsize = math.floor(rsize_ / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = rsize_ * 0.5 - rsize * 0.5 * tsize + x * tsize + tsize * 0.5
	unit.y = offset + f_tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.values[BUTTON_STOREDX] = unit.x
	unit.values[BUTTON_STOREDY] = unit.y
	unit.flags[BUTTON_SLIDING] = true
	
	unit.scaleX = multiplier / 4
	unit.scaleY = multiplier / 4
	
	MF_setcolour(unit.fixed, 1, 1)
	
	return x,y
end

function spritelist(unitid,id)
	local offsetx = f_tilesize * 2
	local offsety = f_tilesize * 5
	local multiplier = 2
	
	local unit = mmf.newObject(unitid)
	
	local rsize = screenw - offsetx
	local tsize = f_tilesize * multiplier
	
	rsize = math.floor(rsize / tsize)
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = offsetx + f_tilesize * multiplier * 0.5 + x * tsize
	unit.y = offsety + f_tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	
	unit.values[BUTTON_STOREDX] = unit.x
	unit.values[BUTTON_STOREDY] = unit.y
	unit.flags[BUTTON_SLIDING] = true
	
	unit.scaleX = multiplier / 2
	unit.scaleY = multiplier / 2
	
	MF_setcolour(unitid, 1, 1)
	
	return x,y
end

function iconlist(unitid,id)
	local offset = tilesize * 4
	local multiplier = 2
	
	local unit = mmf.newObject(unitid)
	
	local rsize = 10
	local tsize = f_tilesize * multiplier
	
	local x = id % rsize
	local y = math.floor(id / rsize)
	
	unit.x = screenw * 0.5 - ((rsize - 1) * 0.5) * f_tilesize * 2 + x * tsize
	unit.y = offset + f_tilesize + y * tsize
	
	unit.values[YORIGIN] = unit.y
	unit.strings[UNITTYPE] = "IconButton"
	unit.strings[BUTTONFUNC] = id
	
	unit.values[XPOS] = x
	unit.values[YPOS] = y
	unit.values[TYPE] = id
	unit.layer = 2
	
	unit.values[BUTTON_STOREDX] = unit.x
	unit.values[BUTTON_STOREDY] = unit.y
	unit.flags[BUTTON_SLIDING] = true
	
	unit.scaleX = multiplier / 2
	unit.scaleY = multiplier / 2
	
	MF_setcolour(unitid, 1, 1)
	
	local symbolid = MF_specialcreate("Editor_levelnum")
	local symbol = mmf.newObject(symbolid)
	
	symbol.x = unit.x
	symbol.y = unit.y
	symbol.layer = 3
	symbol.values[ONLINE] = 0-1-id
	symbol.values[LEVELNUMBER] = id
	symbol.values[LEVELSTYLE] = -1
	symbol.flags[SPECIAL] = true
	
	return x,y
end

function editordelete(id)
	delunit(id)
	MF_cleanremove(id)
end

function editor_moveall(dir,undoing_)
	local drs = ndirs[dir+1]
	local ox,oy = drs[1],drs[2]
	
	for i,unit in ipairs(units) do
		local oldx,oldy = unit.values[XPOS],unit.values[YPOS]
		local newx,newy = oldx + ox,oldy + oy
		
		if (newx <= 0) then
			newx = roomsizex - 2
		elseif (newx >= roomsizex - 1) then
			newx = 1
		end
		
		if (newy <= 0) then
			newy = roomsizey - 2
		elseif (newy >= roomsizey - 1) then
			newy = 1
		end
		
		unit.values[XPOS] = newx
		unit.values[YPOS] = newy
		
		unit.x = Xoffset + newx * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
		unit.y = Yoffset + newy * tilesize * spritedata.values[TILEMULT] + tilesize * 0.5 * spritedata.values[TILEMULT]
		
		updateunitmap(unit.fixed,oldx,oldy,newx,newy,unit.strings[UNITNAME])
	end
	
	for z=0,2 do
		local l = map[z]
		
		for i=1,roomsizex-2 do
			for j=1,roomsizey-2 do
				l:unset(i,j)
				MF_setsublayer(0,i,j,z,3)
				
				local id = i + j * roomsizex
				
				if (unitmap[id] ~= nil) then
					for a,b in ipairs(unitmap[id]) do
						local unit = mmf.newObject(b)
						local data = tileslist[unit.className]
						
						if (unit.values[LAYER] == z) and (unit.className ~= "level") and (unit.className ~= "path") and (unit.className ~= "specialobject") then
							if (data == nil) then
								MF_alert(unit.className .. " doesn't exist in tileslist??")
							else
								local tiledata = data.tile
								
								l:set(i,j,tiledata[1],tiledata[2])
								
								MF_setsublayer(0,i,j,z,unit.values[DIR])
							end
						end
					end
				end
			end
		end
	end
	
	local undoing = undoing_ or false
	
	if (undoing == false) then
		addundo_editor("moveall",{dir})
		updateundo_editor()
	end
end

function editor_objectselectionhack(choice,id)
	if (id == "a") then
		local aselect = choice
		if (choice == 4) then
			aselect = 1
		elseif (choice == 3) then
			aselect = 2
		elseif (choice == 2) then
			aselect = 3
		elseif (choice == 1) then
			aselect = 4
		end
		
		makeselection({"a1","a2","a3","a4","a5","a6"},aselect + 2)
	elseif (id == "w") then
		makeselection({"w1","w2","w3","w4","","w6","","w5"},choice + 1)
	end
end

function objectwordswap(id,dir_)
	local unit = mmf.newObject(id)
	local realname = unit.strings[NAME]
	
	local name = getactualdata(realname, "name")
	local unittype = getactualdata(realname, "unittype")
	local t = getactualdata(realname, "type")
	
	local objword = editor2.values[OBJECTWORDSWAP]
	local objwords = {["object"] = 0, ["text"] = 1}
	local ut = objwords[unittype] or 0
	
	local found = false
	
	local dir = dir_
	if (dir == 0) then
		dir = 1
	end
	
	if (t == 0) then
		if (objectword ~= ut) then
			if (unittype == "text") and (string.sub(name, 1, 5) == "text_") then
				local newname = string.sub(name, 6)
				
				if (unitreference[newname] ~= nil) then
					local newrealname = unitreference[newname]
					local valid = false
					
					for i,v in ipairs(editor_currobjlist) do
						if (v.object == newrealname) then
							valid = true
							break
						end
					end
					
					if valid then
						unit.strings[NAME] = newrealname
						found = true
						return
					end
				end
			elseif (unittype == "object") and (string.sub(name, 1, 5) ~= "text_") then
				local newname = "text_" .. name
				
				if (unitreference[newname] ~= nil) then
					local newrealname = unitreference[newname]
					local valid = false
					
					for i,v in ipairs(editor_currobjlist) do
						if (v.object == newrealname) then
							valid = true
							break
						end
					end
					
					if valid then
						unit.strings[NAME] = newrealname
						found = true
						return
					end
				end
			end
		end
	elseif ((t == 2) and (unittype == "text") and (string.sub(name, 1, 5) == "text_")) or (name == "text_powered") then
		local shortname = string.sub(name, 6)
		
		local pairings =
		{
			fall = {"fall","fallright","fallup","fallleft"},
			nudge = {"nudgedown","nudgeright","nudgeup","nudgeleft"},
			turn = {"turn","deturn"},
			deturn = {"turn","deturn"},
			open = {"open","shut"},
			shut = {"open","shut"},
			hot = {"hot","melt"},
			melt = {"hot","melt"},
			power = {"powered","power"},
			powered = {"power","powered"},
			power2 = {"powered2","power2"},
			powered2 = {"power2","powered2"},
			power3 = {"powered3","power3"},
			powered3 = {"power3","powered3"},
			red = {"red","brown","orange","yellow","lime","green","cyan","blue","purple","pink","rosy"},
			brown = {"brown","orange","yellow","lime","green","cyan","blue","purple","pink","rosy","red"},
			orange = {"orange","yellow","lime","green","cyan","blue","purple","pink","rosy","red","brown"},
			yellow = {"yellow","lime","green","cyan","blue","purple","pink","rosy","red","brown","orange"},
			lime = {"lime","green","cyan","blue","purple","pink","rosy","red","brown","orange","yellow"},
			green = {"green","cyan","blue","purple","pink","rosy","red","brown","orange","yellow","lime"},
			cyan = {"cyan","blue","purple","pink","rosy","red","brown","orange","yellow","lime","green"},
			blue = {"blue","purple","pink","rosy","red","brown","orange","yellow","lime","green","cyan"},
			purple = {"purple","pink","rosy","red","brown","orange","yellow","lime","green","cyan","blue"},
			pink = {"pink","rosy","red","brown","orange","yellow","lime","green","cyan","blue","purple"},
			rosy = {"rosy","red","brown","orange","yellow","lime","green","cyan","blue","purple","pink"},
			black = {"black","grey","silver","white"},
			grey = {"grey","silver","white","black"},
			silver = {"silver","white","black","grey"},
			white = {"white","black","grey","silver"},
		}
		
		for i,v in pairs(pairings) do
			--MF_alert(string.sub(shortname, 1, #i) .. ", " .. i)
			
			if (string.sub(shortname, 1, #i) == i) then
				local current = 0
				local starting = 0
				local total = #v
				
				for a,b in ipairs(v) do
					if (b == shortname) then
						current = a - 1
						starting = a - 1
						break
					end
				end
				
				current = (current + dir + total) % total
				
				while (current ~= starting) and (found == false) do
					local target = "text_" .. v[current + 1]
					
					--MF_alert("target: " .. target)
					
					if (unitreference[target] ~= nil) then
						local newrealname = unitreference[target]
						local valid = false
						
						for i,v in ipairs(editor_currobjlist) do
							if (v.object == newrealname) then
								valid = true
								break
							end
						end
						
						if valid then
							unit.strings[NAME] = newrealname
							found = true
							return
						end
					end
					
					current = (current + dir + total) % total
				end
				
				break
			end
		end
	end
end

function updatecursorthumbnail(name,id)
	local unit = mmf.newObject(id)
	local sprite = getactualdata_objlist(name, "sprite") or ""
	local tiling = getactualdata_objlist(name, "tiling") or -1
	local root_ = getactualdata_objlist(name, "sprite_in_root")
	
	--MF_alert(name .. ", " .. tostring(sprite) .. ", " .. tostring(tiling) .. ", " .. tostring(root_))
	
	if (root_ == nil) then
		root_ = true
	end
	
	tiling = tonumber(tiling)
	
	local dir = 0
	local editordir = editor.values[EDITORDIR]
	
	local root = 1
	if (root_ == false) then
		root = 0
	end
	
	--[[
		Tiling types:
		-1 = none
		0 = dirs
		1 = tiling
		2 = character
		3 = anim dir
		4 = anim
	]]--
	
	if (tiling ~= 0) and (tiling ~= 2) and (tiling ~= 3) then
		dir = 0
	else
		dir = editordir * 8
	end
	
	unit.strings[NAME] = sprite
	unit.values[ICONDIR] = dir
	unit.values[ICONROOT] = root
end

function editor_drawline(currx, curry, endx, endy, oldx, oldy)
	local at_end = false
	local new_tile = false
	
	local cx = math.floor(currx)
	local cy = math.floor(curry)
	
	if (cx == endx) and (cy == endy) then
		at_end = true
	end
	
	if (cx ~= oldx) or (cy ~= oldy) then
		new_tile = true
	end
	
	if (inbounds(cx,cy) == false) or (inbounds(endx,endy) == false) then
		at_end = true
	end
	
	return at_end, new_tile, cx, cy
end

function placetile_table(name,data,z,dir)
	local layer = map[z]
	
	for i,v in ipairs(data) do
		local x = v[1]
		local y = v[2]
		
		if (x > 0) and (y > 0) and (x < roomsizex-1) and (y < roomsizey-1) then
			local tile = layer:get_x(x,y)
			local target = 0
			
			if (tile ~= 255) then
				local tileid = x + y * roomsizex
				
				if (unitmap[tileid] ~= nil) then
					for a,b in ipairs(unitmap[tileid]) do
						local unit = mmf.newObject(b)
						
						if (unit.values[LAYER] == z) then
							target = b
							break
						end
					end
				end
			end
			
			if (string.len(name) > 0) then
				if (tile == 255) then
					placetile(name,x,y,z,dir)
				else
					if (target ~= 0) then
						changetile(name,x,y,z,dir,target)
					end
				end
			else
				if (target ~= 0) then
					removetile(target,x,y)
				end
			end
		end
	end
end

function flood_fill(name,x,y,z,dir,test_)
	local layer = map[z]
	
	local test = test_ or false
	
	if (x > 0) and (y > 0) and (x < roomsizex-1) and (y < roomsizey-1) then
		local tile = layer:get_x(x,y)
		local target = 0
		local targetname = ""
		
		if (tile ~= 255) then
			local tileid = x + y * roomsizex
			
			if (unitmap[tileid] ~= nil) then
				for a,b in ipairs(unitmap[tileid]) do
					local unit = mmf.newObject(b)
					
					if (unit.values[LAYER] == z) then
						target = b
						targetname = unit.className
						break
					end
				end
			end
		end
		
		local floodmap = {{x,y}}
		local floodmap_checked = {}
		local floodmap_targets = {}
		
		while (#floodmap > 0) do
			local current = floodmap[1]
			
			local cx,cy = current[1],current[2]
			
			tile = layer:get_x(cx,cy)
			target = 0
			
			local changethis = false
			
			if (tile ~= 255) and (string.len(targetname) > 0) then
				local tileid = cx + cy * roomsizex
				
				if (unitmap[tileid] ~= nil) then
					for a,b in ipairs(unitmap[tileid]) do
						local unit = mmf.newObject(b)
						
						--MF_alert(targetname .. ", " .. unit.className)
						
						if (unit.values[LAYER] == z) and (unit.className == targetname) then
							target = b
							changethis = true
						end
					end
				end
			elseif (tile == 255) and (string.len(targetname) == 0) then
				changethis = true
			end
			
			if changethis then
				if (target ~= 0) then
					table.insert(floodmap_targets, {target, cx, cy})
				else
					table.insert(floodmap_targets, {0, cx, cy})
				end
			end
			
			if (floodmap_checked[cx] == nil) then
				floodmap_checked[cx] = {}
			end
			
			if (floodmap_checked[cx][cy] == nil) then
				floodmap_checked[cx][cy] = 1
			end
			
			if changethis then
				local flood_dirs = {{1,0}, {0,-1}, {-1,0}, {0,1}}
				
				for i=1,#flood_dirs do
					local drs = flood_dirs[i]
					local cx_ = cx + drs[1]
					local cy_ = cy + drs[2]
					
					if (cx_ > 0) and (cy_ > 0) and (cx_ < roomsizex-1) and (cy_ < roomsizey-1) then
						if (floodmap_checked[cx_] == nil) or (floodmap_checked[cx_][cy_] == nil) then
						
							if (floodmap_checked[cx_] == nil) then
								floodmap_checked[cx_] = {}
							end
							
							if (floodmap_checked[cx_][cy_] == nil) then
								floodmap_checked[cx_][cy_] = 1
							end
							
							table.insert(floodmap, {cx_, cy_})
						end
					end
				end
			end
			
			table.remove(floodmap, 1)
		end
		
		if (#floodmap_targets > 0) then
			for i,v in ipairs(floodmap_targets) do
				if (test == false) then
					if (v[1] == 0) then
						if (string.len(name) > 0) then
							placetile(name,v[2],v[3],z,dir)
						end
					elseif (v[1] ~= 0) then
						local unitid = v[1]
						
						if (string.len(name) > 0) then
							changetile(name,v[2],v[3],z,dir,unitid)
						else
							removetile(unitid,v[2],v[3])
						end
					end
				else
					MF_editormarker(v[2],v[3])
				end
			end
		end
	end
end

function checkthemename(name)
	local world = generaldata.strings[WORLD]
	local themes = MF_filelist("Data/Worlds/" .. world .. "/Themes/","*.txt")
	
	local conflict,themefile = false,""
	
	for i,v in ipairs(themes) do
		MF_setfile("level","Data/Worlds/" .. world .. "/Themes/" .. v)
		
		local themename = MF_read("level","general","name")
		
		if (themename == name) then
			conflict = true
			themefile = v
			break
		end
	end
	
	return conflict,themefile
end

function findfreethemeslot()
	local world = generaldata.strings[WORLD]
	local themes = MF_filelist("Data/Worlds/" .. world .. "/Themes/","*.txt")
	
	local maxid = tonumber(MF_read("world","general","themecount")) or 0
	local id = math.max(#themes, maxid)
	local valid = false
	
	local tester = string.len("theme.txt")
	
	while (valid == false) do
		local test = true
		
		for i,v in ipairs(themes) do
			local s = string.len(v) - tester
			local themeid = tonumber(string.sub(v, 1, s))
			
			if (themeid == id) then
				MF_alert("Theme with ID " .. tostring(themeid) .. " exists")
				test = false
				break
			end
		end
		
		if test then
			valid = true
		else
			id = id + 1
		end
	end
	
	return id
end

function findfreelevelslot()
	local world = generaldata.strings[WORLD]
	local levels = MF_filelist("Data/Worlds/" .. world .. "/","*.ld")
	
	local maxid = tonumber(MF_read("world","levels","levelid")) or 0
	local id = math.max(#levels, maxid)
	local valid = false
	
	local tester = string.len("level.ld")
	
	while (valid == false) do
		local test = true
		
		for i,v in ipairs(levels) do
			local s = string.len(v) - tester
			local themeid = tonumber(string.sub(v, 1, s))
			
			if (themeid == id) then
				MF_alert("Level with ID " .. tostring(themeid) .. " exists")
				test = false
				break
			end
		end
		
		if test then
			valid = true
		else
			id = id + 1
		end
	end
	
	return id
end

function findfreeworldslot(tentative)
	local worlds = MF_dirlist("Data/Worlds/*")
	
	local maxid = tentative or 0
	local id = math.max(#worlds, maxid)
	local valid = false
	
	local tester = string.len("world")
	
	while (valid == false) do
		local test = true
		
		for i,v in ipairs(worlds) do
			local worldname = string.sub(v, 2, string.len(v) - 1)
			local s = string.len(worldname) - tester
			local worldid = tonumber(string.sub(worldname, 1, s))
			
			if (worldid == id) then
				MF_alert("World with ID " .. tostring(worldid) .. " exists")
				test = false
				break
			end
		end
		
		if test then
			valid = true
		else
			id = id + 1
		end
	end
	
	return id
end

function addcodetohistory(code_,name_,list_)
	local code = code_ or ""
	local list = list_ or ""
	
	if (string.len(code) > 0) and (string.len(list) > 0) then
		local name = name_ or "unknown"
		local id = 0
		local duplicate = false
		
		local entries = tonumber(MF_read("settings",list,"total")) or 0
		local debugging = tonumber(MF_read("settings","settingS","debug")) or 0
		
		local entrylist_ = {}
		local entrylist = {}
		
		for i=1,entries do
			local lcode = MF_read("settings",list,tostring(i-1) .. "code")
			local lname = MF_read("settings",list,tostring(i-1) .. "name")
			
			table.insert(entrylist_, {lcode, lname, 0})
		end
		
		for a,b in ipairs(entrylist_) do
			if (code == b[1]) then
				b[3] = 1
			end
		end
		
		table.insert(entrylist_, 1, {code, name, 0})
		
		for a,b in ipairs(entrylist_) do
			if (b[3] == 0) then
				table.insert(entrylist, {b[1], b[2]})
			end
		end
		
		if (debugging == 0) then
			entries = math.min(#entrylist, 15)
		end
		
		for i=1,entries do
			local v = entrylist[i]
			local lcode = v[1]
			local lname = v[2]
			
			MF_store("settings",list,tostring(i-1) .. "code",lcode)
			MF_store("settings",list,tostring(i-1) .. "name",lname)
		end
		
		MF_store("settings",list,"total",tostring(entries))
	end
end

function convertoldlevel()
	local currobjs = {}
	local newobjs = {}
	local currunitmap = {}
	local changestoapply = {}
	
	for i,unit in ipairs(units) do
		if (unit.className ~= "level") and (unit.className ~= "path") and (unit.className ~= "specialobject") then
			local name = unit.strings[UNITNAME]
			local x,y,z = unit.values[XPOS],unit.values[YPOS],unit.values[LAYER]
			local dir,zlayer = unit.values[DIR],unit.values[ZLAYER]
			
			local udata = tileslist[unit.className]
			
			currobjs[udata.name] = unit.className
			newobjs[unit.className] = ""
			
			table.insert(currunitmap, {udata.name, x, y, z, dir, zlayer})
		end
	end
	
	for i,v in pairs(currobjs) do
		if (changes[v] ~= nil) then
			changestoapply[v] = {}
			local this = changestoapply[v]
			
			for a,b in pairs(changes[v]) do
				if (tostring(type(b)) == "table") then
					this[a] = {}
					
					for c,d in pairs(b) do
						this[a][c] = d
					end
				else
					this[a] = b
				end
			end
		end
	end
	
	MF_alert("Preparing to clear everything...")
	
	restoredefaults()
	clearcurrobjlist()
	
	MF_alert("Clearing level...")
	
	MF_loop("editor_clearmap",1)
	clearunits()
	MF_loop("clear_editor",1)
	
	changes = {}
	
	MF_alert("Adding objects to currobjlist... " .. tostring(#editor_currobjlist))
	
	for i,v in pairs(currobjs) do
		--MF_alert("Adding " .. i)
		local id,obj = addobjtolist(i)
		
		MF_alert("New obj for " .. i .. ": " .. tostring(obj) .. ", " .. tostring(id))
		
		local oldobj = currobjs[i]
		currobjs[i] = obj
		
		newobjs[oldobj] = obj
	end
	
	MF_alert("Re-applying changes...")
	
	for i,v in pairs(changestoapply) do
		local newobj = newobjs[i]
		
		MF_alert("Re-applying changes to " .. tostring(newobj))
		
		local paramnames = {"name", "image", "colour", "tiling", "type", "unittype", "activecolour", "root", "layer", "argtype", "argextra", "customobjects"}
		local params = {}
		
		for c,d in ipairs(paramnames) do
			if (v[d] ~= nil) then
				params[c] = convertparam(v[d])
			end
		end
		
		savechange(newobj,params,0)
	end
	
	MF_alert("Re-adding objects to level...")
	
	for i,v in ipairs(currunitmap) do
		local name,x,y,z,dir,zlayer = v[1],v[2],v[3],v[4],v[5],v[6]
		local obj = currobjs[name]
		
		--MF_alert("Dir for " .. tostring(obj) .. " is " .. tostring(dir))
		
		placetile(obj,x,y,z,dir,nil,true)
	end
end

function createdifftext()
	editor2.strings[SUBTITLE] = ""
	local result = ""
	
	for i=0,9 do
		if (editor3.values[DIFFICULTYNUM] > i) then
			result = result .. "♄"
		else
			result = result .. "♏"
		end
		
		if (i < 9) then
			result = result .. " "
		end
	end
	
	result = string.sub(result, 1, 40)
	
	editor2.strings[SUBTITLE] = result
end

function getlevelcopyname(oldname)
	local tlen = string.len(oldname)
	local newname = oldname .. " 2"
	local oldnamepiece = ""
	
	local hasnumber = false
	if (tonumber(string.sub(oldname, -1)) ~= nil) then
		hasnumber = true
	end
	
	if hasnumber then
		for i=1,tlen do
			if ((tonumber(string.sub(oldname, 0-i, 0-i)) == nil) or (string.sub(oldname, 0-i, 0-i) == " ")) and (i > 1) then
				local test = string.sub(oldname, 0-(i-1))
				
				if (tonumber(test) ~= nil) then
					local levelnum = tonumber(test) + 1
					local oldnamepiece = string.sub(oldname, 1, string.len(oldname) - string.len(test))
					
					newname = oldnamepiece .. tostring(levelnum)
					break
				end
			end
		end
	end
	
	return newname
end

function convertparam(data)
	local result = ""
	
	if (type(data) == "string") then
		result = data
	elseif (type(data) == "number") then
		result = tostring(data)
	elseif (type(data) == "table") then
		if (#data > 0) then
			for i,v in ipairs(data) do
				result = result .. tostring(v)
				
				if (i < #data) then
					result = result .. ","
				end
			end
		else
			for i,v in pairs(data) do
				result = result .. tostring(v) .. ","
			end
		end
	else
		MF_alert("Parameter isn't accepted type: " .. type(data))
		
		result = nil
	end
	
	return result
end

function hotbar_updatethumbnail(object,thumbid,slotid)
	local thumb = mmf.newObject(thumbid)
	
	if (string.len(object) > 0) then
		local sprite = getactualdata_objlist(object,"sprite")
		local sprite_in_root = getactualdata_objlist(object,"sprite_in_root")
		local colour = getactualdata_objlist(object,"colour")
		local colour_a = getactualdata_objlist(object,"active")
		local tiletype = getactualdata_objlist(object,"unittype")
		
		local path = "Data/Sprites/"
		if (sprite_in_root == false) then
			path = "Data/Worlds/" .. generaldata.strings[WORLD] .. "/Sprites/"
		end
		
		MF_thumbnail_loadimage(thumbid,0,slotid,path .. sprite .. "_0_1.png")
		
		if (tiletype ~= "text") then
			MF_setcolour(thumbid, colour[1], colour[2])
		else
			MF_setcolour(thumbid, colour_a[1], colour_a[2])
		end
		
		thumb.visible = true
	else
		thumb.visible = false
	end
end

function editor_buttons_getdpad(dpad)
	local editorbuttons_editor = {"move","rotate","place","copy","drag","undo","scollleft_hotbar","scrollright_hotbar","scrollleft_tool","scrollright_tool","currobjlist","quickmenu","swap","scrollleft_layer","scrollright_layer","moveall","altpress","lock","showdir","lock"}
	local editorbuttons_currobjlist = {"move","select","swap","drag","tooltip","scrollleft","scrollright","closemenu","tags","remove","edit","addnew","search"}
	
	local editorstring = ""
	local currobjstring = ""
	local est = {}
	local cst = {}
	local dpadcodes = {["h0.2"] = 1, ["h0.1"] = 2, ["h0.8"] = 3, ["h0.4"] = 4}
	
	for i,v in ipairs(editorbuttons_editor) do
		local button = MF_read("settings","gamepad_editor",v)
		
		if (string.sub(button, 1, 3) == "h0.") then
			local bcode = dpadcodes[button]
			est[bcode] = v
		end
	end
	
	for i,v in ipairs(editorbuttons_currobjlist) do
		local button = MF_read("settings","gamepad_currobjlist",v)
		
		if (string.sub(button, 1, 3) == "h0.") then
			local bcode = dpadcodes[button]
			cst[bcode] = v
		end
	end
	
	for i,v in ipairs(est) do
		editorstring = editorstring .. langtext("buttons_editor_" .. v,true) .. ","
	end
	
	for i,v in ipairs(cst) do
		currobjstring = currobjstring .. langtext("buttons_currobjlist_" .. v,true) .. ","
	end
	
	dpad.strings[1] = editorstring
	dpad.strings[2] = currobjstring
end

function editor_updateanimtype(anim,unitname)
	for i,unit in ipairs(units) do
		if (unit.strings[UNITNAME] == unitname) then
			unit.values[TILING] = anim
			
			if (anim ~= 1) and (anim ~= -1) then
				unit.direction = unit.values[DIR] * 8
			elseif (anim == -1) then
				unit.direction = 0
			end
		end
	end
end

function setobjectanimtype_fromsprite(unitname,sprite,object,fixed)
	local animtype = -2
	
	MF_alert(sprite)
	
	for i,v in pairs(editor_objlist) do
		if (v.sprite == sprite) or ((v.sprite == nil) and (v.name == sprite)) then
			animtype = v.tiling or -2
			break
		end
	end
	
	if (animtype > -2) then
		savechange(object,{nil,nil,nil,animtype},fixed)
		editor_objectselectionhack(animtype,"a")
		editor_updateanimtype(animtype,unitname)
	end
	
	return animtype
end

function editor_quickis(selectorid)
	local selector = mmf.newObject(selectorid)
	
	if (unitreference["text_is"] ~= nil) then
		for i,v in ipairs(editor_currobjlist) do
			if (v.name == "text_is") then
				selector.strings[1] = v.object
				local tpos = v.tile
				selector.values[XPOS] = tpos[1]
				selector.values[YPOS] = tpos[2]
			end
		end
	end
end

function editor_quickand(selectorid)
	local selector = mmf.newObject(selectorid)
	
	if (unitreference["text_and"] ~= nil) then
		for i,v in ipairs(editor_currobjlist) do
			if (v.name == "text_and") then
				selector.strings[1] = v.object
				local tpos = v.tile
				selector.values[XPOS] = tpos[1]
				selector.values[YPOS] = tpos[2]
			end
		end
	end
end

function editor_quicknot(selectorid)
	local selector = mmf.newObject(selectorid)
	
	if (unitreference["text_not"] ~= nil) then
		for i,v in ipairs(editor_currobjlist) do
			if (v.name == "text_not") then
				selector.strings[1] = v.object
				local tpos = v.tile
				selector.values[XPOS] = tpos[1]
				selector.values[YPOS] = tpos[2]
			end
		end
	end
end

function editor_resetselectionrect()
	selectionrect = {}
	selectionrect.x = 0
	selectionrect.y = 0
	selectionrect.w = 0
	selectionrect.h = 0
end

function editor_setselectionrect(x,y,w,h,unitlist_,doundo_)
	selectionrect = {}
	selectionrect.x = x
	selectionrect.y = y
	selectionrect.w = w
	selectionrect.h = h
	
	local doundo = true
	if (doundo_ ~= nil) then
		doundo = doundo_
	end
	
	local db = {}
	
	if (unitlist_ == nil) then
		for i,unit in ipairs(units) do
			local ux,uy,uz = unit.values[XPOS],unit.values[YPOS],unit.values[LAYER]
			
			if (uz == editor.values[LAYER]) and (ux >= x) and (uy >= y) and (ux < x + w) and (uy < y + h) and (unit.className ~= "level") then
				table.insert(db, unit)
			end
		end
	else
		db = unitlist_
	end
	
	for a,bunit in ipairs(db) do
		local x_,y_ = bunit.values[XPOS],bunit.values[YPOS]
		
		local sx = x_ - x
		local sy = y_ - y
		
		local tileid = sx + sy * selection_vwidth
		
		if (selectionrect[tileid] == nil) then
			selectionrect[tileid] = {}
		end
		
		table.insert(selectionrect[tileid], {bunit.className, bunit.values[LAYER], bunit.values[DIR], bunit.fixed})
		
		bunit.values[ONLINE] = 2
		bunit.values[XPOS] = sx
		bunit.values[YPOS] = sy
		
		removetile(bunit.fixed,x_,y_,nil,nil,true)
	end
	
	if doundo then
		updateundo_editor()
	end
end

function editor_rotateselection(dir,placerid)
	local updatedrect = {}
	local x_ = selectionrect.x
	local y_ = selectionrect.y
	local w = selectionrect.w
	local h = selectionrect.h
	
	local nw = h
	local nh = w
	
	for tileid,b in pairs(selectionrect) do
		if (tonumber(tileid) ~= nil) then
			local x = tileid % selection_vwidth
			local y = math.floor(tileid / selection_vwidth)
			
			local nx,ny = x,y
			
			if (dir == 1) then
				nx = (h - 1) - y
				ny = x
			elseif (dir == -1) then
				nx = y
				ny = (w - 1) - x
			end
			
			local ntileid = nx + ny * selection_vwidth
			
			if (updatedrect[ntileid] == nil) then
				updatedrect[ntileid] = {}
			end
			
			for i,v in ipairs(b) do
				local newdir = v[3]
				newdir = (newdir - dir + 4) % 4
				
				local vunit = mmf.newObject(v[4])
				vunit.values[XPOS] = nx
				vunit.values[YPOS] = ny
				vunit.values[DIR] = newdir
				
				if (vunit.values[TILING] == 0) or (vunit.values[TILING] == 2) or (vunit.values[TILING] == 3) then
					vunit.direction = newdir * 8
				end
				table.insert(updatedrect[ntileid], {v[1], v[2], newdir, v[4]})
			end
		end
	end
	
	selectionrect = {}
	selectionrect.x = x_
	selectionrect.y = y_
	selectionrect.w = nw
	selectionrect.h = nh
	
	editor4.values[SELECTIONWIDTH] = nw
	editor4.values[SELECTIONHEIGHT] = nh
	
	for a,b in pairs(updatedrect) do
		if (selectionrect[a] == nil) then
			selectionrect[a] = {}
		end
		
		for i,v in ipairs(b) do
			table.insert(selectionrect[a], {v[1], v[2], v[3], v[4]})
		end
	end
end

function editor_flipselection(dir)
	local updatedrect = {}
	local x_ = selectionrect.x
	local y_ = selectionrect.y
	local w = selectionrect.w
	local h = selectionrect.h
	
	for tileid,b in pairs(selectionrect) do
		if (tonumber(tileid) ~= nil) then
			local x = tileid % selection_vwidth
			local y = math.floor(tileid / selection_vwidth)
			
			local nx,ny = x,y
			
			if (dir == 1) then
				nx = (w - 1) - x
				ny = y
			elseif (dir == 2) then
				nx = x
				ny = (h - 1) - y
			end
			
			local ntileid = nx + ny * selection_vwidth
			
			if (updatedrect[ntileid] == nil) then
				updatedrect[ntileid] = {}
			end
			
			for i,v in ipairs(b) do
				local newdir = v[3]
				
				if (dir == 1) and ((newdir == 0) or (newdir == 2)) then
					newdir = rotate(newdir)
				elseif (dir == 2) and ((newdir == 1) or (newdir == 3)) then
					newdir = rotate(newdir)
				end
				
				local vunit = mmf.newObject(v[4])
				vunit.values[XPOS] = nx
				vunit.values[YPOS] = ny
				vunit.values[DIR] = newdir
				if (vunit.values[TILING] == 0) or (vunit.values[TILING] == 2) or (vunit.values[TILING] == 3) then
					vunit.direction = newdir * 8
				end
				table.insert(updatedrect[ntileid], {v[1], v[2], newdir, v[4]})
			end
		end
	end
	
	selectionrect = {}
	selectionrect.x = x_
	selectionrect.y = y_
	selectionrect.w = w
	selectionrect.h = h
	
	editor4.values[SELECTIONWIDTH] = w
	editor4.values[SELECTIONHEIGHT] = h
	
	for a,b in pairs(updatedrect) do
		if (selectionrect[a] == nil) then
			selectionrect[a] = {}
		end
		
		for i,v in ipairs(b) do
			table.insert(selectionrect[a], {v[1], v[2], v[3], v[4]})
		end
	end
end

function editor_selectionrect_place(x_,y_,ignore_empty_)
	local x,y = selectionrect.x,selectionrect.y
	local w,h = selectionrect.w,selectionrect.h
	
	local ignore_empty = ignore_empty_ or false
	
	for i=1,w do
		for j=1,h do
			local i_ = i - 1
			local j_ = j - 1
			local tileid = (i_) + (j_) * roomsizex
			
			local fx = x_ + i_ - (w - 1)
			local fy = y_ + j_ - (h - 1)
			
			if inbounds(fx,fy,1) then
				local fid = fx + fy * roomsizex
				local target = 0
				
				if (unitmap[fid] ~= nil) and (#unitmap[fid] > 0) then
					for a,b in ipairs(unitmap[fid]) do
						local bunit = mmf.newObject(b)
						
						if (bunit.values[LAYER] == editor.values[LAYER]) then
							target = b
						end
					end
				end
				
				local stileid = (i_) + (j_) * selection_vwidth
				
				if (selectionrect[stileid] ~= nil) and (#selectionrect[stileid] > 0) then
					local data = selectionrect[stileid][1]
					
						
					if (target ~= 0) then
						changetile(data[1],fx,fy,editor.values[LAYER],data[3],target)
					else
						placetile(data[1],fx,fy,editor.values[LAYER],data[3])
					end
				else
					if (target ~= 0) and (ignore_empty == false) then
						removetile(target,fx,fy)
					end
				end
			end
		end
	end
	
	updateundo_editor()
end

function editor_trynamechange(object,newname_,fixed,objlistid,oldname_)
	local valid = true
	
	local newname = newname_ or "error"
	local oldname = oldname_ or "error"
	local checking = true
	
	newname = string.gsub(newname, "_", "UNDERDASH")
	newname = string.gsub(newname, "%W", "")
	newname = string.gsub(newname, "UNDERDASH", "_")
	
	while (string.find(newname, "text_text_") ~= nil) do
		newname = string.gsub(newname, "text_text_", "text_")
	end
	
	while checking do
		checking = false
		
		for a,obj in pairs(editor_currobjlist) do
			if (obj.name == newname) then
				checking = true
				
				if (tonumber(string.sub(obj.name, -1)) ~= nil) then
					local num = tonumber(string.sub(obj.name, -1)) + 1
					
					newname = string.sub(newname, 1, string.len(newname)-1) .. tostring(num)
				else
					newname = newname .. "2"
				end
			end
		end
	end
	
	if (#newname == 0) or (newname == "level") or (newname == "text_crash") or (newname == "text_error") or (newname == "crash") or (newname == "error") or (newname == "text_never") or (newname == "never") or (newname == "text_") then
		valid = false
	end
	
	if (string.find(newname, "#") ~= nil) then
		valid = false
	end
	
	if valid then
		local paircount = 0
		for i,v in ipairs(editor_currobjlist) do
			if (string.sub(newname, 1, 5) ~= "text_") and (v.name == "text_" .. newname) then
				paircount = paircount + 1
			elseif (string.sub(newname, 1, 5) == "text_") and (v.name == string.sub(newname, 6)) then
				paircount = paircount + 1
			end
		end
		
		if (paircount > 0) then
			valid = false
		end
	end
	
	MF_alert("Trying to change name: " .. object .. ", " .. newname .. ", " .. tostring(valid))
	
	if valid then
		savechange(object,{newname},fixed)
		MF_updateobjlistname_hack(objlistid,newname)
		
		for i,v in ipairs(editor_currobjlist) do
			if (v.object == object) then
				v.name = newname
			end
			
			if (v.name == "text_" .. oldname) then
				v.name = "text_" .. newname
				local vid = MF_create(v.object)
				savechange(v.object,{v.name},vid)
				MF_cleanremove(vid)
				
				MF_alert("Found text_" .. oldname .. ", changing to text_" .. newname)
				
				MF_updateobjlistname_byname("text_" .. oldname,"text_" .. newname)
			elseif (string.sub(oldname, 1, 5) == "text_") and (v.name == string.sub(oldname, 6)) and (string.sub(newname, 1, 5) == "text_") then
				v.name = string.sub(newname, 6)
				local vid = MF_create(v.object)
				savechange(v.object,{v.name},vid)
				MF_cleanremove(vid)
				
				MF_alert("Found " .. oldname .. ", changing to " .. newname)
				
				MF_updateobjlistname_byname(string.sub(oldname, 6),string.sub(newname, 6))
			end
		end
	end
	
	return valid
end

function storelevelcode(level,code)
	local ldfile = ""
	
	if (level ~= "_TEMP_") then
		ldfile = "Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. level .. ".ld"
	else
		ldfile = "Data/Temp/temp.ld"
	end
	
	MF_setfile("level",ldfile)
	
	MF_store("level","general","levelcode",code)
end

function editor_testforsearch(text,num)
	if (num ~= 8) and (string.len(text) == 1) then
		local result = string.find(text, "[A-Z0-9]")
		
		if (result ~= nil) then
			if (editor.strings[MENU] == "objlist") or (editor.strings[MENU] == "level") or (editor.strings[MENU] == "spriteselect") then
				editor2.strings[SEARCHSTRING] = editor2.strings[SEARCHSTRING] .. string.lower(text)
			elseif (editor.strings[MENU] == "currobjlist") then
				editor4.strings[SEARCHSTRING_CURROBJLIST] = editor4.strings[SEARCHSTRING_CURROBJLIST] .. string.lower(text)
			end
			return 1
		end
	elseif (num == 8) then
		if ((editor.strings[MENU] == "objlist") or (editor.strings[MENU] == "level") or (editor.strings[MENU] == "spriteselect")) and (string.len(editor2.strings[SEARCHSTRING]) > 0) then
			editor2.strings[SEARCHSTRING] = string.sub(editor2.strings[SEARCHSTRING], 1, string.len(editor2.strings[SEARCHSTRING]) - 1)
			return 1
		elseif (editor.strings[MENU] == "currobjlist") and (string.len(editor4.strings[SEARCHSTRING_CURROBJLIST]) > 0) then
			editor4.strings[SEARCHSTRING_CURROBJLIST] = string.sub(editor4.strings[SEARCHSTRING_CURROBJLIST], 1, string.len(editor4.strings[SEARCHSTRING_CURROBJLIST]) - 1)
			return 1
		end
	end
	
	return 0
end

function editor_massdir()
	local layer = editor.values[LAYER]
	
	for x=1,roomsizex-2 do
		for y=1,roomsizey-2 do
			local tileid = x + y * roomsizex
			
			if (unitmap[tileid] ~= nil) and (#unitmap[tileid] > 0) then
				MF_massdir(layer,x,y)
			end
		end
	end
end

function sanitizetext(text,context)
	local result = text
	
	local symbols = {
		short = {{"_","UNDERDASH"},{" ","SPACE"}},
		long = {{";","SEMI"},{":","COLON"},{",","COMMA"},{"?","QUESTION"},{"!","EXCLAMATION"},{"-","NORMALDASH"},{"_","UNDERDASH"},{" ","SPACE"}},
	}
	
	if (context == nil) or (context == 4) or (context == 5) or (context == 7) or (context == 11) or (context == 13) or (context == 14) or (context == 17) or (context == 18) then
		for i,v in ipairs(symbols.short) do
			result = string.gsub(result, v[1], v[2])
		end
		
		-- result = string.gsub(result, "%W", "")
		result = string.gsub(result, "%#", "")
		result = string.gsub(result, "@", "")
		result = string.gsub(result, "/", "")
		result = string.gsub(result, "\\", "")
		result = string.gsub(result, "%[", "")
		result = string.gsub(result, "%]", "")
		result = string.gsub(result, "%{", "")
		result = string.gsub(result, "%}", "")
		
		for i,v in ipairs(symbols.short) do
			result = string.gsub(result, v[2], v[1])
		end
	elseif (context == 1) or (context == 2) or (context == 3) or (context == 15) then
		for i,v in ipairs(symbols.long) do
			result = string.gsub(result, v[1], v[2])
		end
		
		-- result = string.gsub(result, "%W", "")
		result = string.gsub(result, "%#", "")
		result = string.gsub(result, "@", "")
		result = string.gsub(result, "/", "")
		result = string.gsub(result, "\\", "")
		result = string.gsub(result, "%[", "")
		result = string.gsub(result, "%]", "")
		result = string.gsub(result, "%{", "")
		result = string.gsub(result, "%}", "")
		
		for i,v in ipairs(symbols.long) do
			result = string.gsub(result, v[2], v[1])
		end
	end
	
	if (#result == 0) and ((context == 1) or (context == 2) or (context == 3)) then
		result = "EMPTY"
	end
	
	if (context == 12) and (#result == 8) and (string.find(result, "-") == nil) then
		result = string.sub(result, 1, 4) .. "-" .. string.sub(result, 5)
	end
	
	return result
end