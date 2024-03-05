local tuto_subcontents =
{
	intro =
	{
		init = function()
			MF_tutorialbackground(true,0)
			MF_disablebuttons(1)
			MF_store("settings","editor","firsttime","1")
			
			tutorial_load("slide1")
		end,
		
		slide1 = 
		{
			-- 1. Introduction
			init = function()
				local offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = -1
				end
				
				text_tuto("tutorial_intro_1a",0,-8 + offset,true,nil,{1,3})
				text_tuto("tutorial_intro_1b",0,-7 + offset,true)
				text_tuto("tutorial_intro_1c",0,-1,true)
				
				offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = 1
				end
				
				button_tuto("skip","tutorial_skip",7,6 + offset,8,4,8,10)
				button_tuto("cont","tutorial_continue",-7,6 + offset,8,4,8,10)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			button_skip = function()
				tutorial_end()
			end,
			
			structure =
			{
				{
					{{"cont"},{"skip"}},
				}
			},
		},
		
		slide2 = 
		{
			-- 2. Main editor menu
			init = function()
				changemenu("editor_start")
				MF_tutorialbackground(true,0)
				
				local offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = -0.5
				end
				
				text_tuto("tutorial_intro_2a",0,-9 + offset,true)
				
				button_tuto("cont","tutorial_continue",0,8,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide3 = 
		{
			-- 3. Level menu
			init = function()
				generaldata.strings[WORLD] = "levels"
				changemenu("level")
				MF_tutorialbackground(true,0)
				MF_removebutton("return")
				
				text_tuto({"tutorial_intro_3a", n = "tutorial_intro_3a_n"},0,-9,true)
				
				button_tuto("cont","tutorial_continue",0,7,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide4 = 
		{
			-- 4. Theme selection
			init = function()
				editor.values[NAMETARGET] = 3
				editor.strings[NAMETOGIVE] = "Tutorial"
				MF_loop("name2",1)
				MF_tutorialbackground(true,1)
				
				text_tuto("tutorial_intro_4a",0,-9,true)
				
				button_tuto("cont","tutorial_continue",0,7,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide5 = 
		{
			-- 5. Main editor view
			init = function()
				MF_loop("newlevel_init",1)
				editor2.values[DOPAIRS] = 0
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				
				for i,v in ipairs(editor_objects) do
					local oid = v.databaseid
					local obj = editor_currobjlist[oid]
					if (obj ~= nil) and (obj.name == "wall") then
						editor_currobjlist_remove(i,obj.name,false)
						break
					end
				end
				
				for i,v in ipairs(editor_objects) do
					local oid = v.databaseid
					local obj = editor_currobjlist[oid]
					if (obj ~= nil) and (obj.name == "text_wall") then
						editor_currobjlist_remove(i,obj.name,false)
						break
					end
				end
				
				local gridreference_full = objlistdata.gridreference_full
				gridreference_full[3][1] = nil
				gridreference_full[3][2] = nil
				
				text_tuto("tutorial_intro_5a",0,-6,true,nil,nil,screenw * 0.6)
				
				button_tuto("cont","tutorial_continue",0,2,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide6 = 
		{
			-- 6. Open object palette
			init = function(btype)
				text_tuto({"tutorial_intro_6a", "tutorial_intro_6a_gpad"},0,-6,true,nil,nil,screenw * 0.6)
				
				if (btype == "keyboard") then
					tuto_pointer_button("objects")
				end
				
				button_tuto("cont","tutorial_continue",0,2,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide7 = 
		{
			-- 7. Object palette
			init = function()
				submenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_intro_7a",0,2,true,nil,nil,screenw * 0.6)
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "baba") then
						local data = b.grid_full
						editor3.values[CURROBJX] = data[1]
						editor3.values[CURROBJY] = data[2]
						break
					end
				end
				tuto_pointer(-8,-3)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide8 = 
		{
			-- 8. Place Baba into the level
			init = function()
				closemenu()
				MF_tutorialbackgroundfade(200)
				
				text_tuto({"tutorial_intro_8a", "tutorial_intro_8a_gpad"},0,-6,true,nil,nil,screenw * 0.6)
				
				--MF_pickobject("object000")
				local obj = ""
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "baba") then
						obj = b.object
						break
					end
				end
				placetile(obj,10,10,0,0)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide9 = 
		{
			-- 9. Add more to palette
			init = function()
				submenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_intro_9a",0,2,true,nil,nil,screenw * 0.8)
				
				tuto_pointer_button("add")
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide10 = 
		{
			-- 10. Object list
			init = function()
				editor3.strings[PAGEMENU] = "objlist"
				editor3.values[PAGE] = 2
				submenu("objlist",2)
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_intro_10a",0,-5.5,true,nil,nil,screenw * 0.8)
				
				button_tuto("cont","tutorial_continue",0,7,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide11 = 
		{
			-- 11. Object list
			init = function()
				addobjtolist("wall")
				closemenu()
				changemenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "wall") then
						local data = b.grid_full
						editor3.values[CURROBJX] = data[1]
						editor3.values[CURROBJY] = data[2]
						break
					end
				end
				tuto_pointer(-8,-2)
				
				text_tuto("tutorial_intro_11a",0,2,true,nil,nil,screenw * 0.8)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide12 = 
		{
			-- 12. Place Walls into level
			init = function()
				closemenu()
				MF_tutorialbackgroundfade(200)
				
				text_tuto({"tutorial_intro_12a", "tutorial_intro_12a_gpad"},0,-7,true,nil,nil,screenw * 0.75)
				
				--MF_pickobject("object000")
				local obj = ""
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "wall") then
						obj = b.object
						break
					end
				end
				placetile(obj,9,8,0,0)
				placetile(obj,10,8,0,0)
				placetile(obj,11,8,0,0)
				placetile(obj,12,8,0,0)
				placetile(obj,13,8,0,0)
				placetile(obj,14,8,0,0)
				placetile(obj,15,8,0,0)
				
				placetile(obj,9,12,0,0)
				placetile(obj,10,12,0,0)
				placetile(obj,11,12,0,0)
				placetile(obj,12,12,0,0)
				placetile(obj,13,12,0,0)
				placetile(obj,14,12,0,0)
				placetile(obj,15,12,0,0)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide13 = 
		{
			-- 13. Place the rest of the objects
			init = function()
				local offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = -1
				end
				
				text_tuto("tutorial_intro_13a",0,-7 + offset,true,nil,nil,screenw * 0.6)
				
				--MF_pickobject("object000")
				local obj_f = ""
				local obj_ft = ""
				local obj_wt = ""
				local obj_bt = ""
				local obj_i = ""
				local obj_y = ""
				local obj_w = ""
				local obj_s = ""
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "text_wall") then
						obj_wt = b.object
					elseif (b.name == "text_baba") then
						obj_bt = b.object
					elseif (b.name == "text_flag") then
						obj_ft = b.object
					elseif (b.name == "text_is") then
						obj_i = b.object
					elseif (b.name == "text_you") then
						obj_y = b.object
					elseif (b.name == "text_win") then
						obj_w = b.object
					elseif (b.name == "text_stop") then
						obj_s = b.object
					elseif (b.name == "flag") then
						obj_f = b.object
					end
				end
				
				placetile(obj_f,14,10,0,0)
				
				placetile(obj_bt,9,7,0,0)
				placetile(obj_i,10,7,0,0)
				placetile(obj_y,11,7,0,0)
				
				placetile(obj_ft,13,7,0,0)
				placetile(obj_i,14,7,0,0)
				placetile(obj_w,15,7,0,0)
				
				placetile(obj_wt,11,13,0,0)
				placetile(obj_i,12,13,0,0)
				placetile(obj_s,13,13,0,0)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide14 = 
		{
			-- 14. Saving
			init = function()
				text_tuto({"tutorial_intro_14a", "tutorial_intro_14a_gpad"},0,-7,true,nil,nil,screenw * 0.75)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide15 = 
		{
			-- 15. Testing
			init = function()
				text_tuto({"tutorial_intro_15a", "tutorial_intro_15a_gpad"},0,-7,true,nil,nil,screenw * 0.75)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_nextslide()
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide16 = 
		{
			-- 16. The end
			init = function()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("tutorial_intro")
				MF_clearborders()
				
				text_tuto("tutorial_intro_16a",0,-3,true)
				
				button_tuto("end","tutorial_end",0,4,16,2)
			end,
			
			button_end = function()
				tutorial_end()
			end,
			
			structure =
			{
				{
					{{"end"}},
				}
			},
		},
	},
}

for i,v in pairs(tuto_subcontents) do
	tutodata[i] = v
end