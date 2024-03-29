function objlist_debug(x,y)
	local go = objlistdata.gridreference_overlap
	local gf = objlistdata.gridreference_full
	
	local r1,r2 = "nil","nil"
	
	if (go[x] ~= nil) and (go[x][y] ~= nil) then
		r1 = "!!!"
	end
	
	if (gf[x] ~= nil) and (gf[x][y] ~= nil) then
		r2 = "!!!"
	end
	
	MF_alert(tostring(x) .. ", " .. tostring(y) .. ": " .. r1 .. ", " .. r2)
end

function listrules()
	MF_alert("Units: " .. tostring(#units) .. "; Rules: " .. tostring(#features) .. "; Code: " .. tostring(#codeunits) .. "; Map: " .. tostring(mapcells()))
	MF_alert("Listing the rules:")
	
	for i,rules in ipairs(features) do
		local text = ""
		local rule = rules[1]
		
		for a,b in ipairs(rule) do
			text = text .. b .. " "
		end
		
		local conds = rules[2]
		if (#conds > 0) then
			for a,cond in ipairs(conds) do
				text = text .. cond[1] .. " "
				
				if (cond[2] ~= nil) then
					if (#cond[2] > 0) then
						for c,d in ipairs(cond[2]) do
							text = text .. d .. " "
						end
					end
				end
			end
		end
		
		MF_alert(text)
		
		--[[
		local idcheck = ""
		
		local ids = rules[3]
		for a,idgroup in ipairs(ids) do
			for c,d in ipairs(idgroup) do
				local test = mmf.newObject(d)
				
				idcheck = idcheck .. " " .. test.strings[UNITNAME]
			end
			
			idcheck = idcheck .. ","
		end
		
		MF_alert(idcheck)
		]]--
	end
	
	for i,v in ipairs(leveltree) do
		MF_alert(v .. ", " .. tostring(leveltree_id[i]))
	end
	
	MF_alert("menu: ")
	
	for i,v in ipairs(menu) do
		MF_alert(v)
	end
	
	--updatecode = 1
	--code()
end

function menudebug()
	MF_alert("menu: ")
	
	for i,v in ipairs(menu) do
		MF_alert(v)
	end
end

function editordebug()
	local tables = 0
	local subtables = 0
	local hm = ""
	
	local unitid = MF_create("object001")
	local unit = mmf.newObject(unitid)
	
	for i,v in pairs(_G) do
		tables = tables + 1
		MF_alert(tostring(i))
		
		if (i == "mmfi") then
			--print("yeah")
		end
		
		if (tostring(type(v)) == "table") then
			for a,b in pairs(v) do
				subtables = subtables + 1
			end
		end
	end
	
	MF_alert(tostring(tables) .. " tables with " .. tostring(subtables) .. " subtables in total")

	collectgarbage()
end

function restore()
	clearunits()
	local allunits = MF_getunits()
	
	if (#allunits > 0) then
		for i,v in ipairs(allunits) do
			addunit(v)
		end
	end
	
	updatecode = 1
	code()
end

function debugfunction()
	--[[
	if ruledebug then
		ruledebug = false
		timedmessage("rule debugging disabled - timer on")
		MF_debugmode(0)
	else
		ruledebug = true
		timedmessage("rule debugging enabled - timer off")
		MF_debugmode(1)
	end
	
	for i,v in pairs(changes) do
		local text = ""
		local name = ""
		
		for a,b in pairs(v) do
			text = text .. a .. ", "
		end
		
		if (tileslist[i] ~= nil) then
			local d = tileslist[i]
			name = d.name
		end
		
		MF_alert("Changes for " .. name .. ": " .. text)
	end
	]]--
	formlettermap()
end

function timedmessage(text,x_,y_)
	local x = x_ or 0
	local y = y_ or 0
	writetext(text,-1,f_tilesize * 0.5 + x * f_tilesize,f_tilesize * 1.5 + y * f_tilesize,"timedmessage",false,3)
end

function debugpoint(x,y)
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			MF_alert(tostring(v) .. ", " .. tostring(type(v)))
		end
	end
end

function fixspriteroot()
	for i,v in pairs(changes) do
		if (v.image ~= nil) and (v.root ~= nil) then
			if (v.root == false) then
				local fix = MF_findsprite(v.image .. "_0_1.png", v.root)
				
				if (fix == false) then
					v.root = nil
				end
			end
		end
		
		dochanges_full(i)
	end
end