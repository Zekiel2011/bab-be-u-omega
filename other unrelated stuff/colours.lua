function setcolour(unitid,value_)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local dir = unit.values[DIR]
	local unitinfo = tileslist[name]
	
	local cc1,cc2 = -1,-1
	
	local value = value_ or "colour"
	
	if (name ~= "level") and (name ~= "path") then
		if (objectcolours[name] ~= nil) then
			local c = objectcolours[name]
			
			if (c[value] ~= nil) then
				local cc = c[value]
				cc1,cc2 = cc[1],cc[2]
			elseif (value == "colour") or (unitinfo == nil) or (unitinfo[value] == nil) then
				if (c.colour ~= nil) then
					local cc = c.colour
					cc1,cc2 = cc[1],cc[2]
				end
			end
		end
		
		if (cc1 == -1) or (cc2 == -1) then
			if (unitinfo ~= nil) and (unitinfo[value] ~= nil) then
				local cc = unitinfo[value]
				unit.colour = {cc[1],cc[2]}
				MF_setcolour(unitid,cc[1],cc[2])
				cc1 = cc[1]
				cc2 = cc[2]
			elseif (unitinfo ~= nil) and (unitinfo.colour ~= nil) then
				local cc = unitinfo.colour
				unit.colour = {cc[1],cc[2]}
				MF_setcolour(unitid,cc[1],cc[2])
				cc1 = cc[1]
				cc2 = cc[2]
			else
				cc1,cc2 = 0,3
				unit.colour = {0,3}
				MF_defaultcolour(unitid)
			end
		else
			unit.colour = {cc1,cc2}
			MF_setcolour(unitid,cc1,cc2)
		end
	end
	
	return cc1,cc2
end

function getcolour(unitid,value_)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local name_ = unit.strings[UNITNAME]
	local unitinfo = tileslist[name]
	
	local defaultcolour = colours.default
	
	local value = value_ or "colour"
	
	if (objectcolours[name] ~= nil) then
		local c = objectcolours[name]
		
		if (c[value] ~= nil) then
			local cc = c[value]
			return cc[1],cc[2]
		elseif (value == "colour") or (unitinfo == nil) or (unitinfo[value] == nil) then
			if (c.colour ~= nil) then
				local cc = c.colour
				return cc[1],cc[2]
			end
		end
	end
	
	if (unitinfo == nil) then
		return defaultcolour[1],defaultcolour[2]
	else
		if (unitinfo[value] == nil) then
			if (unitinfo.colour == nil) then
				return defaultcolour[1],defaultcolour[2]
			else
				local colour = unitinfo.colour
				return colour[1],colour[2]
			end
		else
			local colour = unitinfo[value]
			return colour[1],colour[2]
		end
	end

	return defaultcolour[1],defaultcolour[2]
end

function getuicolour(which,subwhich)
	local bcolour = {}
	
	if (subwhich == nil) or (subwhich == "") then
		bcolour = colours[which]
	else
		bcolour = colours[which][subwhich]
	end
	
	if (bcolour == nil) then
		bcolour = colours.default
	end
	
	return bcolour[1],bcolour[2]
end

function updatecolours(edit_)
	local edit = false
	
	if (edit_ ~= nil) then
		edit = edit_
	end
	
	MF_setbackcolour()
	
	for i,unit in ipairs(units) do
		if (unit.strings[UNITNAME] ~= "level") then
			if (unit.strings[UNITTYPE] ~= "text") then
				setcolour(unit.fixed)
			else
				if edit then
					setcolour(unit.fixed,"active")
				else
					setcolour(unit.fixed)
				end
			end
		else
			MF_updatelevelcolour(unit.fixed)
		end
	end
	
	updatecode = 1
	code()
end

function addobjectcolour(name,dir,c1,c2)
	if (objectcolours[name] == nil) then
		objectcolours[name] = {}
	end
	
	local oc = objectcolours[name]
	
	oc[dir] = {c1, c2}
end

function getobjectcolour(unitid,c)
	local unit = mmf.newObject(unitid)
	
	local name = unit.className
	local unitinfo = tileslist[name]
	
	local c1,c2 = -1,-1
	
	if (objectcolours[name] ~= nil) then
		local oc = objectcolours[name]
		
		if (oc[c] ~= nil) then
			c1 = oc[c][1]
			c2 = oc[c][2]
		end
	end
	
	if (c1 == -1) or (c2 == -1) then
		if (unitinfo[c] ~= nil) then
			c1 = unitinfo[c][1]
			c2 = unitinfo[c][2]
		end
	end
	
	return c1,c2
end

function updateunitcolour(unitid,edit_)
	local edit = false
	
	if (edit_ ~= nil) then
		edit = edit_
	end
	
	local unit = mmf.newObject(unitid)
	
	if (unit.strings[UNITNAME] ~= "level") then
		if (unit.strings[UNITTYPE] ~= "text") then
			setcolour(unit.fixed)
		else
			if edit then
				setcolour(unit.fixed,"active")
			else
				setcolour(unit.fixed)
			end
		end
	end
end

function updateallcolours()
	for i,unit in ipairs(units) do
		updateunitcolour(unit.fixed,true)
		
		local data = tileslist[unit.className]
		unit.values[ZLAYER] = data.layer
	end
end

function setthisuicolour(unitid,colourid,colourid2)
	local data = colours[colourid]
	
	if (colourid2 ~= nil) then
		data = colours[colourid][colourid2]
	end
	
	if (data == nil) then
		print("No colour at " .. tostring(colourid) .. ", " .. tostring(colourid2))
	end
	
	MF_setcolour(unitid,data[1],data[2])
end

function setbackcolour()
	MF_setbackcolour()
end