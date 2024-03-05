function savechange(target,params,updateid_)
	local updateid = updateid_ or 0
	
	if (changes[target] == nil) then
		changes[target] = {}
	end
	
	local this = changes[target]
	
	local default = tileslist[target]
	
	if (target == "Editor_levelnum") then
		local icon = params[1]
		local file = params[2]
		local root = params[3]
		
		if (file ~= nil) then
			this[icon] = {}
			local thisdat = this[icon]
			thisdat.file = file
			thisdat.root = root
		else
			this[icon] = nil
		end
	else
		local name = params[1]
		local image = params[2]
		local colour = params[3]
		local tiling = params[4]
		local otype = params[5]
		local unittype = params[6]
		local activecolour = params[7]
		local root = params[8]
		local layer = params[9]
		local argtype = params[10]
		local argextra = params[11]
		local cobjects = params[12]
		
		if (name ~= nil) then
			if (string.len(name) > 0) then
				this.name = name
				
				-- MF_alert(target .. "'s name to " .. tostring(name) .. ", " .. default.name)
				
				if (name == default.name) then
					this.name = nil
					
					if (unitreference[name] == nil) then
						unitreference[name] = target
					end
				else
					if (unitreference[this.name] == nil) then
						unitreference[this.name] = target
					elseif (unitreference[default.name] ~= nil) and (unitreference[default.name] == target) then
						local olduid = unitreference[this.name] or "nil"
						local uid = unitreference[default.name]
						
						unitreference[this.name] = uid
						unitreference[default.name] = nil
						
						-- MF_alert(target .. " -- " .. this.name .. ": " .. olduid .. "/" .. uid .. ", " .. default.name .. ": " .. uid .. "/nil")
					elseif (unitreference[this.name] ~= nil) and (unitreference[this.name] ~= target) then
						-- MF_alert("UR for " .. this.name .. " is already used by " .. target .. "!")
					end
				end
			end
		end
		
		if (image ~= nil) then
			if (string.len(image) > 0) then
				this.image = image
				
				if (image == default.sprite) then
					this.image = nil
				end
			end
		end
		
		if (colour ~= nil) then
			if (string.len(colour) > 0) then
				this.colour = colour
				
				local dvalue = default.colour
				
				--MF_alert(tostring(target) .. "; " .. tostring(dvalue))
				
				local compare = tostring(dvalue[1]) .. "," .. tostring(dvalue[2])
				
				if (colour == compare) then
					this.colour = nil
					
					if (objectcolours[target] ~= nil) and (objectcolours[target]["colour"] ~= nil) then
						objectcolours[target]["colour"] = nil
					end
				end
			end
		end
		
		if (activecolour ~= nil) then
			if (string.len(activecolour) > 0) then
				this.activecolour = activecolour
				
				local dvalue = default.active
				local compare = ""
				
				if (dvalue ~= nil) then
					compare = tostring(dvalue[1]) .. "," .. tostring(dvalue[2])
				
					if (activecolour == compare) then
						this.activecolour = nil
						
						if (objectcolours[target] ~= nil) and (objectcolours[target]["active"] ~= nil) then
							objectcolours[target]["active"] = nil
						end
					end
				end
			end
		end
		
		if (tiling ~= nil) then
			if (string.len(tiling) > 0) then
				this.tiling = tonumber(tiling)
				
				if (tiling == default.tiling) then
					this.tiling = nil
				end
			end
		end
		
		if (otype ~= nil) then
			if (string.len(otype) > 0) then
				this.type = tonumber(otype)
				
				if (otype == default.type) then
					this.type = nil
				end
			end
		end
		
		if (unittype ~= nil) then
			if (string.len(unittype) > 0) then
				this.unittype = unittype
				
				if (unittype == default.unittype) then
					this.unittype = nil
				end
			end
		end
		
		if (root ~= nil) then
			this.root = root
			
			if (root == default.sprite_in_root) then
				this.root = nil
			end
		end
		
		if (layer ~= nil) then
			if (string.len(layer) > 0) then
				this.layer = tonumber(layer)
				
				if (layer == default.layer) then
					this.layer = nil
				end
			end
		end
		
		if (argtype ~= nil) then
			if (string.len(argtype) > 0) then
				local parser = ""
				local argtype_ = {}
				for i=1,string.len(argtype) do
					local l = string.sub(argtype, i, i)
					
					if (l ~= ",") then
						parser = parser .. l
					else
						table.insert(argtype_, tonumber(parser))
						parser = ""
					end
					
					if (i == string.len(argtype)) then
						table.insert(argtype_, tonumber(parser))
						parser = ""
					end
				end
				
				this.argtype = argtype_
				
				local isdefault = true
				local defaultargtype = default.argtype or {0}
				
				if (#argtype_ ~= #defaultargtype) then
					isdefault = false
				else
					for i,v in ipairs(argtype_) do
						local compare = defaultargtype[i] or -1
						
						if (compare ~= v) then
							isdefault = false
						end
					end
				end
				
				if isdefault then
					this.argtype = nil
				end
			end
		end
		
		if (argextra ~= nil) then
			if (string.len(argextra) > 0) then
				local parser = ""
				local argextra_ = {}
				for i=1,string.len(argextra) do
					local l = string.sub(argextra, i, i)
					
					if (l ~= ",") then
						parser = parser .. l
					else
						table.insert(argextra_, parser)
						parser = ""
					end
					
					if (i == string.len(argextra)) then
						table.insert(argextra_, parser)
						parser = ""
					end
				end
				
				this.argextra = argextra_
				
				local isdefault = true
				local defaultargextra = default.argextra or {}
				
				if (#argextra_ ~= #defaultargextra) then
					isdefault = false
				else
					for i,v in ipairs(argextra_) do
						local compare = defaultargextra[i] or ""
						
						if (compare ~= v) then
							isdefault = false
						end
					end
				end
				
				if isdefault then
					this.argextra = nil
				end
			end
		end
		
		if (cobjects ~= nil) then
			if (string.len(cobjects) > 0) then
				local parser = ""
				local cobjects_ = {}
				for i=1,string.len(cobjects) do
					local l = string.sub(cobjects, i, i)
					
					if (l ~= ",") then
						parser = parser .. l
					else
						table.insert(cobjects_, parser)
						parser = ""
					end
					
					if (i == string.len(cobjects)) then
						table.insert(cobjects_, parser)
						parser = ""
					end
				end
				
				this.customobjects = cobjects_
				
				local isdefault = true
				local defaultcobjects = default.customobjects or {}
				
				if (#cobjects_ ~= #defaultcobjects) then
					isdefault = false
				else
					for i,v in ipairs(cobjects_) do
						local compare = defaultcobjects[i] or ""
						
						if (compare ~= v) then
							isdefault = false
						end
					end
				end
				
				if isdefault then
					this.customobjects = nil
					
					if (default.customobjects ~= nil) then
						customobjects[target] = {}
						
						for i,v in ipairs(default.customobjects) do
							table.insert(customobjects[target], v)
						end
					else
						customobjects[target] = nil
					end
				else
					customobjects[target] = {}
					
					for i,v in ipairs(cobjects_) do
						table.insert(customobjects[target], v)
					end
				end
			end
		end
		
		local otype = this.type or default.type
		
		if (otype == 3) or (otype == 7) then
			conditions[target] = {}
			
			local conddata = conditions[target]
			conddata.arguments = false
			
			if (otype == 7) then
				conddata.arguments = true
				conddata.argtype = {}
				
				local argtype = this.argtype or default.argtype or {0}
				for i,v in ipairs(argtype) do
					table.insert(conddata.argtype, v)
				end
				
				local argextra = this.argextra or default.argextra
				if (argextra ~= nil) then
					conddata.argextra = {}
					
					for i,v in ipairs(argextra) do
						table.insert(conddata.argextra, v)
					end
				end
			end
		elseif (conditions[target] ~= nil) then
			conditions[target] = nil
		end
	end
	
	if (updateid ~= 0) then
		dochanges(updateid)
	elseif (target ~= "Editor_levelnum") then
		MF_alert("updateid == 0, changes.lua line 124")
	end
end

function storechanges()
	local changedobjects = ""
	local changedobjects_short = ""
	local changedobjectlist = {}
	local changelimit = 600
	local icons = {}

	for target,this in pairs(changes) do
		if (target == "Editor_levelnum") then
			for i,icondata in pairs(this) do
				MF_store("level","icons",tostring(i) .. "file",icondata.file)
				MF_store("level","icons",tostring(i) .. "root",icondata.root)
				
				icons[i + 1] = 1
				
				--MF_alert("Saved icon " .. tostring(i) .. ", " .. tostring(icondata.file) .. ", " .. tostring(icondata.root))
			end
		else
			for i,thing in pairs(this) do
				local tostore = ""
			
				if (i ~= "argtype") and (i ~= "argextra") and (i ~= "customobjects") then
					tostore = thing
				else
					for a,b in ipairs(thing) do
						tostore = tostore .. b .. ","
					end
				end
				
				MF_store("level","tiles",target .. "_" .. i,tostore)
			end
			
			changedobjects = changedobjects .. target .. ","
			changedobjects_short = changedobjects_short .. string.sub(target, -3) .. ","
			
			if (#changedobjects >= changelimit) then
				table.insert(changedobjectlist, changedobjects)
				changedobjects = ""
			end
		end
	end
	
	if (#changedobjects > 0) then
		table.insert(changedobjectlist, changedobjects)
		changedobjects = ""
	end
	
	for i=1,generaldata2.values[ICONCOUNT] do
		if (icons[i] == nil) then
			MF_store("level","icons",tostring(i - 1) .. "file","")
			MF_store("level","icons",tostring(i - 1) .. "root","")
		end
	end
	
	MF_store("level","tiles","changed_count",tostring(#changedobjectlist))
	
	for i,v in ipairs(changedobjectlist) do
		local id = "changed"
		
		if (i > 1) then
			id = id .. tostring(i)
		end
		
		MF_store("level","tiles",id,v)
	end
	
	editor.strings[CHANGEDOBJECTS] = changedobjects_short
	
	MF_store("level","tiles","changed_short",changedobjects_short)
end

function restoredefaults()
	local namesetups = {}
	
	for target,this in pairs(changes) do
		if (target == "Editor_levelnum") then
			for i,icondata in pairs(this) do
				local thisid = MF_create(target)
				MF_defaultsprite(thisid,31,i,"icon")
				MF_cleanremove(thisid)
			end
		else
			local thisid = MF_create(target)
			
			local tiledata = tileslist[target]
			local root = false
			
			if (tiledata.sprite_in_root ~= nil) then
				root = tiledata.sprite_in_root
			end
			
			if (objectcolours[target] ~= nil) then
				objectcolours[target] = nil
			end
			
			if (this.name ~= nil) then
				if (unitreference[this.name] ~= nil) then
					local uid = unitreference[this.name]
					
					table.insert(namesetups, {tiledata.name, target})
					
					unitreference[tiledata.name] = target
					unitreference[this.name] = nil
				end
			end
			
			if (this.argtype ~= nil) or (this.argextra ~= nil) then
				local argtype_ = this.argtype
				local argtype = tiledata.argtype or {0}
				local argextra = tiledata.argextra or {}
				local otype = tiledata.type
				
				if (conditions[target] ~= nil) then
					conditions[target] = {}
					
					local conddata = conditions[target]
					conddata.arguments = false
					
					if (otype == 7) then
						conddata.arguments = true
						conddata.argtype = {}
						
						for i,v in ipairs(argtype) do
							table.insert(conddata.argtype, v)
						end
						
						if (tiledata.argextra ~= nil) then
							conddata.argextra = {}
							
							for i,v in ipairs(argextra) do
								table.insert(conddata.argextra, v)
							end
						end
					elseif (otype ~= 3) then
						conditions[target] = nil
					end
				end
			end
			
			if (this.customobjects ~= nil) then
				this.customobjects = nil
				
				if (tiledata.customobjects ~= nil) then
					customobjects[target] = {}
					
					for i,v in ipairs(tiledata.customobjects) do
						table.insert(customobjects[target], v)
					end
				else
					customobjects[target] = nil
				end
			end
			
			MF_restoredefaults(thisid,tiledata.sprite,root)
			MF_cleanremove(thisid)
		end
	end
	
	for i,v in ipairs(namesetups) do
		local name = v[1]
		local uid = v[2]
		
		--MF_alert("Setting " .. name .. " to " .. tostring(uid))
		unitreference[name] = uid
	end
	
	if (unitreference ~= nil) then
		for i,v in pairs(tileslist) do
			if (v.name ~= nil) then
				local name = v.name
				
				if (unitreference[name] == nil) then
					--MF_alert("unitreference for " .. name .. " is " .. tostring(i))
					unitreference[name] = i
				end
			end
		end
	end
	
	changes = {}
	
	collectgarbage()
end

function dospritechanges(name,force_)
	local force = force_ or false
	
	if (tileslist[name] ~= nil) then
		local thisid = MF_create(name)
		local tiledata = tileslist[name]

		if (changes[name] ~= nil) then
			local c = changes[name]
			
			local root = false
			if (tiledata.sprite_in_root ~= nil) then
				root = tiledata.sprite_in_root
			end
			
			local croot = root
			if (c.root ~= nil) then
				croot = c.root
			end
			
			local sprite = c.image or tiledata.sprite or "error"
			
			if (c.image ~= nil) or force then
				MF_restoredefaults(thisid,tiledata.sprite,root)
				
				if (force == false) then
					MF_changesprite(thisid,c.image,croot)
				else
					MF_changesprite(thisid,sprite,croot)
				end
			end
		end
		
		MF_cleanremove(thisid)
	else
		print("No object with name " .. name .. " (SPRITE)")
	end
end

function dochanges(unitid)
	local unit = mmf.newObject(unitid)
	
	local realname = unit.className
	local name = unit.strings[UNITNAME]
	local name_ = ""
	
	if (changes[realname] ~= nil) then
		local c = changes[realname]
		
		if (c.name ~= nil) then
			name = c.name
			unit.strings[UNITNAME] = c.name
			
			if (string.sub(c.name, 1, 5) == "text_") then
				name_ = string.sub(c.name, 6)
			else
				name_ = c.name
			end
			
			unit.strings[NAME] = name_
			
			unitreference[name] = realname
		end
		
		if (c.colour ~= nil) then
			local cutoff = 0
			
			for a=1,string.len(c.colour) do
				if (string.sub(c.colour, a, a) == ",") then
					cutoff = a
				end
			end
			
			if (cutoff > 0) then
				local c1 = string.sub(c.colour, 1, cutoff-1)
				local c2 = string.sub(c.colour, cutoff+1)
				
				--MF_alert("Adding objcolour for " .. realname .. ": colour, " .. tostring(c1) .. ", " .. tostring(c2))
				
				addobjectcolour(realname,"colour",c1,c2)
			else
				print("New object colour formatted wrong!")
			end
		end
		
		if (c.activecolour ~= nil) then
			local cutoff = 0
			for a=1,string.len(c.activecolour) do
				if (string.sub(c.activecolour, a, a) == ",") then
					cutoff = a
				end
			end
			
			if (cutoff > 0) then
				local c1 = string.sub(c.activecolour, 1, cutoff-1)
				local c2 = string.sub(c.activecolour, cutoff+1)
				
				--MF_alert("Adding objcolour for " .. realname .. ": active, " .. tostring(c1) .. ", " .. tostring(c2))
				
				addobjectcolour(realname,"active",c1,c2)
			else
				print("New object active colour formatted wrong!")
			end
		end
		
		if (c.tiling ~= nil) then
			unit.values[TILING] = tonumber(c.tiling)
		end
		
		if (c.type ~= nil) then
			unit.values[TYPE] = tonumber(c.type)
		end
		
		if (c.unittype ~= nil) then
			unit.strings[UNITTYPE] = c.unittype
		end
		
		if (c.layer ~= nil) then
			unit.values[ZLAYER] = tonumber(c.layer)
		end
	end
end

function dochanges_allinstances(unitname)
	for i,unit in ipairs(units) do
		if (unit.className == unitname) then
			dochanges(unit.fixed)
			updateunitcolour(unit.fixed,true)
		end
	end
end

function dochanges_full(name)
	if (tileslist[name] ~= nil) then
		local changedobjects_short = ""
		for i,v in pairs(changes) do
			changedobjects_short = changedobjects_short .. string.sub(i, -3) .. ","
		end
		
		dospritechanges(name)
		
		editor.strings[CHANGEDOBJECTS] = changedobjects_short
		
		for i,unit in ipairs(units) do
			if (unit.className == name) then
				dochanges(unit.fixed,name)
				dynamic(unit.fixed)
			end
		end
	else
		print("No object with name " .. tostring(name) .. " (FULL)")
	end
end

function resetchanges_objname(name)
	local unitid = MF_create(name)
	
	resetchanges(unitid)
	
	MF_cleanremove(unitid)
end

function resetchanges(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.className
	
	local tiledata = tileslist[name]
	local root = false
	
	if (tiledata.sprite_in_root ~= nil) then
		root = tiledata.sprite_in_root
	end
	
	if (changes[name] ~= nil) then
		local c = changes[name]
		
		if (c.name ~= nil) then
			local cname = c.name
			local rname = tiledata.name
			unitreference[cname] = nil
			unitreference[rname] = name
		end
		
		if (c.argtype ~= nil) or (c.argextra ~= nil) then
			local argtype_ = c.argtype
			local argtype = tiledata.argtype or {0}
			local argextra = tiledata.argextra or {}
			local otype = tiledata.type
			
			if (conditions[name] ~= nil) then
				conditions[name] = {}
				
				local conddata = conditions[name]
				conddata.arguments = false
				
				if (otype == 7) then
					conddata.arguments = true
					conddata.argtype = {}
					
					for i,v in ipairs(argtype) do
						table.insert(conddata.argtype, v)
					end
					
					if (tiledata.argextra ~= nil) then
						conddata.argextra = {}
						
						for i,v in ipairs(argextra) do
							table.insert(conddata.argextra, v)
						end
					end
				elseif (otype ~= 3) then
					conditions[name] = nil
				end
			end
		end
		
		if (c.customobjects ~= nil) then
			c.customobjects = nil
			
			if (tiledata.customobjects ~= nil) then
				customobjects[name] = {}
				
				for i,v in ipairs(tiledata.customobjects) do
					table.insert(customobjects[name], v)
				end
			else
				customobjects[name] = nil
			end
		end
		
		changes[name] = nil
	end
	
	if (objectcolours[name] ~= nil) then
		objectcolours[name] = nil
	end
	
	MF_restoredefaults(unitid,tiledata.sprite,root)
	
	getmetadata(unit)
	
	updateunitcolour(unitid,true)
	
	updatecolours(true)
end

function addchange(unitid)
	local unit = mmf.newObject(unitid)
	local name = unit.className
	
	local default = tileslist[name]
	
	local things = {"name","image","colour","tiling","type","unittype","activecolour","root","layer","argtype","argextra","customobjects"}
	local allchanges = {}
	
	for i,v in ipairs(things) do
		local result = ""
		
		local data = MF_read("level","tiles",name .. "_" .. v)
		
		if (string.len(data) > 0) then
			result = data
		end
		
		if (v == "root") then
			if (string.len(data) > 0) then
				if (data == "1") then
					result = true
				elseif (data == "0") then
					result = false
				else
					MF_alert("Root contains garbage data in addchange() for " .. default.name)
				end
			else
				result = default.sprite_in_root
			end
		end
		
		table.insert(allchanges, result)
	end
	
	savechange(name,allchanges,unitid)
end

function getactualdata(objectname,param_)
	local data = tileslist[objectname] or {}
	local result = nil
	
	local param = param_
	local diffs =
	{
		sprite = "image",
		sprite_in_root = "root",
		active = "activecolour",
	}
	
	if (data ~= nil) then
		result = data[param]
		
		if (param == "active") and (data[param] == nil) then
			result = data.colour
		end
		
		if (changes[objectname] ~= nil) then
			local c = changes[objectname]
			
			if (diffs[param] ~= nil) then
				param = diffs[param]
			end
			
			if (param == "activecolour") and (c[param] == nil) then
				param = "colour"
			end
			
			if (c[param] ~= nil) then
				if (param == "colour") or (param == "activecolour") then
					result = MF_parsestring(c[param])
				else
					result = c[param]
				end
			end
		end
	else
		MF_alert("No data found for object " .. tostring(objectname) .. " (parameter " .. tostring(param) .. ")")
	end
	
	return result
end

function getactualdata_objlist(objectname,param_)
	local tileslistdata = tileslist[objectname] or {}
	local changesdata = changes[objectname] or {}
	local objlistdata = {}
	
	for i,obj in ipairs(editor_currobjlist) do
		if (obj.object == objectname) then
			local objid = tonumber(obj.id) or obj.id
			objlistdata = editor_objlist[objid]
			
			if (objlistdata == nil) then
				MF_alert("Objlistdata is nil for " .. tostring(objid) .. ", " .. objectname)
				objlistdata = {}
			end
			break
		end
	end
	
	local result = nil
	local modded = false
	
	if (objlistdata == nil) then
		MF_alert("objlistdata is nil, " .. objectname)
	end
	
	local param = param_
	local changediffs =
	{
		sprite = "image",
		sprite_in_root = "root",
		active = "activecolour",
	}
	local changesparam = changediffs[param] or param
	
	local objlistdiffs =
	{
		active = "colour_active",
	}
	local objlistparam = objlistdiffs[param] or param
	
	local tileslistresult = tileslistdata[param]
	local changesresult = changesdata[changesparam]
	local objlistresult = objlistdata[objlistparam]
	
	--MF_alert("looking for " .. param .. ": " .. tostring(tileslistresult) .. ", " .. tostring(changesresult) .. ", " .. tostring(objlistresult))
	
	if (param == "sprite") and (objlistresult == nil) then
		objlistresult = objlistdata["name"] or nil
	end
	
	if ((param == "colour") or (param == "active")) and (changesresult ~= nil) then
		changesresult = MF_parsestring(changesresult)
	end
	
	if (changesresult == nil) then
		if (tileslistresult == nil) then
			result = objlistresult
		else
			result = tileslistresult
		end
	else
		result = changesresult
		
		if (param ~= "colour") and (param ~= "active") then
			local modtest = objlistresult
			
			if (objlistresult == nil) then
				if (tileslistresult ~= nil) then
					modtest = tileslistresult
				else
					modtest = nil
				end
			end
			
			if (modtest ~= nil) and (tostring(type(modtest)) == tostring(type(changesresult))) then
				if (tostring(type(modtest)) ~= "table") then
					if (changesresult ~= modtest) then
						modded = true
					end
				else
					local matching = true
					
					for i,v in ipairs(modtest) do
						if (changesresult[i] ~= v) then
							matching = false
						end
					end
					
					if (matching == false) then
						modded = true
					end
				end
			end
		end
	end
	
	--MF_alert(tostring(objlistdata.name) .. ", " .. objectname .. " " .. param .. ": " .. tostring(result) .. ", " .. tostring(modded))
	
	return result,modded
end

function editor_resetobject(unitid,tilename,objlistid_)
	local data = nil
	local objlistid = -1
	for i,v in pairs(editor_currobjlist) do
		if (v.object == tilename) then
			data = editor_objlist[v.id]
			objlistid = i
		end
	end
	
	if (data ~= nil) then
		resetchanges(unitid)
		
		local colourstring = "0,3"
		if (data.colour ~= nil) then
			local c = data.colour
			colourstring = tostring(c[1]) .. "," .. tostring(c[2])
		end
		
		local c1 = MF_parsestring(colourstring)
		
		local activecolourstring = "0,3"
		if (data.colour_active ~= nil) then
			local c = data.colour_active
			activecolourstring = tostring(c[1]) .. "," .. tostring(c[2])
		end
		
		local c2 = MF_parsestring(activecolourstring)
		
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
		
		local c_name = data.name
		local c_image = data.sprite or data.name
		local c_colour = colourstring
		local c_tiling = data.tiling or -1
		local c_type = data.type or 0
		local c_unittype = data.unittype or "object"
		local c_activecolour = activecolourstring
		local c_root = data.sprite_in_root or true
		local c_layer = data.layer or 10
		local c_argtype = argtypestring
		local c_argextra = argextrastring
		local c_customobjects = customobjectsstring
		
		local changelist = {c_name, c_image, c_colour, c_tiling, c_type, c_unittype, c_activecolour, c_root, c_layer, c_argtype, c_argextra, c_customobjects}
		savechange(tilename, changelist, unitid)
		dochanges_allinstances(tilename)
		dospritechanges(tilename)
		
		local c_ = c1
		
		if (c_unittype == "text") then
			c_ = c2
		end
		
		local objlistdata = editor_currobjlist[objlistid]
		objlistdata.name = c_name
		
		if (objlistid_ ~= nil) then
			MF_updateobjlistname_hack(objlistid_,c_name)
		end
		
		return c_[1],c_[2],c_image .. "_0_1",c_root,c_name
	else
		MF_alert("No data found for " .. tilename)
	end
end

function handleobjectchanges()
	local changelists = tonumber(MF_read("level","tiles","changed_count")) or 1
	
	changelists = math.max(changelists, 1)
	
	for i=1,changelists do
		local id = "changed"
		
		if (i > 1) then
			id = id .. tostring(i)
		end
		
		local changestring = MF_read("level","tiles",id)
		
		if (#changestring > 0) then
			for obj in string.gmatch(changestring, "%w+") do
				if (string.sub(obj, 1, 6) == "object") and (string.len(obj) == 9) and (tonumber(string.sub(obj, -3)) ~= nil) then
					dochanges_full(obj)
				end
			end
		end
	end
end