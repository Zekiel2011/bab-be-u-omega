local tuto_subcontents =
{
	tutorial5 =
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
				text_tuto("tutorial_5_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_5_1b",0,-3,true)
				
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
			-- 2. Editor view & pointing out the settings buttons
			init = function()
				generaldata.strings[WORLD] = "levels"
				editor.values[NAMETARGET] = 3
				editor.strings[NAMETOGIVE] = "Tutorial"
				MF_loop("name2",1)
				MF_loop("newlevel_init",1)
				editor2.values[DOPAIRS] = 0
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				
				text_tuto({"tutorial_5_2a","tutorial_5_2a_gpad"},0,-6,true,nil,nil,screenw * 0.6)
				
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
			-- 3. Level settings overview
			init = function()
				submenu("editorsettingsmenu")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_3a",-8,-5,true,nil,nil,screenw * 0.4)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 4. Level name
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_4a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,-5)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 5. Author name
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_5a",-8,-6,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,-4)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 6. Subtitle
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_6a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,-3)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 7. Music
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_7a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,-2)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 8. Particles
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_8a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,-1)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 9. Palette
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_9a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,0)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 10. Level size
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_10a",-8,-5,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(6,1)
				
				button_tuto("cont","tutorial_continue",-8,1,12,2)
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
			-- 11. Other settings
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_11a",-8,-6,true,nil,nil,screenw * 0.4)
				
				tuto_pointer(0,3)
				
				local offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = 1
				end
				
				button_tuto("cont","tutorial_continue",-8,1 + offset,12,2)
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
			-- 12. Back to general view
			init = function()
				closemenu()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_12a",0,-6,true,nil,nil,screenw * 0.6)
				
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
			-- 13. Editor menu
			init = function()
				submenu("editormenu")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_13a",0,-9,true,nil,nil,screenw * 0.6)
				
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
		
		slide14 = 
		{
			-- 14. Upload
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_14a",0,-9,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(2,-2)
				
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
			-- 15. Themes
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_15a",0,-9,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(2,-1)
				
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
			-- 16. Themes (cont'd)
			init = function()
				submenu("themes")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_16a",0,1,true,nil,nil,screenw * 0.6)
				
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
		
		slide17 = 
		{
			-- 17. Delete level
			init = function()
				closemenu()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_17a",0,-9,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(2,2.5)
				
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
		
		slide18 = 
		{
			-- 18. Copy level
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_5_18a",0,-9,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(2,3.5)
				
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
		
		slide19 = 
		{
			-- 19. The end
			init = function()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("tutorial_intro")
				MF_clearborders()
				
				text_tuto("tutorial_5_19a",0,-4,true)
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