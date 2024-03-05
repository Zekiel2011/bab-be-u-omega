local tuto_subcontents =
{
	tutorial6 =
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
				text_tuto("tutorial_6_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_6_1b",0,-3,true)
				
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
				
				text_tuto("tutorial_6_2a",0,-4,true,nil,nil,screenw * 0.6)
				
				tuto_pointer_button("menu")
				
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
			-- 3. Editor menu
			init = function()
				submenu("editormenu")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_6_3a",0,-7,true,nil,nil,screenw * 0.6)
				
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
		
		slide4 = 
		{
			-- 4. Upload menu
			init = function()
				submenu("uploadlevel")
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				generaldata5.values[TUTORIAL_SHOWTEXT] = 1
				
				text_tuto("tutorial_6_4a",0,-8,true,nil,nil,screenw * 0.6)
				
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
			-- 5. Explanation for having to beat the level
			init = function()
				text_tuto("tutorial_6_5a",0,-8,true,nil,nil,screenw * 0.6)
				
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
			-- 6. Post-upload screen
			init = function()
				closemenu()
				changemenu("upload_done",{"XXXX-YYYY",true,true})
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				generaldata5.values[TUTORIAL_SHOWTEXT] = 1
				
				text_tuto("tutorial_6_6a",0,-8.5,true,nil,nil,screenw * 0.75)
				
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
			-- 7. Main editor menu -> history
			init = function()
				closemenu()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("editor_start")
				MF_clearborders()
				MF_showtileplacer(0)
				MF_tutorialbackground(true,0)
				generaldata5.values[TUTORIAL_SHOWTEXT] = 0
				
				text_tuto("tutorial_6_7a",0,-8.5,true,nil,nil,screenw * 0.6)
				
				tuto_pointer(2,1.5)
				
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
		
		slide8 = 
		{
			-- 8. The end & warning about offensive content
			init = function()
				changemenu("tutorial_intro")
				
				text_tuto("tutorial_6_8a",0,-4,true)
				
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