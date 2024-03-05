function init(tilemapid,roomsizex_,roomsizey_,tilesize_,Xoffset_,Yoffset_,generaldataid,generaldataid2,generaldataid3,generaldataid4,generaldataid5,spritedataid,vardataid,screenw_,screenh_)
	map = TileMap.new(tilemapid)
	generaldata = mmf.newObject(generaldataid)
	generaldata2 = mmf.newObject(generaldataid2)
	generaldata3 = mmf.newObject(generaldataid3)
	generaldata4 = mmf.newObject(generaldataid4)
	generaldata5 = mmf.newObject(generaldataid5)
	spritedata = mmf.newObject(spritedataid)
	vardata = mmf.newObject(vardataid)
	
	roomsizex = roomsizex_
	roomsizey = roomsizey_
	tilesize = tilesize_
	f_tilesize = spritedata.values[FIXEDTILESIZE]
	Xoffset = Xoffset_
	Yoffset = Yoffset_
	
	screenw = screenw_
	screenh = screenh_
	
	features = {}
	visualfeatures = {}
	featureindex = {}
	condfeatureindex = {}
	objectdata = {}
	units = {}
	tiledunits = {}
	codeunits = {}
	unitlists = {}
	objectlist = {}
	objectpalette = {}
	undobuffer = {}
	animunits = {}
	unitmap = {}
	unittypeshere = {}
	unitreference = {}
	deleted = {}
	ruleids = {}
	updatelist = {}
	objectcolours = {}
	wordunits = {}
	wordrelatedunits = {}
	letterunits = {}
	letterunits_map = {}
	paths = {}
	paradox = {}
	movelist = {}
	effecthistory = {}
	notfeatures = {}
	groupfeatures = {}
	groupmembers = {}
	pushedunits = {}
	customobjects = {}
	cobjects = {}
	condstatus = {}
	emptydata = {}
	leveldata = {}
	leveldata.colours = {}
	leveldata.currcolour = 0
	undobuffer_editor = {{}}
	latestleveldetails = {lnum = -1, ltype = -1}
	edgetiles = {}
	funnywalls = {}
	visiontargets = {}
	vision_rendered = {}
	deletereference = {}
	poweredstatus = {}
	specialtiling = {}
	
	generaldata.values[CURRID] = 1
	updatecode = 1
	doundo = true
	updateundo = true
	ruledebug = false
	modsinuse = false
	logevents = true
	maprotation = 0
	mapdir = 3
	last_key = 0
	levelconversions = {}
	auto_dir = {}
	destroylevel_check = false
	destroylevel_style = ""
	
	HACK_MOVES = 0
	HACK_INFINITY = 0
	movemap = {}
	
	Seed = 0
	Fixedseed = 100
	Seedingtype = 0
	
	base_octave = 4
	
	unitlimit = 2000
	movelimit = 15000
	selection_vwidth = 50
	
	levellimit = 120
	
	logrulelist = {}
	logrulelist.old = {}
	logrulelist.new = {}
	
	nlist = {}
	setupnounlists()
	generatetiles()
	formatobjlist()
	generatefreqs()
	
	baserulelist = {}
	setupbaserules()
end

function resetlogrules()
	logrulelist = {}
	logrulelist.old = {}
	logrulelist.new = {}
end

function setupbaserules()
	table.insert(baserulelist, {"text","is","push"})
	table.insert(baserulelist, {"level","is","stop"})
	table.insert(baserulelist, {"cursor","is","select"})
end

function setupmenu(editorid,editor2id,editor3id,editor4id,selectorid,placerid,no_menu_change_)
	editor = mmf.newObject(editorid)
	editor2 = mmf.newObject(editor2id)
	editor3 = mmf.newObject(editor3id)
	editor4 = mmf.newObject(editor4id)
	editor_selector = mmf.newObject(selectorid)
	editor_placer = mmf.newObject(placerid)
	changes = {}
	selectionrect = {}
	selectionrect.x = 0
	selectionrect.y = 0
	selectionrect.w = 0
	selectionrect.h = 0
	
	objlistdata = {}
	objlistdata.alltags = {}
	objlistdata.tags = {}
	objlistdata.objectreference = {}
	objlistdata.tilereference = {}
	objlistdata.gridreference_overlap = {}
	objlistdata.gridreference_full = {}
	objlistdata.search = ""
	
	local no_menu_change = no_menu_change_ or false
	if (no_menu_change == false) then
		menu = {"intro"}
	end
	
	local seentags = {}
	
	table.insert(objlistdata.alltags, "text_verb")
	table.insert(objlistdata.alltags, "text_quality")
	table.insert(objlistdata.alltags, "text_condition")
	table.insert(objlistdata.alltags, "text_prefix")
	table.insert(objlistdata.alltags, "common")
	table.insert(objlistdata.alltags, "movement")
	table.insert(objlistdata.alltags, "animal")
	table.insert(objlistdata.alltags, "obstacle")
	table.insert(objlistdata.alltags, "floor")
	table.insert(objlistdata.alltags, "danger")
	table.insert(objlistdata.alltags, "plant")
	table.insert(objlistdata.alltags, "item")
	
	for i,v in ipairs(objlistdata.alltags) do
		seentags[v] = 1
	end
	
	for i,v in ipairs(editor_objlist) do
		if (v.tags ~= nil) then
			for a,b in ipairs(v.tags) do
				if (seentags[b] == nil) then
					seentags[b] = 1
					
					table.insert(objlistdata.alltags, b)
				end
			end
		end
	end
