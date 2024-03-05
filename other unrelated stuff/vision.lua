function visionmode(state,target_,noundo_,extradata_)
	local noundo = noundo_ or false
	local target = target_ or 0
	local extra = extradata_ or {}
	
	-- MF_alert("Visionmode changed: " .. tostring(state) .. "/" .. tostring(spritedata.values[VISION]))
	
	if (spritedata.values[VISION] == 0) and (state == 1) then
		visiontargets = {}
		
		if (target == 0) then
			local vistest,vt2 = findallfeature(nil,"is","3d",true)
			
			for i,v in ipairs(vistest) do
				table.insert(visiontargets, v)
			end
			
			target = visiontargets[1] or 0
		end
		
		if (target ~= 0) then
			funnywalls = {}
			
			if (target ~= 0.5) then
				local unit = mmf.newObject(target)
				
				if (unit.values[ONLINE] ~= 4) then
					spritedata.values[CAMTARGET] = unit.values[ID]
					spritedata.values[XCAMERA] = unit.values[XPOS]
					spritedata.values[YCAMERA] = unit.values[YPOS]
					spritedata.values[CAMDIR] = unit.values[DIR]
				end
				MF_setupvision(target)
			elseif (#extra == 3) then
				spritedata.values[CAMTARGET] = 0.5
				spritedata.values[XCAMERA] = extra[1]
				spritedata.values[YCAMERA] = extra[2]
				spritedata.values[CAMDIR] = extra[3]
				MF_setupvision(target)
			end
			
			MF_removeblockeffect(0)
			
			updateanimations(nil,true)
			
			if (noundo == false) then
				if (target ~= 0.5) then
					local unit = mmf.newObject(target)
					addundo({"startvision",unit.values[ID]})
					updateundo = true
				else
					addundo({"startvision",0.5})
					updateundo = true
				end
			end
		end
	elseif (spritedata.values[VISION] == 1) and (state == 0) then
		MF_loop("clearedges",1)
		
		HACK_ROOMSIZEUNDO = true
		MF_loop("roomsize",1)
		HACK_ROOMSIZEUNDO = false
		
		MF_resetobjectpos()
		visiontargets = {}
		
		if (noundo == false) then
			addundo({"stopvision",spritedata.values[CAMTARGET],spritedata.values[XCAMERA],spritedata.values[YCAMERA],spritedata.values[CAMDIR]})
			updateundo = true
		end
		
		for i,unitid in ipairs(HACK_ROOMSIZEUNDO_DELTHESE) do
			delete(unitid,nil,nil,true,true)
		end
		HACK_ROOMSIZEUNDO_DELTHESE = {}
		
		funnywalls = {}
		MF_closevision()
		dynamictiling()
		ruleblockeffect()
		
		spritedata.values[CAMTARGET] = 0
		
		for i,unit in ipairs(units) do
			local cc = unit.colour or {}
			local cc1 = cc[1] or 0
			local cc2 = cc[2] or 3
			
			MF_setcolour(unit.fixed,cc1,cc2)
		end
	end
	
	spritedata.values[VISION] = state
end

function changevisiontarget(not_this_)
	local current = spritedata.values[CAMTARGET]
	local newtarget = 0
	local not_this = not_this_ or -1
	
	if (#visiontargets > 0) then
		local fixed = MF_getfixed(current) or 0
		
		if (fixed == 0) then
			newtarget = visiontargets[1]
		else
			local targetid = 0
			
			for i,v in ipairs(visiontargets) do
				if (v == fixed) then
					targetid = i + 1
					break
				end
			end
			
			if (targetid > #visiontargets) then
				targetid = 1
			end
			
			newtarget = visiontargets[targetid]
		end
	end
	
	if (newtarget ~= not_this) then
		if (newtarget == nil) then
			visionmode(0,0,nil,{spritedata.values[XCAMERA],spritedata.values[YCAMERA],spritedata.values[CAMDIR]})
			spritedata.values[CAMTARGET] = 0
		elseif (newtarget ~= 0) and (newtarget ~= 2) then
			local test = MF_findfixed(newtarget)
			
			if (test ~= nil) then
				local unit = mmf.newObject(newtarget)
				newtarget = unit.values[ID]
				MF_updatevision(unit.values[DIR])
				MF_updatevisionpos(unit.values[XPOS],unit.values[YPOS])
			else
				newtarget = 0
			end
			
			spritedata.values[CAMTARGET] = newtarget
		else
			spritedata.values[CAMTARGET] = newtarget
		end
	else
		spritedata.values[CAMTARGET] = 0.5
		newtarget = 0.5
	end
	
	if (newtarget ~= current) then
		local fixed = getunitid(current)
		
		if (fixed ~= 0) then
			local unit = mmf.newObject(fixed)
			unit.x = -24
			unit.y = -24
			unit.scaleX = 1
			unit.scaleY = 1
		end
	end
	
	addundo({"visiontarget",current,newtarget})
	updateundo = true
end

function updatevisiontargets()
	visiontargets = {}
	local current = spritedata.values[CAMTARGET]
	
	local vistest,vt2 = findallfeature(nil,"is","3d",true)
	
	for i,v in ipairs(vistest) do
		table.insert(visiontargets, v)
	end
	
	local targetid = 1
	if (current ~= 0) then
		for i,v in ipairs(visiontargets) do
			local unit = mmf.newObject(v)
			if (unit.values[ID] == current) and (unit.flags[DEAD] == false) then
				targetid = i
				break
			end
		end
	end
	
	local target = visiontargets[targetid] or 0
	local stopvision = false
	
	if (target ~= 0) then
		local unit = mmf.newObject(target)
		
		if (unit.flags[DEAD] == false) then
			spritedata.values[CAMTARGET] = unit.values[ID]
			MF_updatevision(unit.values[DIR])
			MF_updatevisionpos(unit.values[XPOS],unit.values[YPOS])
		else
			stopvision = true
		end
	else
		stopvision = true
	end
	
	if stopvision and (spritedata.values[VISION] == 1) and (spritedata.values[CAMTARGET] ~= 0.5) then
		visionmode(0,0,nil,{spritedata.values[XCAMERA],spritedata.values[YCAMERA],spritedata.values[CAMDIR]})
	end
	
	if (target ~= current) and (current ~= 0) and (MF_getfixed(current) ~= nil) then
		local fixed = getunitid(current)
		
		if (fixed ~= 0) then
			local unit = mmf.newObject(fixed)
			unit.x = -24
			unit.y = -24
			unit.scaleX = 1
			unit.scaleY = 1
		end
	end
end

function extrarender()
	local cx,cy,cdir = spritedata.values[XCAMERA],spritedata.values[YCAMERA],spritedata.values[CAMDIR]
	local mx,my = screenw * 0.5,screenh * 0.5
	local mtx,mty = roomsizex * 0.5,roomsizey * 0.5
	local maxscale = 13
	
	cx = cx - mtx
	cy = cy - mty
	
	local exists = {}
	local renderthese = {}
	
	for i,unit in ipairs(units) do
		if (unit.values[ZLAYER] < 21) then
			if unit.visible then
				if (unit.xpos == nil) then
					unit.xpos = unit.values[XPOS]
				end
				
				if (unit.ypos == nil) then
					unit.ypos = unit.values[YPOS]
				end
				
				if (unit.xpos ~= unit.values[XPOS]) then
					if (math.abs(unit.xpos - unit.values[XPOS]) > 2) then
						unit.xpos = unit.values[XPOS]
					else
						unit.xpos = unit.xpos + (unit.values[XPOS] - unit.xpos) * 0.4
					end
				end
				
				if (unit.ypos ~= unit.values[YPOS]) then
					if (math.abs(unit.ypos - unit.values[YPOS]) > 2) then
						unit.ypos = unit.values[YPOS]
					else
						unit.ypos = unit.ypos + (unit.values[YPOS] - unit.ypos) * 0.4
					end
				end
				
				local dothis = cullvision(unit.xpos - spritedata.values[XCAMERA],unit.ypos - spritedata.values[YCAMERA],cdir)
				
				if dothis then
					table.insert(renderthese, unit)
				else
					unit.x = -24
					unit.y = -24
					unit.scaleX = 1
					unit.scaleY = 1
				end
			end
			
			exists[unit.fixed] = 1
		end
	end
	
	for i,unitid in ipairs(edgetiles) do
		local unit = mmf.newObject(unitid)
		
		if (unit ~= nil) then
			if unit.visible then
				if (unit.xpos == nil) then
					unit.xpos = unit.values[XPOS]
				end
				
				if (unit.ypos == nil) then
					unit.ypos = unit.values[YPOS]
				end
				
				if (unit.xpos ~= unit.values[XPOS]) then
					if (math.abs(unit.xpos - unit.values[XPOS]) > 2) then
						unit.xpos = unit.values[XPOS]
					else
						unit.xpos = unit.xpos + (unit.values[XPOS] - unit.xpos) * 0.4
					end
				end
				
				if (unit.ypos ~= unit.values[YPOS]) then
					if (math.abs(unit.ypos - unit.values[YPOS]) > 2) then
						unit.ypos = unit.values[YPOS]
					else
						unit.ypos = unit.ypos + (unit.values[YPOS] - unit.ypos) * 0.4
					end
				end
				
				local dothis = cullvision(unit.xpos - spritedata.values[XCAMERA],unit.ypos - spritedata.values[YCAMERA],cdir)
				
				if dothis then
					table.insert(renderthese, unit)
				else
					unit.x = -24
					unit.y = -24
					unit.scaleX = 1
					unit.scaleY = 1
				end
			end
			
			exists[unit.fixed] = 1
		end
	end
	
	local renders = 0
	
	for i,unit in ipairs(renderthese) do
		local rendered = extrarender_do(unit,true,cx,cy,cdir,mx,my,mtx,mty,{maxscale})
		renders = renders + 1
		
		if rendered then
			exists[unit.fixed] = 2
		end
	end
	
	local removethese = {}
	
	for i,unit in ipairs(funnywalls) do
		local ownerid = unit.values[VISUALSTYLE]
		
		if (exists[ownerid] ~= nil) and (exists[ownerid] == 2) then
			local owner = mmf.newObject(ownerid)
			unit.visible = owner.visible
			
			if owner.visible and (owner.values[ID] ~= spritedata.values[CAMTARGET]) then
				unit.xpos = owner.xpos
				unit.ypos = owner.ypos
				unit.values[XPOS] = owner.values[XPOS]
				unit.values[YPOS] = owner.values[YPOS]
				unit.values[ZPOS] = owner.values[ZPOS]
				unit.values[ZLAYER] = owner.values[ZLAYER] + 0.5
				unit.values[FLOAT] = owner.values[FLOAT]
				
				unit.strings[COLOUR] = owner.strings[COLOUR]
				unit.strings[CLEARCOLOUR] = owner.strings[CLEARCOLOUR]
				
				unit.flags[PHANTOM] = owner.flags[PHANTOM]
				
				extrarender_do(unit,true,cx,cy,cdir,mx,my,mtx,mty,{maxscale})
				renders = renders + 1
			elseif (owner.values[ID] ~= spritedata.values[CAMTARGET]) then
				unit.visible = false
			end
		elseif (exists[ownerid] ~= nil) and (exists[ownerid] == 1) then
			unit.visible = false
		elseif (exists[ownerid] == nil) then
			unit.flags[DEAD] = true
			table.insert(removethese, {i, unit.fixed})
		end
	end
	
	-- MF_alert("Rendered: " .. tostring(renders))
	
	local offset = 0
	
	for i,v in ipairs(removethese) do
		table.remove(funnywalls, v[1] - offset)
		offset = offset + 1
		
		MF_cleanremove(v[2])
	end
end

function cullvision(dx,dy,cd)
	local ox,oy = 0,0
	
	if (dx == 0) and (dy == 0) then
		return true
	elseif (math.abs(dx) > 8) or (math.abs(dy) > 8) then
		return false
	end
	
	if (cd < 1) or (cd > 3) then
		ox = 1
	elseif (cd > 1) and (cd < 3) then
		ox = -1
	end
	
	if (cd < 2) and (cd > 0) then
		oy = -1
	elseif (cd > 2) and (cd < 4) then
		oy = 1
	end
	
	if (ox > 0) and (dx >= 0) then
		return true
	elseif (ox < 0) and (dx <= 0) then
		return true
	end
	
	if (oy > 0) and (dy >= 0) then
		return true
	elseif (oy < 0) and (dy <= 0) then
		return true
	end
	
	return false
end

function extrarender_do(unit,setcolour_,cx,cy,cdir,mx,my,mtx,mty,data)
	local setcolour = true
	if (setcolour_ ~= nil) then
		setcolour = setcolour_
	end
	
	local cangle = math.rad(cdir * 90)
	local maxs = data[1]
	
	local ux = unit.xpos
	local uy = unit.ypos
	
	local x,y = ux - mtx,uy - mty
	
	local diffx = (x - cx) * f_tilesize
	local diffy = (y - cy) * f_tilesize
	
	local xdist,ydist
	
	if (math.floor(cdir) == cdir) then
		if (cdir == 0) then
			xdist = (cy - y) * f_tilesize
			ydist = (cx - x) * f_tilesize
		elseif (cdir == 1) then
			xdist = (cx - x) * f_tilesize
			ydist = (y - cy) * f_tilesize
		elseif (cdir == 2) then
			xdist = (y - cy) * f_tilesize
			ydist = (x - cx) * f_tilesize
		elseif (cdir == 3) then
			xdist = (x - cx) * f_tilesize
			ydist = (cy - y) * f_tilesize
		end
	else
		local dist = math.sqrt(diffy ^ 2 + diffx ^ 2)
		local dir = 0 - math.atan2(diffy, diffx)
	
		ydist = 0 - math.cos(dir - cangle) * dist
		xdist = math.sin(dir - cangle) * dist
	end
	
	local z = 0 - (ydist / f_tilesize)
	local hor = (xdist / f_tilesize)
	if (xdist < 0) then
		hor = 0 - math.abs(xdist / f_tilesize)
	end
	
	if (unit.values[ZLAYER] > 15) and (unit.values[ZLAYER] <= 20) and (unit.className ~= "edge") then
		z = z + 0.1
	end
	
	local negz = 8 - z
	local partmult = (negz * (0.5 * (negz + 1))) / 2
	local sizedelta = (8 - z) / 4
	local sizemult = 10 - partmult - 1
	local scale = maxs - sizemult
	
	local n_negz = 8 - (z + 1)
	local n_partmult = (n_negz * (0.5 * (n_negz + 1))) / 2
	local n_sizemult = 10 - n_partmult - 1
	local n_scale = maxs - n_sizemult
	
	local difference = n_scale / scale
	
	local nx = mx - hor * scale * f_tilesize
	local ny = my
	local result = false
	
	if (scale > 0) and (z >= 0) and (z < 9) and (nx > 0 - scale * tilesize * 0.5) and (nx < screenw + scale * tilesize * 0.5) then
		result = true
		unit.x = nx
		unit.y = ny
		
		if (math.floor(z) == z) then
			unit.scaleX = scale
			unit.scaleY = scale
		else
			unit.scaleX = scale + 0.05
			unit.scaleY = scale + 0.05
		end
		unit.values[ZPOS] = math.floor(z + 0.5)
		
		if (unit.values[ONLINE] == 4) then
			unit.values[ZPOS] = math.floor(z + 0.5) + 0.5
		elseif (unit.values[ZLAYER] > 15) and (unit.values[ZLAYER] <= 20) and (unit.className ~= "edge") then
			unit.values[ZPOS] = unit.values[ZPOS] + 0.25
		end
		
		unit.flags[VISION_OPTIMIZE] = true
		
		if (hor == 0) and (unit.values[ZLAYER] > 10) then
			unit.flags[VISION_CENTERED] = true
		else
			unit.flags[VISION_CENTERED] = false
		end
		
		if (unit.values[ONLINE] ~= 4) and unit.visible and (unit.values[ID] ~= spritedata.values[CAMTARGET]) then
				if (unit.values[ZLAYER] <= 10) and (unit.className ~= "edge") then
					unit.scaleY = sizedelta
					unit.y = ny + (tilesize * scale * 0.5) - (tilesize * sizedelta * 0.5)
					
					local topw = difference
					local botw = 1.0
					
					local topc = 0.5
					local botc = 0.5
					
					if (hor ~= 0) then
						local awidth = math.abs(hor) + math.max(math.abs(hor) - 1, 0)
						local fullwidth = scale + sizedelta * awidth * 2
						
						unit.scaleX = fullwidth
						
						local topwidth = n_scale / fullwidth
						local botwidth = scale / fullwidth
						local topcenter = 1 - topwidth * 0.5
						local botcenter = 0 + botwidth * 0.5
						
						if (hor < 0) then
							topcenter = 0 + topwidth * 0.5
							botcenter = 1 - botwidth * 0.5
						end
						
						topw = topwidth
						botw = botwidth
						topc = topcenter
					end
					
					unit.strings[SHADEREFFECTS] = tostring(topw) .. "," .. tostring(botw) .. ",1.0,1.0," .. tostring(topc) .. "," .. tostring(botc) .. ",0.5,0.5"
					
					if (unit.values[TILING] == 1) then
						visiontiling(unit,math.floor(cdir))
					end
				elseif (unit.values[ZLAYER] > 10) and (unit.values[ZLAYER] <= 15) then
					if (hor ~= 0) then
						local awidth = math.abs(hor) + math.max(math.abs(hor) - 1, 0)
						
						unit.scaleX = sizedelta * awidth
						
						local righth = difference
						local lefth = 1.0
						
						if (hor > 0) then
							unit.x = nx + (tilesize * scale * 0.5) + (tilesize * sizedelta * 0.5) * awidth
						elseif (hor < 0) then
							unit.x = nx - (tilesize * scale * 0.5) - (tilesize * sizedelta * 0.5) * awidth
							
							lefth = difference
							righth = 1.0
						end
						
						unit.strings[SHADEREFFECTS] = "1.0,1.0," .. tostring(lefth) .. "," .. tostring(righth) .. "," .. "0.5,0.5,0.5,0.5"
					else
						unit.x = -24
						unit.y = -24
						unit.scaleX = 1
						unit.scaleY = 1
						unit.flags[VISION_OPTIMIZE] = false
						unit.strings[SHADEREFFECTS] = "1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5"
					end
				end
			
			if setcolour then
				local coloffset = math.min(math.max((z-1) * 7, 0), 255)
				
				local colour = unit.colour or {}
				local c1 = colour[1] or 0
				local c2 = colour[2] or 3
				
				if (unit.className == "edge") then
					c1 = 1
					c2 = 1
				end
				
				unit.strings[CLEARCOLOUR] = tostring(c1) .. "," .. tostring(c2) .. "," .. tostring(coloffset)
			end
		end
	else
		unit.flags[VISION_OPTIMIZE] = false
		unit.x = -24
		unit.y = -24
		unit.scaleX = 1
		unit.scaleY = 1
		unit.values[ZPOS] = -1
		unit.strings[SHADEREFFECTS] = "1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5"
	end
	
	return result
end

function grid_3d()
	local vertlines = 3
	
	for i=0-vertlines,vertlines do
		local unitid = MF_specialcreate("Grid_vertical")
		local unit = mmf.newObject(unitid)
		
		local hor = i - 0.5
		local z = 8
		local z2 = 1
		local maxs = 13
		
		local negz = 8 - z
		local partmult = (negz * (0.5 * (negz + 1))) / 2
		local sizedelta = (8 - z) / 4
		local sizemult = 10 - partmult - 1
		local scale = maxs - sizemult
		
		local negz2 = 8 - z2
		local partmult2 = (negz2 * (0.5 * (negz2 + 1))) / 2
		local sizedelta2 = (8 - z2) / 4
		local sizemult2 = 10 - partmult2 - 1
		local scale2 = maxs - sizemult2
		
		local nx = (screenw * 0.5) - hor * scale * f_tilesize
		local ny = (screenh * 0.5)
		
		unit.x = nx
		unit.y = ny + 48
		
		local tx = (screenw * 0.5) - hor * scale2 * f_tilesize
		local ty = screenh - 24
		
		local dir = 0 - math.atan2(ty - (ny + 48), tx - nx)
		unit.angle = math.deg(dir) + 90
		unit.scaleY = 12.0
		
		MF_setcolour(unitid,1,2)
	end
	
	for i=0,8 do
		local unitid = MF_specialcreate("Grid_horizontal")
		local unit = mmf.newObject(unitid)
		
		local z = i
		local maxs = 13
		
		local negz = 8 - z
		local partmult = (negz * (0.5 * (negz + 1))) / 2
		local sizedelta = (8 - z) / 4
		local sizemult = 10 - partmult - 1
		local scale = maxs - sizemult
		
		local nx = 0
		local ny = (screenh * 0.5)
		
		unit.x = nx
		unit.y = ny + (tilesize * scale * 0.5) -- (tilesize * sizedelta * 0.5)
		
		unit.scaleX = 32.0
		
		MF_setcolour(unitid,1,2)
	end
end

function setupvision_wall(unitid)
	local unit = mmf.newObject(unitid)
	
	if (unit.flags[DEAD] == false) then
		local wallid = MF_create(unit.className)
		
		local wall = mmf.newObject(wallid)
		wall.values[VISUALSTYLE] = unitid
		
		wall.values[ONLINE] = 4
		wall.scaleX = unit.scaleX
		wall.scaleY = unit.scaleY
		wall.values[XPOS] = unit.values[XPOS]
		wall.values[YPOS] = unit.values[YPOS]
		wall.values[TILING] = unit.values[TILING]
		wall.strings[COLOUR] = unit.strings[COLOUR]
		wall.strings[CLEARCOLOUR] = unit.strings[CLEARCOLOUR]
		
		wall.strings[1] = unit.strings[1]
		wall.strings[2] = unit.strings[2]
		wall.strings[3] = unit.strings[3]
		
		table.insert(funnywalls, wall)
	end
end

function visiontiling(unit,cdir)
	if (unit.values[TILING] == 1) then
		if (cdir == 1) then
			unit.direction = unit.values[VISUALDIR]
		else
			local dir = unit.values[VISUALDIR]
			local r,u,l,d = 0,0,0,0
			
			if (dir >= 8) then
				dir = dir - 8
				d = 1
			end
			
			if (dir >= 4) then
				dir = dir - 4
				l = 1
			end
			
			if (dir >= 2) then
				dir = dir - 2
				u = 1
			end
			
			if (dir >= 1) then
				dir = dir - 1
				r = 1
			end
			
			local nr,nu,nl,nd = 0,0,0,0
			
			if (cdir == 2) then
				nr = u
				nu = l
				nl = d
				nd = r
			elseif (cdir == 3) then
				nr = l
				nu = d
				nl = r
				nd = u
			else
				nr = d
				nu = r
				nl = u
				nd = l
			end
			
			local final = nr + nu * 2 + nl * 4 + nd * 8
			unit.direction = final
		end
	end
end