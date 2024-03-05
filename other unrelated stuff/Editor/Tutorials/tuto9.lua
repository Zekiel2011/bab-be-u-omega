local tuto_subcontents =
{
	tutorial9 =
	{
		init = function()
			MF_tutorialbackground(true,0)
			MF_disablebuttons(1)
			tutorial_load("slide1")
		end,
		
		slide1 = 
		{
			-- 1. Welcome back & explanation
			init = function()
				text_tuto("tutorial_9_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_9_1b",0,-3,true)
				
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
			-- 2. Sandboxes/machines/etc
			init = function()
				local wraplimit = screenw * 0.75
				if (generaldata.strings[LANG] ~= "en") then
					wraplimit = screenw * 0.85
				end
				
				text_tuto("tutorial_9_2a",0,-7,true,nil,nil,wraplimit)
				
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
		
		slide3 = 
		{
			-- 3. Trolling & flashing colours etc
			init = function()
				text_tuto("tutorial_9_3a",0,-6,true,nil,nil,screenw * 0.85)
				
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
			-- 4. Good puzzle basics (imo)
			init = function()
				text_tuto("tutorial_9_4a",0,-6,true,nil,nil,screenw * 0.85)
				
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
			-- 5. Interactions
			init = function()
				local wraplimit = screenw * 0.75
				if (generaldata.strings[LANG] ~= "en") then
					wraplimit = screenw * 0.85
				end
				
				text_tuto("tutorial_9_5a",0,-6,true,nil,nil,wraplimit)
				
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
			-- 6. Elegance
			init = function()
				local wraplimit = screenw * 0.85
				if (generaldata.strings[LANG] == "jpn") then
					wraplimit = screenw * 0.65
				end
				
				text_tuto("tutorial_9_6a",0,-8.5,true,nil,nil,wraplimit)
				
				local offset = 0
				if (generaldata.strings[LANG] == "vi") then
					offset = 1
				end
				text_tuto("tutorial_9_6b",0,0.5 + offset,true,nil,nil,screenw * 0.85)
				
				button_tuto("cont","tutorial_continue",0,7.5,16,2)
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
			-- 7. Simplicity
			init = function()
				local wraplimit = screenw * 0.75
				if (generaldata.strings[LANG] ~= "en") then
					wraplimit = screenw * 0.85
				end
				
				text_tuto("tutorial_9_7a",0,-8.5,true,nil,nil,wraplimit)
				text_tuto("tutorial_9_7b",0,-0.5,true,nil,nil,wraplimit)
				
				button_tuto("cont","tutorial_continue",0,7.5,16,2)
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
			-- 8. Overly obscure systems
			init = function()
				local wraplimit = screenw * 0.75
				if (generaldata.strings[LANG] ~= "en") and (generaldata.strings[LANG] ~= "jpn") then
					wraplimit = screenw * 0.85
				end
				
				text_tuto("tutorial_9_8a",0,-8.5,true,nil,nil,wraplimit)
				text_tuto("tutorial_9_8b",0,1.5,true,nil,nil,wraplimit)
				
				button_tuto("cont","tutorial_continue",0,7.5,16,2)
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
			-- 9. Overly obscure systems
			init = function()
				text_tuto("tutorial_9_9a",0,-6,true,nil,nil,screenw * 0.85)
				
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
		
		slide10 = 
		{
			-- 10. Decoration
			init = function()
				local wraplimit = screenw * 0.85
				if (generaldata.strings[LANG] == "jpn") then
					wraplimit = screenw * 0.8
				end
				
				text_tuto("tutorial_9_10a",0,-8.5,true,nil,nil,wraplimit)
				text_tuto("tutorial_9_10b",0,0,true,nil,nil,wraplimit)
				
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
		
		slide11 = 
		{
			-- 11. The end
			init = function()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("tutorial_intro")
				MF_clearborders()
				
				text_tuto("tutorial_9_11a",0,-5,true)
				MF_showtileplacer(0)
				
				button_tuto("end","tutorial_end",0,5,16,2)
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