end

function generatetiles()
	tilereference = {}
	tilereference["0,0"] = ""
	
	for i,tile in pairs(tileslist) do
		local tiledata = tile.tile
		
		local x = tiledata[1]
		local y = tiledata[2]
		
		local id = tostring(x) .. "," .. tostring(y)
		
		tilereference[id] = i
		
		if (tile.type == 3) or (tile.type == 7) then
			conditions[i] = {}
			
			local conddata = conditions[i]
			conddata.arguments = false
			
			if (tile.type == 7) then
				conddata.arguments = true
				conddata.argtype = {}
				
				local argtype = tile.argtype or {0}
				for a,b in ipairs(argtype) do
					table.insert(conddata.argtype, b)
				end
				
				if (tile.argextra ~= nil) then
					conddata.argextra = {}
					
					for a,b in ipairs(tile.argextra) do
						table.insert(conddata.argextra, b)
					end
				end
			end
		end
	end
end

function worldinit()
	unitreference = {}
	
	for i,tile in pairs(tileslist) do
		if (tile.does_not_exist == nil) or (tile.does_not_exist == false) then
			local thisid = MF_create(i)
			local name = tile.name or "error"
			local sprite = tile.sprite or name
			local root = tile.sprite_in_root or false
			MF_changesprite(thisid,sprite,root)
			MF_cleanremove(thisid)
			
			if (name ~= "error") then
				unitreference[name] = i
			end
		end
	end
	
	unitreference["level"] = "level"
	
	if (generaldata.values[MODE] == 0) then
		local world = generaldata.strings[WORLD]
		local slot = generaldata2.values[SAVESLOT]
		
		MF_store("settings","savegame","world",world)
		MF_store("settings","savegame","slot",tostring(slot))
	end
	
	if modsinuse then
		refreshfiles()
	end
end

function createobjectpalette()
	objectpalette = {}
	
	local objectids = MF_read("level","tiles","changed_short")
	local objids = MF_parsestring(objectids)
	
	for i,v in ipairs(objids) do
		local objid = "object" .. v
		local name = getactualdata_objlist(objid,"name")
		
		if (name ~= nil) then
			objectpalette[name] = objid
		end
	end
	
	objectpalette["level"] = "level"
end

function loadpathgate()
	if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
		local pathgate = ""
		local filegate = MF_read("level","general","gatepath")
		
		--MF_alert(filegate .. ", " .. tostring(unitreference[filegate]))
		
		if (string.len(filegate) > 0) then
			local filegate_ = unitreference[filegate] or ""
			pathgate = filegate_
		end
		
		if (string.len(pathgate) == 0) then
			local linegate = unitreference["line"] or ""
			pathgate = linegate
		end
		
		if (string.len(pathgate) == 0) then
			for i,v in pairs(unitreference) do
				pathgate = v
				break
			end
		end
		
		--MF_alert("Pathgate set to " .. pathgate)
		
		editor.strings[PATHOBJECT] = pathgate
	else
		editor.strings[PATHOBJECT] = "object117"
	end
end

function loadtile(x,y)
	local id = tostring(x) .. "," .. tostring(y)
	
	if (tilereference[id] ~= nil) then
		return tilereference[id]
	else
		print("Couldn't find object with tile id: " .. tostring(x) .. ", " .. tostring(y))
		return "error"
	end
end

