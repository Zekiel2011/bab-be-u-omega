function dynamictile(unitid,x,y,name,extra_)
	local ox,oy = 0,0
	local result = 0
	local exclude = 0
	local layer = map[0]
	
	local extra = {name,"edge","level"}
	
	if (extra_ ~= nil) then
		for a,b in ipairs(extra_) do
			table.insert(extra, b)
		end
	end
	
	local i_ = 4
	local sdirs = {}
	local sresult = false
	local sresult2 = false
	if (unitreference[name] ~= nil) and (specialtiling[unitreference[name]] ~= nil) and specialtiling[unitreference[name]] then
		i_ = 8
	end
	
	for i=1,i_ do
		local v = dirs_diagonals_[i]
		ox = v[1]
		oy = v[2]
		
		sdirs[i] = 0
		
		local tileid = (x+ox) + (y+oy) * roomsizex
		local uth = unittypeshere[tileid]
		local maptile = 255
		local found = false
		
		if (uth ~= nil) and inbounds(x+ox,y+oy) then
			for c,d in ipairs(extra) do
				if (uth[d] ~= nil) then
					if (d ~= "level") or (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
						found = true
						break
					else
						if (unitid < 0) or (unitid > 2) then
							local unit = mmf.newObject(unitid)
							
							if (unit.values[COMPLETED] > 0) then
								found = true
								break
							end
						end
						
						if (unitmap[tileid] ~= nil) then
							local umh = unitmap[tileid]
							
							for e,f in ipairs(umh) do
								local funit = mmf.newObject(f)
								
								if (funit.strings[UNITNAME] == "level") and (funit.visible and (funit.values[COMPLETED] > 0)) then
									found = true
									break
								end
							end
						end
					end
				end
			end
		end
		
		if (x+ox == 0) or (y+oy == 0) or (x+ox == roomsizex-1) or (y+oy == roomsizey-1) then
			maptile = 1
		end
		
		if found or (maptile ~= 255) then
			sdirs[i] = 1
			
			--MF_alert(tostring(i))
			
			if (i < 5) then
				result = result + 2 ^ (i - 1)
			else
				sresult = true
			end
		end
	end
	
	if sresult then
		result = handlespecialtiling(sdirs,result)
		
		if (result > 31) then
			sresult2 = true
			result = result % 32
		end
	end
	
	return result,sresult2
end

function dynamictiling()
	for i,unitid in ipairs(tiledunits) do
		local unit = mmf.newObject(unitid)
		
		if (unit.values[TILING] == 1) then
			unit.direction,unit.flags[SPECIALTILING] = dynamictile(unitid,unit.values[XPOS],unit.values[YPOS],unit.strings[UNITNAME])
			unit.values[VISUALDIR] = unit.direction
		end
	end
end

function dynamic(id,extra_)
	local unit = mmf.newObject(id)
	
	if (unit.values[TILING] == 1) then
		local x,y = unit.values[XPOS],unit.values[YPOS]
		local ox,oy = 0,0
		local name = unit.strings[UNITNAME]
		
		local extra = {name,"edge","level"}
	
		if (extra_ ~= nil) then
			for a,b in ipairs(extra_) do
				table.insert(extra, b)
			end
		end
		
		unit.direction,unit.flags[SPECIALTILING] = dynamictile(unit.fixed,x,y,name,extra)
		unit.values[VISUALDIR] = unit.direction
		
		local i_ = 4
		if (specialtiling.exists ~= nil) then
			i_ = 8
		end
		
		for i=1,i_ do
			local v = dirs_diagonals_[i]
			ox = v[1]
			oy = v[2]
			
			local tileid = (x+ox) + (y+oy) * roomsizex
			local tiledata = unitmap[tileid]
			
			if (tiledata ~= nil) and inbounds(x+ox,y+oy) then
				for a,b in ipairs(tiledata) do
					local tile = mmf.newObject(b)
					
					if (tile.strings[UNITNAME] == name) and (tile.values[TILING] == 1) then
						tile.direction,tile.flags[SPECIALTILING] = dynamictile(b,x+ox,y+oy,name,extra_)
						tile.values[VISUALDIR] = tile.direction
					end
				end
			end
		end
	end
end

function dynamicat(x,y)
	local ox,oy = 0,0
	
	--MF_alert("Dynamicat at " .. tostring(x) .. ", " .. tostring(y))
	local i_ = 4
	if (specialtiling.exists ~= nil) then
		i_ = 8
	end
	
	for i=1,i_ do
		local v = dirs_diagonals_[i]
		ox = v[1]
		oy = v[2]
		
		if inbounds(x+ox,y+oy) then
			local tiles = findallhere(x+ox,y+oy)
			
			if (#tiles > 0) then
				for a,b in ipairs(tiles) do
					local tile = mmf.newObject(b)

					if (tile.values[TILING] == 1) then
						tile.direction,tile.flags[SPECIALTILING] = dynamictile(b,x+ox,y+oy,tile.strings[UNITNAME])
						tile.values[VISUALDIR] = tile.direction
					end
				end
			end
		end
	end
end

function setspecialtiling(name,status)
	specialtiling[name] = status
	specialtiling.exists = true
end

function handlespecialtiling(sdirs,result_)
	local dat = tostring(sdirs[1]) .. tostring(sdirs[2]) .. tostring(sdirs[3]) .. tostring(sdirs[4])
	local dat2 = tostring(sdirs[5]) .. tostring(sdirs[6]) .. tostring(sdirs[7]) .. tostring(sdirs[8])
	local result = result_
	
	local opts = {
	["1100"] = {
			["1xxx"] = 1,
		},
	["0110"] = {
			["x1xx"] = 5,
		},
	["0011"] = {
			["xx1x"] = 11,
		},
	["1001"] = {
			["xxx1"] = 19,
		},
	["1110"] = {
			["10xx"] = 2,
			["01xx"] = 6,
			["11xx"] = 9,
		},
	["0111"] = {
			["x10x"] = 7,
			["x01x"] = 13,
			["x11x"] = 16,
		},
	["1011"] = {
			["xx10"] = 12,
			["xx01"] = 21,
			["xx11"] = 27,
		},
	["1101"] = {
			["1xx0"] = 3,
			["0xx1"] = 20,
			["1xx1"] = 23,
		},
	["1111"] = {
			["1000"] = 4,
			["0100"] = 8,
			["0010"] = 14,
			["0001"] = 22,
			["1100"] = 10,
			["0110"] = 17,
			["0011"] = 28,
			["1001"] = 24,
			["1010"] = 15,
			["0101"] = 25,
			["1110"] = 18,
			["0111"] = 30,
			["1011"] = 29,
			["1101"] = 26,
			["1111"] = 31,
		},
	}
	
	if (opts[dat] ~= nil) then
		for i,v in pairs(opts[dat]) do
			local found = true
			
			if found and (string.sub(i, 1, 1) ~= "x") and (string.sub(i, 1, 1) ~= string.sub(dat2, 1, 1)) then
				found = false
			end
			
			if found and (string.sub(i, 2, 2) ~= "x") and (string.sub(i, 2, 2) ~= string.sub(dat2, 2, 2)) then
				found = false
			end
			
			if found and (string.sub(i, 3, 3) ~= "x") and (string.sub(i, 3, 3) ~= string.sub(dat2, 3, 3)) then
				found = false
			end
			
			if found and (string.sub(i, 4, 4) ~= "x") and (string.sub(i, 4, 4) ~= string.sub(dat2, 4, 4)) then
				found = false
			end
			
			if found then
				result = 15 + v
				break
			end
		end
	end
	
	return result
end