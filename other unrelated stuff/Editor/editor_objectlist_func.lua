function createbutton_objlist(func,x,y,menu,c1_,c2_,id_,style,disabled_)
	local buttonid = MF_create("Editor_objlistbutton")
	local button = mmf.newObject(buttonid)
	button.x = x
	button.y = y
	button.layer = 2
	button.values[ONLINE] = 1
	button.values[YORIGIN] = y
	button.strings[BUTTONFUNC] = func
	button.strings[BUTTONTEXT] = func
	button.animSet = style or 1
	button.flags[NOSCROLL] = true
	
	button.values[BUTTON_STOREDX] = x
	button.values[BUTTON_STOREDY] = y
	
	local disabled = disabled_ or false
	if disabled then
		button.values[BUTTON_DISABLED] = 1
	end
	
	local c = colours["editorui"]
	local c1 = c1_ or c[1]
	local c2 = c2_ or c[2]
	
	local colour = tostring(c1) .. "," .. tostring(c2)
	button.strings[UI_CUSTOMCOLOUR] = colour
	MF_setcolour(buttonid, c1, c2)
	
	button.values[XPOS] = x
	button.values[YPOS] = y
	
	local id = "EditorButton"
	
	if (id_ ~= nil) then
		id = id_
	end
	
	button.strings[BUTTONID] = id
	
	return buttonid
end