function loadtile_oldlevel(x,y)
	local id = tostring(x) .. "," .. tostring(y)
	
	oldtiles = {
	["0,0"] = "wall",
	["1,0"] = "wall",
	["2,0"] = "baba",
	["3,0"] = "keke",
	["4,0"] = "rock",
	["5,0"] = "text_grass",
	["6,0"] = "tile",
	["7,0"] = "text_and",
	["8,0"] = "text_hide",
	["9,0"] = "text_follow",
	["10,0"] = "text_float",
	["0,1"] = "wall",
	["1,1"] = "wall",
	["2,1"] = "lava",
	["3,1"] = "water",
	["4,1"] = "wall",
	["5,1"] = "text_empty",
	["6,1"] = "text_tile",
	["7,1"] = "text_weak",
	["8,1"] = "text_back",
	["9,1"] = "cloud",
	["10,1"] = "pillar",
	["0,2"] = "text_baba",
	["1,2"] = "text_keke",
	["2,2"] = "text_flag",
	["3,2"] = "flag",
	["4,2"] = "ice",
	["5,2"] = "text_shift",
	["6,2"] = "statue",
	["7,2"] = "text_all",
	["8,2"] = "text_right",
	["9,2"] = "text_cloud",
	["10,2"] = "text_pillar",
	["0,3"] = "text_rock",
	["1,3"] = "text_lava",
	["2,3"] = "text_wall",
	["3,3"] = "text_ice",
	["4,3"] = "text_is",
	["5,3"] = "text_statue",
	["6,3"] = "text_more",
	["7,3"] = "text_safe",
	["8,3"] = "text_up",
	["9,3"] = "star",
	["10,3"] = "text_rose",
	["0,4"] = "text_water",
	["1,4"] = "text_win",
	["2,4"] = "text_push",
	["3,4"] = "text_stop",
	["4,4"] = "text_move",
	["5,4"] = "text_best",
	["6,4"] = "text_tele",
	["7,4"] = "hand",
	["8,4"] = "text_left",
	["9,4"] = "text_star",
	["10,4"] = "text_red",
	["0,5"] = "text_melt",
	["1,5"] = "text_hot",
	["2,5"] = "text_you",
	["3,5"] = "text_not",
	["4,5"] = "text_sink",
	["5,5"] = "love",
	["6,5"] = "door",
	["7,5"] = "text_hand",
	["8,5"] = "text_down",
	["9,5"] = "dust",
	["10,5"] = "text_violet",
	["0,6"] = "text_stick",
	["1,6"] = "text_defeat",
	["2,6"] = "skull",
	["3,6"] = "grass",
	["4,6"] = "text_skull",
	["5,6"] = "text_love",
	["6,6"] = "text_door",
	["7,6"] = "text_text",
	["8,6"] = "text_restart",
	["9,6"] = "text_dust",
	["10,6"] = "text_blue",
	["0,7"] = "key",
	["1,7"] = "text_key",
	["2,7"] = "text_open",
	["3,7"] = "text_shut",
	["4,7"] = "text_has",
	["5,7"] = "box",
	["6,7"] = "text_box",
	["7,7"] = "belt",
	["8,7"] = "text_make",
	["9,7"] = "text_fall",
	["10,7"] = "violet",
	["0,8"] = "text_belt",
	["1,8"] = "me",
	["2,8"] = "text_me",
	["3,8"] = "orb",
	["4,8"] = "text_orb",
	["5,8"] = "text_swap",
	["6,8"] = "text_pull",
	["7,8"] = "text_on",
	["8,8"] = "text_star",
	["9,8"] = "moon",
	["10,8"] = "rose",
	["0,9"] = "text_moon",
	["1,9"] = "star",
	["2,9"] = "moon",
	["3,9"] = "hedge",
	["4,9"] = "text_hedge",
	["5,9"] = "text_level",
	["6,9"] = "text_orb",
	["7,9"] = "orb",
	["8,9"] = "text_bonus",
	["9,9"] = "text_moon",
	["10,9"] = "text_group",
	["0,10"] = "brick",
	["1,10"] = "text_brick",
	["2,10"] = "text_wonder",
	["3,10"] = "text_eat",
	["4,10"] = "text_statue",
	["5,10"] = "statue",
	}
	
	if (oldtiles[id] ~= nil) then
		local corresponding = oldtiles[id]
		
		for a,b in pairs(tileslist) do
			if (b.name == corresponding) then
				return a
			end
		end
	else
		MF_alert("Trying to load mystery object")
	end
	
	if (tilereference[id] ~= nil) then
		return tilereference[id]
	else
		print("Couldn't find object with tile id: " .. tostring(x) .. ", " .. tostring(y))
		return "error"
	end
end

function firstlevel()
	local world = generaldata.strings[WORLD]
	local level = generaldata.strings[CURRLEVEL]
	
	generaldata.strings[CURRLEVEL] = ""
	
	if (string.len(level) == 0) then
		local flevel = MF_read("world","general","firstlevel")
		local slevel = MF_read("world","general","start")
		
		local fstatus = tonumber(MF_read("save",world,flevel)) or 0
		local intro = tonumber(MF_read("save",world,"intro")) or 0
		
		if (string.len(flevel) > 0) then
			if (fstatus ~= 3) or (string.len(slevel) == 0) then
				sublevel(slevel,0,0)
				sublevel(flevel,0,0)
				
				generaldata.strings[CURRLEVEL] = flevel
				generaldata.strings[PARENT] = slevel
				
				if (world == generaldata.strings[BASEWORLD]) and (intro == 0) then
					MF_intro()
				end
			else
				generaldata.strings[CURRLEVEL] = slevel
			end
		elseif (string.len(slevel) > 0) then
			generaldata.strings[CURRLEVEL] = slevel
			sublevel(slevel,0,0)
		end
	end
end

function loadcustomobjects(data)
	local cobjects = MF_parsestring(data)
	customobjects = {}
	
	local target = ""
	
	if (#cobjects > 0) then
		for i,v in ipairs(cobjects) do
			if (string.sub(v, 1, 4) == "OBJ-") then
				target = string.sub(v, 5)
				customobjects[target] = {}
			else
				if (string.len(target) > 0) then
					table.insert(customobjects[target], v)
				else
					MF_alert("customobject's target was an empty string!")
				end
			end
		end
	end
end

function createcobjectlist()
	cobjects = {}
	for a,b in pairs(customobjects) do
		for c,d in ipairs(b) do
			cobjects[d] = 1
		end
	end
	
	cobjects[1] = "SET"
end