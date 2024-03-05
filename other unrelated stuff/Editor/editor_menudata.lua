menufuncs =
{
	main =
	{
		button = "MainMenuButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 + f_tilesize * 1
				local bw = 13 * f_tilesize * 0.5
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				local dynamic_structure = {}
				
				if (build ~= "m") then
					local existing_world = MF_read("settings","savegame","world")
					local existing_slot = MF_read("settings","savegame","slot")
					if (#existing_world > 0) and (#existing_slot) and (existing_world ~= "levels") then
						local exists = MF_findfile("Data/Worlds/" .. existing_world .. "/world_data.txt")
						
						if exists then
							local blen = getdynamicbuttonwidth(langtext("main_continue"),11)
							createbutton("continue",x,y,2,blen,1.5,langtext("main_continue"),name,3,2,buttonid)
							
							y = y + f_tilesize * 2
							
							table.insert(dynamic_structure, {{"continue"}})
						end
					end
					
					local blen = getdynamicbuttonwidth(langtext("main_start"),11)
					createbutton("start",x - bw,y,2,blen,1.5,"$2,4" .. langtext("main_start"),name,3,2,buttonid)
					
					blen = getdynamicbuttonwidth(langtext("main_custom"),11)
					createbutton("custom",x + bw,y,2,blen,1.5,"$3,4" .. langtext("main_custom"),name,3,2,buttonid,disable)
					
					y = y + f_tilesize * 1.5
					
					blen = getdynamicbuttonwidth(langtext("main_editor"),11)
					createbutton("editor",x - bw,y,2,blen,1.5,langtext("main_editor"),name,3,2,buttonid,disable)
					
					blen = getdynamicbuttonwidth(langtext("settings"),11)
					createbutton("settings",x + bw,y,2,blen,1.5,langtext("settings"),name,3,2,buttonid)
					
					table.insert(dynamic_structure, {{"start"},{"custom"}})
					table.insert(dynamic_structure, {{"editor"},{"settings"}})
					
					y = y + f_tilesize * 1.5
					
					blen = getdynamicbuttonwidth(langtext("credits"),11)
					createbutton("credits",x - bw,y,2,blen,1.5,langtext("credits"),name,3,2,buttonid)
					
					if (build ~= "n") and (build ~= "promo") then
						blen = getdynamicbuttonwidth(langtext("main_exit"),11)
						createbutton("quit",x + bw,y,2,blen,1.5,langtext("main_exit"),name,3,2,buttonid)
						
						table.insert(dynamic_structure, {{"credits"},{"quit"}})
					else
						table.insert(dynamic_structure, {{"credits"}})
					end
				else
					x = screenw * 0.5
					y = screenh * 0.5 + f_tilesize * 3
					local w = f_tilesize * 6
					
					createbutton("start",x - w,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.m_start)
					createbutton("settings",x,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.m_settings)
					createbutton("credits",x + w,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.m_credits)
					
					table.insert(dynamic_structure, {{"start"},{"settings"},{"credits"}})
				end
				
				if (generaldata.strings[LANG] ~= "en") then
					local madeby = langtext("intro_madeby")
					
					writetext(madeby,0,screenw * 0.5,screenh - f_tilesize * 0.8,name,true,1)
				end
				
				local version = langtext("main_version") .. " " .. string.lower(MF_getversion())
				
				if (build ~= "m") then
					writetext(version,0,f_tilesize * 0.2,screenh - f_tilesize * 0.4,name,false,1)
				else
					version = string.lower(MF_getversion())
					writetext(version,0,f_tilesize * 0.2,screenh - f_tilesize * 0.8,name,false,1)
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	pause =
	{
		button = "PauseMenu",
		enter = 
			function(parent,name,buttonid)
				MF_letterclear("editorname")
				editor.values[NAMEFLAG] = 0
				
				local build = generaldata.strings[BUILD]
				
				local x = f_tilesize * 5
				local y = f_tilesize * 2
				
				local mx = screenw * 0.5
				local mult = 1
				local mult_y = 1
				
				if (build == "m") then
					mult = 2
					mult_y = 2.5
				end
				
				local leveltitle = ""
				local levelcode = ""
				if (string.len(generaldata.strings[LEVELNUMBER_NAME]) > 0) and (generaldata.strings[LEVELNUMBER_NAME] ~= "_NONE_") and (generaldata.strings[LEVELNUMBER_NAME] ~= " ") then
					leveltitle = generaldata.strings[LEVELNUMBER_NAME] .. ": "
				end
				
				if (editor.values[LEVELTYPE] == 1) or (build == "m") then
					leveltitle = ""
				end
				
				if (#generaldata4.strings[LEVEL_DATABASEID] > 0) and (generaldata.strings[WORLD] == "levels") then
					levelcode = "(" .. generaldata4.strings[LEVEL_DATABASEID] .. ")"
				end
				
				displaylevelname(nil,generaldata.strings[CURRLEVEL],2,name,mx,nil,true,leveltitle,levelcode)
				
				if (build ~= "m") then
					y = y + f_tilesize
				else
					y = y + f_tilesize * 3
				end
				
				local mblen = 10
				if (build ~= "m") then
					mblen = nil
				end
				
				local blen = mblen or getdynamicbuttonwidth(langtext("resume"),10)
				createbutton("resume",mx,y,2,blen * mult_y,1 * mult_y,langtext("resume"),name,1,3,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"resume"}})
				
				y = y + f_tilesize * mult_y
				
				local playstatus = editor.values[INEDITOR]
				if (playstatus == 0) then
					local returndisable = false
					if (#leveltree <= 1) then
						returndisable = true
					end
					
					if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) and (generaldata.strings[CURRLEVEL] == "200level") then
						returndisable = false
					end
					
					local customreturn = MF_read("level","general","customreturn")
					if (string.len(customreturn) > 0) and (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) then
						returndisable = false
					end
					
					if (generaldata.strings[WORLD] ~= generaldata.strings[BASEWORLD]) and (customreturn == "_NONE_") then
						returndisable = true
					end
					
					blen = mblen or getdynamicbuttonwidth(langtext("pause_returnmap"),10)
					createbutton("return",mx,y,2,blen * mult_y,1 * mult_y,langtext("pause_returnmap"),name,1,3,buttonid,returndisable)
				elseif (playstatus ~= 3) then
					blen = mblen or getdynamicbuttonwidth(langtext("pause_returneditor"),10)
					createbutton("return",mx,y,2,blen * mult_y,1 * mult_y,langtext("pause_returneditor"),name,1,3,buttonid)
				else
					blen = mblen or getdynamicbuttonwidth(langtext("pause_returnplaylevels"),10)
					createbutton("return",mx,y,2,blen * mult_y,1 * mult_y,langtext("pause_returnplaylevels"),name,1,3,buttonid)
				end
				
				table.insert(dynamic_structure, {{"return"}})
				
				y = y + f_tilesize * mult_y
				
				blen = mblen or getdynamicbuttonwidth(langtext("restart"),10)
				createbutton("restart",mx,y,2,blen * mult_y,1 * mult_y,langtext("restart"),name,1,3,buttonid)
				
				table.insert(dynamic_structure, {{"restart"}})
				
				y = y + f_tilesize * mult_y
				
				blen = mblen or getdynamicbuttonwidth(langtext("settings"),10)
				createbutton("settings",mx,y,2,blen * mult_y,1 * mult_y,langtext("settings"),name,1,3,buttonid)
				
				table.insert(dynamic_structure, {{"settings"}})
				
				if (playstatus ~= 3) then
					y = y + f_tilesize * 1.5 * mult_y
				else
					y = y + f_tilesize * 1 * mult_y
				end
				
				local mainmenudisable = false
				if (editor.values[INEDITOR] > 0) and (editor.values[INEDITOR] < 3) then
					mainmenudisable = true
				end
				
				if (editor.values[INEDITOR] ~= 1) then
					blen = mblen or getdynamicbuttonwidth(langtext("pause_returnmain"),10)
					createbutton("returnmain",mx,y,2,blen * mult_y,1 * mult_y,langtext("pause_returnmain"),name,1,3,buttonid,mainmenudisable)
				
					table.insert(dynamic_structure, {{"returnmain"}})
				else
					y = y - f_tilesize * 1
				end
				
				if (playstatus ~= 3) then
					y = y + f_tilesize * 1.5
				else
					y = y + f_tilesize * 1 * mult_y
					
					local disablereport = true
					if (string.len(generaldata4.strings[LEVEL_DATABASEID]) == 9) and (string.sub(generaldata4.strings[LEVEL_DATABASEID], 5, 5) == "-") then
						disablereport = false
					end
					
					blen = mblen or getdynamicbuttonwidth(langtext("pause_reportlevel"),10)
					createbutton("report",mx,y,2,blen * mult_y,1 * mult_y,langtext("pause_reportlevel"),name,1,3,buttonid,disablereport)
					
					table.insert(dynamic_structure, {{"report"}})
					
					y = y + f_tilesize * 1
				end
				
				if (build ~= "m") and (generaldata2.values[ENDINGGOING] == 0) then
					writerules(parent,name,mx,y)
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	settings =
	{
		button = "SettingsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 1.5 * f_tilesize
				
				local disable = MF_unfinished()
				local build = generaldata.strings[BUILD]
				
				local extrasize = 0
				local sliderxoffset = 0
				local slideryoffset = 0
				local delaytext = "settings_repeat"
				
				if (build ~= "m") then
					writetext(langtext("settings_colon"),0,x,y,name,true,2,true)
					y = y + f_tilesize * 2
				else
					extrasize = f_tilesize * 1.5
					sliderxoffset = 0 - f_tilesize * 4
					slideryoffset = 0 - f_tilesize * 0.6
					delaytext = "settings_repeat_m"
				end
				
				x = screenw * 0.5 - f_tilesize * 1
				
				writetext(langtext("settings_music"),0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local mvolume = MF_read("settings","settings","music")
				slider("music",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,0,100,tonumber(mvolume))
				
				y = y + f_tilesize + extrasize * 0.5
				
				writetext(langtext("settings_sound"),0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local svolume = MF_read("settings","settings","sound")
				slider("sound",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,0,100,tonumber(svolume))
				
				y = y + f_tilesize + extrasize * 0.5
				
				writetext(langtext(delaytext),0,x - f_tilesize * 11.5 + sliderxoffset,y + slideryoffset,name,false,2,true)
				local delay = MF_read("settings","settings","delay")
				slider("delay",x + f_tilesize * 5 + sliderxoffset * 1.5,y + slideryoffset,8,{1,3},{1,4},buttonid,7,20,tonumber(delay))
				
				x = screenw * 0.5
				y = y + f_tilesize * 2 + extrasize
				
				local s,c,icon = 0,{0,3},""
				
				if (build ~= "m") then
					createbutton("language",x,y,2,18,1,langtext("settings_language"),name,3,2,buttonid)
				
					y = y + f_tilesize
				end
				
				if (build ~= "n") and (build ~= "m") then
					createbutton("controls",x,y,2,18,1,langtext("controls"),name,3,2,buttonid)
				
					y = y + f_tilesize
				
					local fullscreen = MF_read("settings","settings","fullscreen")
					s,c = gettoggle(fullscreen)
					createbutton("fullscreen",x,y,2,18,1,langtext("settings_fullscreen"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize
				end
				
				local grid = MF_read("settings","settings","grid")
				s,c,icon = gettoggle(grid,{"m_settings_grid_no","m_settings_grid"})
				
				if (build ~= "m") then
					createbutton("grid",x,y,2,18,1,langtext("settings_grid"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize
				else
					y = y - f_tilesize * 0.5
					
					createbutton("grid",x - f_tilesize * 12.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				local wobble = MF_read("settings","settings","wobble")
				s,c,icon = gettoggle(wobble,{"m_settings_wobble","m_settings_wobble_no"})
				
				if (build ~= "m") then
					createbutton("wobble",x,y,2,18,1,langtext("settings_wobble"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize
				else
					createbutton("wobble",x - f_tilesize * 7.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				local particles = MF_read("settings","settings","particles")
				s,c,icon = gettoggle(particles,{"m_settings_particles","m_settings_particles_no"})
				
				if (build ~= "m") then
					createbutton("particles",x,y,2,18,1,langtext("settings_particles"),name,3,2,buttonid,nil,s)
				else
					createbutton("particles",x - f_tilesize * 2.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				end
				
				if (build == "m") then
					createbutton("language",x + f_tilesize * 2.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_settings_language)
					
					local hand = MF_read("settings","settings","m_hand")
					s,c,icon = gettoggle(hand,{"m_settings_hand_right","m_settings_hand_left"})
					
					createbutton("hand",x + f_tilesize * 7.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
					
					local pointers = MF_read("settings","settings","m_pointers")
					s,c,icon = gettoggle(pointers,{"m_settings_pointers_on","m_settings_pointers_off"})
					
					createbutton("pointers",x + f_tilesize * 12.5,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons[icon])
				
					y = y + f_tilesize
				end
				
				local shake = MF_read("settings","settings","shake")
				s,c,icon = gettoggle(shake)
				
				y = y + f_tilesize + extrasize
				
				if (build ~= "m") then
					createbutton("shake",x,y,2,18,1,langtext("settings_shake"),name,3,2,buttonid,nil,s)
				else
					createbutton("shake",x,y,2,32,2,langtext("settings_shake"),name,3,2,buttonid,nil,s)
				end
				
				y = y + f_tilesize + extrasize * 0.9
				
				local contrast = MF_read("settings","settings","contrast")
				s,c = gettoggle(contrast)
				
				if (build ~= "m") then
					createbutton("contrast",x,y,2,18,1,langtext("settings_palette"),name,3,2,buttonid,nil,s)
				else
					createbutton("contrast",x,y,2,32,2,langtext("settings_palette"),name,3,2,buttonid,nil,s)
					
					--y = y + f_tilesize * 0.1
				end
				
				y = y + f_tilesize + extrasize * 0.9
				
				local blinking = MF_read("settings","settings","blinking")
				s,c = gettoggle(blinking)
				
				if (build ~= "m") then
					createbutton("blinking",x,y,2,18,1,langtext("settings_blinking"),name,3,2,buttonid,nil,s)
					
					y = y + f_tilesize + extrasize * 0.9
				end
				
				local restartask = MF_read("settings","settings","restartask")
				s,c = gettoggle(restartask)
				
				if (build ~= "m") then
					createbutton("restartask",x,y,2,18,1,langtext("settings_restart"),name,3,2,buttonid,nil,s)
				else
					createbutton("restartask",x,y,2,32,2,langtext("settings_restart"),name,3,2,buttonid,nil,s)
					
					--y = y + f_tilesize * 0.1
				end
				
				y = y + f_tilesize + extrasize * 0.9
				
				--[[
				local zoom = MF_read("settings","settings","zoom")
				s,c = gettoggle(zoom)
				createbutton("zoom",x,y,2,16,1,langtext("settings_zoom"),name,3,2,buttonid,nil,s)
				]]--
				
				if (build ~= "m") then
					writetext(langtext("settings_zoom"),0,x - f_tilesize * 15.5,y,name,false,2,true)
					
					local zoom = tonumber(MF_read("settings","settings","zoom")) or 0
					createbutton("zoom1",x - f_tilesize * 4.5,y,2,7,1,langtext("zoom1"),name,3,2,buttonid,nil)
					createbutton("zoom2",x + f_tilesize * 3.5,y,2,7,1,langtext("zoom2"),name,3,2,buttonid,nil)
					createbutton("zoom3",x + f_tilesize * 11.5,y,2,7,1,langtext("zoom3"),name,3,2,buttonid,nil)
					
					makeselection({"zoom2","zoom1","zoom3"},tonumber(zoom) + 1)
					
					y = y + f_tilesize
				end
				
				if (build == "n") and (1 == 0) then
					local disablestick = generaldata5.values[DISABLESTICK] + 1
					createbutton("disable_stick",x,y,2,18,1,langtext("controls_disablestick"),name,3,2,buttonid)
					makeselection({"","disable_stick"},disablestick)
					
					y = y + f_tilesize
				end
				
				if (build ~= "m") then
					createbutton("return",x,y,2,18,1,langtext("return"),name,3,2,buttonid)
				else
					createbutton("return",x,y,2,24,2,langtext("return"),name,3,2,buttonid)
				end
			end,
		structure =
		{
			{
				{{"music",-392},},
				{{"sound",-392},},
				{{"delay",-392},},
				{{"language"},},
				{{"controls"},},
				{{"fullscreen"},},
				{{"grid"},},
				{{"wobble"},},
				{{"particles"},},
				{{"shake"},},
				{{"contrast"},},
				{{"blinking"},},
				{{"restartask"},},
				{{"zoom1"},{"zoom2"},{"zoom3"},},
				{{"return"},},
			},
			n = {
				{{"music",-392},},
				{{"sound",-392},},
				{{"delay",-392},},
				{{"language"},},
				{{"grid"},},
				{{"wobble"},},
				{{"particles"},},
				{{"shake"},},
				{{"contrast"},},
				{{"blinking"},},
				{{"restartask"},},
				{{"zoom1"},{"zoom2"},{"zoom3"},},
				-- {{"disable_stick"},},
				{{"return"},},
			},
			m = {
				{{"music",-340},},
				{{"sound",-340},},
				{{"delay",-340},},
				{{"grid"},{"wobble"},{"particles"},{"language"},{"hand"},{"pointers"},},
				{{"shake"}},
				{{"contrast"}},
				{{"restartask"},},
				{{"return"},},
			},
		}
	},
	controls =
	{
		button = "ControlsButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				writetext(langtext("controls_setup"),0,x,y,name,true,2,true)
				
				local pad,padname = MF_profilefound()
				local padtext = langtext("controls_noconnectedgamepad")
				
				if (pad ~= nil) then
					if pad then
						padtext = langtext("controls_gamepadname") .. " " .. string.lower(string.sub(padname, 1, math.min(string.len(padname), 25)))
					else
						padtext = langtext("controls_unknowngamepad")
					end
				end
				
				y = y + f_tilesize * 1
				
				writetext(padtext,0,x,y,name,true,2,true)

				y = y + f_tilesize * 2
				
				createbutton("detect",x,y,2,16,1,langtext("controls_detectgamepad"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("gamepad",x,y,2,16,1,langtext("controls_gamepadsetup"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("default_gamepad",x,y,2,16,1,langtext("controls_defaultgamepad"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				local s,c,icon = 0,{0,3},""
				local disablegamepad = generaldata4.values[DISABLEGAMEPAD]
				s,c = gettoggle(disablegamepad)
				createbutton("disable_gamepad",x,y,2,16,1,langtext("controls_disablegamepad_off"),name,3,2,buttonid,nil,s)
				
				y = y + f_tilesize * 1.5
				
				createbutton("keyboard",x,y,2,16,1,langtext("controls_keysetup"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("default_keyboard",x,y,2,16,1,langtext("controls_defaultkey"),name,3,2,buttonid)

				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"detect"},},
				{{"gamepad"},},
				{{"default_gamepad"},},
				{{"disable_gamepad"},},
				{{"keyboard"},},
				{{"default_keyboard"},},
				{{"return"},},
			},
		}
	},
	gamepad =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				x = x + f_tilesize * 1.5
				y = y + f_tilesize * 2
				
				createbutton("move",x - f_tilesize * 8,y,2,6,1,langtext("move"),name,3,2,buttonid)
				createcontrolicon("move",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("move2",x + f_tilesize * 3,y,2,6,1,langtext("move") .. " 2",name,3,2,buttonid)
				createcontrolicon("move2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("idle",x - f_tilesize * 8,y,2,6,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("idle2",x + f_tilesize * 3,y,2,6,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("undo",x - f_tilesize * 8,y,2,6,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("undo2",x + f_tilesize * 3,y,2,6,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("restart",x - f_tilesize * 8,y,2,6,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("restart2",x + f_tilesize * 3,y,2,6,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("confirm",x - f_tilesize * 8,y,2,6,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",true,x - f_tilesize * 3.5,y,buttonid)
				
				createbutton("confirm2",x + f_tilesize * 3,y,2,6,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",true,x + f_tilesize * 7.5,y,buttonid)
				
				y = y + f_tilesize * 1.4
				
				createbutton("pause",x - f_tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",true,x + f_tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	keyboard =
	{
		button = "KeyConfigButton",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 3 * f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)

				y = y + f_tilesize * 2
				
				createbutton("right",x - f_tilesize * 7,y,2,6,1,langtext("right"),name,3,2,buttonid)
				createcontrolicon("right",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("right2",x + f_tilesize * 4,y,2,6,1,langtext("right") .. " 2",name,3,2,buttonid)
				createcontrolicon("right2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("up",x - f_tilesize * 7,y,2,6,1,langtext("up"),name,3,2,buttonid)
				createcontrolicon("up",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("up2",x + f_tilesize * 4,y,2,6,1,langtext("up") .. " 2",name,3,2,buttonid)
				createcontrolicon("up2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("left",x - f_tilesize * 7,y,2,6,1,langtext("left"),name,3,2,buttonid)
				createcontrolicon("left",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("left2",x + f_tilesize * 4,y,2,6,1,langtext("left") .. " 2",name,3,2,buttonid)
				createcontrolicon("left2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("down",x - f_tilesize * 7,y,2,6,1,langtext("down"),name,3,2,buttonid)
				createcontrolicon("down",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("down2",x + f_tilesize * 4,y,2,6,1,langtext("down") .. " 2",name,3,2,buttonid)
				createcontrolicon("down2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize * 1.2
				
				createbutton("idle",x - f_tilesize * 7,y,2,6,1,langtext("idle"),name,3,2,buttonid)
				createcontrolicon("idle",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("idle2",x + f_tilesize * 4,y,2,6,1,langtext("idle") .. " 2",name,3,2,buttonid)
				createcontrolicon("idle2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("undo",x - f_tilesize * 7,y,2,6,1,langtext("undo"),name,3,2,buttonid)
				createcontrolicon("undo",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("undo2",x + f_tilesize * 4,y,2,6,1,langtext("undo") .. " 2",name,3,2,buttonid)
				createcontrolicon("undo2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("restart",x - f_tilesize * 7,y,2,6,1,langtext("controls_restart"),name,3,2,buttonid)
				createcontrolicon("restart",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("restart2",x + f_tilesize * 4,y,2,6,1,langtext("controls_restart") .. " 2",name,3,2,buttonid)
				createcontrolicon("restart2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize
				
				createbutton("confirm",x - f_tilesize * 7,y,2,6,1,langtext("confirm"),name,3,2,buttonid)
				createcontrolicon("confirm",false,x - f_tilesize * 2.5,y,buttonid)
				
				createbutton("confirm2",x + f_tilesize * 4,y,2,6,1,langtext("confirm") .. " 2",name,3,2,buttonid)
				createcontrolicon("confirm2",false,x + f_tilesize * 8.5,y,buttonid)
				
				y = y + f_tilesize * 1.2
				
				createbutton("pause",x - f_tilesize * 3,y,2,8,1,langtext("pause"),name,3,2,buttonid)
				createcontrolicon("pause",false,x + f_tilesize * 3.5,y,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"right"},{"right2"}},
				{{"up"},{"up2"}},
				{{"left"},{"left2"}},
				{{"down"},{"down2"}},
				{{"move"},{"move2"}},
				{{"idle"},{"idle2"}},
				{{"undo"},{"undo2"}},
				{{"restart"},{"restart2"}},
				{{"confirm"},{"confirm2"}},
				{{"pause"},},
			},
		}
	},
	change_keyboard =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	change_gamepad =
	{
		button = "Change",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				writetext(langtext("controls_pressany"),0,x,y,name,true,2,true)
			end,
	},
	editor_start =
	{
		button = "EditLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7
				
				MF_loop("clear",1)
				clearunits()
				
				writetext(langtext("editor_start_title"),0,x,y,name,true,1)
				
				y = y + f_tilesize * 3
				
				local enableworlds = true
				local build = generaldata.strings[BUILD]
				
				local enableworlds_ = tonumber(MF_read("settings","editor","mode")) or 0
				if (enableworlds_ == 1) then
					enableworlds = false
				end
				
				local blen = getdynamicbuttonwidth(langtext("editor_start_level"),16)
				createbutton("editor_start_level",x,y,2,blen,2,langtext("editor_start_level"),name,3,2,buttonid)
				
				if (build ~= "n") and (build ~= "m") then
					y = y + f_tilesize * 2
					
					blen = getdynamicbuttonwidth(langtext("editor_start_world"),16)
					createbutton("editor_start_world",x,y,2,blen,2,langtext("editor_start_world"),name,3,2,buttonid,enableworlds)
				end
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("customlevels_play_get"),16)
				createbutton("customlevels_play_get",x,y,2,blen,2,langtext("customlevels_play_get"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("customlevels_play_getlist"),16)
				createbutton("editor_start_getlist",x,y,2,blen,2,langtext("customlevels_play_getlist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_start_settings"),16)
				createbutton("editor_start_settings",x,y,2,blen,2,langtext("editor_start_settings"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				setundo_editor()
			end,
		structure =
		{
			{
				{{"editor_start_level"},},
				{{"editor_start_world"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
			n = {
				{{"editor_start_level"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
			m = {
				{{"editor_start_level"},},
				{{"customlevels_play_get"},},
				{{"editor_start_getlist"},},
				{{"editor_start_settings"},},
				{{"return"},},
			},
		}
	},
	editor_start_settings =
	{
		button = "EditLevelsSettings",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7
				
				local blen, toobig = getdynamicbuttonwidth(langtext("return"),16,24)
				createbutton("return",x,y,2,blen,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				--[[
				if (build ~= "m") then
					createbutton("editor_settings_controls",x,y,2,16,1,langtext("editor_settings_controls"),name,3,2,buttonid)
				
					y = y + f_tilesize * 1.5
				end
				]]--
				local pad,padname = MF_profilefound()
				local padtext = langtext("controls_noconnectedgamepad")
				
				if (pad ~= nil) then
					if pad then
						padtext = langtext("controls_gamepadname") .. " " .. string.lower(string.sub(padname, 1, math.min(string.len(padname), 25)))
					else
						padtext = langtext("controls_unknowngamepad")
					end
				end
				
				local build = generaldata.strings[BUILD]
				if (build ~= "n") then
					writetext(padtext,0,x,y,name,true,1)
					
					y = y + f_tilesize * 1.5
					
					blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_defaultpad"),16,24)
					createbutton("editor_settings_defaultpad",x,y,2,blen,1,langtext("editor_settings_defaultpad"),name,3,2,buttonid)
					
					y = y + f_tilesize * 1.5
				end
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_help"),16,24)
				createbutton("editor_settings_help",x,y,2,blen,1,langtext("editor_settings_help"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1.5
				
				local tiptext = "editor_settings_tips"
				if (build == "n") then
					tiptext = "editor_settings_tips_n"
				end
				
				blen, toobig = getdynamicbuttonwidth(langtext(tiptext),16,24)
				createbutton("editor_settings_tips",x,y,2,blen,1,langtext(tiptext),name,3,2,buttonid)
				
				makeselection({"","editor_settings_tips"},editor4.values[EDITOR_DISABLETIPS] + 1)
				
				y = y + f_tilesize * 1.5
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_slide"),16,24)
				createbutton("editor_settings_slide",x,y,2,blen,1,langtext("editor_settings_slide"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_slide"},editor4.values[EDITOR_DISABLESLIDE] + 1)
				
				y = y + f_tilesize * 1.5
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_music"),16,24)
				createbutton("editor_settings_music",x,y,2,blen,1,langtext("editor_settings_music"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_music"},generaldata5.values[EDITOR_MUSICTYPE] + 1)
				
				y = y + f_tilesize * 1.5
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_advanced"),16,24)
				createbutton("editor_settings_advanced",x,y,2,blen,1,langtext("editor_settings_advanced"),name,3,2,buttonid)
				
				makeselection({"","editor_settings_advanced"},editor2.values[ADVANCEDWORDS] + 1)
				
				if (build ~= "n") and (build ~= "m") then
					y = y + f_tilesize * 1.5
					
					blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_mod"),16,24)
					createbutton("editor_settings_mod",x,y,2,blen,1,langtext("editor_settings_mod"),name,3,2,buttonid,enableworlds)
					
					makeselection({"","editor_settings_mod"},editor2.values[EXTENDEDMODE] + 1)
				end
			end,
		structure =
		{
			{
				{{"return"},},
				{{"editor_settings_defaultpad"},},
				{{"editor_settings_help"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
				{{"editor_settings_mod"},},
			},
			n = {
				{{"return"},},
				--{{"editor_settings_controls"},},
				{{"editor_settings_help"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
			},
			m = {
				{{"return"},},
				{{"editor_settings_tips"},},
				{{"editor_settings_slide"},},
				{{"editor_settings_music"},},
				{{"editor_settings_advanced"},},
			},
		}
	},
	editor_start_settings_help =
	{
		button = "EditLevelsSettingsHelp",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6
				
				local blen, toobig = getdynamicbuttonwidth(langtext("return"),16,24)
				createbutton("return",x,y,2,blen,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_settings_hotkeys"),16,24)
				createbutton("editor_settings_hotkeys",x,y,2,blen,1,langtext("editor_settings_hotkeys"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1.5
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial1"),16,24)
				createbutton("editor_tutorial1",x,y,2,blen,1,langtext("editor_tutorial1"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial2"),16,24)
				createbutton("editor_tutorial2",x,y,2,blen,1,langtext("editor_tutorial2"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial3"),16,24)
				createbutton("editor_tutorial3",x,y,2,blen,1,langtext("editor_tutorial3"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial4"),16,24)
				createbutton("editor_tutorial4",x,y,2,blen,1,langtext("editor_tutorial4"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial5"),16,24)
				createbutton("editor_tutorial5",x,y,2,blen,1,langtext("editor_tutorial5"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial6"),16,24)
				createbutton("editor_tutorial6",x,y,2,blen,1,langtext("editor_tutorial6"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial7"),16,24)
				createbutton("editor_tutorial7",x,y,2,blen,1,langtext("editor_tutorial7"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial8"),16,24)
				createbutton("editor_tutorial8",x,y,2,blen,1,langtext("editor_tutorial8"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial9"),16,24)
				createbutton("editor_tutorial9",x,y,2,blen,1,langtext("editor_tutorial9"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				blen, toobig = getdynamicbuttonwidth(langtext("editor_tutorial10"),16,24)
				createbutton("editor_tutorial10",x,y,2,blen,1,langtext("editor_tutorial10"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"editor_settings_hotkeys"},},
				{{"editor_tutorial1"},},
				{{"editor_tutorial2"},},
				{{"editor_tutorial3"},},
				{{"editor_tutorial4"},},
				{{"editor_tutorial5"},},
				{{"editor_tutorial6"},},
				{{"editor_tutorial7"},},
				{{"editor_tutorial8"},},
				{{"editor_tutorial9"},},
				{{"editor_tutorial10"},},
			},
		}
	},
	editor_hotkeys =
	{
		button = "EditLevelsHotkeys",
		escbutton = "return",
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5 - f_tilesize * 0.5
				local y = screenh * 0.5 - f_tilesize * 9.5
				
				MF_clearcontrolicons(0)
				
				local page = editor3.values[PAGEMENU]
				local build = generaldata.strings[BUILD]
				
				local x_ = 0
				local y_ = 0
				local hotkeylist = 
				{
					keyboard =
					{
						{
						"hotkeys_editor_rotate",
						"hotkeys_editor_copy",
						"hotkeys_editor_cut",
						"hotkeys_editor_swap",
						"hotkeys_editor_drag",
						"hotkeys_editor_cleartile",
						"hotkeys_editor_changetool",
						"hotkeys_editor_changelayer",
						"hotkeys_editor_quickbar_scroll",
						"hotkeys_editor_quickbar_lock",
						"hotkeys_editor_quickbar_reset",
						"hotkeys_editor_pickis",
						"hotkeys_editor_pickand",
						"hotkeys_editor_picknot",
						"hotkeys_editor_pickempty",
						"hotkeys_editor_massdir",
						"hotkeys_editor_moveall",
						"hotkeys_editor_rotateselection",
						"hotkeys_editor_flipselection",
						"hotkeys_editor_altselection",
						"hotkeys_editor_opencurrobjlist",
						"hotkeys_editor_openeditormenu",
						"hotkeys_editor_openeditorsettingsmenu",
						"hotkeys_editor_testlevel",
						"hotkeys_editor_undo",
						"hotkeys_editor_save",
						"hotkeys_editor_deleteall",
						"hotkeys_editor_addobject",
						"hotkeys_editor_return",
						"hotkeys_editor_autopick",
						},
						{
						"hotkeys_currobjlist_swap",
						"hotkeys_currobjlist_drag",
						"hotkeys_currobjlist_leave",
						"hotkeys_currobjlist_edit",
						"hotkeys_currobjlist_remove",
						"hotkeys_currobjlist_search",
						"hotkeys_currobjlist_autoadd",
						},
						{
						"hotkeys_levellist_search",
						"hotkeys_levellist_leave",
						"hotkeys_levellist_delete",
						},
						{
						"hotkeys_objlist_quickadd",
						"hotkeys_editor_restart",
						"hotkeys_editor_windowsize",
						},
					},
					gamepad =
					{
						{
						"hotkeys_editor_gpad_rotate",
						"hotkeys_editor_gpad_copy",
						"hotkeys_editor_gpad_undo",
						"hotkeys_editor_gpad_drag",
						"hotkeys_editor_gpad_openquickmenu",
						"hotkeys_editor_gpad_opencurrobjlist",
						"hotkeys_editor_gpad_changetool",
						"hotkeys_editor_gpad_changelayer",
						"hotkeys_editor_gpad_moveall",
						"hotkeys_editor_gpad_quickbar_scroll",
						"hotkeys_editor_gpad_quickbar_lock",
						"hotkeys_editor_gpad_quickbar_empty",
						"hotkeys_editor_gpad_cut",
						"hotkeys_editor_gpad_swap",
						"hotkeys_editor_gpad_emptytile",
						"hotkeys_editor_gpad_massdir",
						"hotkeys_editor_gpad_altmove",
						"hotkeys_editor_gpad_save",
						"hotkeys_editor_gpad_test",
						"hotkeys_editor_gpad_pickempty",
						"hotkeys_editor_gpad_autopick",
						"hotkeys_editor_gpad_rotateselection",
						"hotkeys_editor_gpad_flipselection",
						"hotkeys_editor_gpad_altselection",
						},
						{
						"hotkeys_currobjlist_gpad_swap",
						"hotkeys_currobjlist_gpad_drag",
						"hotkeys_currobjlist_gpad_leave",
						"hotkeys_currobjlist_gpad_edit",
						"hotkeys_currobjlist_gpad_add",
						"hotkeys_currobjlist_gpad_remove",
						"hotkeys_currobjlist_gpad_search",
						"hotkeys_currobjlist_gpad_removesearch",
						"hotkeys_currobjlist_gpad_removesearch_alt",
						"hotkeys_currobjlist_gpad_autoadd",
						"hotkeys_currobjlist_gpad_tags",
						},
						{
						"hotkeys_levellist_gpad_addnew",
						"hotkeys_levellist_gpad_delete",
						"hotkeys_levellist_gpad_removesearch",
						"hotkeys_levellist_gpad_search",
						},
						{
						"hotkeys_editor_gpad_altsave",
						"hotkeys_editor_gpad_settings",
						"hotkeys_editor_gpad_menu",
						"hotkeys_objlist_gpad_quickadd",
						"hotkeys_objlist_gpad_search",
						"hotkeys_objlist_gpad_tags",
						},
					},
				}
				
				local list = extra
				local choice = 1
				if (string.len(list) == 0) then
					local gpad = MF_profilefound()
					
					if (gpad ~= nil) then
						list = "gamepad"
					else
						list = "keyboard"
					end
				end
				
				if (build == "n") then
					list = "gamepad"
				end
				
				if (list == "keyboard") then
					choice = 1
				elseif (list == "gamepad") then
					choice = 2
				end
				
				if (editor2.values[EXTENDEDMODE] == 1) and (build ~= "n") and (build ~= "m") then
					if (page == 0) then
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_editlevel")
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_quickaddlevel")
						table.insert(hotkeylist["keyboard"][1], "hotkeys_editor_resetmapicon")
					end
				end
				
				x = x - f_tilesize * 17
				
				local db = hotkeylist[list][page + 1]
				local limit = 19
				local ymult = 0.9
				
				if (list == "gamepad") then
					y = y + f_tilesize * 0.4
					limit = 12
					ymult = 1.45
				end
				
				if (#db > 0) then
					for i=1,#db do
						writetext(langtext(db[i],true),0,x + x_ * 18 * f_tilesize,y + y_ * f_tilesize * ymult,name,false,1,nil,nil,nil,nil,true)
						
						y_ = y_ + 1
						
						if (y_ >= limit) then
							y_ = 0
							x_ = x_ + 1
						end
					end
				end
				
				x = screenw * 0.5
				y = screenh - f_tilesize * 2
				
				local blen, toobig = getdynamicbuttonwidth(langtext("hotkeys_editor_category_editor"),8,8)
				createbutton("editor",x - f_tilesize * 12.5,y,2,blen,1,langtext("hotkeys_editor_category_editor"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				blen, toobig = getdynamicbuttonwidth(langtext("hotkeys_editor_category_currobjlist"),9,9)
				createbutton("currobjlist",x - f_tilesize * 2.5,y,2,blen,1,langtext("hotkeys_editor_category_currobjlist"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				blen, toobig = getdynamicbuttonwidth(langtext("hotkeys_editor_category_levellist"),10,10)
				createbutton("levellist",x + f_tilesize * 8,y,2,blen,1,langtext("hotkeys_editor_category_levellist"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				blen, toobig = getdynamicbuttonwidth(langtext("hotkeys_editor_category_misc"),4,4)
				createbutton("misc",x + f_tilesize * 15.5,y,2,blen,1,langtext("hotkeys_editor_category_misc"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				makeselection({"editor","currobjlist","levellist","misc"},page + 1)
				
				y = y + f_tilesize * 1
				
				createbutton("return",x,y,2,12,1,langtext("return"),name,3,1,buttonid)
				
				if (build ~= "n") and (build ~= "m") then
					createbutton("keyboard",x - f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_keyboard"),name,3,2,buttonid)
					createbutton("gamepad",x + f_tilesize * 12,y,2,9,1,langtext("hotkeys_editor_gamepad"),name,3,2,buttonid)
					makeselection({"keyboard","gamepad"},choice)
				end
			end,
		structure =
		{
			{
				{{"editor"},{"currobjlist"},{"levellist"},{"misc"}},
				{{"keyboard"},{"return"},{"gamepad"},defaultx = 1},
			},
			n = {
				{{"editor"},{"currobjlist"},{"levellist"},{"misc"}},
				{{"return"}},
			},
		}
	},
	world =
	{
		button = "WorldChoice",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				setundo_editor()
				
				menudata_customscript.worldlist(parent,name,buttonid,extra)
			end,
	},
	level =
	{
		button = "LevelButton",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = f_tilesize * 0.5
				
				if (generaldata.strings[WORLD] ~= "levels") then
					local worldname = MF_read("world","general","name")
					local worldauthor = editor2.strings[WORLDAUTHOR]
					MF_clearborders()
					
					local authorname = worldauthor
					
					if (string.len(worldauthor) == 0) then
						authorname = langtext("noauthor")
					end
					
					writetext(worldname .. " " .. langtext("by") .. " " .. authorname,0,x,y,name,true,2,nil,nil,nil,nil,nil,true)
				else
					writetext(langtext("editor_levellist_levels"),0,x,y,name,true,2,nil,nil,nil,nil,nil,true)
				end
				
				y = y + f_tilesize
				
				y = y + f_tilesize
				
				local dynamic_structure = {}
				
				local page = extra or 0
				page = MF_setpagemenu(name)
				
				local search = editor2.strings[SEARCHSTRING]
				local levels,maxpage,menustruct,page = createlevellist(buttonid,page,search)
				
				local disableaddlevels = false
				if (generaldata.strings[BUILD] == "n") and (levels >= levellimit) then
					disableaddlevels = true
				end
				
				local returntext = langtext("editor_levellist_return")
				if (generaldata.strings[WORLD] ~= "levels") then
					returntext = langtext("editor_levellist_returnworld")
				end
				
				createbutton("return",x,y,2,0,1,returntext,name,3,1,buttonid,nil,nil,nil,nil,nil,nil,10)
				
				table.insert(dynamic_structure, {{"return"}})
				
				if (generaldata.strings[WORLD] ~= "levels") then
					local y_ = y + f_tilesize
					
					if (generaldata.strings[WORLD] ~= "baba_editor") and (generaldata.strings[WORLD] ~= "baba") then
						local blen,toobig = getdynamicbuttonwidth(langtext("editor_levellist_setstart"),8,8.5)
						createbutton("setstart",x + f_tilesize * 4.5,y_,2,blen,1,langtext("editor_levellist_setstart"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
						
						blen,toobig = getdynamicbuttonwidth(langtext("editor_levellist_setauthor"),8,8.5)
						createbutton("setauthor",x - f_tilesize * 13.5,y_,2,blen,1,langtext("editor_levellist_setauthor"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
						
						blen,toobig = getdynamicbuttonwidth(langtext("editor_levellist_setname"),8,8.5)
						createbutton("setname",x - f_tilesize * 4.5,y_,2,blen,1,langtext("editor_levellist_setname"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
						
						blen,toobig = getdynamicbuttonwidth(langtext("editor_levellist_setmap"),8,8.5)
						createbutton("setmap",x + f_tilesize * 13.5,y_,2,blen,1,langtext("editor_levellist_setmap"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
						
						table.insert(dynamic_structure, {{"setauthor","longcursor"},{"setname","longcursor"},{"setstart","longcursor"},{"setmap","longcursor"}})
					end
				end
				
				y = y + f_tilesize * 2
				
				createbutton("newlevel",x,y,2,10,1,langtext("editor_levellist_new"),name,3,2,buttonid,disableaddlevels)
				createbutton("sort",x - f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sort"),name,3,2,buttonid)
				
				if (generaldata.strings[WORLD] ~= "levels") then
					createbutton("sorttypes",x + f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sorttypes"),name,3,2,buttonid)
					makeselection({"","sorttypes"},editor2.values[SORTING_TYPES] + 1)
				
					table.insert(dynamic_structure, {{"sort"},{"newlevel"},{"sorttypes"},defaultx = 1})
				else
					table.insert(dynamic_structure, {{"sort"},{"newlevel"},defaultx = 1})
				end
				
				makeselection({"","sort"},editor2.values[SORTING] + 1)
				
				--MF_alert(tostring(extra))
				
				for a,b in ipairs(menustruct) do
					table.insert(dynamic_structure, b)
				end
				
				editor3.values[MAXPAGE] = maxpage
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				local dynamic_structure_row = {{"search"}}
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_levellist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure_row, {"scroll_left2","cursor"})
					table.insert(dynamic_structure_row, {"scroll_left","cursor"})
					table.insert(dynamic_structure_row, {"scroll_right","cursor"})
					table.insert(dynamic_structure_row, {"scroll_right2","cursor"})
				end
				
				table.insert(dynamic_structure_row, {"removesearch"})
				table.insert(dynamic_structure, dynamic_structure_row)
				
				createbutton("search",screenw * 0.5 - f_tilesize * 12.75,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_search"),name,3,2,buttonid)
				
				local disableremovesearch = true
				if (string.len(editor2.strings[SEARCHSTRING]) > 0) then
					disableremovesearch = false
				end
				
				createbutton("removesearch",screenw * 0.5 + f_tilesize * 12.75,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_removesearch"),name,3,2,buttonid,disableremovesearch)
				
				MF_visible("LevelButton",1)
				
				makeselection({"","setstart","setmap"}, editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				setundo_editor()
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				MF_letterclear("nametext")
			end,
		submenu_leave =
			function(parent,name)
				MF_visible("LevelButton",0)
				MF_letterclear("nametext")
			end,
	},
	name =
	{
		enter = 
			function(parent,name)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
			end,
		leave = 
			function(parent,name)
				MF_delete("LetterButton")
				MF_letterclear("nametext")
			end,
	},
	editor =
	{
		button = "EditorButton",
		enter = 
			function(parent,name,buttonid)
				local levelname = generaldata.strings[LEVELNAME]
				local level = generaldata.strings[CURRLEVEL]
				
				if (generaldata.strings[BUILD] ~= "n") then
					displaylevelname(levelname .. " (" .. level .. ")",level,nil,"editorname",nil,nil,true)
				else
					displaylevelname(levelname,level,nil,"editorname",nil,nil,true)
				end
				
				local x = screenw - f_tilesize * 0.8
				local y = f_tilesize * 0.75
				
				for i=0,9 do
					local hotbarid = MF_create("Editor_hotbarbutton")
					local hotbar = mmf.newObject(hotbarid)
					
					hotbar.x = x - f_tilesize * 1.25 * i
					hotbar.y = y
					hotbar.layer = 2
					hotbar.values[HOTBAR_ID] = 9 - i
					hotbar.values[BUTTON_STOREDX] = hotbar.x
					hotbar.values[BUTTON_STOREDY] = hotbar.y
					
					MF_setcolour(hotbarid,3,2)
					hotbar.strings[UI_CUSTOMCOLOUR] = "3,2"
					hotbar.strings[GROUP] = buttonid
					hotbar.flags[BUTTON_SLIDING] = false
					
					local thumbid = MF_specialcreate("Editor_thumbnail_hotbar")
					local thumb = mmf.newObject(thumbid)
					
					thumb.x = hotbar.x
					thumb.y = hotbar.y
					thumb.values[HOTBAR_ID] = 9 - i
					thumb.strings[GROUP] = buttonid
					thumb.layer = 2
					thumb.visible = false
				end
				
				x = x - f_tilesize * 1.25 * 10.25
				
				local tooliconid = MF_specialcreate("Editor_toolindicator")
				local toolicon = mmf.newObject(tooliconid)
				
				toolicon.x = x
				toolicon.y = y
				toolicon.layer = 2
				toolicon.strings[GROUP] = buttonid
				
				toolicon.strings[4] = langtext("editor_toolindicator_eraser",true)
				--toolicon.strings[5] = langtext("editor_toolindicator_quickswitch",true)
				
				x = screenw
				y = screenh - f_tilesize * 0.5
				
				if (generaldata.strings[BUILD] ~= "n") then
					local blen = getdynamicbuttonwidth(langtext("editor_mainmenu"),4)
					x = x - f_tilesize * (blen * 0.5 + 0.25)
					
					createbutton("menu",x,y,2,0,1,langtext("editor_mainmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu",true),nil,nil,nil,4)
					
					blen = getdistancebetweenbuttons(langtext("editor_mainmenu"),langtext("editor_settingsmenu"),4)
					x = x - f_tilesize * (blen + 1)
					
					createbutton("settingsmenu",x,y,2,0,1,langtext("editor_settingsmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_settingsmenu",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_settingsmenu"),langtext("editor_objectlist"))
					x = x - f_tilesize * blen
					
					createbutton("objects",x,y,2,0,1,langtext("editor_objectlist"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_objects",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_objectlist"),langtext("editor_savelevel"))
					x = x - f_tilesize * (blen + 1)
					
					createbutton("save",x,y,2,0,1,langtext("editor_savelevel"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_save",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_savelevel"),langtext("editor_undo"))
					x = x - f_tilesize * blen
					
					local disableundo = true
					if (#undobuffer_editor > 1) then
						disableundo = false
					end
					createbutton("undo",x,y,2,0,1,langtext("editor_undo"),name,3,2,buttonid,disableundo,nil,langtext("tooltip_editor_undo",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_undo"),langtext("editor_swap"))
					x = x - f_tilesize * blen
					
					createbutton("swap",x,y,2,0,1,langtext("editor_swap"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_swap",true))
					
					blen = getdistancebetweenbuttons(langtext("editor_swap"),langtext("editor_test"))
					x = x - f_tilesize * blen
					
					createbutton("test",x,y,2,0,1,langtext("editor_test"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_test",true))
				end
				
				x = screenw - f_tilesize * 0.75
				y = f_tilesize * 2
				
				createbutton("layer1",x,y,2,1.5,1,langtext("editor_l1"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				y = y + f_tilesize
				
				createbutton("layer2",x,y,2,1.5,1,langtext("editor_l2"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				y = y + f_tilesize
				
				createbutton("layer3",x,y,2,1.5,1,langtext("editor_l3"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_layer",true),nil,true)
				
				makeselection({"layer1","layer2","layer3"},editor.values[LAYER] + 1)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_normal",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_normal",true),bicons.t_pen,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_line",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_line",true),bicons.t_line,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_rectangle",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_rectangle",true),bicons.t_rect,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_fillrectangle",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fillrectangle",true),bicons.t_frect,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_select",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_select",true),bicons.t_select,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_fill",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fill",true),bicons.t_fill,true)
				
				y = y + f_tilesize * 1.5
				
				createbutton("tool_erase",x,y,2,1.5,1.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_erase",true),bicons.t_erase,true)
				
				local selected_tool = editor2.values[EDITORTOOL]
				
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},selected_tool + 1)
				
				editor.values[STATE] = 0
				
				local pad,padname = MF_profilefound()
				
				if (pad ~= nil) or (generaldata.strings[BUILD] == "n") then
					x = f_tilesize * 5
					y = screenh - f_tilesize * 3
					
					local dpadid = MF_specialcreate("Editor_buttons_dpad")
					local dpad = mmf.newObject(dpadid)
					
					dpad.x = f_tilesize * 5
					dpad.y = screenh - f_tilesize * 4
					dpad.layer = 2
					dpad.values[8] = dpad.x
					dpad.values[9] = dpad.y
					dpad.values[10] = 2
					
					editor_buttons_getdpad(dpad)
					
					y = y - f_tilesize * 6
					
					controlicon_editor("gamepad_editor","quickmenu",x,y,buttonid,langtext("buttons_editor_quickmenu",true),3,nil,"save",langtext("buttons_editor_save",true))
					
					y = y - f_tilesize * 3
					
					controlicon_editor("gamepad_editor","currobjlist",x,y,buttonid,langtext("buttons_editor_currobjlist",true),3,nil,"test",langtext("buttons_editor_test",true))
					
					x = screenw - f_tilesize * 8
					y = f_tilesize * 3					
					
					controlicon_editor("gamepad_editor","scrollleft_hotbar",x,y,buttonid,langtext("buttons_editor_scrollleft_hotbar",true),3,nil,"autopick",langtext("buttons_editor_autopick",true),langtext("buttons_editor_selection_flip",true))
					
					x = x + f_tilesize * 3
					
					controlicon_editor("gamepad_editor","scrollright_hotbar",x,y,buttonid,langtext("buttons_editor_scrollright_hotbar",true),1,nil,"pickempty",langtext("buttons_editor_pickempty",true),langtext("buttons_editor_selection_mirror",true))
					
					x = x - f_tilesize * 7.25
					
					controlicon_editor("gamepad_editor","scrollright_tool",x,y,buttonid,langtext("buttons_editor_scrollright_tool",true),1,nil,"lock",langtext("buttons_editor_lock",true),langtext("buttons_editor_selection_rotate_right",true))
					
					x = x - f_tilesize * 3
					
					controlicon_editor("gamepad_editor","scrollleft_tool",x,y,buttonid,langtext("buttons_editor_scrollleft_tool",true),3,nil,"empty_hotbar",langtext("buttons_editor_empty_hotbar",true),langtext("buttons_editor_selection_rotate_left",true))
					
					if (generaldata.strings[BUILD] ~= "n") then
						x = screenw - f_tilesize * 7
						y = screenh - f_tilesize * 3
						
						controlicon_editor("gamepad_editor","drag",x,y,buttonid,langtext("buttons_editor_drag",true),nil,nil,"showdir",langtext("buttons_editor_showdir",true),langtext("buttons_editor_selection_cancel",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","undo",x,y,buttonid,langtext("buttons_editor_undo",true),nil,nil,"emptytile",langtext("buttons_editor_emptytile",true),langtext("buttons_editor_selection_ignore",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","copy",x,y,buttonid,langtext("buttons_editor_copy",true),nil,nil,"cut",langtext("buttons_editor_cut",true),langtext("buttons_editor_selection_cancel",true))
						
						y = y - f_tilesize * 1.5
						
						controlicon_editor("gamepad_editor","place",x,y,buttonid,langtext("buttons_editor_place",true),nil,nil,"swap",langtext("buttons_editor_swap",true),langtext("buttons_editor_selection_place",true))
					else
						x = screenw - f_tilesize * 6
						y = screenh - f_tilesize * 4
						
						controlicon_editor("gamepad_editor","x",x,y - f_tilesize,buttonid,"buttons_editor",1,true)
						controlicon_editor("gamepad_editor","y",x - f_tilesize,y,buttonid,"buttons_editor",2,true)
						controlicon_editor("gamepad_editor","b",x,y + f_tilesize,buttonid,"buttons_editor",3,true)
						controlicon_editor("gamepad_editor","a",x + f_tilesize,y,buttonid,"buttons_editor",0,true)
					end
				end
			end,
	},
	editorsettingsmenu =
	{
		button = "EditorSettingsMenuButton",
		escbutton = "closemenu",
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				y = y + f_tilesize * 1.5
				
				local blen,toobig = getdynamicbuttonwidth(langtext("editor_menu_close"),16)
				createbutton("closemenu",x,y,2,blen,1,langtext("editor_menu_close"),name,3,1,buttonid)
				
				y = y + f_tilesize * 1.5
				local refx = x
				local lx = refx - f_tilesize * 14
				local mx = refx - f_tilesize * 8
				local rx = refx + f_tilesize * 8
				
				local lname = generaldata.strings[LEVELNAME]
				if (string.len(lname) > 24) then
					lname = string.sub(lname, 1, 21) .. "..."
				end
				
				local author = editor2.strings[AUTHOR]
				if (string.len(author) == 0) then
					author = langtext("noauthor")
				elseif (string.len(author) > 24) then
					author = string.sub(author, 1, 21) .. "..."
				end
				
				local subtitle = editor2.strings[SUBTITLE]
				if (string.len(subtitle) == 0) then
					subtitle = langtext("editor_levelmenu_subtitle_none")
				end
				
				local vname = langtext("music_" .. editor2.strings[LEVELMUSIC],true,true)
				if (#vname == 0) then
					vname = editor2.strings[LEVELMUSIC]
				end
				
				local levelparts = langtext("particles_" .. editor2.strings[LEVELPARTICLES],true,true)
				if (string.len(levelparts) == 0) then
					levelparts = langtext("particles_none")
				end
				
				local pname = langtext("palettes_" .. MF_getpalettename(),true,true)
				if (#pname == 0) then
					pname = MF_getpalettename()
				end
				
				local sizetext = langtext("editor_levelmenu_levelwidth") .. " " .. tostring(roomsizex - 2) .. ", " .. langtext("editor_levelmenu_levelheight") .. " " .. tostring(roomsizey - 2)
				
				local max_width = 130
				local greatest_width = findmaxtextwidth({langtext("editor_levelmenu_name"), langtext("editor_levelmenu_author"), langtext("editor_levelmenu_subtitle"), langtext("editor_levelmenu_music"), langtext("editor_levelmenu_particles"), langtext("editor_levelmenu_palette"), langtext("editor_levelmenu_levelsize")})
				
				if (greatest_width > max_width) then
					lx = lx - (greatest_width - max_width)
				end
				
				writetext(langtext("editor_levelmenu_name"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(lname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_rename"),10,12)
				createbutton("rename",rx,y,2,blen,1,langtext("editor_levelmenu_rename"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_author"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(author,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changeauthor"),10,12)
				createbutton("author",rx,y,2,blen,1,langtext("editor_levelmenu_changeauthor"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_subtitle"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(subtitle,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changesubtitle"),10,12)
				createbutton("subtitle",rx,y,2,blen,1,langtext("editor_levelmenu_changesubtitle"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize * 1.5
				
				writetext(langtext("editor_levelmenu_music"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(vname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changemusic"),10,12)
				createbutton("music",rx,y,2,blen,1,langtext("editor_levelmenu_changemusic"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_particles"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(levelparts,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changeparticles"),10,12)
				createbutton("particles",rx,y,2,blen,1,langtext("editor_levelmenu_changeparticles"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_palette"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(pname,0,mx,y,name,false,nil,nil,nil,nil,nil,nil,true)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changepalette"),10,12)
				createbutton("palette",rx,y,2,blen,1,langtext("editor_levelmenu_changepalette"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_levelmenu_levelsize"),0,lx,y,name,false,nil,nil,{2,4})
				writetext(sizetext,0,mx,y,name,false)
				
				blen,toobig = getdynamicbuttonwidth(langtext("editor_levelmenu_changelevelsize"),10,12)
				createbutton("levelsize",rx,y,2,blen,1,langtext("editor_levelmenu_changelevelsize"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_levelmenu_disableparticles"),16)
				createbutton("disableparticles",x,y,2,blen,1,langtext("editor_levelmenu_disableparticles"),name,3,2,buttonid)
				makeselection({"","disableparticles"},generaldata5.values[LEVEL_DISABLEPARTICLES] + 1)
				
				y = y + f_tilesize * 1
				
				blen = getdynamicbuttonwidth(langtext("editor_levelmenu_disableruleeffect"),16)
				createbutton("disableruleeffect",x,y,2,blen,1,langtext("editor_levelmenu_disableruleeffect"),name,3,2,buttonid)
				makeselection({"","disableruleeffect"},generaldata5.values[LEVEL_DISABLERULEEFFECT] + 1)
				
				y = y + f_tilesize * 1
				
				blen = getdynamicbuttonwidth(langtext("editor_levelmenu_disableshake"),16)
				createbutton("disableshake",x,y,2,blen,1,langtext("editor_levelmenu_disableshake"),name,3,2,buttonid)
				makeselection({"","disableshake"},generaldata5.values[LEVEL_DISABLESHAKE] + 1)
				
				y = y + f_tilesize * 1.5
				
				local lia_max = 230
				local lia_width = gettextwidth(langtext("editor_levelmenu_autodelay"))
				local lia_offset = 0
				
				if (lia_width > lia_max) then
					lia_offset = lia_width - lia_max
				end
				
				writetext(langtext("editor_levelmenu_autodelay"),0,x - f_tilesize * 9.25 - lia_offset,y,name,false,2,true)
				slider("autodelay",x + f_tilesize * 0.75,y,8,{1,3},{1,4},buttonid,1,30,generaldata5.values[AUTO_DELAY])
				
				y = y + f_tilesize * 1.5
				
				if (generaldata.strings[BUILD] ~= "n") then
					local enableworlds = true
					local enableworlds_ = tonumber(MF_read("settings","editor","mode")) or 0
					if (enableworlds_ == 1) and (generaldata.strings[WORLD] ~= "levels") then
						enableworlds = false
					end
					blen = getdynamicbuttonwidth(langtext("editor_levelmenu_mapsetup"),16)
					createbutton("mapsetup",x,y,2,blen,1,langtext("editor_levelmenu_mapsetup"),name,3,2,buttonid,enableworlds)
					
					y = y + f_tilesize * 2
				end
			end,
		structure =
		{
			n = {
				{{"closemenu"},},
				{{"rename"},},
				{{"author"},},
				{{"subtitle"},},
				{{"music"},},
				{{"particles"},},
				{{"palette"},},
				{{"levelsize"},},
				{{"disableparticles"},},
				{{"disableruleeffect"},},
				{{"disableshake"},},
				{{"autodelay",-238},},
			},
			{
				{{"closemenu"},},
				{{"rename"},},
				{{"author"},},
				{{"subtitle"},},
				{{"music"},},
				{{"particles"},},
				{{"palette"},},
				{{"levelsize"},},
				{{"disableparticles"},},
				{{"disableruleeffect"},},
				{{"disableshake"},},
				{{"autodelay",-238},},
				{{"mapsetup"},},
			},
		}
	},
	editormenu =
	{
		button = "EditorMenuButton",
		escbutton = "closemenu",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				
				local x = screenw * 0.5
				local y = f_tilesize * 5.0
				
				local blen = getdynamicbuttonwidth(langtext("editor_menu_close"),16)
				createbutton("closemenu",x,y,2,blen,1,langtext("editor_menu_close"),name,3,1,buttonid)
				
				if (generaldata.strings[BUILD] ~= "n") then
					y = y + f_tilesize
					
					blen = getdynamicbuttonwidth(langtext("editor_menu_test"),16)
					createbutton("test",x,y,2,blen,1,langtext("editor_menu_test"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_test",true))
				end
				
				y = y + f_tilesize
				
				local levelfound = MF_findfile("Data/Worlds/" .. generaldata.strings[WORLD] .. "/" .. generaldata.strings[CURRLEVEL] .. ".ld")
				local disableupload = true
				if levelfound then
					disableupload = false
				end
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_upload"),16)
				createbutton("upload",x,y,2,blen,1,langtext("editor_menu_upload"),name,3,2,buttonid,disableupload,nil,langtext("tooltip_editor_menu_upload",true))
				
				y = y + f_tilesize * 1.5
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_themes"),16)
				createbutton("theme",x,y,2,blen,1,langtext("editor_menu_themes"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_theme",true))
				
				y = y + f_tilesize * 1.5
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_return"),16)
				createbutton("return",x,y,2,blen,1,langtext("editor_menu_return"),name,3,1,buttonid,nil,nil,langtext("tooltip_editor_menu_return",true))
				
				y = y + f_tilesize
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_returnfull"),16)
				createbutton("returnfull",x,y,2,blen,1,langtext("editor_menu_returnfull"),name,3,1,buttonid,nil,nil,langtext("tooltip_editor_menu_returnfull",true))
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_delete"),16)
				createbutton("delete",x,y,2,blen,1,langtext("editor_menu_delete"),name,3,2,buttonid,nil,nil,langtext("tooltip_editor_menu_delete",true))
				
				y = y + f_tilesize * 1
				
				local levels = MF_filelist("Data/Worlds/levels/","*.l")
				local disablecopy = false
				if (generaldata.strings[BUILD] == "n") and (#levels >= levellimit) then
					disablecopy = true
				end
				
				if disableupload then
					disablecopy = true
				end
				
				blen = getdynamicbuttonwidth(langtext("editor_menu_copy"),16)
				createbutton("copy",x,y,2,blen,1,langtext("editor_menu_copy"),name,3,2,buttonid,disablecopy,nil,langtext("tooltip_editor_menu_copy",true))
				
				y = y + f_tilesize * 1
				
				--createbutton("convert",x,y,2,16,1,"debug - old level conversion",name,3,2,buttonid)
			end,
		submenu_return =
			function(parent,name)
				MF_visible("EditorMenuButton",1)
				local x = f_tilesize * 0.5
				local y = f_tilesize * 0.5

				if (parent == "name") then
					MF_letterclear("editorname")
					writetext(generaldata.strings[LEVELNAME],0,x,y,"editorname",false,2,nil,nil,nil,nil,nil,true)
					MF_letterhide("editorname",1)
					--writetext(editor.strings[5],renamebuttonid,0,0,name,true)
				end
			end,
		structure =
		{
			{
				{{"closemenu"},},
				{{"test"},},
				{{"upload"},},
				{{"theme"},},
				{{"return"},},
				{{"returnfull"},},
				{{"delete"},},
				{{"copy"},},
			},
			n = {
				{{"closemenu"},},
				{{"upload"},},
				{{"theme"},},
				{{"return"},},
				{{"returnfull"},},
				{{"delete"},},
				{{"copy"},},
			},
		}
	},
	editorquickmenu =
	{
		button = "EditorQuickMenuButton",
		escbutton = "closemenu",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				MF_menubackground(true)
				
				local x = screenw * 0.5
				local y = f_tilesize * 6.5
				
				local blen = getdynamicbuttonwidth(langtext("editor_menu_close"),16)
				createbutton("closemenu",x,y,2,blen,2,langtext("editor_menu_close"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_savelevel"),16)
				createbutton("save",x,y,2,blen,2,langtext("editor_savelevel"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_testlevel"),16)
				createbutton("test",x,y,2,blen,2,langtext("editor_testlevel"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_settingsmenu"),16)
				createbutton("editorsettingsmenu",x,y,2,blen,2,langtext("editor_settingsmenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_quickmenu_editorsettingsmenu",true))
				
				y = y + f_tilesize * 2
				
				blen = getdynamicbuttonwidth(langtext("editor_editormenu"),16)
				createbutton("editormenu",x,y,2,blen,2,langtext("editor_editormenu"),name,3,2,buttonid,nil,nil,langtext("tooltip_quickmenu_editormenu",true))
			end,
		structure =
		{
			{
				{{"closemenu"},},
				{{"save"},},
				{{"test"},},
				{{"editorsettingsmenu"},},
				{{"editormenu"},},
			},
		}
	},
	musicload =
	{
		button = "MusicLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,page_)
				menudata_customscript.musiclist(parent,name,buttonid,page_)
			end,
	},
	particlesload =
	{
		button = "ParticlesLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.particleslist(parent,name,buttonid)
			end,
	},
	paletteload =
	{
		button = "PaletteLoad",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,page_)
				menudata_customscript.palettelist(parent,name,buttonid,page_)
			end,
	},
	levelsize =
	{
		button = "LevelSize",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 7.0
				
				local xoff = f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				x = f_tilesize * 5.0
				local bx = x + f_tilesize * 5.0
				y = y + f_tilesize * 3.5
				
				writetext(langtext("editor_levelsize_width"),0,x,y,name,false,2)
				
				y = y + f_tilesize
				
				createbutton("w--",bx - xoff * 2,y,2,2,1,"--",name,3,2,buttonid)
				createbutton("w-",bx - xoff * 0.5,y,2,2,1,"-",name,3,2,buttonid)
				createbutton("w+",bx + xoff,y,2,2,1,"+",name,3,2,buttonid)
				createbutton("w++",bx + xoff * 2.5,y,2,2,1,"++",name,3,2,buttonid)
				
				local wcountid = MF_specialcreate("Editor_counter")
				local wcount = mmf.newObject(wcountid)
				wcount.x = bx + xoff + f_tilesize * 4.5
				wcount.y = y
				wcount.values[COUNTER_VALUE] = roomsizex - 2
				wcount.strings[COUNTER_ID] = "levelw"
				wcount.values[6] = wcount.x
				wcount.values[7] = wcount.y
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_levelsize_height"),0,x,y,name,false,2)
				
				y = y + f_tilesize
				
				createbutton("h--",bx - xoff * 2,y,2,2,1,"--",name,3,2,buttonid)
				createbutton("h-",bx - xoff * 0.5,y,2,2,1,"-",name,3,2,buttonid)
				createbutton("h+",bx + xoff,y,2,2,1,"+",name,3,2,buttonid)
				createbutton("h++",bx + xoff * 2.5,y,2,2,1,"++",name,3,2,buttonid)
				
				local hcountid = MF_specialcreate("Editor_counter")
				local hcount = mmf.newObject(hcountid)
				hcount.x = bx + xoff + f_tilesize * 4.5
				hcount.y = y
				hcount.values[COUNTER_VALUE] = roomsizey - 2
				hcount.strings[COUNTER_ID] = "levelh"
				hcount.values[6] = hcount.x
				hcount.values[7] = hcount.y
				
				y = y + f_tilesize * 2
				
				createbutton("apply",bx,y,2,10,1,langtext("editor_levelsize_apply"),name,3,2,buttonid)
				
				x = screenw * 0.5
				y = y + f_tilesize * 3
				
				writetext(langtext("editor_levelsize_quick"),0,x,y,name,true,2)
				
				y = y + f_tilesize
				
				createbutton("s148",x + f_tilesize * -14,y,2,3,1,"12x6",name,3,2,buttonid)
				createbutton("s1710",x + f_tilesize * -10,y,2,3,1,"15x8",name,3,2,buttonid)
				createbutton("s1616",x + f_tilesize * -6,y,2,3,1,"14x14",name,3,2,buttonid)
				createbutton("s2616",x + f_tilesize * -2,y,2,3,1,"24x14",name,3,2,buttonid)
				createbutton("s3018",x + f_tilesize * 2,y,2,3,1,"28x16",name,3,2,buttonid)
				createbutton("s2020",x + f_tilesize * 6,y,2,3,1,"18x18",name,3,2,buttonid)
				createbutton("s2620",x + f_tilesize * 10,y,2,3,1,"24x18",name,3,2,buttonid)
				createbutton("s3520",x + f_tilesize * 14,y,2,3,1,"33x18",name,3,2,buttonid)
				
				local frameid = MF_specialcreate("Editor_levelsizeframe")
				local frame = mmf.newObject(frameid)
				
				x = screenw * 0.5 + f_tilesize * 7.0
				y = screenh * 0.5 + f_tilesize * 1.0
				
				frame.x = x
				frame.y = y
				frame.layer = 2
				
				frame.values[XPOS] = x
				frame.values[YPOS] = y
				
				local c1,c2 = getuicolour("edge")
				MF_setcolour(frameid, c1, c2)
				
				local wlineid1 = MF_specialcreate("Editor_levelsize_w")
				local wline1 = mmf.newObject(wlineid1)
				wline1.layer = 2
				
				local wlineid2 = MF_specialcreate("Editor_levelsize_w")
				local wline2 = mmf.newObject(wlineid2)
				wline2.layer = 2
				wline2.values[1] = 1
				
				local hlineid1 = MF_specialcreate("Editor_levelsize_h")
				local hline1 = mmf.newObject(hlineid1)
				hline1.layer = 2
				
				local hlineid2 = MF_specialcreate("Editor_levelsize_h")
				local hline2 = mmf.newObject(hlineid2)
				hline2.layer = 2
				hline2.values[1] = 1
				
				MF_setcolour(wlineid1, 2, 2)
				MF_setcolour(wlineid2, 2, 2)
				MF_setcolour(hlineid1, 2, 2)
				MF_setcolour(hlineid2, 2, 2)
			end,
		leave = 
			function(parent,name)
				MF_delete("LevelSize")
				MF_removecounter("levelw")
				MF_removecounter("levelh")
			end,
		structure =
		{
			{
				{{"return"},},
				{{"w--"},{"w-"},{"w+"},{"w++"},},
				{{"h--"},{"h-"},{"h+"},{"h++"},},
				{{"apply"},},
				{{"s148"},{"s1710"},{"s1616"},{"s2616"},{"s3018"},{"s2020"},{"s2620"},{"s3520"},},
			},
		}
	},
	mapsetup =
	{
		button = "MapSetupButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter =
			function(parent,name,buttonid)			
				local x = screenw * 0.5
				local leftx = f_tilesize * 2
				local y = f_tilesize * 3
				
				createbutton("return",x,y,2,8,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_map_leveltype"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				createbutton("islevel",screenw * 0.25,y,2,8,1,langtext("editor_map_level"),name,3,2,buttonid)
				createbutton("ismap",screenw * 0.75,y,2,8,1,langtext("editor_map_map"),name,3,2,buttonid)
				
				local leveltype = editor.values[LEVELTYPE] + 1
				makeselection({"islevel","ismap"},leveltype)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_map_clearlimit"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_map_clearlimit_hint"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				createbutton("y--",x - f_tilesize * 4,y,2,1,1,"<<",name,3,2,buttonid)
				createbutton("y-",x - f_tilesize * 2,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("y+",x + f_tilesize * 2,y,2,1,1,">",name,3,2,buttonid)
				createbutton("y++",x + f_tilesize * 4,y,2,1,1,">>",name,3,2,buttonid)
				
				local symbolid = MF_specialcreate("Editor_number")
				local symbol = mmf.newObject(symbolid)
				symbol.values[TYPE] = editor.values[UNLOCKCOUNT]
				symbol.x = x
				symbol.y = y
				symbol.layer = 3
				symbol.strings[GROUP] = "MapSetup"
				symbol.values[6] = symbol.x
				symbol.values[7] = symbol.y
				
				y = y + f_tilesize * 2
				
				createbutton("seticons",x,y,2,16,1,langtext("editor_map_mapicon"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_map_returnto"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				local blen = getdynamicbuttonwidth(langtext("editor_map_parentlevel"),8)
				createbutton("reset",x - f_tilesize * 6.5,y,2,blen,1,langtext("editor_map_parentlevel"),name,3,2,buttonid,nil,nil,nil,nil,true)
				
				blen = getdynamicbuttonwidth(langtext("editor_map_winlevel"),8)
				createbutton("win",x + f_tilesize * 6.5,y,2,blen,1,langtext("editor_map_winlevel"),name,3,2,buttonid,nil,nil,nil,nil,true)
				
				local customparent,cparentname = 1,langtext("editor_map_selectlevel")
				if (editor2.strings[CUSTOMPARENT] ~= "") and (editor2.strings[CUSTOMPARENT] ~= "<win>") then
					customparent,cparentname = 3,editor2.strings[CUSTOMPARENTNAME]
				elseif (editor2.strings[CUSTOMPARENT] == "<win>") then
					customparent,cparentname = 2,langtext("editor_map_selectlevel")
				end
				
				makeselection({"reset","win"},customparent)
				
				y = y + f_tilesize
				
				createbutton("changelevel",x,y,2,16,1,cparentname,name,3,2,buttonid,nil,nil,nil,nil,true)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"islevel"},{"ismap"},},
				{{"y--"},{"y-"},{"y+"},{"y++"},},
				{{"seticons"},},
				{{"reset"},{"win"}},
				{{"changelevel"},},
			},
		}
	},
	addlevel =
	{
		escbutton = "return",
		button = "AddLevel",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local leftx = f_tilesize * 10
				local y = f_tilesize * 1.5
				writetext(langtext("editor_level_levelsetup"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_level_leveltarget"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				
				local world = generaldata.strings[WORLD]
				local disable = false
				
				if (world == "levels") then
					disable = true
				end
				
				createbutton("changelevel",x,y,2,16,1,unit.strings[U_LEVELNAME],name,3,2,buttonid,disable)
				
				y = y + f_tilesize * 3
				
				writetext(langtext("editor_level_iconcolour"),0,leftx,y,name,false)
				
				y = y + f_tilesize * 1
				
				createbutton("setcolour",leftx + f_tilesize * 4,y,2,8,1,langtext("editor_level_setcolour"),name,3,2,buttonid)
				
				y = y + f_tilesize * 1
				
				createbutton("setclearcolour",leftx + f_tilesize * 4,y,2,8,1,langtext("editor_level_setclearcolour"),name,3,2,buttonid)
				
				local paletteid = MF_specialcreate("Editor_colourselector")
				local palette = mmf.newObject(paletteid)
				
				palette.layer = 2
				palette.x = screenw * 0.55
				palette.y = screenh * 0.3
				
				palette.values[3] = palette.x
				palette.values[4] = palette.y
				
				local palettefile,paletteroot = MF_getpalettedata()
				local palettepath = getpath(paletteroot) .. "Palettes/" .. palettefile
				
				palette.strings[1] = palettepath
				palette.strings[2] = "addlevel"
				
				MF_loadcolourselector(paletteid,palettepath)
				
				palette.scaleX = 24
				palette.scaleY = 24
				palette.values[PALETTE_WIDTH] = 7
				palette.values[PALETTE_HEIGHT] = 5
				
				y = y + f_tilesize * 3
				
				writetext(langtext("editor_level_initialstate"),0,leftx - f_tilesize * 3.5,y,name,false)
				createbutton("s1",leftx + f_tilesize * 5,y,2,3.5,1,langtext("editor_level_initialstate_hidden"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("s2",leftx + f_tilesize * 9.5,y,2,3.5,1,langtext("editor_level_initialstate_normal"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("s3",leftx + f_tilesize * 14,y,2,3.5,1,langtext("editor_level_initialstate_opened"),name,3,2,buttonid,nil,nil,nil,nil,true)
				
				makeselection({"s1","s2","s3"},unit.values[COMPLETED] + 1)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_level_levelsymbol"),0,leftx - f_tilesize * 3.5,y,name,false)
				createbutton("l1",leftx + f_tilesize * 4.5,y,2,2.5,1,langtext("editor_level_levelsymbol_none"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("l2",leftx + f_tilesize * 8.6,y,2,3.5,1,langtext("editor_level_levelsymbol_numbers"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("l3",leftx + f_tilesize * 12.6,y,2,2.5,1,langtext("editor_level_levelsymbol_text"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("l4",leftx + f_tilesize * 16.1,y,2,2.5,1,langtext("editor_level_levelsymbol_dots"),name,3,2,buttonid,nil,nil,nil,nil,true)
				createbutton("l5",leftx + f_tilesize * 19.4,y,2,2,1,"...",name,3,2,buttonid,nil,nil,nil,nil,true)
				
				local lselect = unit.values[VISUALSTYLE]
				if (lselect == -2) then
					lselect = -1
				elseif (lselect == -1) then
					lselect = 3
				end
				
				makeselection({"l1","l2","l3","l4","l5"},lselect + 2)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_level_levelsymbol_symbol"),0,leftx - f_tilesize * 3.5,y,name,false)
				createbutton("y--",leftx + f_tilesize * 3.75,y,2,1,1,"<<",name,3,2,buttonid)
				createbutton("y-",leftx + f_tilesize * 4.75,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("y+",leftx + f_tilesize * 7.75,y,2,1,1,">",name,3,2,buttonid)
				createbutton("y++",leftx + f_tilesize * 8.75,y,2,1,1,">>",name,3,2,buttonid)
				
				local symbolid = MF_specialcreate("Editor_levelnum")
				local symbol = mmf.newObject(symbolid)
				symbol.x = leftx + f_tilesize * 6.25
				symbol.y = y
				symbol.layer = 3
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("removelevel",x,y,2,16,1,langtext("editor_level_remove"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"changelevel"}},
				{{"setcolour"}},
				{{"setclearcolour"}},
				{{"s1"},{"s2"},{"s3"}},
				{{"l1"},{"l2"},{"l3"},{"l4"},{"l5"}},
				{{"y--","cursor"},{"y-","cursor"},{"y+","cursor"},{"y++","cursor"}},
				{{"return"}},
				{{"removelevel"}},
			}
		},
	},
	levelselect =
	{
		button = "LevelSelectButton",
		escbutton = "return",
		enter =
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				writetext(langtext("editor_level_leveltarget"),0,x,y,name,true,2)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,10,1,langtext("return"),name,3,1,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				y = y + f_tilesize * 1
				
				createbutton("sort",x - f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sort"),name,3,2,buttonid)
				createbutton("sorttypes",x + f_tilesize * 11,y,2,10,1,langtext("editor_levellist_sorttypes"),name,3,2,buttonid)
				
				makeselection({"","sort"},editor2.values[SORTING] + 1)
				makeselection({"","sorttypes"},editor2.values[SORTING_TYPES] + 1)
				
				table.insert(dynamic_structure, {{"sort"},{"sorttypes"}})
				
				local page = extra or 0
				page = MF_setpagemenu(name)
				local levels,maxpage,menustruct,page = createlevellist(buttonid,page)
				
				for i,v in ipairs(menustruct) do
					table.insert(dynamic_structure, v)
				end
				
				editor3.values[MAXPAGE] = maxpage
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"}})
				
					writetext(langtext("editor_levellist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				end
				
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name,buttonid)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				--updatebuttontext("changelevel",unit.strings[U_LEVELNAME],parent)
			end,
	},
	maplevelselect =
	{
		leave = 
			function(parent,name)
				MF_delete("LevelButton")
				MF_letterclear("leveltext")
				
				updatebuttontext("changelevel",editor2.strings[CUSTOMPARENTNAME],parent)
			end,
	},
	spriteselect =
	{
		button = "SpriteSelect",
		escbutton = "return",
		enter =
			function(parent,name,buttonid,extra)
				menudata_customscript.spritelist(parent,name,buttonid,extra)
			end,
		leave = 
			function(parent,name)
				MF_delete("SpriteButton")
				MF_letterclear("leveltext")
			end,
	},
	iconselect =
	{
		button = "IconButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local y_ = 0
				local dynamic_structure_row = {}
				local count = generaldata2.values[ICONCOUNT]
				
				for i=1,count do
					local iconid = MF_create("Editor_spritebutton")
					
					local x,y = iconlist(iconid,i-1)
					
					if (y ~= y_) then
						y_ = y
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
					
					table.insert(dynamic_structure_row, {tostring(i - 1), "cursor"})
					
					if (i == count) then
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	icons =
	{
		button = "IconButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local y_ = 0
				local dynamic_structure_row = {}
				local count = generaldata2.values[ICONCOUNT]
				
				for i=1,count do
					local iconid = MF_create("Editor_spritebutton")
					
					local x,y = iconlist(iconid,i-1)
					
					if (y ~= y_) then
						y_ = y
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
					
					table.insert(dynamic_structure_row, {tostring(i - 1), "cursor"})
					
					if (i == count) then
						table.insert(dynamic_structure, dynamic_structure_row)
						dynamic_structure_row = {}
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	deleteconfirm =
	{
		button = "DeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_delete_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	unsaved_confirm =
	{
		button = "UnsavedConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_unsaved_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	unsaved_confirmfull =
	{
		button = "UnsavedConfirmFull",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_unsaved_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	uploadlevel =
	{
		button = "UploadLevel",
		escbutton = "no",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4
				
				writetext(langtext("editor_upload_name") .. " $0,3" .. generaldata.strings[LEVELNAME],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_author") .. " $0,3" .. editor2.strings[AUTHOR],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_subtitle") .. " $0,3" .. editor2.strings[SUBTITLE],0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_upload_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_upload_confirm_note"),0,x,y,name,true,nil,nil,{0,2})
				
				y = y + f_tilesize * 1.5
				
				--writetext(langtext("editor_upload_confirm_hint"),0,x,y,name,true,nil,nil,{0,2})
				
				y = y + f_tilesize
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	upload_do =
	{
		button = "UploadDo",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5
				
				writetext(langtext("editor_upload_uploading"),0,x,y,name,true)
			end,
	},
	upload_done =
	{
		button = "UploadDone",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3.5
				
				MF_cursorvisible(1)
				
				local levelid,success,skipstoring = "",false,false
				
				if (extra ~= nil) and (#extra > 0) then
					levelid = extra[1]
					success = extra[2]
					skipstoring = extra[3] or false
				end
				
				if success then
					writetext(langtext("editor_upload_done"),0,x,y,name,true)
					
					y = y + f_tilesize * 2
					
					writetext(levelid,0,x,y,name,true)
					
					if (skipstoring == false) then
						storelevelcode(generaldata.strings[CURRLEVEL],levelid)
					end
				else
					writetext(langtext("editor_upload_failed"),0,x,y,name,true)
					
					y = y + f_tilesize * 2
					
					writetext(levelid,0,x,y,name,true)
				end
				
				if (generaldata.strings[BUILD] ~= "n") then
					y = y + f_tilesize * 2
					
					local disablecopy = true
					if success then disablecopy = false end
					
					createbutton("copy",x,y,2,16,1,langtext("editor_upload_copy"),name,3,2,buttonid,disablecopy)
					
					y = y + f_tilesize * 1
					
					writetext(langtext("editor_upload_copyhint"),0,x,y,name,true,nil,nil,{0,2})
				end
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			n = {
				{{"return"},},
			},
			{
				{{"copy"},},
				{{"return"},},
			},
		}
	},
	copyconfirm =
	{
		button = "CopyConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid,lname)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_copy_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_copy_confirm_name") .. " '" .. lname .. "'",0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	copydone =
	{
		button = "CopyDone",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_copy_done"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("ok",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	setpath =
	{
		button = "PathButton",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,targeted_)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 5
				
				writetext(langtext("editor_path_settings"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				local pathobj = getactualdata_objlist(editor.strings[PATHOBJECT],"name") or "unknown"
				
				local targeted = targeted_ or 0
				if (targeted == 1) then
					local unitid = editor.values[EDITTARGET]
					local unit = mmf.newObject(unitid)
					
					editor.values[PATHSTYLE] = unit.values[PATH_STYLE]
					editor.values[PATHGATE] = unit.values[PATH_GATE]
					editor.values[PATHREQUIREMENT] = unit.values[PATH_REQUIREMENT]
					pathobj = getactualdata_objlist(unit.strings[PATHOBJECT],"name") or "unknown"
				end
				
				writetext(langtext("editor_path_object") .. " " .. pathobj,0,x,y,name,true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("hidden",x - f_tilesize * 4,y,2,8,1,langtext("editor_path_pathstate_hidden"),name,3,2,buttonid)
				createbutton("visible",x + f_tilesize * 4,y,2,8,1,langtext("editor_path_pathstate_visible"),name,3,2,buttonid)
				
				makeselection({"hidden","visible"},editor.values[PATHSTYLE] + 1)
				
				y = y + f_tilesize * 2
				
				writetext(langtext("editor_path_locked"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				createbutton("s1",x - f_tilesize * 12,y,2,6,1,langtext("no"),name,3,2,buttonid)
				
				createbutton("s2",x - f_tilesize * 6,y,2,6,1,langtext("editor_path_locked_levels"),name,3,2,buttonid)
				
				createbutton("s3",x,y,2,6,1,langtext("editor_path_locked_maps"),name,3,2,buttonid)
				
				createbutton("s4",x + f_tilesize * 6,y,2,6,1,langtext("editor_path_locked_orbs"),name,3,2,buttonid)
				
				createbutton("s5",x + f_tilesize * 12,y,2,6,1,langtext("editor_path_locked_loclevels"),name,3,2,buttonid)
				
				makeselection({"s1","s2","s3","s4","s5"},editor.values[PATHGATE] + 1)
				
				y = y + f_tilesize * 1
				
				local symbolid = MF_specialcreate("Editor_number")
				local symbol = mmf.newObject(symbolid)
				symbol.x = x
				symbol.y = y
				symbol.layer = 3
				symbol.strings[GROUP] = "PathSetup"
				
				createbutton("y--",x - f_tilesize * 2,y,2,1,1,"<<",name,3,2,buttonid)
				createbutton("y-",x - f_tilesize * 1,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("y+",x + f_tilesize * 1,y,2,1,1,">",name,3,2,buttonid)
				createbutton("y++",x + f_tilesize * 2,y,2,1,1,">>",name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"hidden"},{"visible"}},
				{{"s1"},{"s2"},{"s3"},{"s4"},{"s5"}},
				{{"y--"},{"y-"},{"y+"},{"y++"}},
				{{"return"}},
			},
		},
	},
	objectedit =
	{
		button = "ObjectEditButton",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,unitname)
				local x = screenw * 0.5
				local y = f_tilesize * 2.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"}})
				
				local extended = false
				local extended_ = tonumber(MF_read("settings","editor","mode")) or 0
				if (extended_ == 1) then
					extended = true
				end
				
				y = y + f_tilesize * 1.5
				
				local realname = unitreference[unitname]
				local currname = getactualdata_objlist(realname,"name")
				local unittype = getactualdata_objlist(realname,"unittype")
				
				local unitid = MF_create(realname)
				local unit = mmf.newObject(unitid)
				
				unit.x = f_tilesize * 5
				unit.y = f_tilesize * 5
				unit.scaleX = 5
				unit.scaleY = 5
				unit.layer = 2
				editor.values[EDITTARGET] = unitid
				
				getmetadata(unit)
				if (changes[realname] ~= nil) then
					dochanges(unitid)
				end
				setcolour(unitid)
				
				if (extended == false) then
					y = y + f_tilesize * 1
				end
				
				x = screenw * 0.6
				
				writetext(tostring(currname) .. " (" .. tostring(realname) .. ") - " .. tostring(unittype),0,x,y,"objectinfo",true,nil,nil,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				createbutton("sprite",x,y,2,16,1,langtext("editor_object_sprite"),name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"sprite"}})
				
				if extended then
					y = y + f_tilesize * 1
					
					createbutton("name",x,y,2,16,1,langtext("editor_object_name"),name,3,2,buttonid)
					table.insert(dynamic_structure, {{"name"}})
					
					y = y + f_tilesize * 1
					
					createbutton("type",x,y,2,16,1,langtext("editor_object_type"),name,3,2,buttonid)
					table.insert(dynamic_structure, {{"type"}})
				
					y = y + f_tilesize * 1
				else
					y = y + f_tilesize * 2
				end
				
				x = screenw * 0.5
				
				writetext(langtext("editor_object_colour"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				local dynamic_structure_row = {}
				
				if (unittype == "text") then
					createbutton("colour",x - f_tilesize * 6.5,y,2,12,1,langtext("editor_object_colour_base"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"colour"})
					
					createbutton("acolour",x + f_tilesize * 6.5,y,2,12,1,langtext("editor_object_colour_active"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"acolour"})
				else
					createbutton("colour",x,y,2,12,1,langtext("editor_object_colour_onlybase"),name,3,2,buttonid)
					table.insert(dynamic_structure_row, {"colour"})
				end
				
				table.insert(dynamic_structure, dynamic_structure_row)
				
				if extended then
					y = y + f_tilesize * 1
					
					writetext(langtext("editor_object_animation"),0,x,y,name,true)
					
					y = y + f_tilesize * 1
					
					local w = 9
					
					local bw = w * f_tilesize + f_tilesize
					local bh = f_tilesize
					
					local ox = x - bw
					
					createbutton("a1",ox,y,2,w,1,langtext("editor_object_animation_none"),name,3,2,buttonid)
					createbutton("a2",ox + bw,y,2,w,1,langtext("editor_object_animation_dirs"),name,3,2,buttonid)
					createbutton("a3",ox + bw * 2,y,2,w,1,langtext("editor_object_animation_anim"),name,3,2,buttonid)
					createbutton("a4",ox,y + bh,2,w,1,langtext("editor_object_animation_animdirs"),name,3,2,buttonid)
					createbutton("a5",ox + bw,y + bh,2,w,1,langtext("editor_object_animation_character"),name,3,2,buttonid)
					createbutton("a6",ox + bw * 2,y + bh,2,w,1,langtext("editor_object_animation_tiled"),name,3,2,buttonid)
					
					table.insert(dynamic_structure, {{"a1"},{"a2"},{"a3"}})
					table.insert(dynamic_structure, {{"a4"},{"a5"},{"a6"}})
					
					local aselect = getactualdata(realname,"tiling")
					local changed = false
					
					MF_alert(unit.strings[NAME] .. ", " .. tostring(aselect) .. ", " .. tostring(realname))
					
					if (aselect == 4) and (changed == false) then
						aselect = 1
						changed = true
					elseif (aselect == 3) and (changed == false) then
						aselect = 2
						changed = true
					elseif (aselect == 2) and (changed == false) then
						aselect = 3
						changed = true
					elseif (aselect == 1) and (changed == false) then
						aselect = 4
						changed = true
					end
					
					makeselection({"a1","a2","a3","a4","a5","a6"},aselect + 2)
					
					y = y + f_tilesize * 2
					
					if (unittype == "text") then
						writetext(langtext("editor_object_text_type"),0,x,y,name,true)
					
						y = y + f_tilesize * 1
					
						w = 4.5
						bw = w * f_tilesize + f_tilesize
						
						ox = x - bw * 2.5
						
						createbutton("w1",ox,y,2,w,1,"baba",name,3,2,buttonid)
						createbutton("w2",ox + bw,y,2,w,1,"is",name,3,2,buttonid)
						createbutton("w3",ox + bw * 2,y,2,w,1,"you",name,3,2,buttonid)
						
						createbutton("w4",ox + bw * 3,y,2,w,1,"lonely",name,3,2,buttonid)
						createbutton("w5",ox + bw * 4,y,2,w,1,"on",name,3,2,buttonid)
						createbutton("w6",ox + bw * 5,y,2,w,1,"ba",name,3,2,buttonid)
						
						table.insert(dynamic_structure, {{"w1"},{"w2"},{"w3"},{"w4"},{"w5"},{"w6"}})
						
						local otype = getactualdata(realname,"type")
						makeselection({"w1","w2","w3","w4","","w6","","w5"},otype + 1)
						
						y = y + f_tilesize * 1
						
						writetext(langtext("editor_object_text_manualtype"),0,x,y,name,true)
						
						x = screenw * 0.5
						y = y + f_tilesize * 1
						
						createbutton("-",x - f_tilesize * 1,y,2,1,1,"<",name,3,2,buttonid)
						createbutton("+",x + f_tilesize * 1,y,2,1,1,">",name,3,2,buttonid)
						
						table.insert(dynamic_structure, {{"-","cursor"},{"+","cursor"}})
					
						local symbolid = MF_specialcreate("Editor_number")
						local symbol = mmf.newObject(symbolid)
						symbol.x = x
						symbol.y = y
						symbol.layer = 3
						symbol.values[1] = 0
						symbol.strings[OWNERMENU] = "objectedit"
						symbol.strings[GROUP] = "TextType"
						symbol.values[6] = x
						symbol.values[7] = y
						
						symbol.values[TYPE] = otype
						
						y = y + f_tilesize * 1
					end
				else
					y = y + f_tilesize * 2
				end
				
				x = screenw * 0.5
				
				writetext(langtext("editor_object_zlevel"),0,x,y,name,true)
				
				y = y + f_tilesize * 1
				
				createbutton("l-",x - f_tilesize * 1,y,2,1,1,"<",name,3,2,buttonid)
				createbutton("l+",x + f_tilesize * 1,y,2,1,1,">",name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"l-","cursor"},{"l+","cursor"}})
				
				local symbolid2 = MF_specialcreate("Editor_number")
				local symbol2 = mmf.newObject(symbolid2)
				symbol2.x = x
				symbol2.y = y
				symbol2.layer = 3
				symbol2.values[1] = -1
				symbol2.strings[OWNERMENU] = "objectedit"
				symbol2.strings[GROUP] = "ZLevel"
				symbol2.values[6] = x
				symbol2.values[7] = y
				
				symbol2.values[TYPE] = getactualdata(realname,"layer")
				
				y = y + f_tilesize * 1
				
				table.insert(dynamic_structure, {{"reset"}})
				
				createbutton("reset",x,y,2,16,1,langtext("editor_object_reset"),name,3,2,buttonid)
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_delete("ObjectEditButton")
				MF_letterclear("objectinfo",0)
			end,
		submenu_leave = 
			function(parent,name)
				MF_visible("ObjectEditButton",0)
				MF_letterclear("objectinfo",0)
			end,
		submenu_return = 
			function(parent,name)
				MF_visible("ObjectEditButton",1)
				
				local x = screenw * 0.6
				local y = f_tilesize * 4
				
				local unitid = editor.values[EDITTARGET]
				local unit = mmf.newObject(unitid)
				
				local currname = getactualdata_objlist(unit.className,"name")
				local realname = unit.className
				local unittype = getactualdata_objlist(unit.className,"unittype")
				
				unit.strings[UNITTYPE] = unittype
				
				writetext(currname .. " (" .. realname .. ") - " .. unittype,0,x,y,"objectinfo",true,nil,nil,nil,nil,nil,nil,true)
			end,
	},
	object_colour =
	{
		button = "ColourButton",
		escbutton = "return",
		enter =
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 2
				
				writetext(langtext("editor_object_colour_select"),0,x,y,name,true)
				
				y = y + f_tilesize
				
				local paletteid = MF_specialcreate("Editor_colourselector")
				local palette = mmf.newObject(paletteid)
				
				palette.layer = 2
				palette.x = screenw * 0.5
				palette.y = screenh * 0.5 - f_tilesize * 2.5
				
				palette.values[3] = palette.x
				palette.values[4] = palette.y
				
				local palettefile,paletteroot = MF_getpalettedata()
				local palettepath = getpath(paletteroot) .. "Palettes/" .. palettefile
				
				palette.strings[1] = palettepath
				palette.strings[2] = "object_colour"
				
				MF_loadcolourselector(paletteid,palettepath)
				
				palette.scaleX = 24
				palette.scaleY = 24
				palette.values[PALETTE_WIDTH] = 7
				palette.values[PALETTE_HEIGHT] = 5
				
				createbutton("return",x,y,2,8,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize
			end,
		leave = 
			function(parent,name)
				MF_delete("ColourButton")
			end,
		structure =
		{
			{
				{{"return"}},
			},
		},
	},
	themes =
	{
		button = "ThemeEditor",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 4.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("loadtheme",x,y,2,16,1,langtext("editor_theme_load"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("savetheme",x,y,2,16,1,langtext("editor_theme_save"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("deletetheme",x,y,2,16,1,langtext("editor_theme_delete"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				{{"loadtheme"},},
				{{"savetheme"},},
				{{"deletetheme"},},
			},
		}
	},
	themeload =
	{
		button = "ThemeLoad",
		escbutton = "return",
		slide = {1,0},
		enter = 
			function(parent,name,buttonid,extra)
				menudata_customscript.themelist(parent,name,buttonid,extra)
			end,
	},
	themeload_confirm =
	{
		button = "ThemeLoadConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_load_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize
				
				writetext(langtext("editor_theme_load_confirm_hint"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	themeload_confirm_newlevel =
	{
		button = "ThemeLoadConfirmNew",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_load_confirm_newlevel"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	themedelete =
	{
		button = "ThemeDelete",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid,extra)
				menudata_customscript.themelist(parent,name,buttonid,extra)
			end,
	},
	themedelete_confirm =
	{
		button = "EraseConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_delete_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	themesave_confirm =
	{
		button = "EraseConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("editor_theme_save_confirm"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	themeselect =
	{
		escbutton = "return",
		enter = 
			function(parent,name)
				local x = roomsizex * f_tilesize * 0.5 * spritedata.values[TILEMULT]
				local y = f_tilesize * 1.5
				writetext(langtext("editor_theme_use"),0,x,y,name,true,2)

				y = y + f_tilesize
				
				createbutton("return",x,y,2,16,1,langtext("editor_theme_return"),name,3,1,"ThemeButton")
			end,
		leave = 
			function(parent,name)
				MF_delete("ThemeButton")
				MF_delete("ThemeChoice")
				MF_letterclear("themes")
			end,
	},
	restartconfirm =
	{
		escbutton = "no",
		button = "RestartConfirm",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				local build = generaldata.strings[BUILD]
				
				if (build ~= "m") then
					writetext(langtext("restart_confirm"),0,x,y,name,true,2,true)
					
					y = y + f_tilesize * 1
					
					writetext(langtext("restart_tip"),0,x,y,name,true,2,true,{1,4})
				else
					y = screenh * 0.5 - f_tilesize * 4.5
					
					writetext(langtext("restart_confirm_m"),0,x,y,name,true,2,true)
					
					y = y + f_tilesize * 2
					
					writetext(langtext("restart_tip_m_1"),0,x,y,name,true,2,true,{1,4})
					
					y = y + f_tilesize * 1.5
					
					writetext(langtext("restart_tip_m_2"),0,x,y,name,true,2,true,{1,4})
				end
				
				if (build ~= "m") then
					y = y + f_tilesize * 2
				
					createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				else
					y = y + f_tilesize * 4
					
					createbutton("yes",x - f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.yes)
					createbutton("no",x + f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.no)
				end
			end,
		leave = 
			function(parent,name)
				MF_delete("RestartConfirm")
			end,
	},
	playlevels =
	{
		button = "PlayLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 8.5
				
				local currslot = generaldata2.values[SAVESLOT]
				local slotname = MF_read("settings","slotnames",tostring(currslot))
				if (#slotname == 0) then
					slotname = langtext("slot") .. " " .. tostring(currslot + 1)
				end
				
				writetext(langtext("slot_current") .. " $2,4" .. slotname,0,x,y,name,true,1)
				
				y = y + f_tilesize * 2
				
				local levels = MF_filelist("Data/Worlds/levels/","*.ld")
				local worlds = MF_dirlist("Data/Worlds/*")
				
				local enablelevels = false
				local enableworlds = false
				
				local enablelevels = true
				local enableworlds = true
				
				if (#levels > 0) then
					enablelevels = false
				end
				
				for i,v in ipairs(worlds) do
					local worldfolder = string.sub(v, 2, string.len(v) - 1)
					
					if (worldfolder ~= "levels") then
						enableworlds = false
					end
				end
				
				createbutton("customlevels_play_single",x,y,2,16,2,langtext("customlevels_play_singular"),name,3,2,buttonid,enablelevels)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_pack",x,y,2,16,2,langtext("customlevels_play_pack"),name,3,2,buttonid,enableworlds)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_get",x,y,2,16,2,langtext("customlevels_play_get"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_getlist",x,y,2,16,2,langtext("customlevels_play_getlist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2.5
				
				createbutton("slot_change",x,y,2,16,2,langtext("slot_change"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("customlevels_play_changename",x,y,2,16,2,langtext("customlevels_play_changename"),name,3,2,buttonid)
				
				if (generaldata.strings[BUILD] ~= "n") then
					y = y + f_tilesize * 2.5
					
					local disableerase = true
					if (editor2.values[EXTENDEDMODE] == 1) then
						disableerase = false
					end
					
					createbutton("customlevels_play_eraseslot",x,y,2,16,2,langtext("customlevels_play_eraseslot"),name,3,2,buttonid,disableerase)
				end
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"customlevels_play_single"},},
				{{"customlevels_play_pack"},},
				{{"customlevels_play_get"},},
				{{"customlevels_play_getlist"},},
				{{"slot_change"},},
				{{"customlevels_play_changename"},},
				{{"customlevels_play_eraseslot"},},
				{{"return"},},
			},
			n =
			{
				{{"customlevels_play_single"},},
				{{"customlevels_play_pack"},},
				{{"customlevels_play_get"},},
				{{"customlevels_play_getlist"},},
				{{"slot_change"},},
				{{"customlevels_play_changename"},},
				{{"return"},},
			},
		}
	},
	playlevels_single =
	{
		button = "PlayLevels_pack",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_single(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_pack =
	{
		button = "PlayLevels_pack",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_pack(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_featured =
	{
		button = "PlayLevels_featured",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,page)
				menudata_customscript.playlevels_featured(parent,name,buttonid,page)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("")
			end,
	},
	playlevels_featured_fail =
	{
		button = "FeaturedError",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("playlevels_featured_fail"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("playlevels_featured_fail_reason") .. " " .. editor2.strings[ERRORCODE],0,x,y,name,true,2,true)
			
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				editor4.strings[CURRMENUITEM] = "return"
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_getmenu =
	{
		button = "PlayLevelsGetMenu",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				y = y + f_tilesize * 3
				
				--[[
				createbutton("playlevels_get_newest",x,y,2,16,2,langtext("customlevels_play_singular"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				]]--
				
				createbutton("playlevels_get_featured",x,y,2,16,2,langtext("playlevels_get_featured"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("playlevels_get_code",x,y,2,16,2,langtext("playlevels_get_code"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
				--{{"playlevels_get_newest"},},
				{{"playlevels_get_featured"},},
				{{"playlevels_get_code"},},
			},
		}
	},
	playlevels_getlist =
	{
		button = "PlayLevels_getlist",
		escbutton = "return",
		slide = {1,0},
		enter = 
			function(parent,name,buttonid)
				menudata_customscript.playlevels_getlist(parent,name,buttonid)
			end,
	},
	playlevels_get_wait =
	{
		button = "PlayLevelsGetWait",
		enter = 
			function(parent,name,buttonid,page)
				local x = screenw * 0.5
				local y = screenh * 0.5
				
				writetext(langtext("customlevels_get_wait"),0,x,y,name,true,2,true)
			end,
	},
	playlevels_get_success =
	{
		button = "PlayLevelsGetSuccess",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4.5
				
				writetext(langtext("customlevels_get"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				local lname = extra[1]
				local lauthor = extra[2]
				local lsubtitle = extra[3]
				
				local levels = MF_filelist("Data/Worlds/levels/","*.l")
				local disablesave = false
				if (generaldata.strings[BUILD] == "n") and (#levels >= levellimit) then
					disablesave = true
				end
				
				writetext(langtext("editor_upload_name") .. " $0,3" .. lname,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_author") .. " $0,3" .. lauthor,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_subtitle") .. " $0,3" .. lsubtitle,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("get_save",x,y,2,16,2,langtext("customlevels_get_save"),name,3,2,buttonid,disablesave)
				
				y = y + f_tilesize * 2
				
				createbutton("get_nosave",x,y,2,16,2,langtext("customlevels_get_nosave"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("customlevels_get_cancel"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"get_save"},},
				{{"get_nosave"},},
				{{"return"},},
			},
		}
	},
	playlevels_get_play =
	{
		button = "PlayLevelsGetPlay",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4.5
				
				writetext(langtext("customlevels_get_saved"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 2
				
				local lname = extra[1]
				local lauthor = extra[2]
				local lsubtitle = extra[3]
				
				writetext(langtext("editor_upload_name") .. " $0,3" .. lname,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_author") .. " $0,3" .. lauthor,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("editor_upload_subtitle") .. " $0,3" .. lsubtitle,0,x,y,name,true,2,true,nil,nil,nil,nil,true)
				
				y = y + f_tilesize * 2
				
				createbutton("get_play",x,y,2,16,2,langtext("customlevels_get_play"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("get_levellist",x,y,2,16,2,langtext("customlevels_get_levellist"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("editor_levellist",x,y,2,16,2,langtext("editor_start_level"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"get_play"},},
				{{"get_levellist"},},
				{{"editor_levellist"},},
				{{"return"},},
			},
		}
	},
	playlevels_get_fail =
	{
		button = "PlayLevelsGetFail",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("customlevels_get_fail"),0,x,y,name,true,2,true)
				
				y = y + f_tilesize * 1
				
				writetext(langtext("customlevels_get_fail_reason") .. " " .. editor2.strings[ERRORCODE],0,x,y,name,true,2,true,nil,nil,nil,nil,true)
			
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_eraseslot =
	{
		button = "PlayLevelsEraseConfirm",
		escbutton = "no",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("erase_confirm"),0,x,y,name,true,2,true)
				y = y + f_tilesize * 1
				writetext(langtext("customlevels_play_eraseslot_tip"),0,x,y,name,true,2,true,{1,4})
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	start_new =
	{
		button = "NewStartMenu",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				local worlds = MF_dirlist("Data/Worlds/*")
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "levels") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "baba") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "baba_m") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "debug") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "new_adv_m") then
						table.remove(worlds, i)
						break
					end
				end
				
				table.insert(worlds, 1, "_baba_")
				
				local bworld = generaldata.strings[BASEWORLD]
				local currslot = generaldata2.values[SAVESLOT]
				MF_setfile("save",tostring(currslot) .. "ba.ba")
				
				local slotname = MF_read("settings","slotnames",tostring(currslot))
				if (#slotname == 0) then
					slotname = langtext("slot") .. " " .. tostring(currslot + 1)
				end
				
				writetext(langtext("slot_current"),0,x,y,name,true,1)
				
				y = y + f_tilesize * 1
				
				writetext(slotname,0,x,y,name,true,1,nil,{2,4})
				
				y = y + f_tilesize * 1
				
				writetext(langtext("customlevels_pack"),0,x,y,name,true,1)
				
				y = y - f_tilesize * 1
				
				editor2.values[MENU_YDIM] = math.max(0, #worlds - 1)
				
				local actual_i = 1
				
				local page = page_ or 0
				page = MF_setpagemenu(name)
				local amount = 3
				local maxpage = math.floor((#worlds-1) / amount)
				page = math.min(page, maxpage)
				
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
				
				local dynamic_structure = {}
				local curr_dynamic_structure = {}
				
				local x_ = 0
				local y_ = 0
				
				if (#worlds > 0) then
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					
					y = y + f_tilesize * 3
					
					for i=page_min,page_max do
						local v = worlds[i + 1]
						local worldfolder = string.sub(v, 2, string.len(v) - 1)
						
						if (worldfolder ~= "levels") then
							MF_setfile("world","Data/Worlds/" .. worldfolder .. "/world_data.txt")
							
							local worldfolder_ = tostring(actual_i) .. "," .. worldfolder
							
							local prizes = tonumber(MF_read("save",worldfolder .. "_prize","total")) or 0
							local clears = tonumber(MF_read("save",worldfolder .. "_clears","total")) or 0
							local bonus = tonumber(MF_read("save",worldfolder .. "_bonus","total")) or 0
							local timeplayed = tonumber(MF_read("save",worldfolder,"time")) or 0
							local win = tonumber(MF_read("save",worldfolder,"end")) or 0
							local done = tonumber(MF_read("save",worldfolder,"done")) or 0
							
							local p_max = tonumber(MF_read("world","general","prize_max")) or 9999
							local c_max = tonumber(MF_read("world","general","clear_max")) or 9999
							local b_max = tonumber(MF_read("world","general","bonus_max")) or 9999
							
							local minutes = string.sub("00" .. tostring(math.floor(timeplayed / 60) % 60), -2)
							local hours = tostring(math.floor(timeplayed / 3600))
							
							local desc = ""
							
							if (timeplayed > 0) then						
								if (generaldata4.values[CUSTOMFONT] == 0) then
									desc = desc .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "🤣  " .. tostring(clears) .. "¤"
								else
									desc = desc .. hours .. ":" .. minutes .. "💀  " .. tostring(prizes) .. "😈  " .. tostring(clears) .. "😠"
								end
							
								if (bonus > 0) then
									desc = desc .. "  (+" .. tostring(bonus) .. ")"
								end
							else
								desc = langtext("customlevels_pack_emptysave")
							end
							
							local worldname = MF_read("world","general","name")
							local worldauthor = MF_read("world","general","author")
							
							if (#worldfolder > 0) and (string.len(langtext("world_" .. string.lower(worldfolder),true,true)) > 0) then
								worldname = langtext("world_" .. string.lower(worldfolder),true,true)
							end
							
							if (string.len(worldname) == 0) then
								worldname = langtext("world_unknown")
							elseif (string.len(worldname) > 38) then
								worldname = string.sub(worldname, 1, 35) .. "..."
							end
							
							if (string.len(worldauthor) == 0) then
								worldauthor = langtext("noauthor")
							elseif (string.len(worldauthor) > 38) then
								worldauthor = string.sub(worldauthor, 1, 35) .. "..."
							end
							
							local yoffset = 0
							if (string.lower(worldauthor) == "hempuli") then
								yoffset = f_tilesize * 0.25
							end
							
							local leftoffset = f_tilesize * 9.1
							local bid = createbutton(worldfolder_,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,24,3,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
							writetext(worldname,0,x + x_ * 17 * f_tilesize - leftoffset,y + y_ * 3 * f_tilesize - f_tilesize * 0.8 + yoffset,name,false,2,nil,{0,3},nil,1,nil,true)
							
							if (yoffset == 0) then
								writetext(langtext("by") .. " " .. worldauthor,0,x + x_ * 17 * f_tilesize - leftoffset,y + y_ * 3 * f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
							end
							
							writetext(desc,0,x + x_ * 17 * f_tilesize - leftoffset,y + y_ * 3 * f_tilesize + f_tilesize * 0.8 - yoffset,name,false,2,nil,{0,3},nil,1,nil,true)
							
							local iconpath = "Worlds/" .. worldfolder .. "/"
							local imagefile = "icon"
							
							local icon_exists = MF_findfile("Data/" .. iconpath .. imagefile .. ".png")
							
							if icon_exists then
								MF_thumbnail(iconpath,imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 10.5,0,buttonid,"")
							end
							
							local ix = 0
							
							for j=1,3 do
								if ((j == 1) and (win > 0)) or ((j == 2) and (done > 0)) or ((j == 3) and (prizes >= p_max) and (clears >= c_max) and (bonus >= b_max)) then
									local iconid = MF_create("Hud_completionicon")
									local icon = mmf.newObject(iconid)
									
									icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 10.7 - ix
									icon.y = y + y_ * 3 * f_tilesize
									icon.layer = 2
									icon.strings[GROUP] = buttonid
									icon.values[XPOS] = icon.x
									icon.values[YPOS] = icon.y
									
									if (j == 1) then
										--icon.direction = 0
										--icon.y = icon.y - f_tilesize * 0.75
										icon.values[COUNTER_VALUE] = 0
										ix = ix + f_tilesize * 1.5
									elseif (j == 2) then
										--icon.direction = 4
										--icon.y = icon.y - f_tilesize * 0.75
										--icon.x = icon.x - f_tilesize * 1.5
										icon.values[COUNTER_VALUE] = 4
										ix = ix + f_tilesize * 1.5
									elseif (j == 3) then
										--icon.direction = 4
										--icon.y = icon.y - f_tilesize * 0.75
										--icon.x = icon.x - f_tilesize * 3
										icon.values[COUNTER_VALUE] = 5
										ix = ix + f_tilesize * 1.5
									end
									
									icon.values[XPOS] = icon.x
									icon.values[YPOS] = icon.y
									icon.values[BUTTON_STOREDX] = icon.x
									icon.values[BUTTON_STOREDY] = icon.y
								end
							end
							
							table.insert(curr_dynamic_structure, {worldfolder_})
							
							y_ = y_ + 1
							
							if (i < page_max) then
								table.insert(dynamic_structure, {})
								curr_dynamic_structure = dynamic_structure[#dynamic_structure]
							end
							
							actual_i = actual_i + 1
						end
					end
				end
				
				editor2.values[MENU_XDIM] = 1
				
				-- Korjaa tämä
				editor2.values[MENU_YDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				y = screenh - f_tilesize * 5.5
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,y,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
				end
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				x = screenw * 0.5
				y = screenh - f_tilesize * 3
				
				if (maxpage == 0) then
					y = screenh - f_tilesize * 5.5
				end
				
				local blen,toobig = getdynamicbuttonwidth(langtext("customlevels_forget"),8,11)
				createbutton("remove",x + f_tilesize * 11.5,y,2,blen,2,langtext("customlevels_forget"),name,3,2,buttonid,disableremove,nil,nil,nil,nil,nil,nil,toobig)
				
				blen,toobig = getdynamicbuttonwidth(langtext("slot_change"),8,11)
				createbutton("slot_change",x - f_tilesize * 11.5,y,2,blen,2,langtext("slot_change"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				
				blen,toobig = getdynamicbuttonwidth(langtext("customlevels_play_changename"),8,11)
				createbutton("slot_rename",x,y,2,blen,2,langtext("customlevels_play_changename"),name,3,2,buttonid,nil,nil,nil,nil,nil,nil,nil,toobig)
				makeselection({"","remove"},editor.values[STATE] + 1)
				
				table.insert(dynamic_structure, {{"slot_change"},{"slot_rename"},{"remove"}})
				
				y = y + f_tilesize * 1.5
				
				local disableremove = false
				if (#worlds == 0) then
					disableremove = true
				end
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
				
				table.insert(dynamic_structure, {{"return"}})
				
				buildmenustructure(dynamic_structure)
			end,
		structure =
		{
			{
				{{"s1"},},
				{{"s2"},},
				{{"s3"},},
				{{"return"},},
				{{"erase"},},
			},
			m =
			{
				{{"s1"},{"s2"},{"s3"},},
				{{"return"},{"erase"},},
			},
		}
	},
	m_levelpacks =
	{
		button = "NewStartMenu",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = f_tilesize * 1.5
				
				local worlds = MF_dirlist("Data/Worlds/*")
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "levels") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "baba") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "baba_m") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "debug") then
						table.remove(worlds, i)
						break
					end
				end
				
				for i,v_ in ipairs(worlds) do
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v == "new_adv") then
						table.remove(worlds, i)
						break
					end
				end
				
				table.insert(worlds, 1, "_baba_m_")
				
				local bworld = generaldata.strings[BASEWORLD]
				
				y = y + f_tilesize * 1
				
				writetext(langtext("customlevels_pack"),0,x,y,name,true,1)
				
				editor2.values[MENU_YDIM] = math.max(0, #worlds - 1)
				
				local actual_i = 1
				
				local page = page_ or 0
				page = MF_setpagemenu(name)
				local amount = 3
				local maxpage = math.floor((#worlds-1) / amount)
				page = math.min(page, maxpage)
				
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
				
				local dynamic_structure = {}
				local curr_dynamic_structure = {}
				
				local x_ = 0
				local y_ = 0
				
				if (#worlds > 0) then
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					
					y = y + f_tilesize * 3
					
					for i=page_min,page_max do
						local v = worlds[i + 1]
						local worldfolder = string.sub(v, 2, string.len(v) - 1)
						
						if (worldfolder ~= "levels") then
							MF_setfile("world","Data/Worlds/" .. worldfolder .. "/world_data.txt")
							
							local worldfolder_ = tostring(actual_i) .. "," .. worldfolder
							
							local worldname = MF_read("world","general","name")
							
							if (#worldfolder > 0) and (string.len(langtext("world_" .. string.lower(worldfolder),true,true)) > 0) then
								worldname = langtext("world_" .. string.lower(worldfolder),true,true)
							end
							
							if (worldfolder == "baba_m") then
								worldname = "Baba Is You"
							end
							
							if (string.len(worldname) == 0) then
								worldname = langtext("world_unknown")
							elseif (string.len(worldname) > 38) then
								worldname = string.sub(worldname, 1, 35) .. "..."
							end
							
							local leftoffset = f_tilesize * 9.1
							local yoffset = f_tilesize * 1
							local bid = createbutton(worldfolder_,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,24,3,worldname,name,3,2,buttonid,nil,nil,nil,nil,nil,true)
							
							local iconpath = "Worlds/" .. worldfolder .. "/"
							local imagefile = "icon"
							
							local icon_exists = MF_findfile("Data/" .. iconpath .. imagefile .. ".png")
							
							if icon_exists then
								MF_thumbnail(iconpath,imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 10.5,0,buttonid,"")
							end
							
							table.insert(curr_dynamic_structure, {worldfolder_})
							
							y_ = y_ + 1
							
							if (i < page_max) then
								table.insert(dynamic_structure, {})
								curr_dynamic_structure = dynamic_structure[#dynamic_structure]
							end
							
							actual_i = actual_i + 1
						end
					end
				end
				
				editor2.values[MENU_XDIM] = 1
				
				-- Korjaa tämä
				editor2.values[MENU_YDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				y = screenh - f_tilesize * 5.5
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,y,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,y,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
				end
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				x = screenw * 0.5
				y = screenh - f_tilesize * 3
				
				if (maxpage == 0) then
					y = screenh - f_tilesize * 4
				end
				
				createbutton("return",x,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_return)
				
				table.insert(dynamic_structure, {{"return"}})
				
				buildmenustructure(dynamic_structure)
			end,
		structure =
		{
		}
	},
	slots =
	{
		button = "SlotMenu",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * f_tilesize
				
				local world = generaldata.strings[BASEWORLD]
				local cworld = generaldata.strings[WORLD]
				local build = generaldata.strings[BUILD]
				
				if (build == "m") then
					y = y - f_tilesize * 1
					
					if (cworld == "baba") then
						cworld = "baba_m"
					end
					
					MF_setfile("world","Data/Worlds/" .. cworld .. "/world_data.txt")
					world = cworld
				else
					MF_setfile("world","Data/Worlds/baba/world_data.txt")
				end
				
				writetext(langtext("slots_select"),0,x,y,name,true,2,true)

				y = y + f_tilesize * 2.5
				
				for saveslot=1,3 do
					local savefile = tostring(saveslot - 1) .. "ba.ba"
					MF_setfile("save",savefile)
					local prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
					local clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
					local bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
					local timer = tonumber(MF_read("save",world,"time")) or 0
					local win = tonumber(MF_read("save",world,"end")) or 0
					local done = tonumber(MF_read("save",world,"done")) or 0
					
					local p_max = tonumber(MF_read("world","general","prize_max")) or 9999
					local c_max = tonumber(MF_read("world","general","clear_max")) or 9999
					local b_max = tonumber(MF_read("world","general","bonus_max")) or 9999
				
					local minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
					local hours = tostring(math.floor(timer / 3600))
				
					local slotname = langtext("slot") .. " " .. tostring(saveslot)
				
					if (build ~= "m") then
						if (prizes > 0) then
							slotname = ""
							
							if (generaldata4.values[CUSTOMFONT] == 0) then
								slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "🤣  " .. tostring(clears) .. "¤"
							else
								slotname = slotname .. hours .. ":" .. minutes .. "💀  " .. tostring(prizes) .. "😈  " .. tostring(clears) .. "😠"
							end
						end
					
						if (bonus > 0) then
							slotname = slotname .. "  (+" .. tostring(bonus) .. ")  "
						end
						
						if (win > 0) then
							slotname = slotname .. "  "
						end
						
						if (done > 0) then
							slotname = slotname .. "  "
						end
					else
						if (prizes > 0) then
							slotname = ""
							
							if (generaldata4.values[CUSTOMFONT] == 0) then
								slotname = slotname .. tostring(prizes) .. "🤣 " .. tostring(clears) .. "¤ "
							else
								slotname = slotname .. tostring(prizes) .. "😈 " .. tostring(clears) .. "😠 "
							end
						end
					end
					
					local buttoncode = "s" .. tostring(saveslot)
					
					if (build ~= "m") then
						createbutton(buttoncode,x,y,2,16,2,slotname,name,3,2,buttonid)
					else
						editor2.values[MENU_XPOS] = 0
						editor2.values[MENU_YPOS] = 0
						
						local w = f_tilesize * 9
						x = screenw * 0.5 - w + w * (saveslot - 1)
						y = screenh * 0.5 - f_tilesize
						createbutton(buttoncode,x,y,2,8,6,"",name,3,2,buttonid)
						
						local extray = 0
						
						if (win == 0) and (done == 0) and (bonus == 0) and (prizes > 0) then
							extray = f_tilesize * 0.9
						end
						
						writetext(slotname,0,x,y + extray,name,true,2,nil,{0,3},nil,1)
						
						if (prizes > 0) then
							if (generaldata4.values[CUSTOMFONT] == 0) then
								writetext(hours .. ":" .. minutes .. "£",0,x - 4,y - f_tilesize * 1.8 + extray,name,true,2,nil,{0,3},nil,1)
							else
								writetext(hours .. ":" .. minutes .. "💀",0,x - 4,y - f_tilesize * 1.8 + extray,name,true,2,nil,{0,3},nil,1)
							end
						end
						
						if (bonus > 0) then
							writetext("+" .. tostring(bonus),0,x - f_tilesize * 3.5,y + f_tilesize * 1.7,name,false,2,nil,{0,3},nil,1)
						end
						
						x = screenw * 0.5
					end
					
					local ix = 0
					
					for j=1,4 do
						if ((j == 1) and (win > 0)) or ((j == 2) and (done > 0)) or ((j == 3) and (prizes >= p_max) and (clears >= c_max) and (bonus >= b_max)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.x = x + f_tilesize * 7.2 - ix
							icon.y = y
							
							local extra = 0
							
							if (build == "m") then
								local w = f_tilesize * 9
								x = screenw * 0.5 - w + w * (saveslot - 1) + f_tilesize * 2.8 - ix
								y = screenh * 0.5 - f_tilesize + f_tilesize * 1.8
								
								icon.x = x
								icon.y = y
								extra = 0.2
							end
							
							if (j == 1) then
								--icon.direction = 0
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 1
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 4
							elseif (j == 3) then
								--icon.direction = 2
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 5
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					if (build ~= "m") then
						y = y + f_tilesize * 2
					end
				end
				
				MF_setfile("save","ba.ba")
				
				if (build ~= "m") then
					y = y + f_tilesize * 0.5
					
					createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("erase",x,y,2,16,1,langtext("slots_erase"),name,3,2,buttonid)
				else
					x = screenw * 0.5
					y = y + f_tilesize * 6
					
					createbutton("return",x - f_tilesize * 4,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_return)
					createbutton("erase",x + f_tilesize * 4,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_erase)
				end
			end,
		structure =
		{
			{
				{{"s1"},},
				{{"s2"},},
				{{"s3"},},
				{{"return"},},
				{{"erase"},},
			},
			m =
			{
				{{"s1"},{"s2"},{"s3"},},
				{{"return"},{"erase"},},
			},
		}
	},
	slots_erase =
	{
		button = "SlotEraseMenu",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * f_tilesize
				
				local bworld = generaldata.strings[BASEWORLD]
				local world = generaldata.strings[WORLD]
				local build = generaldata.strings[BUILD]
				
				if (build == "m") then
					y = y - f_tilesize * 1
					MF_setfile("world","Data/Worlds/" .. world .. "/world_data.txt")
				else
					MF_setfile("world","Data/Worlds/" .. world .. "/world_data.txt")
				end
				
				writetext(langtext("erase_select"),0,x,y,name,true,2,true)

				y = y + f_tilesize * 2.5
				
				for saveslot=1,3 do
					local savefile = tostring(saveslot - 1) .. "ba.ba"
					MF_setfile("save",savefile)
					local prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
					local clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
					local bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
					local timer = tonumber(MF_read("save",world,"time")) or 0
					local win = tonumber(MF_read("save",world,"end")) or 0
					local done = tonumber(MF_read("save",world,"done")) or 0
					
					local p_max = tonumber(MF_read("world","general","prize_max")) or 9999
					local c_max = tonumber(MF_read("world","general","clear_max")) or 9999
					local b_max = tonumber(MF_read("world","general","bonus_max")) or 9999
				
					local minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
					local hours = tostring(math.floor(timer / 3600))
				
					local slotname = langtext("slot") .. " " .. tostring(saveslot)
				
					if (build ~= "m") then
						if (prizes > 0) then
							slotname = ""
							
							if (generaldata4.values[CUSTOMFONT] == 0) then
								slotname = slotname .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "🤣  " .. tostring(clears) .. "¤"
							else
								slotname = slotname .. hours .. ":" .. minutes .. "💀  " .. tostring(prizes) .. "😈  " .. tostring(clears) .. "😠"
							end
						end
					
						if (bonus > 0) then
							slotname = slotname .. "  (+" .. tostring(bonus) .. ")  "
						end
						
						if (win > 0) then
							slotname = slotname .. "  "
						end
						
						if (done > 0) then
							slotname = slotname .. "  "
						end
					else
						editor2.values[MENU_XPOS] = 0
						editor2.values[MENU_YPOS] = 0
						
						if (prizes > 0) then
							slotname = ""
							
							if (generaldata4.values[CUSTOMFONT] == 0) then
								slotname = slotname .. tostring(prizes) .. "🤣 " .. tostring(clears) .. "¤ "
							else
								slotname = slotname .. tostring(prizes) .. "😈 " .. tostring(clears) .. "😠 "
							end
						end
					end
					
					local buttoncode = tostring(saveslot - 1) .. "ba"
					
					if (build ~= "m") then
						createbutton(buttoncode,x,y,2,16,2,slotname,name,2,2,buttonid)
					else
						local w = f_tilesize * 9
						x = screenw * 0.5 - w + w * (saveslot - 1)
						y = screenh * 0.5 - f_tilesize
						createbutton(buttoncode,x,y,2,8,6,"",name,2,2,buttonid)
						
						local extray = 0
						
						if (win == 0) and (done == 0) and (bonus == 0) and (prizes > 0) then
							extray = f_tilesize * 0.9
						end
						
						writetext(slotname,0,x,y + extray,name,true,2,nil,{0,3},nil,1)
						
						if (prizes > 0) then
							if (generaldata4.values[CUSTOMFONT] == 0) then
								writetext(hours .. ":" .. minutes .. "£",0,x - 4,y - f_tilesize * 1.8 + extray,name,true,2,nil,{0,3},nil,1)
							else
								writetext(hours .. ":" .. minutes .. "💀",0,x - 4,y - f_tilesize * 1.8 + extray,name,true,2,nil,{0,3},nil,1)
							end
						end
						
						if (bonus > 0) then
							writetext("+" .. tostring(bonus),0,x - f_tilesize * 3.5,y + f_tilesize * 1.7 + extray,name,false,2,nil,{0,3},nil,1)
						end
						
						x = screenw * 0.5
					end
					
					local ix = 0
					
					for j=1,4 do
						if ((j == 1) and (win > 0)) or ((j == 2) and (done > 0)) or ((j == 3) and (prizes >= p_max) and (clears >= c_max) and (bonus >= b_max)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.x = x + f_tilesize * 7.2 - ix
							icon.y = y
							
							local extra = 0
							
							if (build == "m") then
								local w = f_tilesize * 9
								x = screenw * 0.5 - w + w * (saveslot - 1) + f_tilesize * 2.8 - ix
								y = screenh * 0.5 - f_tilesize + f_tilesize * 1.8
								
								icon.x = x
								icon.y = y
								extra = 0.2
							end
							
							if (j == 1) then
								--icon.direction = 0
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 1
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 4
							elseif (j == 3) then
								--icon.direction = 2
								ix = ix + f_tilesize * (1.2 + extra)
								icon.values[COUNTER_VALUE] = 5
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					if (build ~= "m") then
						y = y + f_tilesize * 2
					end
				end
				
				MF_setfile("save","ba.ba")
				
				y = y + f_tilesize * 0.5
				
				if (build ~= "m") then
					createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
				else
					x = screenw * 0.5
					y = y + f_tilesize * 6
					
					createbutton("return",x,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_return)
				end
			end,
		structure =
		{
			{
				{{"0ba"},},
				{{"1ba"},},
				{{"2ba"},},
				{{"return"},},
			},
			m =
			{
				{{"0ba"},{"1ba"},{"2ba"},},
				{{"return"},},
			},
		}
	},
	eraseconfirm =
	{
		button = "EraseConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				local extra = 1
				local build = generaldata.strings[BUILD]
				local econfirm = "erase_confirm"
				local etip = "erase_tip"
				
				if (build == "m") then
					extra = 2
					econfirm = "erase_confirm_mobile"
					etip = "erase_tip_mobile"
				end
				
				writetext(langtext(econfirm),0,x,y,name,true,2,true)
				y = y + f_tilesize * 1 * extra
				writetext(langtext(etip),0,x,y,name,true,2,true,{1,4})
				
				if (build ~= "m") then
					y = y + f_tilesize * 2
					
					createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
					
					editor4.strings[CURRMENUITEM] = "no"
				else
					x = screenw * 0.5
					y = y + f_tilesize * 6
					
					createbutton("no",x - f_tilesize * 4,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_return)
					createbutton("yes",x + f_tilesize * 4,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_erase)
					
					editor4.strings[CURRMENUITEM] = "no"
				end
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
			m = {
				{{"no"},{"yes"},},
			},
		}
	},
	watchintro =
	{
		button = "IntroConfirm",
		escbutton = "cancel",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 4
				
				local build = generaldata.strings[BUILD]
				
				if (build == "m") then
					y = screenh * 0.5 - f_tilesize * 5
				end
				
				writetext(langtext("intro_confirm"),0,x,y,name,true,2,true)
				
				if (build ~= "m") then
					y = y + f_tilesize * 2
					
					createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					createbutton("cancel",x,y,2,16,1,langtext("cancel"),name,3,2,buttonid)
				else
					y = y + f_tilesize * 4
					
					createbutton("yes",x - f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.yes)
					createbutton("no",x + f_tilesize * 7,y,2,5,5,"",name,3,2,buttonid,nil,nil,nil,bicons.no)
					
					y = y + f_tilesize * 6
					
					createbutton("cancel",x,y,2,4,4,"",name,3,2,buttonid,nil,nil,nil,bicons.m_return)
				end
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
				{{"cancel"},},
			},
			m = {
				{{"yes"},{"no"},},
				{{"cancel"},},
			},
		}
	},
	slots_playlevels =
	{
		button = "PlayLevelSlotMenu",
		escbutton = "return",
		slide = {0,1},
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = 5 * f_tilesize
				
				local world = generaldata.strings[BASEWORLD]
				
				writetext(langtext("slots_select"),0,x,y,name,true,2,true)

				y = y + f_tilesize * 2.5
				
				for saveslot=1,3 do
					local savefile = tostring(saveslot - 1) .. "ba.ba"
					MF_setfile("save",savefile)
					prizes = tonumber(MF_read("save",world .. "_prize","total")) or 0
					clears = tonumber(MF_read("save",world .. "_clears","total")) or 0
					bonus = tonumber(MF_read("save",world .. "_bonus","total")) or 0
					timer = tonumber(MF_read("save",world,"time")) or 0
					win = tonumber(MF_read("save",world,"end")) or 0
					done = tonumber(MF_read("save",world,"done")) or 0
					
					minutes = string.sub("00" .. tostring(math.floor(timer / 60) % 60), -2)
					hours = tostring(math.floor(timer / 3600))
					
					slotname = langtext("slot") .. " " .. tostring(saveslot)
					
					local fullslotname = MF_read("settings","slotnames",tostring(saveslot - 1))
					
					if (string.len(fullslotname) > 0) then
						slotname = slotname .. " - " .. fullslotname
					end
					
					local buttoncode = tostring(saveslot)
					createbutton(buttoncode,x,y,2,16,2,slotname,name,3,2,buttonid)
					
					y = y + f_tilesize * 2
				end
				
				MF_setfile("save","ba.ba")
				
				y = y + f_tilesize * 0.5
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			end,
		structure =
		{
			{
				{{"1"},},
				{{"2"},},
				{{"3"},},
				{{"return"},},
			},
		}
	},
	languages =
	{
		button = "LanguageMenu",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 6
				
				if (generaldata.strings[BUILD] == "m") then
					y = y - f_tilesize * 3
				end
				
				writetext(langtext("lang_setup"),0,x,y,name,true,2,true)
				
				local langs = MF_filelist("Data/Languages/","*.txt")
				
				y = y + f_tilesize * 2
				
				local selection = 0
				local options = {}
				
				local m_mult = 1
				local m_mult2 = 1
				if (generaldata.strings[BUILD] == "m") then
					m_mult = 1.75
					m_mult2 = 1.5
				end
				
				x = x - f_tilesize * 6 * m_mult2
				local x_ = 0
				
				local dynamic_structure = {{}}
				local dynamic_structure_y = 1
				local dynamic_structure_x = dynamic_structure[dynamic_structure_y]
				
				for c,d in ipairs(langs) do
					MF_setfile("lang",d)
					
					local buttonname = string.sub(d, 1, string.len(d) - 4)
					local langname = MF_read("lang","general","name")
					
					if (generaldata4.values[CUSTOMFONT] == 0) then
						langname = string.lower(langname)
					end
					
					createbutton(buttonname,x + x_ * 12 * f_tilesize * m_mult2,y,2,10 * m_mult2,1 * m_mult,langname,name,3,2,buttonid)
					
					if (generaldata.strings[LANG] == string.sub(buttonname, 6)) then
						selection = c
					end
					
					table.insert(options, buttonname)
					
					table.insert(dynamic_structure_x, {buttonname})
					
					x_ = x_ + 1
					if (x_ > 1) and (c < #langs) then
						x_ = 0
						y = y + f_tilesize * m_mult
						
						table.insert(dynamic_structure, {})
						dynamic_structure_y = dynamic_structure_y + 1
						dynamic_structure_x = dynamic_structure[dynamic_structure_y]
					end
				end
				
				makeselection(options,selection)
				
				MF_setfile("lang","lang_" .. generaldata.strings[LANG] .. ".txt")
				
				x = screenw * 0.5
				y = y + f_tilesize * m_mult
				
				createbutton("return",x,y,2,16 * m_mult2,1 * m_mult,langtext("return"),name,3,2,buttonid)
				
				editor2.values[MENU_XDIM] = 1
				editor2.values[MENU_YDIM] = math.floor(#langs / 2) + 1
				
				table.insert(dynamic_structure, {{"return"}})
				buildmenustructure(dynamic_structure)
			end,
	},
	enterlevel_multiple =
	{
		button = "MultipleLevels",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				local x = screenw * 0.5
				local y = f_tilesize * 4.5
				
				local build = generaldata.strings[BUILD]
				
				if (build ~= "m") then
					createbutton("return",x,y,2,16,1,langtext("return"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2
					
					writetext(langtext("enterlevel_multiple"),0,x,y,name,true,2)
					
					y = y + f_tilesize * 1
					
					editor2.values[MENU_YDIM] = #extra
					
					for i,v in ipairs(extra) do
						y = y + f_tilesize * 1
						
						local levelunit = v[1]
						local levelfile = v[3]
						
						local lunit = mmf.newObject(levelunit)
						
						local levelname = ""
						
						if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
							levelname = langtext(levelfile,true)
						else
							levelname = langtext(generaldata.strings[WORLD] .. "_" .. levelfile,true)
						end
						
						if (levelname == "not found") then
							levelname = v[2]
						end
						
						local blen,toobig = getdynamicbuttonwidth(levelname,16)
						
						createbutton(tostring(i) .. "," .. fixed_to_str(levelunit),x,y,2,blen,1,levelname,name,3,2,buttonid)
					end
				else
					y = f_tilesize * 4
					
					createbutton("return",x,y,2,16,3,langtext("return"),name,3,2,buttonid)
					
					y = y + f_tilesize * 2.5
					
					writetext(langtext("enterlevel_multiple_m"),0,x,y,name,true,2)
					
					y = y - f_tilesize * 0.5
					
					editor2.values[MENU_YDIM] = #extra
					
					for i,v in ipairs(extra) do
						y = y + f_tilesize * 3
						
						local levelunit = v[1]
						local levelname = v[2]
						local blen,toobig = getdynamicbuttonwidth(levelname,16)
						blen = blen * 1.5
						
						createbutton(tostring(i) .. "," .. fixed_to_str(levelunit),x,y,2,blen,3,levelname,name,3,2,buttonid)
					end
				end
			end,
	},
	objlist =
	{
		button = "EditorObjectList",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,extra)
				editor2.values[OBJLISTTYPE] = 0
				editor_objects_build(nil,nil)
				
				local x = 2
				local y = 2
				
				local dynamic_structure = {}
				
				createbutton("return",6 * f_tilesize,y * f_tilesize,2,6,1,langtext("return"),name,3,1,buttonid)
				
				table.insert(dynamic_structure, {{"return"}})
				
				y = 3
				
				local deletesearchdisable = false
				if (string.len(objlistdata.search) == 0) then
					deletesearchdisable = true
				end
				
				local blen,toobig = getdynamicbuttonwidth(langtext("editor_objectlist_search_edit"),8,12)
				local blen2,toobig2 = getdynamicbuttonwidth(langtext("editor_objectlist_search_remove"),8,12)
				local blen3,toobig3 = getdynamicbuttonwidth(langtext("editor_objectlist_tags_select"),6,12)
				
				createbutton("search_edit",3 * f_tilesize + (blen * 0.5) * f_tilesize,y * f_tilesize,2,blen,1,langtext("editor_objectlist_search_edit"),name,3,2,buttonid)
				createbutton("search_remove",3 * f_tilesize + (blen + blen2 * 0.5 + 1) * f_tilesize,y * f_tilesize,2,blen2,1,langtext("editor_objectlist_search_remove"),name,3,2,buttonid,deletesearchdisable)
				createbutton("search_tags",3 * f_tilesize + (blen + blen2 + blen3 * 0.5 + 2) * f_tilesize,y * f_tilesize,2,blen3,1,langtext("editor_objectlist_tags_select"),name,3,2,buttonid)
				
				table.insert(dynamic_structure, {{"search_edit"},{"search_remove"},{"search_tags"}})
				
				y = 4
				
				local subline = ""
				
				if (string.len(objlistdata.search) > 0) then
					subline = langtext("editor_objectlist_result") .. " '" .. objlistdata.search .. "'"
					
					if (#objlistdata.tags > 0) then
						subline = subline .. ", "
					end
				end
				
				if (#objlistdata.tags > 0) then
					if (#objlistdata.tags == 1) then
						subline = subline .. langtext("editor_objectlist_tag") .. " "
					else
						subline = subline .. langtext("editor_objectlist_tags") .. " "
					end
					
					for i,v in ipairs(objlistdata.tags) do
						subline = subline .. v
						
						if (i < #objlistdata.tags) then
							subline = subline .. ", "
						end
					end
				end
				
				if (string.len(subline) == 0) then
					subline = langtext("editor_objectlist_search_none")
				end
				
				writetext(subline,0,3 * f_tilesize,y * f_tilesize,name,false,2,nil,nil,nil,nil,nil,true)
				
				y = 3.5
				
				local xdim = (screenw - f_tilesize * 4) / (f_tilesize * 2)
				
				local pagesize = 60
				local page = extra or 0
				page = MF_setpagemenu(name)
				local maxpage = math.ceil(#editor_objects / pagesize)
				local minobj = page * pagesize + 1
				local maxobj = math.min((page + 1) * pagesize, #editor_objects)
				
				editor3.values[MAXPAGE] = maxpage
				
				local dynamic_structure_row = {}
				
				local total = #editor_currobjlist
				local disableall = false
				if (total >= 150) then
					disableall = true
				end
				
				local i_ = 1
				
				if (#editor_objects > 0) then
					for i=minobj,maxobj do
						local id = editor_objects[i]["objlistid"]
						local v = editor_objlist[id]
						
						local inuse = false
						if (objlistdata.objectreference[id] ~= nil) then
							inuse = true
						end
						
						if disableall then
							inuse = true
						end
						
						local bid = createbutton_objlist(tostring(id),x * (f_tilesize * 2),y * (f_tilesize * 2),name,3,2,buttonid,nil,inuse)
						--local bid = createbutton(tostring(i),x * (f_tilesize * 2),y * (f_tilesize * 2),2,2,2,"<empty>",name,3,2,buttonid)
						
						local imagefile = v.sprite or v.name
						local c = v.colour_active or v.colour
						local c1 = c[1] or 0
						local c2 = c[2] or 3
						
						if inuse then
							c1 = 0
							c2 = 1
						end
						
						local imagepath = "Sprites/"
						
						if (v.sprite_in_root ~= nil) and (v.sprite_in_root == false) then
							imagepath = "Worlds/" .. generaldata.strings[WORLD] .. "/Sprites/"
						end
						
						imagefile = imagefile .. "_0_1"
						MF_thumbnail(imagepath,imagefile,i_-1,0,0,bid,c1,c2,0,0,buttonid,"")
						
						table.insert(dynamic_structure_row, {tostring(id),"cursor"})
						
						x = x + 1
						i_ = i_ + 1
						
						if (x > xdim + 1) then
							x = 2
							y = y + 1
							
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
						
						if (i == maxobj) and (#dynamic_structure_row > 0) then
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
					end
				else
					editor4.strings[CURRMENUITEM] = "search_tags"
				end
				
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage - 1) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 1) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"}})
				
					writetext(langtext("editor_objectlist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				end
				
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("EditorObjectList")
			end,
	},
	objlist_update =
	{
		button = "EditorObjectList_update",
		enter = 
			function(parent,name,buttonid,extra)
				MF_clearthumbnails("")
			end,
	},
	objlist_tags =
	{
		button = "EditorObjectList_tags",
		escbutton = "return",
		slide = {1,0},
		slide_leave = {-1,0},
		enter = 
			function(parent,name,buttonid)
				local x = 2
				local y = 2
				
				createbutton("return",6 * f_tilesize,2 * f_tilesize,2,8,1,langtext("return"),name,3,1,buttonid)
				
				local blen,toobig = getdynamicbuttonwidth(langtext("editor_objectlist_tags_cleartags"),8)
				createbutton("cleartags",11 * f_tilesize + (blen * 0.5) * f_tilesize,2 * f_tilesize,2,blen,1,langtext("editor_objectlist_tags_cleartags"),name,3,1,buttonid)
				
				local dynamic_structure = {}
				table.insert(dynamic_structure, {{"return"},{"cleartags"}})
				
				y = 3
				
				writetext(langtext("editor_objectlist_tags_select"),0,x * f_tilesize,y * f_tilesize,name,false,2)
				
				x = 0.75
				y = 4
				
				local xdim = (screenw - f_tilesize * 16) / (f_tilesize * 8)
				
				local tagdata = objlistdata.tags
				if (editor2.values[OBJLISTTYPE] == 1) then
					tagdata = objlistdata.tags_currobjlist
				end
				
				local dynamic_structure_row = {}
				
				for i,tag in ipairs(objlistdata.alltags) do
					if (tag ~= "special") then
						local tag_ = langtext("tag_" .. tag)
						if (tag_ == "not found") then
							tag_ = tag
						end
						
						local used = 0
						for a,b in ipairs(tagdata) do
							if (b == tag) then
								used = 1
							end
						end
						
						s,c = gettoggle(used)
						
						blen,toobig = getdynamicbuttonwidth(tag_,8,9,8)
						local bid = createbutton("tag," .. tag,x * f_tilesize * 8,y * f_tilesize,2,8,1,tag_,name,3,2,buttonid,nil,s,nil,nil,nil,nil,nil,toobig)
						
						table.insert(dynamic_structure_row, {"tag," .. tag, "longcursor"})
						
						x = x + 1
						
						if (x >= xdim + 2) then
							x = 0.75
							y = y + 1
							
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
						
						if (i == #objlistdata.alltags) and (#dynamic_structure_row > 0) then
							table.insert(dynamic_structure, dynamic_structure_row)
							dynamic_structure_row = {}
						end
					end
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	currobjlist =
	{
		button = "CurrentObjectList",
		escbutton = "editor_return",
		enter = 
			function(parent,name,buttonid,extra)
				editor2.values[OBJLISTTYPE] = 1
				editor_objects_build(nil,nil)
				
				local total = #editor_objects
				local total_ = #editor_currobjlist
				
				local ymult = 1.5
				
				local x_ = 1.5 * f_tilesize
				local y_ = 2 * f_tilesize
				
				local dynamic_structure = {}
				
				createbutton("tool_normal",x_,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_normal",true),bicons.t_pen,true)
				createbutton("tool_line",x_ + f_tilesize * 2,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_line",true),bicons.t_line,true)
				createbutton("tool_rectangle",x_ + f_tilesize * 4,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_rectangle",true),bicons.t_rect,true)
				createbutton("tool_fillrectangle",x_ + f_tilesize * 6,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fillrectangle",true),bicons.t_frect,true)
				createbutton("tool_select",x_ + f_tilesize * 8,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_select",true),bicons.t_select,true)
				createbutton("tool_fill",x_ + f_tilesize * 10,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_fill",true),bicons.t_fill,true)
				createbutton("tool_erase",x_ + f_tilesize * 12,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_tool_erase",true),bicons.t_erase,true)
				
				local selected_tool = editor2.values[EDITORTOOL]
				
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},selected_tool + 1)
				
				local searchdisable = true
				if (total_ > 1) then
					searchdisable = false
				end
				
				local deletesearchdisable = searchdisable
				
				if (string.len(objlistdata.search_currobjlist) == 0) then
					deletesearchdisable = true
				end
				
				createbutton("search_edit",x_ + f_tilesize * 14.5,y_,2,2,2,"",name,3,2,buttonid,searchdisable,nil,langtext("tooltip_currobjlist_search_edit",true),bicons.search)
				createbutton("search_remove",x_ + f_tilesize * 16.5,y_,2,2,2,"",name,3,2,buttonid,deletesearchdisable,nil,langtext("tooltip_currobjlist_search_remove",true),bicons.rsearch)
				createbutton("search_tags",x_ + f_tilesize * 18.5,y_,2,2,2,"",name,3,2,buttonid,searchdisable,nil,langtext("tooltip_currobjlist_search_tags",true),bicons.tags)
				
				ymult = ymult + 1
				
				local atlimit = false
				if (total_ >= 150) then
					atlimit = true
				end
				createbutton("add",x_ + f_tilesize * 21,y_,2,2,2,"",name,3,2,buttonid,atlimit,nil,langtext("tooltip_currobjlist_add",true),bicons.o_add)
				
				local removedisable = true
				if (total_ > 0) then
					removedisable = false
				end
				
				createbutton("remove",x_ + f_tilesize * 23,y_,2,2,2,"",name,3,2,buttonid,removedisable,nil,langtext("tooltip_currobjlist_remove",true),bicons.o_del)
				createbutton("editobject",x_ + f_tilesize * 25,y_,2,2,2,"",name,3,2,buttonid,removedisable,nil,langtext("tooltip_currobjlist_editobject",true),bicons.o_edit)
				
				local pair_option_names = {"l_separate", "l_pairs"}
				local pair_option = editor2.values[DOPAIRS] + 1
				local pair_option_ = pair_option_names[pair_option]
				
				--createbutton("nothing",24.5 * f_tilesize,ymult * f_tilesize - f_tilesize,2,8,1,langtext("editor_objectlist_nothing"),name,3,2,buttonid)
				createbutton("dopairs",x_ + f_tilesize * 27.5,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dopairs",true),bicons[pair_option_])
				
				local this_structure = {{"tool_normal","cursor"},{"tool_line","cursor"},{"tool_rectangle","cursor"},{"tool_fillrectangle","cursor"},{"tool_select","cursor"},{"tool_fill","cursor"},{"tool_erase","cursor"},{"search_edit","cursor"},{"search_remove","cursor"},{"search_tags","cursor"},{"add","cursor"},{"remove","cursor"},{"editobject","cursor"},{"dopairs","cursor"}}
				
				if (pair_option == 2) then
					createbutton("swap",x_ + f_tilesize * 29.5,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_swap",true),bicons.swap)
					table.insert(this_structure, {"swap","cursor"})
				end
				
				if (generaldata.strings[BUILD] ~= "n") then
					table.insert(this_structure, {"editor_return","cursor"})
					createbutton("editor_return",x_ + f_tilesize * 32,y_,2,2,2,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_return",true),bicons.cross)
				end
				
				table.insert(dynamic_structure, this_structure)
				
				ymult = ymult + 1
				
				local subline = ""
				
				if (editor4.values[EDITOR_TUTORIAL] == 0) then
					if (string.len(objlistdata.search_currobjlist) > 0) then
						subline = langtext("editor_objectlist_result") .. " '" .. objlistdata.search_currobjlist .. "'"
						
						if (#objlistdata.tags_currobjlist > 0) then
							subline = subline .. ", "
						end
					end
					
					if (#objlistdata.tags_currobjlist > 0) then
						if (#objlistdata.tags_currobjlist == 1) then
							subline = subline .. langtext("editor_objectlist_tag") .. " "
						else
							subline = subline .. langtext("editor_objectlist_tags") .. " "
						end
						
						for i,v in ipairs(objlistdata.tags_currobjlist) do
							subline = subline .. v
							
							if (i < #objlistdata.tags_currobjlist) then
								subline = subline .. ", "
							end
						end
					end
					
					if (string.len(subline) == 0) then
						subline = langtext("editor_objectlist_search_none")
					end
				
					writetext(subline,0,1.5 * f_tilesize,ymult * f_tilesize,name,false,2,nil,nil,nil,nil,nil,true)
				end
				
				local xmaxdim = 15
				local ymaxdim = 9
				
				local yoff = ymult * f_tilesize
				local xoff = f_tilesize * 0.5 + 6
				local tsize = 36
				
				for a=1,xmaxdim do
					for b=1,(ymaxdim+1) do
						local backid = MF_currobjlist_back(xoff + a * tsize, yoff + b * tsize, 1)
					end
				end
				
				if (total > 0) then
					local x = 1
					local y = 1
					
					local ydim = math.floor(math.sqrt(total))
					local xdim = math.floor(total / ydim)
					
					ydim = math.min(ymaxdim, ydim)
					local maxtotal = xdim * ydim
					
					while (total > maxtotal) do
						xdim = xdim + 1
						maxtotal = xdim * ydim
					end
					
					local struct = {}
					
					MF_setobjlisttopleft(tsize + xoff,tsize + yoff)
					
					for i=1,total do
						local iddata = editor_objects[i]
						local id = iddata.objlistid
						local oid = iddata.databaseid
						
						local gx = x
						local gy = y
						
						local obj = editor_currobjlist[oid]
						
						if (editor2.values[DOPAIRS] == 1) then
							if (obj.grid_overlap ~= nil) then
								local gridpos = obj.grid_overlap
								gx = gridpos[1] + 1
								gy = gridpos[2] + 1
							end
						elseif (editor2.values[DOPAIRS] == 0) then
							if (obj.grid_full ~= nil) then
								local gridpos = obj.grid_full
								gx = gridpos[1] + 1
								gy = gridpos[2] + 1
							end
						end
						
						local v = editor_objlist[id]
						local name = getactualdata_objlist(obj.object, "name")
						
						local objword = editor2.values[OBJECTWORDSWAP]
						local objwords = {["object"] = 0, ["text"] = 1}
						local ut = objwords[v.unittype] or 0
						local valid = true
						
						if (editor2.values[DOPAIRS] == 1) and ((v.unpaired == nil) or (v.unpaired == false)) and ((obj.pair ~= nil) and (obj.pair ~= 0)) then
							if (v.type == 0) and (ut ~= objword) then
								valid = false
							end
						end
						
						if valid then
							local buttonfunc = tostring(oid) .. "," .. name .. "," .. tostring(i)
							local bid = createbutton_objlist(buttonfunc,gx * tsize + xoff,gy * tsize + yoff,name,3,2,buttonid,2)
							MF_setbuttongrid(bid,gx - 1,gy - 1,obj.object)
							
							local imagefile = getactualdata_objlist(obj.object, "sprite")
							local ut = getactualdata_objlist(obj.object, "unittype")
							local root = getactualdata_objlist(obj.object, "sprite_in_root")
							local c = {}
							
							if (ut == "object") then
								c = getactualdata_objlist(obj.object, "colour")
							elseif (ut == "text") then
								c = getactualdata_objlist(obj.object, "active")
							end
							
							if (root == nil) then
								root = true
							end
							
							local c1 = c[1] or 0
							local c2 = c[2] or 3
							
							local folder = "Sprites/"
							
							if (root == false) then
								local world = generaldata.strings[WORLD]
								folder = "Worlds/" .. world .. "/Sprites/"
							end
							
							--MF_alert(name .. ", " .. obj.object .. ", " .. imagefile)
							imagefile = imagefile .. "_0_1"
							MF_thumbnail(folder,imagefile,i-1,0,0,bid,c1,c2,0,0,buttonid,obj.object)
							
							x = x + 1
							
							if (x > xdim) then
								x = 1
								y = y + 1
							end
						end
					end
				end
				
				if (generaldata.strings[BUILD] ~= "n") then
					local dir = editor.values[EDITORDIR]
					
					local dir_x = screenw - f_tilesize * 5
					local dir_y = f_tilesize * 7.6
					
					createbutton("dir_right",dir_x + f_tilesize * 2.5,dir_y,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_right",true),bicons.r_arrow)
					createbutton("dir_up",dir_x,dir_y - f_tilesize * 2.5,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_up",true),bicons.u_arrow)
					createbutton("dir_left",dir_x - f_tilesize * 2.5,dir_y,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_left",true),bicons.l_arrow)
					createbutton("dir_down",dir_x,dir_y + f_tilesize * 2.5,2,2.5,2.5,"",name,3,2,buttonid,nil,nil,langtext("tooltip_currobjlist_dir_down",true),bicons.d_arrow)
					
					makeselection({"dir_right","dir_up","dir_left","dir_down"},dir + 1)
				end
				
				local dir_x = screenw - f_tilesize * 5
				local dir_y = f_tilesize * 4.6
				
				--table.insert(dynamic_structure, {{"currobjlist","custom"}})
				
				local x = screenw - f_tilesize * 7
				local y = f_tilesize * 14.5
				
				if (generaldata.strings[BUILD] ~= "n") then
					controlicon_editor("gamepad_currobjlist","tooltip",x,y,buttonid,langtext("buttons_currobjlist_tooltip",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","swap",x,y,buttonid,langtext("buttons_currobjlist_swap",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","drag",x,y,buttonid,langtext("buttons_currobjlist_drag",true))
					
					y = y - f_tilesize * 1.25
					
					controlicon_editor("gamepad_currobjlist","select",x,y,buttonid,langtext("buttons_currobjlist_select",true))
				else
					x = screenw - f_tilesize * 5
					y = f_tilesize * 13
					
					controlicon_editor("gamepad_currobjlist","x",x,y - f_tilesize,buttonid,"buttons_currobjlist",1,true)
					controlicon_editor("gamepad_currobjlist","y",x - f_tilesize,y,buttonid,"buttons_currobjlist",2,true)
					controlicon_editor("gamepad_currobjlist","b",x,y + f_tilesize,buttonid,"buttons_currobjlist",3,true)
					controlicon_editor("gamepad_currobjlist","a",x + f_tilesize,y,buttonid,"buttons_currobjlist",0,true)
				end
				
				x = screenw - f_tilesize * 6
				y = f_tilesize * 4
				
				controlicon_editor("gamepad_currobjlist","scrollleft",x - f_tilesize,y,buttonid,langtext("buttons_currobjlist_scrollleft",true),2)
				controlicon_editor("gamepad_currobjlist","scrollright",x + f_tilesize,y,buttonid,langtext("buttons_currobjlist_scrollright",true),0)
				
				controlicon_editor("gamepad_currobjlist","autoadd",x - f_tilesize,y + f_tilesize * 2,buttonid,langtext("buttons_currobjlist_autoadd",true),2)
				controlicon_editor("gamepad_editor","scrollright_tool",x + f_tilesize,y + f_tilesize * 2,buttonid,langtext("buttons_currobjlist_removesearch",true),0)
				
				dir_y = f_tilesize * 5 + f_tilesize * 5
				
				if (editor2.values[EXTENDEDMODE] == 1) then
					dir_y = dir_y + f_tilesize * 4 + f_tilesize * 2
					
					local world = generaldata.strings[WORLD]
					local tooldisable = false
					if (world == "levels") then
						tooldisable = true
					end
					
					createbutton("brush_normal",dir_x,dir_y,2,8,1,langtext("editor_brush_normal"),name,3,2,buttonid)
					createbutton("brush_level",dir_x,dir_y + f_tilesize * 1,2,8,1,langtext("editor_brush_level"),name,3,2,buttonid,tooldisable)
					createbutton("brush_path",dir_x - f_tilesize * 0.5,dir_y + f_tilesize * 2,2,7,1,langtext("editor_brush_path"),name,3,2,buttonid)
					createbutton("brush_special",dir_x,dir_y + f_tilesize * 3,2,8,1,langtext("editor_brush_special"),name,3,2,buttonid)
					
					createbutton("brush_pathsetup",dir_x + f_tilesize * 3.5,dir_y + f_tilesize * 2,2,1,1,"",name,3,2,buttonid,nil,nil,nil,bicons.cog)
					
					selected_tool = editor.values[STATE]
					makeselection({"brush_normal","brush_level","_brush_cursor","brush_path","brush_special"},selected_tool + 1)
					
					table.insert(dynamic_structure, {{"brush_normal"}})
					table.insert(dynamic_structure, {{"brush_level"}})
					table.insert(dynamic_structure, {{"brush_path"},{"brush_pathsetup"}})
					table.insert(dynamic_structure, {{"brush_special"}})
				end
				
				if (string.len(editor4.strings[EDITOR_CURROBJTARGET]) > 0) then
					MF_positioncurrobjselector(editor4.strings[EDITOR_CURROBJTARGET])
					editor4.strings[EDITOR_CURROBJTARGET] = ""
				end
				
				buildmenustructure(dynamic_structure)
			end,
		leave = 
			function(parent,name)
				MF_clearthumbnails("CurrentObjectList")
				MF_currobjlist_backdel()
			end,
	},
	currobjlist_update =
	{
		button = "EditorObjectList_update",
		enter = 
			function(parent,name,buttonid,extra)
				MF_clearthumbnails("")
			end,
	},
	currobjlist_update_objects =
	{
		button = "EditorObjectList_update_objects",
		enter = 
			function(parent,name,buttonid,extra)
				local total = #editor_objects
				
				for i=1,total do
					local iddata = editor_objects[i]
					local id = iddata.objlistid
					local oid = iddata.databaseid
					
					local data = editor_objlist[id]
					local obj = editor_currobjlist[oid]
					
					local name = obj.name
					
					local objword = editor2.values[OBJECTWORDSWAP]
					local objwords = {["object"] = 0, ["text"] = 1}
					local ut = objwords[data.unittype] or 0
					
					if (obj.pair ~= nil) and (obj.pair ~= 0) and (ut ~= objword) then
						local buttonfunc = tostring(oid) .. "," .. name .. "," .. tostring(i)
						local objbuttonid = MF_getobjbuttonid(buttonfunc)
						
						if (objbuttonid ~= 0) then
							MF_clearthumbnail_withowner(objbuttonid)
							local objbutton = mmf.newObject(objbuttonid)
							
							local pairobjid = obj.pair
							local pairobj = editor_currobjlist[pairobjid]
							local v = editor_objlist[pairobj.id]
							
							local tempid = 0
							for a,b in ipairs(editor_objects) do
								if (b.databaseid == obj.pair) then
									tempid = a
									break
								end
							end
							
							if (tempid > 0) then
								local newbuttonfunc = tostring(obj.pair) .. "," .. pairobj.name .. "," .. tostring(tempid)
								objbutton.strings[BUTTONFUNC] = newbuttonfunc
								
								local imagefile = getactualdata_objlist(pairobj.object, "sprite")
								local c = {}
								local ut_ = getactualdata_objlist(pairobj.object, "unittype")
								
								if (ut_ == "object") then
									c = getactualdata_objlist(pairobj.object, "colour")
								elseif (ut_ == "text") then
									c = getactualdata_objlist(pairobj.object, "active")
								end
								
								local c1 = c[1] or 0
								local c2 = c[2] or 3
								
								imagefile = imagefile .. "_0_1"
								MF_thumbnail("Sprites/",imagefile,i-1,0,0,objbuttonid,c1,c2,0,0,"CurrentObjectList",pairobj.object)
							end
						end
					end
				end
				
				closemenu()
			end,
	},
	playlevels_single_deleteconfirm =
	{
		button = "SingleDeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("customlevels_deleteconfirm_single"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	playlevels_pack_deleteconfirm =
	{
		button = "PackDeleteConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				writetext(langtext("customlevels_deleteconfirm_pack"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize * 2
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	mobile_tuto1 =
	{
		button = "MobileTuto1",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				MF_menubackground(1)
				editor.values[EDITORDELAY] = 10
				editor2.values[MENU_YPOS] = 0
				
				writetext(langtext("mobile_tuto1a"),0,x,y - f_tilesize * 2,name,true)
				writetext(langtext("mobile_tuto1b"),0,x,y,name,true)
				writetext(langtext("mobile_tuto1c"),0,x,y + f_tilesize * 2,name,true)
				
				y = y + f_tilesize * 6
				
				createbutton("ok",x,y,2,16,4,langtext("tutorial_continue"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	mobile_tuto2 =
	{
		button = "MobileTuto2",
		escbutton = "ok",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				MF_menubackground(1)
				editor.values[EDITORDELAY] = 10
				editor2.values[MENU_YPOS] = 0
				
				writetext(langtext("mobile_tuto2a"),0,x,y - f_tilesize * 2,name,true)
				writetext(langtext("mobile_tuto2b"),0,x,y,name,true)
				writetext(langtext("mobile_tuto2c"),0,x,y + f_tilesize * 2,name,true)
				
				y = y + f_tilesize * 6
				
				createbutton("ok",x,y,2,16,4,langtext("tutorial_continue"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"ok"},},
			},
		}
	},
	reportlevel_confirm =
	{
		button = "ReportLevelConfirm",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("reportlevel_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
				
				editor4.strings[CURRMENUITEM] = "no"
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
	reportlevel_result =
	{
		button = "ReportLevel",
		escbutton = "return",
		enter = 
			function(parent,name,buttonid,result)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				if (result == 1) then
					writetext(langtext("reportlevel_success"),0,x,y,name,true)
				elseif (result == 0) then
					writetext(langtext("reportlevel_fail"),0,x,y,name,true)
				end
				
				y = y + f_tilesize * 2
				
				createbutton("return",x,y,2,16,1,langtext("reportlevel_ok"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"return"},},
			},
		}
	},
	playlevels_featured_wait =
	{
		button = "FeaturedWait",
		enter = 
			function(parent,name,buttonid,page_)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 3
				
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
				y = y + f_tilesize * 2
				
				writetext(langtext("playlevels_featured_wait"),0,x,y,name,true)
				
				local dynamic_structure = {{{"return"}}}
				
				local amount = generaldata3.values[LEVELCOUNT]
				local pagecount = generaldata2.values[PAGECOUNT]
				local total = amount * pagecount
				
				editor2.values[MENU_YDIM] = total
				local page = page_ or 0
				local maxpage = pagecount - 1
				page = math.min(page, maxpage)
				
				editor2.values[MENU_XDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 1.2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
				end
				
				makeselection({"","remove"},editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
				
				buildmenustructure(dynamic_structure)
			end,
	},
	upload_do_ask =
	{
		button = "UploadConfirm2",
		escbutton = "no",
		enter = 
			function(parent,name,buttonid)
				local x = screenw * 0.5
				local y = screenh * 0.5 - f_tilesize * 2
				
				writetext(langtext("editor_upload_confirm"),0,x,y,name,true)
				
				y = y + f_tilesize * 2
				
				createbutton("yes",x,y,2,16,1,langtext("yes"),name,3,2,buttonid)
				
				y = y + f_tilesize
				
				createbutton("no",x,y,2,16,1,langtext("no"),name,3,2,buttonid)
			end,
		structure =
		{
			{
				{{"yes"},},
				{{"no"},},
			},
		}
	},
}

menudata_customscript =
{
	worldlist =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_editworld"),0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local opts = MF_dirlist("Data/Worlds/*")
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "levels") then
					table.remove(opts, i)
					break
				end
			end
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "baba") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(opts, i)
					break
				end
			end
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "baba_m") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(opts, i)
					break
				end
			end
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "museum") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(opts, i)
					break
				end
			end
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "new_adv") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(opts, i)
					break
				end
			end
			
			for i,v_ in ipairs(opts) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "new_adv_m") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(opts, i)
					break
				end
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			local x_ = -1
			local y_ = 0
			local page = page_ or 0
			page = MF_setpagemenu(name)
			local amount = 16
			local maxpage = math.floor((#opts-1) / amount)
			page = math.min(page, maxpage)
			
			if (#opts == 0) then
				writetext(langtext("editor_editworld_none"),0,x,y,name,true,2)
				editor3.values[MAXPAGE] = 0
			else
			
				x = x - f_tilesize * 5
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				editor3.values[MAXPAGE] = maxpage
				
				local pagemin = page * amount
				local pagemax = math.min((((page + 1) * amount) - 1), #opts - 1)
				local i_ = 1
				
				x = screenw * 0.5
				
				for i=pagemin,pagemax do
					local v_ = opts[i + 1]
					local v = string.sub(v_, 2, string.len(v_) - 1)
					if (v ~= "levels") then
						MF_setfile("world","Data/Worlds/" .. v .. "/world_data.txt")
						
						local optbutton = v
						local optname = string.lower(MF_read("world","general","name")) or ""
						if (#optname == 0) then
							optname = langtext("world_unknown")
						end
						
						if (#v > 0) and (string.len(langtext("world_" .. string.lower(v),true,true)) > 0) then
							optname = langtext("world_" .. string.lower(v),true,true)
						end
						
						if (v == "new_adv_m") then
							optname = "new adventures - m"
						end
						
						createbutton(optbutton,x + x_ * f_tilesize * 8.5,y + y_ * f_tilesize,2,16,1,optname,name,3,2,buttonid,nil,nil,nil,nil,nil,true)
						
						table.insert(curr_dynamic_structure, {optbutton})
						
						x_ = x_ + 2
						
						if (x_ > 1) and (i < pagemax) then
							x_ = -1
							y_ = y_ + 1
							
							table.insert(dynamic_structure, {})
							curr_dynamic_structure = dynamic_structure[#dynamic_structure]
						end
						
						i_ = i_ + 1
					end
				end
				
				MF_setfile("world","Data/Worlds/" .. generaldata.strings[WORLD] .. "/world_data.txt")
				
				editor2.values[MENU_XDIM] = 1
				editor2.values[MENU_YDIM] = math.floor((pagemax + 1) / 2) + 1
			end
			
			y = y + f_tilesize * 2
			
			createbutton("make a new world",x,y + y_ * f_tilesize,2,16,1,langtext("editor_newworld"),name,3,2,buttonid)
			table.insert(dynamic_structure, {{"make a new world"}})
			
			if (#opts > 0) then
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left","cursor"},{"scroll_right","cursor"},})
				end
			end
			
			local mypos = editor2.values[MENU_YPOS]
			local mxdim = #dynamic_structure[#dynamic_structure]
			
			if (mypos > 0) and (mypos < #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = #dynamic_structure - 1
			elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			else
				editor2.values[MENU_XPOS] = 0
				editor2.values[MENU_YPOS] = 0
			end
			
			buildmenustructure(dynamic_structure)
		end,
	spritelist =
		function(parent,name,buttonid,data)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_spritelist_title"),0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local search = editor2.strings[SEARCHSTRING]
			
			local world = generaldata.strings[WORLD]
			
			local generalsprites = MF_filelist("Data/Sprites/","*_0_1.png")
			local generalsprites2 = {}
			local generalsprites3 = {}
			local generalsprites4 = {}
			local generalsprites5 = {}
			
			local worldsprites = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_0_1.png")
			local worldsprites2 = {}
			local worldsprites3 = {}
			local worldsprites4 = {}
			local worldsprites5 = {}
			
			local full = data[2] or 0
			
			if (full == 1) then
				generalsprites2 = MF_filelist("Data/Sprites/","*_8_1.png")
				generalsprites3 = MF_filelist("Data/Sprites/","*_16_1.png")
				generalsprites4 = MF_filelist("Data/Sprites/","*_24_1.png")
				generalsprites5 = MF_filelist("Data/Sprites/","icon_*.png")
				
				worldsprites2 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_8_1.png")
				worldsprites3 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_16_1.png")
				worldsprites4 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","*_24_1.png")
				worldsprites5 = MF_filelist("Data/Worlds/" .. world .. "/Sprites/","icon_*.png")
			end
			
			local sprites = {}
			local sprites_ = {}
			
			for i,v in ipairs(generalsprites) do
				if (string.sub(v, 1, 5) == "text_") then
					table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
				elseif (string.sub(v, 1, 5) ~= "icon_") or (full == 1) then
					table.insert(sprites_, v)
				end
			end
			
			if (full == 1) then
				for i,v in ipairs(generalsprites2) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites3) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites4) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
				
				for i,v in ipairs(generalsprites5) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(sprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(sprites_, v)
					end
				end
			end
			
			if (#sprites_ > 0) then
				table.sort(sprites_)
			end
			
			local worldsprite_cutoff = #sprites_
			local wsprites_ = {}
			
			for i,v in ipairs(worldsprites) do
				if (string.sub(v, 1, 5) == "text_") then
					table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
				elseif (string.sub(v, 1, 5) ~= "icon_") or (full == 1) then
					table.insert(wsprites_, v)
				end
			end
			
			if (full == 1) then
				for i,v in ipairs(worldsprites2) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites3) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites4) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
				
				for i,v in ipairs(worldsprites5) do
					if (string.sub(v, 1, 5) == "text_") then
						table.insert(wsprites_, string.sub(v, 6) .. "_TEXT_")
					else
						table.insert(wsprites_, v)
					end
				end
			end
			
			if (#wsprites_ > 0) then
				table.sort(wsprites_)
				
				for i,v in ipairs(wsprites_) do
					table.insert(sprites_, v)
				end
			end
			
			if (string.len(search) == 0) then
				sprites = sprites_
			else
				for i,v in ipairs(sprites_) do
					if (string.find(v, search) ~= nil) then
						table.insert(sprites, v)
					end
				end
			end
			
			if (#sprites == 0) then
				writetext(langtext("editor_spritelist_none"),0,x,y,name,true,2)
			end
			
			local amount = 80
			local maxpage = math.floor((#sprites-1) / amount)
			local page = data[1] or 0
			page = MF_setpagemenu(name)
			page = math.min(maxpage, page)
			
			editor3.values[MAXPAGE] = maxpage
			
			local page_min,page_max = 0,0
			page_min = page * amount
			page_max = math.min(((page + 1) * amount) - 1, #sprites - 1)
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			if (#sprites > 0) then
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			end
			
			local by_ = -1
			
			if (#sprites > 0) then
				local i_ = 1
				for i=page_min,page_max do
					local v = sprites[i + 1]
					
					if (string.sub(v, -6) == "_TEXT_") then
						v = "text_" .. string.sub(v, 1, string.len(v) - 6)
					end
					
					local spritefile = v
					local spritename = string.sub(v, 1, string.len(v) - 4)
					local spriteid = spritename .. tostring(i)
					
					--MF_alert(tostring(i) .. ", " .. v)
					
					local unitid = MF_create("Editor_spritebutton")
					local unit = mmf.newObject(unitid)
					unit.strings[BUTTONNAME] = spritename
					unit.strings[BUTTONFUNC] = spriteid
					unit.layer = 2
					
					local path = "Data/Sprites/"
					unit.values[MODE] = 1
					if (i >= worldsprite_cutoff) then
						unit.values[MODE] = 0
						path = "Data/Worlds/" .. world .. "/Sprites/"
					end
					
					local bx,by = spritelist(unitid,i_ - 1)
					
					if (by_ ~= by) then
						if (by_ ~= -1) then
							table.insert(dynamic_structure, {})
							curr_dynamic_structure = dynamic_structure[#dynamic_structure]
						end
						
						by_ = by
					end
					
					table.insert(curr_dynamic_structure, {spriteid,"cursor"})
					
					local thumbid = MF_specialcreate("Editor_thumbnail_sprite")
					local thumb = mmf.newObject(thumbid)
					thumb.values[OWNER] = unitid
					thumb.layer = 2
					thumb.strings[BUTTONID] = buttonid
					
					--MF_alert(path .. spritefile)
					
					MF_thumbnail_loadimage(thumbid,0,i_-1,path .. spritefile)
					
					i_ = i_ + 1
				end
			end
			
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = 1
			
			local cannot_scroll_left = true
			local cannot_scroll_left2 = true
			local cannot_scroll_right = true
			local cannot_scroll_right2 = true
			
			if (page > 0) then
				cannot_scroll_left = false
			end
			
			if (page > 4) then
				cannot_scroll_left2 = false
			end
			
			if (page < maxpage) then
				cannot_scroll_right = false
			end
			
			if (page < maxpage - 4) then
				cannot_scroll_right2 = false
			end
			
			local dynamic_structure_row = {}
			table.insert(dynamic_structure_row, {"search"})
			
			if (maxpage > 0) then
				createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
				createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
				createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
			
				writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				
				table.insert(dynamic_structure_row, {"scroll_left2","cursor"})
				table.insert(dynamic_structure_row, {"scroll_left","cursor"})
				table.insert(dynamic_structure_row, {"scroll_right","cursor"})
				table.insert(dynamic_structure_row, {"scroll_right2","cursor"})
			end
			
			table.insert(dynamic_structure_row, {"removesearch"})
			table.insert(dynamic_structure, dynamic_structure_row)
			
			createbutton("search",screenw * 0.5 - f_tilesize * 12.75,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_search"),name,3,2,buttonid)
			
			local disableremovesearch = true
			if (string.len(editor2.strings[SEARCHSTRING]) > 0) then
				disableremovesearch = false
			end
			
			createbutton("removesearch",screenw * 0.5 + f_tilesize * 12.75,screenh - f_tilesize * 2,2,8,1,langtext("editor_levellist_removesearch"),name,3,2,buttonid,disableremovesearch)
			
			local mypos = editor2.values[MENU_YPOS]
			local mxdim = #dynamic_structure[#dynamic_structure]
			
			if (mypos > 0) and (mypos < #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = #dynamic_structure - 1
			elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			else
				editor2.values[MENU_XPOS] = 0
				editor2.values[MENU_YPOS] = 0
			end
			
			buildmenustructure(dynamic_structure)
		end,
	themelist =
		function(parent,name,buttonid,extra)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			local menutype = extra[1] or false
			
			if (menutype == false) then
				createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			else
				createbutton("return",x,y,2,16,1,langtext("editor_theme_done"),name,3,1,buttonid)
			end
			
			y = y + f_tilesize * 2
			
			if (buttonid == "ThemeLoad") then
				writetext(langtext("editor_theme_themeload"),0,x,y,name,true,2)
			elseif (buttonid == "ThemeDelete") then
				writetext(langtext("editor_theme_themedelete"),0,x,y,name,true,2)
			end
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local themes = MF_filelist("Data/Themes/","*.txt")
			local worldthemes = MF_filelist("Data/Worlds/" .. world .. "/Themes/","*.txt")
			
			if ((#themes == 0) and (#worldthemes == 0)) or ((buttonid == "ThemeDelete") and (#worldthemes == 0)) then
				writetext(langtext("editor_theme_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 8
			local x_ = 0
			local y_ = 0
			
			local opts = {}
			local breakpoint = 0
			
			if (buttonid ~= "ThemeDelete") then
				for i,v in ipairs(themes) do
					table.insert(opts, v)
				end
				
				breakpoint = #opts
			end
			
			for i,v in ipairs(worldthemes) do
				table.insert(opts, v)
			end
			
			if (#opts > 0) then
				local page = extra[2] or 0
				page = MF_setpagemenu(name)
				local amount = 22
				local maxpage = math.floor((#opts-1) / amount)
				page = math.min(page, maxpage)
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				local page_min,page_max = 0,0
				page_min = page * amount
				page_max = math.min(((page + 1) * amount) - 1, #opts - 1)
				
				local i_ = 0
				
				for i=page_min+1,page_max+1 do
					local v = opts[i]
					local themefile = v
					i_ = i_ + 1
					
					if (i <= breakpoint) then
						MF_setfile("level","Data/Themes/" .. v)
					else
						MF_setfile("level","Data/Worlds/" .. world .. "/Themes/" .. v)
					end
					
					local rootid = ",1"
					if (i > breakpoint) then
						rootid = ",0"
					end
					
					local themename = MF_read("level","general","name")
					local themebutton = v .. rootid
					local vname = langtext("themes_" .. string.lower(themename),true,true)
					if (#vname == 0) then
						vname = themename
					end
					
					if (i > breakpoint) then
						if (#vname > 25) then
							vname = string.sub(vname, 1, 22) .. "..."
						end
						
						vname = vname .. " (U)"
					else
						if (#vname > 29) then
							vname = string.sub(vname, 1, 26) .. "..."
						end
					end
					
					createbutton(themebutton,x + x_ * f_tilesize * 16,y + y_ * f_tilesize,2,14,1,vname,name,3,2,buttonid)
					
					table.insert(curr_dynamic_structure, {themebutton})
					
					x_ = x_ + 1
					
					if (x_ > 1) and (i < page_max+1) then
						x_ = 0
						y_ = y_ + 1
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
				end
			
				if (#editor_currobjlist == 0) then
					editor3.values[NOTHEMECONFIRM] = 1
				end
				
				local level = generaldata.strings[CURRLEVEL]
				MF_setfile("level","Data/Worlds/" .. world .. "/" .. level .. ".ld")
				
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left","cursor"},{"scroll_right","cursor"},})
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor(#themes / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	palettelist =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_palette_select"),0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local opts = MF_filelist("Data/Palettes/","*.png")
			local worldopts = MF_filelist("Data/Worlds/" .. world .. "/Palettes/","*.png")
			
			local breakpoint = #opts
			for i,v in ipairs(worldopts) do
				table.insert(opts, v)
			end
			
			if (#opts == 0) then
				writetext(langtext("editor_palette_none"),0,x,y,name,true,2)
			end
			
			local paletteid = MF_specialcreate("Editor_colourselector")
			local palette = mmf.newObject(paletteid)
			
			palette.layer = 2
			palette.x = screenw * 0.5 + f_tilesize * 10
			palette.y = screenh * 0.5 - f_tilesize * 3
			palette.scaleX = 24
			palette.scaleY = 24
			palette.visible = false
			
			palette.values[3] = palette.x
			palette.values[4] = palette.y
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 11
			local x_ = 0
			local y_ = 0
			
			local page = page_ or 0
			page = MF_setpagemenu(name)
			local amount = 22
			local maxpage = math.floor((#opts-1) / amount)
			page = math.min(page, maxpage)
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			local page_min,page_max = 0,0
			page_min = page * amount
			page_max = math.min(((page + 1) * amount) - 1, #opts - 1)
			
			local i_ = 0
			
			for i=page_min+1,page_max+1 do
				i_ = i_ + 1
				
				local v = opts[i]
				local rootid = ",1"
				if (i > breakpoint) then
					rootid = ",0"
				end
				
				local optbutton = v .. rootid
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("palettes_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				if (i > breakpoint) then
					if (#vname > 18) then
						vname = string.sub(vname, 1, 15) .. "..."
					end
					
					vname = vname .. " (U)"
				else
					if (#vname > 22) then
						vname = string.sub(vname, 1, 19) .. "..."
					end
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 11,y + y_ * f_tilesize,2,10,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (i < page_max+1) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			if (#opts > 0) then
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left","cursor"},{"scroll_right","cursor"},})
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor(#opts / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	musiclist =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_music_select"),0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			
			local opts = MF_filelist("Data/Music/","*.ogg")
			local worldopts = MF_filelist("Data/Worlds/" .. world .. "/Music/","*.ogg")
			
			local breakpoint = #opts
			for i,v in ipairs(worldopts) do
				table.insert(opts, v)
			end
			
			if (#opts == 0) then
				writetext(langtext("editor_music_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 8
			local x_ = 0
			local y_ = 0
			
			local page = page_ or 0
			page = MF_setpagemenu(name)
			local amount = 22
			local maxpage = math.floor((#opts-1) / amount)
			page = math.min(page, maxpage)
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			local page_min,page_max = 0,0
			page_min = page * amount
			page_max = math.min(((page + 1) * amount) - 1, #opts - 1)
			
			local i_ = 0
			
			for i=page_min+1,page_max+1 do
				i_ = i_ + 1
				
				local v = opts[i]
				local rootid = ",0"
				if (i > breakpoint) then
					rootid = ",1"
				end
				local optbutton = v .. rootid
				local optname = string.sub(v, 1, string.len(v) - 4)
				local vname = langtext("music_" .. optname,true,true)
				if (#vname == 0) then
					vname = optname
				end
				
				if (i > breakpoint) then
					if (#vname > 25) then
						vname = string.sub(vname, 1, 22) .. "..."
					end
					
					vname = vname .. " (U)"
				else
					if (#vname > 29) then
						vname = string.sub(vname, 1, 26) .. "..."
					end
				end
				
				createbutton(optbutton,x + x_ * f_tilesize * 16,y + y_ * f_tilesize,2,14,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {optbutton})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (i < page_max+1) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			if (#opts > 0) then
				local cannot_scroll_left = true
				local cannot_scroll_right = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left","cursor"},{"scroll_right","cursor"},})
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor(#opts / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	particleslist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("editor_particles_select"),0,x,y,name,true,2)
			
			y = y + f_tilesize * 2
			
			local world = generaldata.strings[WORLD]
			local opts = {}
			
			table.insert(opts, "none")
			
			for i,v in pairs(particletypes) do
				if (i ~= "world") then
					table.insert(opts, i)
				end
			end
			
			local count = 0
			for i,v in pairs(opts) do
				count = count + 1
			end

			if (count == 0) then
				writetext(langtext("editor_particles_none"),0,x,y,name,true,2)
			end
			
			local dynamic_structure = {{{"return"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 5
			local x_ = 0
			local y_ = 0
			
			table.insert(dynamic_structure, {})
			curr_dynamic_structure = dynamic_structure[#dynamic_structure]
			
			local count_ = 0
			for i,v in ipairs(opts) do
				count_ = count_ + 1
				local vname = langtext("particles_" .. v,true,true)
				if (#vname == 0) then
					vname = v
				end
				
				createbutton(v,x + x_ * f_tilesize * 10,y + y_ * f_tilesize,2,8,1,vname,name,3,2,buttonid)
				
				table.insert(curr_dynamic_structure, {v})
				
				x_ = x_ + 1
				
				if (x_ > 1) and (count_ < count) then
					x_ = 0
					y_ = y_ + 1
					
					table.insert(dynamic_structure, {})
					curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				end
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			editor2.values[MENU_YDIM] = math.floor(count / 2) + 1
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_pack =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x - f_tilesize * 7,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			local worlds = MF_dirlist("Data/Worlds/*")
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "levels") then
					table.remove(worlds, i)
					break
				end
			end
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "baba") then
					table.remove(worlds, i)
					break
				end
			end
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "debug") and (generaldata.strings[BUILD] ~= "debug") then
					table.remove(worlds, i)
					break
				end
			end
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "baba_m") then
					table.remove(worlds, i)
					break
				end
			end
			
			for i,v_ in ipairs(worlds) do
				local v = string.sub(v_, 2, string.len(v_) - 1)
				if (v == "new_adv_m") then
					table.remove(worlds, i)
					break
				end
			end
			
			local disableremove = false
			if (#worlds == 0) then
				disableremove = true
			end
			
			local blen = getdynamicbuttonwidth(langtext("customlevels_forget"),8,10)
			createbutton("remove",x + f_tilesize * 7,y,2,blen,1,langtext("customlevels_forget"),name,3,2,buttonid,disableremove)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("customlevels_pack"),0,x,y,name,true,1)
			
			editor2.values[MENU_YDIM] = math.max(0, #worlds - 1)
			
			local actual_i = 1
			local imageid = 0
			
			local page = page_ or 0
			page = MF_setpagemenu(name)
			local amount = 8
			local maxpage = math.floor((#worlds-1) / amount)
			page = math.min(page, maxpage)
			
			editor3.values[MAXPAGE] = maxpage
			
			local page_min = page * amount
			local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
			
			local dynamic_structure = {{{"return"},{"remove"}}}
			local curr_dynamic_structure = {}
			
			x = x - f_tilesize * 8.5
			local x_ = 0
			local y_ = 0
			
			if (#worlds > 0) then
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				y = y + f_tilesize * 3
				
				for i=page_min,page_max do
					local v = worlds[i + 1]
					local worldfolder = string.sub(v, 2, string.len(v) - 1)
					
					if (worldfolder ~= "levels") then
						MF_setfile("world","Data/Worlds/" .. worldfolder .. "/world_data.txt")
						
						local worldfolder_ = tostring(actual_i) .. "," .. worldfolder
						
						local prizes = tonumber(MF_read("save",worldfolder .. "_prize","total")) or 0
						local clears = tonumber(MF_read("save",worldfolder .. "_clears","total")) or 0
						local bonus = tonumber(MF_read("save",worldfolder .. "_bonus","total")) or 0
						local timeplayed = tonumber(MF_read("save",worldfolder,"time")) or 0
						local win = tonumber(MF_read("save",worldfolder,"end")) or 0
						local done = tonumber(MF_read("save",worldfolder,"done")) or 0
						
						local p_max = tonumber(MF_read("world","general","prize_max")) or 9999
						local c_max = tonumber(MF_read("world","general","clear_max")) or 9999
						local b_max = tonumber(MF_read("world","general","bonus_max")) or 9999
						
						local minutes = string.sub("00" .. tostring(math.floor(timeplayed / 60) % 60), -2)
						local hours = tostring(math.floor(timeplayed / 3600))
						
						local desc = ""
						
						if (timeplayed > 0) then						
							if (generaldata4.values[CUSTOMFONT] == 0) then
								desc = desc .. hours .. ":" .. minutes .. "£  " .. tostring(prizes) .. "🤣  " .. tostring(clears) .. "¤"
							else
								desc = desc .. hours .. ":" .. minutes .. "💀  " .. tostring(prizes) .. "😈  " .. tostring(clears) .. "😠"
							end
						
							if (bonus > 0) then
								desc = desc .. "  (+" .. tostring(bonus) .. ")"
							end
						else
							desc = langtext("customlevels_pack_emptysave")
						end
						
						local worldname = MF_read("world","general","name")
						local worldauthor = MF_read("world","general","author")
						
						if (#worldfolder > 0) and (string.len(langtext("world_" .. string.lower(worldfolder),true,true)) > 0) then
							worldname = langtext("world_" .. string.lower(worldfolder),true,true)
						end
						
						if (string.len(worldname) == 0) then
							worldname = langtext("world_unknown")
						elseif (string.len(worldname) > 24) then
							worldname = string.sub(worldname, 1, 21) .. "..."
						end
						
						if (string.len(worldauthor) == 0) then
							worldauthor = langtext("noauthor")
						elseif (string.len(worldauthor) > 24) then
							worldauthor = string.sub(worldauthor, 1, 21) .. "..."
						end
						
						local bid = createbutton(worldfolder_,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,3,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
						writetext(worldname,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize - f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
						writetext(langtext("by") .. " " .. worldauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
						writetext(desc,0,x + x_ * 17 * f_tilesize - f_tilesize * 5,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
						
						local iconpath = "Worlds/" .. worldfolder .. "/"
						local imagefile = "icon"
						
						local icon_exists = MF_findfile("Data/" .. iconpath .. imagefile .. ".png")
						
						if icon_exists then
							MF_thumbnail(iconpath,imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6.5,0,buttonid,"")
						end
						
						local ix = 0
						
						for j=1,3 do
							if ((j == 1) and (win > 0)) or ((j == 2) and (done > 0)) or ((j == 3) and (prizes >= p_max) and (clears >= c_max) and (bonus >= b_max)) then
								local iconid = MF_create("Hud_completionicon")
								local icon = mmf.newObject(iconid)
								
								icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2 - ix
								icon.y = y + y_ * 3 * f_tilesize
								icon.layer = 2
								icon.strings[GROUP] = buttonid
								icon.values[XPOS] = icon.x
								icon.values[YPOS] = icon.y
								
								if (j == 1) then
									--icon.direction = 0
									icon.y = icon.y - f_tilesize * 0.75
									icon.values[COUNTER_VALUE] = 0
									ix = ix + f_tilesize
								elseif (j == 2) then
									--icon.direction = 4
									icon.y = icon.y - f_tilesize * 0.75
									icon.values[COUNTER_VALUE] = 4
									ix = ix + f_tilesize
								elseif (j == 3) then
									--icon.direction = 4
									icon.y = icon.y - f_tilesize * 0.75
									icon.values[COUNTER_VALUE] = 5
									ix = ix + f_tilesize
								end
								
								icon.values[XPOS] = icon.x
								icon.values[YPOS] = icon.y
								icon.values[BUTTON_STOREDX] = icon.x
								icon.values[BUTTON_STOREDY] = icon.y
							end
						end
						
						ix = 0
						local custom = tonumber(MF_read("world","completion_icons","count")) or 0
						if (custom > 0) then
							for j=1,custom do
								local flag = MF_read("world","completion_icons",tostring(j) .. "_flag")
								local file = MF_read("world","completion_icons",tostring(j) .. "_file")
								
								if (#flag > 0) and (#file > 0) then
									local flagcheck = tonumber(MF_read("save",worldfolder,flag)) or 0
									
									if (flagcheck == 1) then
										local iconid = MF_create("Hud_completionicon")
										local icon = mmf.newObject(iconid)
										
										icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2 - ix
										icon.y = y + y_ * 3 * f_tilesize + f_tilesize * 0.75
										icon.layer = 2
										icon.strings[GROUP] = buttonid
										icon.values[XPOS] = icon.x
										icon.values[YPOS] = icon.y
										icon.values[ICON_DIRECTION] = -1
										icon.values[ICON_FRAME] = imageid
										
										MF_loadpackicon(iconid,worldfolder,file,imageid)
										imageid = imageid + 1
										
										icon.values[XPOS] = icon.x
										icon.values[YPOS] = icon.y
										icon.values[BUTTON_STOREDX] = icon.x
										icon.values[BUTTON_STOREDY] = icon.y
										ix = ix + f_tilesize
									end
								end
							end
						end
						
						table.insert(curr_dynamic_structure, {worldfolder_})
						
						x_ = x_ + 1
						if (x_ > 1) and (i < page_max) then
							x_ = 0
							y_ = y_ + 1
							
							table.insert(dynamic_structure, {})
							curr_dynamic_structure = dynamic_structure[#dynamic_structure]
						end
						
						actual_i = actual_i + 1
					end
				end
			end
			
			editor2.values[MENU_XDIM] = 1
			
			-- Korjaa tämä
			editor2.values[MENU_YDIM] = 1
			
			local cannot_scroll_left = true
			local cannot_scroll_left2 = true
			local cannot_scroll_right = true
			local cannot_scroll_right2 = true
			
			if (page > 0) then
				cannot_scroll_left = false
			end
			
			if (page > 4) then
				cannot_scroll_left2 = false
			end
			
			if (page < maxpage) then
				cannot_scroll_right = false
			end
			
			if (page < maxpage - 4) then
				cannot_scroll_right2 = false
			end
			
			if (maxpage > 0) then
				createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
				createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
				createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
				createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
			
				writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
				
				table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
			end
			
			makeselection({"","remove"},editor.values[STATE] + 1)
			
			local mypos = editor2.values[MENU_YPOS]
			local mxdim = #dynamic_structure[#dynamic_structure]
			
			if (mypos > 0) and (mypos < #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = #dynamic_structure - 1
			elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
				editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
				editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			else
				editor2.values[MENU_XPOS] = 0
				editor2.values[MENU_YPOS] = 0
			end
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_single =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 1.5
			
			createbutton("return",x - f_tilesize * 7,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			local blen = getdynamicbuttonwidth(langtext("customlevels_delete"),8)
			createbutton("remove",x + f_tilesize * 7,y,2,blen,1,langtext("customlevels_delete"),name,3,2,buttonid)
			
			y = y + f_tilesize * 2
			
			writetext(langtext("customlevels_single"),0,x,y,name,true,1)
			
			local worlds = MF_filelist("Data/Worlds/levels/","*.l")
			local dynamic_structure = {{{"return"},{"remove"}}}
			
			if (#worlds > 0) then
				editor2.values[MENU_YDIM] = #worlds - 1
				
				local actual_i = 1
				
				local page = page_ or 0
				page = MF_setpagemenu(name)
				local amount = 8
				local maxpage = math.floor((#worlds-1) / amount)
				page = math.min(page, maxpage)
				
				local targetlevel = editor3.strings[PREVLEVELFILE] .. ".l"
				if (string.len(targetlevel) > 0) then
					for i,v in ipairs(worlds) do
						if (v == targetlevel) then
							page = math.floor(i / amount)
							editor3.values[PAGE] = page
						end
					end
				end
				
				editor3.strings[PREVLEVELFILE] = ""
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, #worlds - 1)
				
				local curr_dynamic_structure = {}
				
				x = x - f_tilesize * 8.5
				local x_ = 0
				local y_ = 0
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				y = y + f_tilesize * 3
				
				for i=page_min,page_max do
					local v = worlds[i + 1]
					local leveldata = v .. "d"
					local levelid = string.sub(v, 1, string.len(v) - 2)
					
					MF_setfile("level","Data/Worlds/levels/" .. leveldata)
					
					local levelname = MF_read("level","general","name")
					local levelauthor = MF_read("level","general","author")
					local levelsubtitle = MF_read("level","general","subtitle")
					local levelcode = MF_read("level","general","levelcode")
					
					if (string.len(levelname) > 24) then
						levelname = string.sub(levelname, 1, 21) .. "..."
					end
					
					if (string.len(levelauthor) == 0) then
						levelauthor = langtext("noauthor")
					elseif (string.len(levelauthor) > 24) then
						levelauthor = string.sub(levelauthor, 1, 21) .. "..."
					end
					
					if (#levelname <= 12) then
						levelname = levelname .. " (" .. levelcode .. ")"
					elseif (#levelsubtitle <= 12) then
						levelsubtitle = levelsubtitle .. " (" .. levelcode .. ")"
					elseif (#levelauthor <= 12) then
						levelauthor = levelauthor .. " (" .. levelcode .. ")"
					end
					
					local bid = createbutton(levelid .. "," .. levelname,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,3,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
					writetext(levelname,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					writetext(langtext("by") .. " " ..  levelauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
					writetext(levelsubtitle,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{1,3},nil,1,nil,true)
					
					local imagefile = levelid
					MF_thumbnail("Worlds/levels/",imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6,0,buttonid,"")
					
					table.insert(curr_dynamic_structure, {levelid .. "," .. levelname})
					
					local beaten = tonumber(MF_read("save","levels",levelid)) or 0
					local bonus = tonumber(MF_read("save","levels_bonus",levelid)) or 0
					local converted = tonumber(MF_read("save","levels_converts_single",levelid)) or 0
					local ended = tonumber(MF_read("save","levels_end_single",levelid)) or 0
					local doned = tonumber(MF_read("save","levels_done_single",levelid)) or 0
					
					local databaseid = MF_read("level","general","levelcode")
					if (#databaseid == 9) then
						local dbid = MF_read("save","levels_won",databaseid)
						
						if (#dbid > 0) then
							local dbdata = MF_read("save","levels_won",dbid)
							
							if (#dbdata > 0) then
								local dbtable = MF_parsestring(dbdata)
								
								if (tonumber(dbtable[1]) ~= nil) then
									beaten = tonumber(dbtable[1]) * 3
								end
								bonus = tonumber(dbtable[2]) or bonus
								ended = tonumber(dbtable[3]) or ended
								doned = tonumber(dbtable[4]) or doned
								converted = tonumber(dbtable[5]) or converted
							end
						end
					end
					
					for j=1,5 do
						if ((j == 1) and (beaten == 3)) or ((j == 2) and (bonus > 0)) or ((j == 3) and (converted > 0)) or ((j == 4) and (ended > 0)) or ((j == 5) and (doned > 0)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2
							icon.y = y + y_ * 3 * f_tilesize
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							
							if (j == 1) then
								--icon.direction = 0
								icon.y = icon.y - f_tilesize * 0.75
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 1
								icon.y = icon.y - f_tilesize * 0.75
								icon.x = icon.x - f_tilesize * 1
								icon.values[COUNTER_VALUE] = 1
							elseif (j == 3) then
								--icon.direction = 2
								icon.y = icon.y + f_tilesize * 0.25
								icon.values[COUNTER_VALUE] = 2
							elseif (j == 4) then
								--icon.direction = 3
								icon.x = icon.x - f_tilesize * 1
								icon.y = icon.y + f_tilesize * 0.25
								icon.values[COUNTER_VALUE] = 3
							elseif (j == 5) then
								--icon.direction = 3
								icon.x = icon.x - f_tilesize * 0.5
								icon.y = icon.y + f_tilesize * 0.75
								icon.values[COUNTER_VALUE] = 4
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					x_ = x_ + 1
					if (x_ > 1) and (i < page_max) then
						x_ = 0
						y_ = y_ + 1
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
					
					actual_i = actual_i + 1
				end
				
				editor2.values[MENU_XDIM] = 1
				
				-- Korjaa tämä
				editor2.values[MENU_YDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
				end
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
			end
			
			makeselection({"","remove"},editor.values[STATE] + 1)
			
			editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_featured =
		function(parent,name,buttonid,page_)
			local x = screenw * 0.5
			local y = f_tilesize * 0.6
			
			createbutton("return",x,y,2,16,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 1
			
			writetext(langtext("playlevels_get_featured_colon"),0,x,y,name,true,1)
			
			local amount = MF_getlevelcount()
			local pagecount = MF_getpagecount()
			local total = amount * pagecount
			
			local dynamic_structure = {{{"return"}}}
			
			local actual_i = 1
			
			if (total > 0) then
				local page = page_ or 0
				local maxpage = pagecount-1
				page = math.min(page, maxpage)
				
				editor3.strings[PREVLEVELFILE] = ""
				editor3.values[MAXPAGE] = maxpage
				
				local page_min = page * amount
				local page_max = math.min(((page + 1) * amount) - 1, total-1)
				
				page_min = 0
				page_max = amount - 1
				
				local curr_dynamic_structure = {}
				
				x = x - f_tilesize * 8.5
				local x_ = 0
				local y_ = 0
				
				table.insert(dynamic_structure, {})
				curr_dynamic_structure = dynamic_structure[#dynamic_structure]
				
				y = y + f_tilesize * 3
				
				for i=page_min,page_max do
					local levelid,levelname,levelauthor,levelsubtitle,leveltagline,thumbnail = MF_getlistlevel(i)
					
					if (string.len(levelname) > 24) then
						levelname = string.sub(levelname, 1, 21) .. "..."
					end
					
					if (string.len(levelauthor) == 0) then
						levelauthor = langtext("noauthor")
					elseif (string.len(levelauthor) > 24) then
						levelauthor = string.sub(levelauthor, 1, 21) .. "..."
					end
					
					local bid = createbutton(levelid .. "," .. levelname,x + x_ * 17 * f_tilesize,y + y_ * 3 * f_tilesize,1,16,5,"",name,3,2,buttonid,nil,nil,nil,nil,nil,true)
					writetext(levelname,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 1.8,name,false,2,nil,{0,3},nil,1,nil,true)
					writetext(langtext("by") .. " " ..  levelauthor,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize,name,false,2,nil,{1,4},nil,1,nil,true)
					writetext(levelsubtitle,0,x + x_ * 17 * f_tilesize - f_tilesize * 4,y + y_ * 3 * f_tilesize - f_tilesize * 0.2,name,false,2,nil,{1,3},nil,1,nil,true)
					
					if (#leveltagline >= 73) then
						leveltagline = string.sub(leveltagline, 1, 69) .. "..."
					end
					
					local taglines = wordwrap(leveltagline, f_tilesize * 13, true)
					local tg1 = taglines[1]
					local tg2 = taglines[2] or ""
					local tg3 = taglines[3] or ""
					
					local beaten,bonus,ended,doned,converted = 0,0,0,0,0
					local dbid = MF_read("save","levels_won",levelid)
					
					if (#dbid > 0) then
						local dbdata = MF_read("save","levels_won",dbid)
						
						if (#dbdata > 0) then
							local dbtable = MF_parsestring(dbdata)
							
							if (tonumber(dbtable[1]) ~= nil) then
								beaten = tonumber(dbtable[1]) * 3
							end
							bonus = tonumber(dbtable[2]) or bonus
							ended = tonumber(dbtable[3]) or ended
							doned = tonumber(dbtable[4]) or doned
							converted = tonumber(dbtable[5]) or converted
						end
					end
					
					writetext(tg1,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 0.8,name,false,2,nil,{0,3},nil,1,nil,true)
					
					if (#tg2 > 0) then
						writetext(tg2,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 1.8,name,false,2,nil,{0,3},nil,1,nil,true)
					end
					
					if (#tg3 > 0) then
						writetext(tg3,0,x + x_ * 17 * f_tilesize - f_tilesize * 7.75,y + y_ * 3 * f_tilesize + f_tilesize * 2.8,name,false,2,nil,{0,3},nil,1,nil,true)
					end
					
					for j=1,5 do
						if ((j == 1) and (beaten == 3)) or ((j == 2) and (bonus > 0)) or ((j == 3) and (converted > 0)) or ((j == 4) and (ended > 0)) or ((j == 5) and (doned > 0)) then
							local iconid = MF_create("Hud_completionicon")
							local icon = mmf.newObject(iconid)
							
							icon.x = x + x_ * 17 * f_tilesize + f_tilesize * 7.2
							icon.y = y + y_ * 3 * f_tilesize
							icon.layer = 2
							icon.strings[GROUP] = buttonid
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							
							if (j == 1) then
								--icon.direction = 0
								icon.y = icon.y - f_tilesize * 1.5
								icon.values[COUNTER_VALUE] = 0
							elseif (j == 2) then
								--icon.direction = 1
								icon.x = icon.x - f_tilesize * 0.65
								icon.y = icon.y - f_tilesize * 1.5
								icon.values[COUNTER_VALUE] = 1
							elseif (j == 3) then
								--icon.direction = 2
								icon.y = icon.y + f_tilesize * 1.5
								icon.values[COUNTER_VALUE] = 2
							elseif (j == 4) then
								--icon.direction = 3
								icon.y = icon.y - f_tilesize * 0.5
								icon.values[COUNTER_VALUE] = 3
							elseif (j == 5) then
								--icon.direction = 3
								icon.y = icon.y + f_tilesize * 0.5
								icon.values[COUNTER_VALUE] = 4
							end
							
							icon.values[XPOS] = icon.x
							icon.values[YPOS] = icon.y
							icon.values[BUTTON_STOREDX] = icon.x
							icon.values[BUTTON_STOREDY] = icon.y
						end
					end
					
					local imagefile = levelid
					MF_thumbnail("Temp/",imagefile,actual_i-1,0,0,bid,0,3,0-f_tilesize * 6,0-f_tilesize,buttonid,"")
					
					table.insert(curr_dynamic_structure, {levelid .. "," .. levelname})
					
					x_ = x_ + 1
					if (x_ > 1) and (i < page_max) then
						x_ = 0
						y_ = y_ + 1.75
						
						table.insert(dynamic_structure, {})
						curr_dynamic_structure = dynamic_structure[#dynamic_structure]
					end
					
					actual_i = actual_i + 1
				end
				
				editor2.values[MENU_XDIM] = 1
				
				local cannot_scroll_left = true
				local cannot_scroll_left2 = true
				local cannot_scroll_right = true
				local cannot_scroll_right2 = true
				
				if (page > 0) then
					cannot_scroll_left = false
				end
				
				if (page > 4) then
					cannot_scroll_left2 = false
				end
				
				if (page < maxpage) then
					cannot_scroll_right = false
				end
				
				if (page < maxpage - 4) then
					cannot_scroll_right2 = false
				end
				
				if (maxpage > 0) then
					createbutton("scroll_left",screenw * 0.5 - f_tilesize * 5,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.l_arrow)
					createbutton("scroll_left2",screenw * 0.5 - f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_left,nil,nil,bicons.dl_arrow)
					createbutton("scroll_right",screenw * 0.5 + f_tilesize * 5,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.r_arrow)
					createbutton("scroll_right2",screenw * 0.5 + f_tilesize * 7,screenh - f_tilesize * 1.2,2,2,2,"",name,3,2,buttonid,cannot_scroll_right,nil,nil,bicons.dr_arrow)
				
					writetext(langtext("editor_spritelist_page") .. " " .. tostring(page + 1) .. "/" .. tostring(maxpage + 1),0,screenw * 0.5,screenh - f_tilesize * 1.2,name,true,2)
					
					table.insert(dynamic_structure, {{"scroll_left2","cursor"},{"scroll_left","cursor"},{"scroll_right","cursor"},{"scroll_right2","cursor"},})
				end
				
				makeselection({"","remove"},editor.values[STATE] + 1)
				
				local mypos = editor2.values[MENU_YPOS]
				local mxdim = #dynamic_structure[#dynamic_structure]
				
				if (mypos > 0) and (mypos < #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = #dynamic_structure - 1
				elseif (mypos > 0) and (mypos >= #dynamic_structure - 1) then
					editor2.values[MENU_XPOS] = math.min(editor2.values[MENU_XPOS], mxdim - 1)
					editor2.values[MENU_YPOS] = math.min(editor2.values[MENU_YPOS], #dynamic_structure - 1)
				else
					editor2.values[MENU_XPOS] = 0
					editor2.values[MENU_YPOS] = 0
				end
			end
			
			editor2.values[MENU_YDIM] = #dynamic_structure
			
			buildmenustructure(dynamic_structure)
		end,
	playlevels_getlist =
		function(parent,name,buttonid)
			local x = screenw * 0.5
			local y = f_tilesize * 1.25
			
			createbutton("return",x,y,2,8,1,langtext("return"),name,3,1,buttonid)
			
			y = y + f_tilesize * 1
			
			writetext(langtext("customlevels_getlist"),0,x,y,name,true,1)
			
			if (generaldata.strings[BUILD] ~= "n") then
				y = y + f_tilesize * 1
				
				writetext(langtext("customlevels_getlist2"),0,x,y,name,true,1,nil,{1,3})
			end
			
			local dynamic_structure = {{{"return"}}}
			y = y + f_tilesize * 1
			
			writetext(langtext("customlevels_getlist_download"),0,screenw * 0.5 - f_tilesize * 8.5,y,name,true,1)
			writetext(langtext("customlevels_getlist_upload"),0,screenw * 0.5 + f_tilesize * 8.5,y,name,true,1)
			
			local column1 = {}
			local column2 = {}
			
			local uploads = math.min(15, tonumber(MF_read("settings","get_u","total")) or 0)
			local downloads = math.min(15, tonumber(MF_read("settings","get_d","total")) or 0)
			
			y = y + f_tilesize * 1
			
			if (downloads > 0) then
				for i=1,downloads do
					local lcode = MF_read("settings","get_d",tostring(i-1) .. "code")
					local lname = MF_read("settings","get_d",tostring(i-1) .. "name")
					
					local combo = lname .. ", " .. lcode
					
					createbutton(tostring(i) .. "a," .. lcode,x - f_tilesize * 8.5,y + (i - 1) * f_tilesize,2,16,1,combo,name,3,2,buttonid)
					
					table.insert(column1, {tostring(i) .. "a," .. lcode})
				end
			end
			
			if (uploads > 0) then
				for i=1,uploads do
					local lcode = MF_read("settings","get_u",tostring(i-1) .. "code")
					local lname = MF_read("settings","get_u",tostring(i-1) .. "name")
					
					local combo = lname .. ", " .. lcode
					
					createbutton(tostring(i) .. "b," .. lcode,x + f_tilesize * 8.5,y + (i - 1) * f_tilesize,2,16,1,combo,name,3,2,buttonid)
					
					table.insert(column2, {tostring(i) .. "b," .. lcode})
				end
			end
			
			local ydim_ = math.max(#column1, #column2)
			
			for i=1,ydim_ do
				local c1 = column1[i] or nil
				local c2 = column2[i] or nil
				
				local result = {}
				
				if (c1 ~= nil) then
					table.insert(result, c1)
				end
				
				if (c2 ~= nil) then
					table.insert(result, c2)
				end
				
				table.insert(dynamic_structure, result)
			end
			
			editor2.values[MENU_XPOS] = 0
			editor2.values[MENU_YPOS] = 0
			editor2.values[MENU_XDIM] = 1
			
			-- Korjaa tämä
			editor2.values[MENU_YDIM] = 1
			
			buildmenustructure(dynamic_structure)
		end,
}