function editor_objects_build(search_,tags_)
	editor_objects = {}
	
	if (search_ ~= nil) then
		if (editor2.values[OBJLISTTYPE] == 1) then
			objlistdata.search_currobjlist = search_
			editor4.strings[SEARCHSTRING_CURROBJLIST] = search_
		else
			objlistdata.search = search_
			editor2.strings[SEARCHSTRING] = search_
		end
	end
	
	local database = editor_objlist
	
	if (editor2.values[OBJLISTTYPE] == 1) then
		database = editor_currobjlist
	end
	
	if (tags_ ~= nil) then
		if (editor2.values[OBJLISTTYPE] == 1) then
			objlistdata.tags_currobjlist = tags_
		else
			objlistdata.tags = tags_
		end
	end
	
	local tags = {}
	local search = objlistdata.search
	
	if (editor2.values[OBJLISTTYPE] == 1) then
		tags = objlistdata.tags_currobjlist
		search = objlistdata.search_currobjlist
	else
		tags = objlistdata.tags
	end
	
	if (#tags == 0) then
		editor4.strings[CURRENTTAGS] = ""
	end
	
	local objectreference = objlistdata.objectreference
	
	local j = 0
	for i,vv in pairs(database) do
		local v = vv
		local i_ = tonumber(i) or i
		j = j + 1
		
		if (editor2.values[OBJLISTTYPE] == 1) then
			local objid = tonumber(vv.id) or vv.id
			v = editor_objlist[objid]
			i_ = objid
		else
			local current = editor_objlist_order[j]
			local objlist_target = editor_objlist_reference[current]
			local objid = tonumber(objlist_target) or objlist_target
			i_ = objid
			v = editor_objlist[objid]
		end
		
		local n = v.name
		local t = v.tags
		local s = v.special or false
		local adv = v.advanced or false
		local redact = v.redacted or false
		
		if (redact == false) then
			if ((editor2.values[OBJLISTTYPE] == 1) or ((s == false) or (editor2.values[EXTENDEDMODE] == 1)) and ((adv == false) or (editor2.values[ADVANCEDWORDS] == 1))) then
				local valid = true
				
				if (string.len(search) > 0) then
					local n_ = n
					if (string.sub(n_, 1, 5) == "text_") then
						n_ = string.sub(n_, 6)
					end
					
					if (string.find(n_, search) == nil) then
						valid = false
					end
				end
				
				if valid then
					if (#tags > 0) then
						for a,b in ipairs(tags) do
							local found = false
							
							for c,d in ipairs(t) do
								if (d == b) then
									found = true
								end
							end
							
							if (found == false) then
								valid = false
								break
							end
						end
					end
					
					if valid then
						table.insert(editor_objects, {objlistid = i_, databaseid = i})
					end
				end
			end
		end
	end
end

function editor_defaultobjects()
	if (#editor_currobjlist == 0) and (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
		addobjtolist("text_is",0,1)
		addobjtolist("baba",1)
		addobjtolist("text_you",2)
		addobjtolist("flag",3)
		addobjtolist("text_win",4)
		addobjtolist("text_and",5)
		addobjtolist("text_stop",6)
		addobjtolist("text_push",7)
		addobjtolist("wall",8)
		
		if (editor2.values[EXTENDEDMODE] == 1) then
			--addobjtolist("line")
			--addobjtolist("cursor")
		end
	end
end

function editor_defaulthotbar()
	if objectinpalette("text_is") then
		MF_addquickbar(0,unitreference["text_is"],1)
	end
	
	if objectinpalette("baba") then
		MF_addquickbar(1,unitreference["baba"],0)
	end
	
	if objectinpalette("text_you") then
		MF_addquickbar(2,unitreference["text_you"],0)
	end
	
	if objectinpalette("flag") then
		MF_addquickbar(3,unitreference["flag"],0)
	end
	
	if objectinpalette("text_win") then
		MF_addquickbar(4,unitreference["text_win"],0)
	end
	
	if objectinpalette("text_and") then
		MF_addquickbar(5,unitreference["text_and"],0)
	end
	
	if objectinpalette("text_stop") then
		MF_addquickbar(6,unitreference["text_stop"],0)
	end
	
	if objectinpalette("text_push") then
		MF_addquickbar(7,unitreference["text_push"],0)
	end
	
	if objectinpalette("wall") then
		MF_addquickbar(8,unitreference["wall"],0)
	end
	
	if (editor2.values[EXTENDEDMODE] == 1) then
		if objectinpalette("line") then
			--MF_addquickbar(8,unitreference["line"],0)
		end
	end
end

function addobjtolist(name,quickbarslot_,fixed_)
	local id,object = 0,""
	local fixed = fixed_ or 0
	
	for i,v in pairs(editor_objlist) do
		if (v.name == name) then
			id,object = editor_currobjlist_add(i)
			break
		end
	end
	
	if (quickbarslot_ ~= nil) then
		--MF_alert("Added " .. name .. " to object " .. object)
		MF_addquickbar(quickbarslot_,object,fixed)
	end
	
	return id,object
end

function editor_currobjlist_add(objid_,build_,dopairs_,gridpos_,pairid_,pairedwith_)
	local valid = true
	local objid = tonumber(objid_) or objid_
	local build = true
	local dopairs = true
	local pairedwith = true
	local newtilename = ""
	
	local data = editor_objlist[objid]
	local newname = data.name or "error"
	
	if (build_ ~= nil) then
		build = build_
	end
	
	if (dopairs_ ~= nil) then
		dopairs = dopairs_
	end
	
	if (pairedwith_ ~= nil) then
		pairedwith = pairedwith_
	end
	
	local checking = true
	while checking and valid do
		checking = false
		
		for i,v in ipairs(editor_currobjlist) do
			if (v.id == objid) then
				newtilename = v.object
				valid = false
			end
			
			if (v.name == newname) then
				checking = true
				
				if (tonumber(string.sub(v.name, -1)) ~= nil) then
					local num = tonumber(string.sub(v.name, -1)) + 1
					
					newname = string.sub(newname, 1, string.len(newname)-1) .. tostring(num)
				else
					newname = newname .. "2"
				end
			end
		end
	end
	
	local newid = 0
	
	if valid then
		local id = #editor_currobjlist + 1
		newid = id
		editor_currobjlist[id] = {}
		
		local this = editor_currobjlist[id]
		this.id = objid
		this.name = newname
		
		if (pairid_ ~= nil) then
			this.pair = pairid_
		end
		
		local edata = objlistdata.objectreference
		local tdata = objlistdata.tilereference
		edata[objid] = 1
		
		local ogx,ogy = 0,0
		if (gridpos_ == nil) then
			local gx1,gy1 = findgridid(objid,1)
			local gx2,gy2 = findgridid(objid,0)
			
			ogx,ogy = gx1,gy1
			
			--MF_alert("Adding " .. this.name .. ", overlap: " .. tostring(gx1) .. ", " .. tostring(gy1) .. ", full: " .. tostring(gx2) .. ", " .. tostring(gy2) .. ", gridpos nil")
			
			this.grid_overlap = {gx1, gy1}
			this.grid_full = {gx2, gy2}
		else
			ogx,ogy = gridpos_[1],gridpos_[2]
			local gx2,gy2 = findgridid(objid,0)
			
			local gridreference = {}
			
			--MF_alert("Adding " .. this.name .. ", overlap: " .. tostring(ogx) .. ", " .. tostring(ogy) .. ", full: " .. tostring(gx2) .. ", " .. tostring(gy2) .. ", gridpos not nil")
			
			this.grid_overlap = {ogx, ogy}
			this.grid_full = {gx2, gy2}
			
			local gridreference = objlistdata.gridreference_overlap
			table.insert(gridreference[ogx][ogy], objid)
		end
		
		local tilename = ""
		local tileid = 0
		
		tilename = "object" .. string.sub("00" .. tostring(tileid), -3)
		
		while (tdata[tilename] ~= nil) do
			tileid = tileid + 1
			tilename = "object" .. string.sub("00" .. tostring(tileid), -3)
		end
		
		local alreadyexists = false
		this.object = tilename
		
		for i,v in pairs(tileslist) do
			if (v.name == newname) then
				local valid = true
				
				if (changes[i] ~= nil) then
					local cdata = changes[i]
					
					if (cdata.name ~= nil) and (cdata.name ~= newname) then
						valid = false
					end
				end
				
				if valid then
					alreadyexists = true
					this.object = i
					tilename = i
					local tilepos = v.tile
					this.tile = {tilepos[1], tilepos[2]}
				end
			end
		end
		
		tdata[tilename] = 1
		
		if (alreadyexists == false) then
			local d = tileslist[tilename]
			local tilepos = d.tile
			this.tile = {tilepos[1], tilepos[2]}
		end
		
		local unitid = MF_create(tilename)
		resetchanges(unitid)
		
		local colourstring = "0,3"
		if (data.colour ~= nil) then
			local c = data.colour
			colourstring = tostring(c[1]) .. "," .. tostring(c[2])
		end
		
		local activecolourstring = "0,3"
		if (data.colour_active ~= nil) then
			local c = data.colour_active
			activecolourstring = tostring(c[1]) .. "," .. tostring(c[2])
		end
		
		local argtypestring = "0"
		if (data.argtype ~= nil) then
			local c = data.argtype
			argtypestring = gettablestring(c)
		end
		
		local argextrastring = ""
		if (data.argextra ~= nil) then
			local c = data.argextra
			
			argextrastring = gettablestring(c)
		end
		
		local customobjectsstring = ""
		if (data.customobjects ~= nil) then
			local c = data.customobjects
			
			customobjectsstring = gettablestring(c)
		end
		
		local c_name = newname
		local c_image = data.sprite or data.name
		local c_colour = colourstring
		local c_tiling = data.tiling or -1
		local c_type = data.type or 0
		local c_unittype = data.unittype or "object"
		local c_activecolour = activecolourstring
		local c_root = true
		local c_layer = data.layer or 10
		local c_argtype = argtypestring
		local c_argextra = argextrastring
		local c_customobjects = customobjectsstring
		
		if (data.sprite_in_root ~= nil) then
			c_root = data.sprite_in_root
		end
		
		local changelist = {c_name, c_image, c_colour, c_tiling, c_type, c_unittype, c_activecolour, c_root, c_layer, c_argtype, c_argextra, c_customobjects}
		savechange(tilename, changelist, unitid)
		dochanges_allinstances(tilename)
		dospritechanges(tilename)
		
		MF_cleanremove(unitid)
		
		if dopairs then
			local pair_id = 0
			local so = data.paired or true
			if (data.unittype == "object") and (data.type == 0) and so then
				for i,v in pairs(editor_objlist) do
					if (v.name == "text_" .. data.name) and (v.type == 0) and (v.unittype == "text") then
						--MF_alert(this.name .. " adds " .. v.name)
						pair_id = editor_currobjlist_add(i,false,false,{ogx,ogy},id)
						this.pair = pair_id
					end
				end
			elseif (data.unittype == "text") and (data.type == 0) and so then
				local objpair = string.sub(data.name, 6)
				
				for i,v in pairs(editor_objlist) do
					if (v.name == objpair) and (v.type == 0) and (v.unittype == "object") then
						--MF_alert(this.name .. " adds " .. v.name)
						pair_id = editor_currobjlist_add(i,false,false,{ogx,ogy},id)
						this.pair = pair_id
					end
				end
			end
		end
		
		if (data.pairedwith ~= nil) and pairedwith then
			local alreadyadded = false
			
			for i,v in ipairs(editor_currobjlist) do
				if (v.name == data.pairedwith) then
					alreadyadded = true
				end
			end
			
			if (alreadyadded == false) then
				for i,v in pairs(editor_objlist) do
					if (v.name == data.pairedwith) and (v.type ~= 0) and (v.unittype == "text") then
						--MF_alert(this.name .. " adds " .. v.name)
						editor_currobjlist_add(i,false,nil,nil,nil,false)
					end
				end
			end
		end
		
		newtilename = tilename
	else
		MF_alert("ID already listed! " .. tostring(objid))
	end
	
	if build then
		editor_objects_build()
	end
	
	setundo_editor()
	--MF_alert(tostring(newid) .. ", " .. tostring(newtilename) .. ", " .. tostring(newname))
	
	return newid,newtilename,newname
end

function editor_currobjlist_remove(id_,name_,dopairs_)
	local dopairs = true
	
	if (dopairs_ ~= nil) then
		dopairs = dopairs_
	end
	
	local iddata = editor_objects[id_]
	local id = iddata.objlistid
	local oid = iddata.databaseid
	
	local obj = editor_currobjlist[oid]
	local name = obj.object
	
	MF_alert("Deleting " .. name .. ", " .. obj.name)
	
	resetchanges_objname(name)
	
	local edata = objlistdata.objectreference
	local tdata = objlistdata.tilereference
	
	edata[id] = nil
	tdata[name] = nil
	
	local gopos = obj.grid_overlap
	local gfpos = obj.grid_full
	
	gox,goy = gopos[1],gopos[2]
	gfx,gfy = gfpos[1],gfpos[2]
	
	local gridreference_overlap = objlistdata.gridreference_overlap
	local gridreference_full = objlistdata.gridreference_full
	
	if (gridreference_overlap[gox] ~= nil) and (gridreference_overlap[gox][goy] ~= nil) then
		for i,v in ipairs(gridreference_overlap[gox][goy]) do
			if (v == id) then
				table.remove(gridreference_overlap[gox][goy], i)
			end
		end
		
		if (#gridreference_overlap[gox][goy] == 0) then
			gridreference_overlap[gox][goy] = nil
		end
	else
		MF_alert("Didn't find grid_overlap data for pos " .. tostring(gox) .. ", " .. tostring(goy))
	end
	
	if (gridreference_full[gfx] ~= nil) and (gridreference_full[gfx][gfy] ~= nil) then
		for i,v in ipairs(gridreference_full[gfx][gfy]) do
			if (v == id) then
				table.remove(gridreference_full[gfx][gfy], i)
			end
		end
		
		if (#gridreference_full[gfx][gfy] == 0) then
			gridreference_full[gfx][gfy] = nil
		end
	else
		MF_alert("Didn't find grid_full data for pos " .. tostring(gfx) .. ", " .. tostring(gfy))
	end
	
	local pairid = 0
	
	if dopairs and (obj.pair ~= nil) then
		pairid = obj.pair
		local pairid_objects = 0
		
		local pairdata = editor_currobjlist[pairid] or {}
		local pairname = pairdata.name or nil
		
		for i,v in pairs(editor_objects) do
			if (v.databaseid == pairid) then
				pairid_objects = i
				break
			end
		end
		
		if (pairname ~= nil) and (pairid_objects > 0) then
			editor_currobjlist_remove(pairid_objects,pairname,false)
		else
			MF_alert(obj.name .. "'s pair wasn't found!")
		end
	end
	
	if (pairid == 0) or (dopairs == false) or (pairid > oid) then
		table.remove(editor_currobjlist, oid)
	else
		oid = oid - 1
		table.remove(editor_currobjlist, oid)
	end
	
	for i,v in ipairs(editor_currobjlist) do
		if (v.pair ~= nil) and (v.pair > oid) then
			v.pair = v.pair - 1
		end
	end
	
	setundo_editor()
	editor_removeeverytile(name)
	
	MF_removequickbar(name)
	
	return name
end

function editor_pickobj(id,name)
	local obj = editor_currobjlist[id]
	
	local object = "error"
	local tilex = 0
	local tiley = 0
	
	if (obj ~= nil) then
		object = obj.object
		local tilepos = obj.tile
		tilex = tilepos[1]
		tiley = tilepos[2]
	else
		MF_alert("No object with id " .. tostring(id))
	end
	
	return object,tilex,tiley
end

function findgridid(objid,listtype)
	local id = 0
	local increment = 0
	local x,y = 0,0
	
	result_x,result_y,result_id = 0,0,0
	
	local vertical = false
	local resolved = false
	
	while (resolved == false) do
		if vertical then
			if (y > increment) or (y > 9) then
				if (increment < 9) then
					increment = increment + 1
					x = 0
					y = increment
					vertical = false
					
					--MF_alert("y > " .. tostring(increment) .. " A (" .. tostring(x) .. ", " .. tostring(y) .. ")")
				else
					increment = increment + 1
					x = increment
					y = 0
					vertical = true
					
					--MF_alert("y > " .. tostring(increment) .. " B (" .. tostring(x) .. ", " .. tostring(y) .. ")")
				end
			end
		else
			if (x > increment) then
				x = increment + 1
				y = 0
				vertical = true
				
				--MF_alert("x > " .. tostring(increment) .. " (" .. tostring(x) .. ", " .. tostring(y) .. ")")
			end
		end
		
		--MF_alert(tostring(increment) .. " (" .. tostring(x) .. ", " .. tostring(y) .. ") " .. tostring(vertical))
		
		local gridreference = {}
		if (listtype == 1) then
			gridreference = objlistdata.gridreference_overlap
		elseif (listtype == 0) then
			gridreference = objlistdata.gridreference_full
		end
		
		if (gridreference[x] == nil) then
			gridreference[x] = {}
		end
		
		if (gridreference[x][y] == nil) then
			result_x = x
			result_y = y
			result_id = id
			
			--MF_alert(tostring(listtype) .. ", Currently at " .. tostring(x) .. ", " .. tostring(y) .. ": " .. tostring(gridreference[x][y]))
			
			gridreference[x][y] = {objid}
			
			resolved = true
		end
		
		id = id + 1
		
		if vertical then
			y = y + 1
		else
			x = x + 1
		end
	end
	
	return result_x,result_y,result_id
end

function changeobjectgridpos_tempid(id,name,newx,newy)
	local iddata = editor_objects[id]
	
	local olid = iddata.objlistid
	local dbid = iddata.databaseid
	
	changeobjectgridpos(dbid,newx,newy)
end

function changeobjectgridpos(id,newx,newy,recursed_)
	local recursed = recursed_ or false
	local iddata = editor_objects[id]
	
	local olid = iddata.objlistid
	local dbid = iddata.databaseid
	
	local odata = editor_currobjlist[dbid]
	
	--MF_alert(tostring(id) .. ", " .. name .. ": " .. tostring(odata["grid_overlap"][1]) .. ", " .. tostring(odata["grid_overlap"][2]) .. "; " .. tostring(newx) .. ", " .. tostring(newy))
	
	local oldx,oldy = 0,0
	
	if (editor2.values[DOPAIRS] == 1) then
		local gdata = odata.grid_overlap
		oldx = gdata[1]
		oldy = gdata[2]
	elseif (editor2.values[DOPAIRS] == 0) then
		local gdata = odata.grid_full
		oldx = gdata[1]
		oldy = gdata[2]
	end
	
	local gridreference = {}
	
	if (editor2.values[DOPAIRS] == 1) then
		gridreference = objlistdata.gridreference_overlap
	elseif (editor2.values[DOPAIRS] == 0) then
		gridreference = objlistdata.gridreference_full
	end
	
	local oldgridreference = gridreference[oldx][oldy]
	
	for i,v in ipairs(oldgridreference) do
		if (v == olid) then
			table.remove(gridreference[oldx][oldy], i)
			break
		end
	end
	
	if (#gridreference[oldx][oldy] == 0) then
		gridreference[oldx][oldy] = nil
	end
	
	if (odata.pair ~= nil) and (recursed == false) and (editor2.values[DOPAIRS] == 1) then
		changeobjectgridpos(odata.pair,newx,newy,true)
	end
	
	if (editor2.values[DOPAIRS] == 1) then
		odata.grid_overlap = {newx, newy}
	elseif (editor2.values[DOPAIRS] == 0) then
		odata.grid_full = {newx, newy}
	end
	
	if (gridreference[newx] == nil) then
		gridreference[newx] = {}
	end
	
	if (gridreference[newx][newy] == nil) then
		gridreference[newx][newy] = {}
	end
	
	table.insert(gridreference[newx][newy], olid)
end

function savecurrobjlist()
	--[[
	objlistdata.gridreference_overlap
	objlistdata.gridreference_full
	objlistdata.objectreference
	objlistdata.tilereference
	]]--
	
	local storage_entries = {"id", "name", "object", "gox", "goy", "gfx", "gfy", "pair", "tile"}
	
	local currobjlist_total = #editor_currobjlist
	MF_store("level","general","currobjlist_total",tostring(currobjlist_total))
	
	for i,obj in ipairs(editor_currobjlist) do
		local id = obj.id
		local listid = i
		local name = obj.name
		local object = obj.object
		local pairid = obj.pair or -1
		local tile = gettablestring(obj.tile)
		
		local go = obj.grid_overlap
		local gf = obj.grid_full
		
		local gox,goy = go[1],go[2]
		local gfx,gfy = gf[1],gf[2]
		
		local storage_values = {id, name, object, gox, goy, gfx, gfy, pairid, tile}
		
		for a,b in ipairs(storage_entries) do
			local ini_id = tostring(i) .. b
			local ini_value = storage_values[a]
			
			MF_store("level","currobjlist",ini_id,tostring(ini_value))
		end
	end
end

function loadcurrobjlist()
	clearobjlist()
	
	local currobjlist_total = tonumber(MF_read("level","general","currobjlist_total")) or 0
	
	--MF_alert(currobjlist_total)
	
	if (currobjlist_total == 0) then
		editor_defaultobjects()
	else
		local storage_entries = {"id", "name", "object", "gox", "goy", "gfx", "gfy", "pair", "tile"}
		
		for i=1,currobjlist_total do
			local entry_data = {}
			
			for a,b in ipairs(storage_entries) do
				local ini_id = tostring(i) .. b
				local ini_value = MF_read("level","currobjlist",ini_id)
				
				entry_data[b] = ini_value
			end
			
			local id = tonumber(entry_data.id) or entry_data.id
			local listid = i
			local name = entry_data.name
			local object = entry_data.object
			local pairid = tonumber(entry_data.pair) or -1
			local tile = MF_parsestring(entry_data.tile)
			
			local gox = tonumber(entry_data.gox)
			local goy = tonumber(entry_data.goy)
			
			local gfx = tonumber(entry_data.gfx)
			local gfy = tonumber(entry_data.gfy)
			
			editor_currobjlist[listid] = {}
			local obj = editor_currobjlist[listid]
			
			obj.id = id
			obj.name = name
			obj.object = object
			obj.tile = tile
			
			if (pairid ~= -1) then
				obj.pair = pairid
			end
			
			obj.grid_overlap = {}
			obj.grid_full = {}
			
			local go = obj.grid_overlap
			local gf = obj.grid_full
			
			go[1] = gox
			go[2] = goy
			
			gf[1] = gfx
			gf[2] = gfy
			
			local gridreference_overlap = objlistdata.gridreference_overlap
			local gridreference_full = objlistdata.gridreference_full
			local edata = objlistdata.objectreference
			local tdata = objlistdata.tilereference
			
			tdata[object] = 1
			edata[id] = 1
			
			if (gridreference_overlap[gox] == nil) then
				gridreference_overlap[gox] = {}
			end
			
			if (gridreference_overlap[gox][goy] == nil) then
				gridreference_overlap[gox][goy] = {}
			end
			
			if (gridreference_full[gfx] == nil) then
				gridreference_full[gfx] = {}
			end
			
			if (gridreference_full[gfx][gfy] == nil) then
				gridreference_full[gfx][gfy] = {}
			end
			
			table.insert(gridreference_overlap[gox][goy], id)
		end
	end
	
	if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
		local pathobj = ""
		
		for i,v in ipairs(editor_currobjlist) do
			if (i == 1) then
				pathobj = v.object
			end
			
			if (v.name == "line") then
				pathobj = v.object
				break
			end
		end
		
		editor.strings[PATHOBJECT] = pathobj
	else
		editor.strings[PATHOBJECT] = "object117"
	end
end

function clearcurrobjlist()
	for i,data in pairs(editor_currobjlist) do
		local realname = data.object
		resetchanges_objname(realname)
	end
	
	clearobjlist()
end

function HACK_updatethumbnailcolour(object,c1,c2)
	--MF_alert(object .. ", " .. tostring(c1) .. ", " .. tostring(c2))
	MF_thumbnail_updatecolour(object,c1,c2)
end

function HACK_updatethumbnailsprite(object,sprite,root)
	local path = "Sprites/"
	local world = generaldata.strings[WORLD]
	
	if (root == false) then
		path = "Worlds/" .. world .. "/Sprites/"
	end
	
	local spritefile = sprite .. ".png"
	
	MF_alert(object .. ", " .. path .. spritefile .. ", " .. tostring(root))
	
	MF_thumbnail_updatesprite(object,"Data/" .. path .. spritefile)
end

function editor_autoadd(text,noupdate_)
	local noupdate = noupdate_ or false
	
	for word_ in string.gmatch(text, "%S+") do
		local valid = false
		local word = string.lower(word_)
		
		if (string.sub(word, 1, 5) == "text_") then
			word = string.sub(word, 6)
		end
		
		for i,v in pairs(editor_objlist) do
			if ((v.name == word) or (v.name == "text_" .. word)) and ((v.redacted == nil) or (v.redacted == false)) then
				valid = true
				break
			end
		end
		
		if valid then
			for i,v in ipairs(editor_currobjlist) do
				if (v.name == word) or (v.name == "text_" .. word) then
					valid = false
					break
				end
			end
			
			if (#editor_currobjlist >= 150) then
				valid = false
				break
			end
			
			if valid then
				editor3.values[UNSAVED] = 1
				setundo_editor()
				addobjtolist(word)
			end
		end
	end
	
	if (noupdate == false) then
		changemenu("currobjlist")
	end
end

function editor_autopick(text)
	local result = ""
	local addthese = {}
	
	for word_ in string.gmatch(text, "%S+") do
		local word = string.lower(word_)
		local obj = ""
		
		if (string.sub(word, 1, 5) == "text_") then
			word = string.sub(word, 6)
		end
		
		for i,v in ipairs(editor_currobjlist) do
			if (v.name == "text_" .. word) then
				obj = v.object
				break
			end
		end
		
		if (string.len(obj) == 0) and (#editor_currobjlist < 150) then
			for i,v in pairs(editor_objlist) do
				if (v.name == "text_" .. word) and ((v.redacted == nil) or (v.redacted == false)) then
					local id_,obj_ = addobjtolist(v.name)
					editor3.values[UNSAVED] = 1
					setundo_editor()
					obj = obj_ or ""
					break
				end
			end
		end
		
		result = result .. obj .. ","
		table.insert(addthese, obj)
	end
	
	editor_resetselectionrect()
	local database = {}
	
	for i,v in ipairs(addthese) do
		if (string.len(v) > 0) then
			local unitid = placetile(v,i - 1,0,0,editor.values[EDITORDIR],nil,nil,nil,nil,true)
			local unit = mmf.newObject(unitid)
			unit.values[ONLINE] = 2
			table.insert(database, unit)
		end
	end
	
	if (#database > 0) and (#addthese > 0) then
		editor_setselectionrect(0,0,#addthese,1,database,false)
		editor4.values[SELECTIONX] = #addthese - 1
		editor4.values[SELECTIONY] = 0
	end
	
	if (#addthese > 0) then
		editor4.values[SELECTIONWIDTH] = #addthese
		editor4.values[SELECTIONHEIGHT] = 1
		editor_placer.values[SELECTION_XOFFSET] = 0
		editor_placer.values[SELECTION_YOFFSET] = 0
		
		MF_loop("createselectionrect_x", #addthese)
	else
		editor4.values[SELECTION_ON] = 0
		editor4.values[SELECTIONWIDTH] = 0
		editor4.values[SELECTIONHEIGHT] = 0
		editor_placer.values[SELECTION_XOFFSET] = 0
		editor_placer.values[SELECTION_YOFFSET] = 0
	end
	
	return result,#addthese
end

function objectinpalette(name)
	for i,v in ipairs(editor_currobjlist) do
		if (v.name == name) then
			return true
		end
	end
	
	return false
end