local tuto_subcontents =
{
	tutorial2 =
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
				text_tuto("tutorial_2_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_2_1b",0,-3,true)
				
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
				
				text_tuto("tutorial_2_2a",0,-6,true,nil,nil,screenw * 0.6)
				
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
			-- 3. Object placement
			init = function()
				text_tuto({"tutorial_2_3a", "tutorial_2_3a_gpad"},0,-7,true,nil,nil,screenw * 0.75)
				
				MF_showtileplacer(1)
				MF_movetileplacer(10,10)
				
				tutorial_placetile("baba",10,10,0)
				tutorial_placetile("flag",11,10,0)
				tutorial_placetile("text_baba",12,10,0)
				
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
		
		slide4 = 
		{
			-- 4. Object copying & cutting
			init = function()
				text_tuto({"tutorial_2_4a", "tutorial_2_4a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_copytile(11,10,0)
				MF_movetileplacer(10,11)
				MF_loop("updatecursor",1)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide4b")
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide4b = 
		{
			-- 4b. Swapping
			init = function()
				text_tuto({"tutorial_2_4b", "tutorial_2_4b_gpad"},0,-6,true,nil,nil,screenw * 0.6)
				
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "text_flag") then
						editor_selector.strings[1] = b.object
						break
					end
				end
				MF_loop("updatecursor",1)
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide5")
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
			-- 5. Object dragging
			init = function()
				text_tuto({"tutorial_2_5a", "tutorial_2_5a_gpad"},0,-7,true,nil,nil,screenw * 0.8)
				
				MF_movetileplacer(10,10)
				editor3.values[PREVLAYER] = editor.values[LAYER]
				MF_loop("emptytile",5)
				
				MF_movetileplacer(7,9)
				tutorial_placetile("baba",7,9,0)
				editor.values[EDITORDIR] = 0
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide5b")
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide5b = 
		{
			-- 5b. Changing object direction
			init = function()
				text_tuto({"tutorial_2_5b", "tutorial_2_5b_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_updatedir(7,9,2)
				editor.values[EDITORDIR] = 2
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide6")
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
			-- 6. Selecting empty
			init = function()
				text_tuto({"tutorial_2_6a", "tutorial_2_6a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_copytile(8,9,0)
				MF_movetileplacer(8,9)
				MF_loop("updatecursor",1)
				
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
		
		slide7 = 
		{
			-- 7. Tools (for later)
			init = function(btype)
				text_tuto("tutorial_2_7a",0,-6,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(16,-1)
				
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
			-- 8. Switching layer
			init = function()
				text_tuto({"tutorial_2_8a", "tutorial_2_8a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				if (btype == "keyboard") then
					tuto_pointer(16,-6.5)
				end
				editor.values[LAYER] = 1
				makeselection({"layer1","layer2","layer3"},2)
				
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
			-- 9. Quickbar intro
			init = function()
				text_tuto("tutorial_2_9a",0,-5,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(9,-8)
				
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
			-- 10. Quickbar - browsing
			init = function()
				text_tuto({"tutorial_2_10a", "tutorial_2_10a_gpad"},0,-5,true,nil,nil,screenw * 0.6)
				
				editor4.values[QUICKBAR_ID] = editor4.values[QUICKBAR_ID] + 1
				MF_loop("hotbar_updatetile",1)
				
				tuto_pointer(9,-8)
				
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
		
		slide11 = 
		{
			-- 11. Quickbar - locking/unlocking
			init = function()
				text_tuto({"tutorial_2_11a", "tutorial_2_11a_gpad"},0,-5,true,nil,nil,screenw * 0.75)
				
				MF_hotbar_lock(1,1)
				
				tuto_pointer(6,-8)
				MF_showtileplacer(0)
				
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
			-- 12. Quickbar - emptying a tile
			init = function()
				text_tuto({"tutorial_2_12a", "tutorial_2_12a_gpad"},0,-5,true,nil,nil,screenw * 0.6)
				
				MF_hotbar_empty(1)
				MF_loop("updatecursor",1)
				MF_showtileplacer(1)
				
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
			-- 13. Testing & Saving
			init = function()
				text_tuto({"tutorial_2_13a", "tutorial_2_13a_gpad"},0,-5,true,nil,nil,screenw * 0.6)
				
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
			-- 14. The end
			init = function()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("tutorial_intro")
				MF_clearborders()
				
				text_tuto("tutorial_2_14a",0,-4,true)
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