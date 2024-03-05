local tuto_subcontents =
{
	tutorial4 =
	{
		init = function()
			MF_tutorialbackground(true,0)
			MF_disablebuttons(1)
			tutorial_load("slide1")
		end,
		
		slide1 = 
		{
			-- 1. Welcome back
			init = function()
				text_tuto("tutorial_4_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_4_1b",0,-3,true)
				
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
		
		slide2 = 
		{
			-- 2. Editor view
			init = function()
				generaldata.strings[WORLD] = "levels"
				editor.values[NAMETARGET] = 3
				editor.strings[NAMETOGIVE] = "Tutorial"
				MF_loop("name2",1)
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
				
				text_tuto("tutorial_4_2a",0,-6,true,nil,nil,screenw * 0.6)
				
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
		
		slide3 = 
		{
			-- 3. Currobjlist view
			init = function()
				text_tuto({"tutorial_4_3a","tutorial_4_3a_gpad"},0,-5,true,nil,nil,screenw * 0.6)
				
				tuto_pointer_button("objects")
				
				button_tuto("cont","tutorial_continue",0,-1,16,2)
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
			-- 4. Normal selection
			init = function()
				submenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto({"tutorial_4_4a","tutorial_4_4a_gpad"},0,0,true,nil,nil,screenw * 0.6)
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "flag") then
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
		
		slide5 = 
		{
			-- 5. Changing viewmode
			init = function()
				text_tuto("tutorial_4_5a",0,-2,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(10,-7)
				
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
		
		slide6 = 
		{
			-- 6. Changing viewmode showcase
			init = function()
				MF_loop("changedopairs",1)
				changemenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto({"tutorial_4_6a","tutorial_4_6a_gpad"},0,-1,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(12,-7)
				
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
		
		slide7 = 
		{
			-- 7. Add new object
			init = function()
				MF_loop("changedopairs",1)
				changemenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto({"tutorial_4_7a","tutorial_4_7a_gpad"},0,1,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(4,-7)
				
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
		
		slide8 = 
		{
			-- 8. Objlist intro
			init = function()
				editor3.strings[PAGEMENU] = "objlist"
				editor3.values[PAGE] = 0
				submenu("objlist",2)
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_4_8a",0,2.5,true,nil,nil,screenw * 0.75)
				
				button_tuto("cont","tutorial_continue",0,-5,16,2)
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
			-- 9. Searching & tags
			init = function()
				text_tuto({"tutorial_4_9a","tutorial_4_9a_gpad"},0,2.5,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(-1,-6)
				
				button_tuto("cont","tutorial_continue",0,-5,16,2)
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
			-- 10. Back to currobjlist
			init = function()
				addobjtolist("wall")
				closemenu()
				changemenu("currobjlist")
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "wall") then
						local data = b.grid_full
						editor3.values[CURROBJX] = data[1]
						editor3.values[CURROBJY] = data[2]
						break
					end
				end
				
				text_tuto({"tutorial_4_10a","tutorial_4_10a_gpad"},0,0,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(-9,-3)
				
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
			-- 11. Deleting objects
			init = function()
				MF_tutorialbackgroundfade(58)
				
				text_tuto({"tutorial_4_11a","tutorial_4_11a_gpad"},0,-2,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(6,-7)
				
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
		
		slide12 = 
		{
			-- 12. Edit object data
			init = function()
				text_tuto({"tutorial_4_12a","tutorial_4_12a_gpad"},0,-1,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(8,-7)
				
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
		
		slide13 = 
		{
			-- 13. Edit metadata showcase
			init = function()
				unitreference = {}
				MF_loop("enter_objectedit",1)
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "wall") then
						unitreference["wall"] = b.object
					end
				end
				submenu("objectedit","wall")
				MF_tutorialbackground(true,0)
				MF_specialvisible_string("ZLevel",0)
				
				text_tuto("tutorial_4_13a",0,2,true)
				MF_removebutton("a1")
				MF_removebutton("a2")
				MF_removebutton("a3")
				MF_removebutton("a4")
				MF_removebutton("a5")
				MF_removebutton("a6")
				
				MF_removebutton("w1")
				MF_removebutton("w2")
				MF_removebutton("w3")
				MF_removebutton("w4")
				MF_removebutton("w5")
				MF_removebutton("w6")
				
				MF_removebutton("-")
				MF_removebutton("+")
				
				MF_removebutton("l-")
				MF_removebutton("l+")
				
				MF_removebutton("reset")
				
				button_tuto("cont","tutorial_continue",0,8.5,16,2)
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
			-- 14. Back to currobjlist
			init = function()
				closemenu()
				MF_loop("closeobjectsettings",1)
				
				text_tuto("tutorial_4_14a",0,2,true,nil,nil,screenw * 0.6)
				
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
		
		slide15 = 
		{
			-- 15. Dragging objects
			init = function()
				text_tuto({"tutorial_4_15a","tutorial_4_15a_gpad"},0,0,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(-9.5,-3)
				--tuto_pointer(-5,-0.5)
				
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
				
				text_tuto("tutorial_4_16a",0,-4,true)
				MF_showtileplacer(0)
				
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