local tuto_subcontents =
{
	tutorial7 =
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
				text_tuto("tutorial_7_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_7_1b",0,-3,true)
				
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
			-- 2. Explaining the level codes
			init = function()
				text_tuto("tutorial_7_2a",0,-4,true)
				
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
			-- 3. Editor main menu & get levels
			init = function()
				changemenu("editor_start")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_7_3a",0,-8,true)
				
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
		
		slide4 = 
		{
			-- 4. Get levels menu
			init = function()
				changemenu("playlevels_getmenu")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_7_4a",0,2,true)
				
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
			-- 5. Featured levels
			init = function()
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_7_5a",0,1,true)
				
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
			-- 6. Level found menu
			init = function()
				changemenu("playlevels_get_success",{langtext("tutorial_7_levelname",true),langtext("tutorial_7_author",true),langtext("tutorial_7_subtitle",true)})
				MF_tutorialbackground(true,0)
				generaldata5.values[TUTORIAL_SHOWTEXT] = 1
				
				text_tuto("tutorial_7_6a",0,-8,true)
				
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
		
		slide7 = 
		{
			-- 7. Play without saving
			init = function()
				text_tuto("tutorial_7_7a",0,-8,true)
				
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
			-- 8. Save level menu
			init = function()
				changemenu("playlevels_get_play",{langtext("tutorial_7_levelname",true),langtext("tutorial_7_author",true),langtext("tutorial_7_subtitle",true)})
				MF_tutorialbackground(true,0)
				generaldata5.values[TUTORIAL_SHOWTEXT] = 1
				
				text_tuto("tutorial_7_8a",0,-8,true)
				
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
		
		slide9 = 
		{
			-- 9. Notice about reporting levels
			init = function()
				changemenu("tutorial_intro")
				text_tuto("tutorial_7_9a",0,-4,true)
				
				button_tuto("cont","tutorial_continue",0,4,16,2)
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
			-- 10. The end
			init = function()
				changemenu("tutorial_intro")
				
				text_tuto({"tutorial_7_10a", n = "tutorial_7_10a"},0,-4,true)
				
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