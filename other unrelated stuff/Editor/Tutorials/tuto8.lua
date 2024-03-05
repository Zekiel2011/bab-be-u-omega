local tuto_subcontents =
{
	tutorial8 =
	{
		init = function()
			MF_tutorialbackground(true,0)
			MF_disablebuttons(1)
			tutorial_load("slide1")
		end,
		
		slide1 = 
		{
			-- 1. Welcome back & shortcut menu
			init = function()
				text_tuto("tutorial_8_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_8_1b",0,-3,true)
				
				button_tuto("cont","tutorial_continue",0,6,16,4)
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
			-- 2. Removing levels quickly
			init = function()
				generaldata.strings[WORLD] = "levels"
				changemenu("level")
				MF_tutorialbackground(true,0)
				MF_removebutton("return")
				
				text_tuto({"tutorial_8_2a","tutorial_8_2a_gpad"},0,-9,true)
				
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
			-- 3. Quickly searching
			init = function()
				text_tuto({"tutorial_8_3a","tutorial_8_3a_gpad"},0,-9,true,nil,nil,screenw * 0.75)
				
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
			-- 4. Rest of the stuff in editor
			init = function()
				editor.values[NAMETARGET] = 3
				editor.strings[NAMETOGIVE] = "Tutorial"
				MF_loop("name2",1)
				MF_loop("newlevel_init",1)
				editor2.values[DOPAIRS] = 0
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				
				addobjtolist("wall")
				local obj = ""
				for a,b in ipairs(editor_currobjlist) do
					if (b.name == "wall") then
						obj = b.object
						break
					end
				end
				placetile(obj,9,8,0,0)
				placetile(obj,10,8,0,1)
				placetile(obj,11,8,0,2)
				placetile(obj,12,8,0,3)
				placetile(obj,13,8,0,0)
				placetile(obj,14,8,0,1)
				placetile(obj,15,8,0,2)
				
				placetile(obj,9,12,0,3)
				placetile(obj,10,12,0,0)
				placetile(obj,11,12,0,1)
				placetile(obj,12,12,0,2)
				placetile(obj,13,12,0,3)
				placetile(obj,14,12,0,0)
				placetile(obj,15,12,0,1)
				
				text_tuto("tutorial_8_4a",0,-6,true,nil,nil,screenw * 0.6)
				
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
			-- 5. Show directions
			init = function()
				text_tuto({"tutorial_8_5a","tutorial_8_5a_gpad"},0,-6,true,nil,nil,screenw * 0.6)
				
				editor4.strings[TUTORIAL_EXTRA] = "multidir"
				
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
		
		slide6 = 
		{
			-- 6. Move all objects
			init = function()
				text_tuto({"tutorial_8_6a","tutorial_8_6a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				editor4.strings[TUTORIAL_EXTRA] = ""
				
				editor_moveall(1)
				
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
			-- 7. Empty level & empty tile
			init = function()
				text_tuto({"tutorial_8_7a","tutorial_8_7a_gpad"},0,-8,true,nil,nil,screenw * 0.6)
				
				MF_showtileplacer(1)
				MF_movetileplacer(10,7)
				
				editor3.values[PREVLAYER] = editor.values[LAYER]
				MF_loop("emptytile",5)
				
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
			-- 8. Quick test & other buttons
			init = function()
				text_tuto({"tutorial_8_8a","tutorial_8_8a_gpad"},0,-8,true,nil,nil,screenw * 0.6)
				
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
			-- 9. Quick select
			init = function()
				text_tuto({"tutorial_8_9a","tutorial_8_9a_gpad"},0,-8,true,nil,nil,screenw * 0.8)
				
				editor_autopick("baba is you")
				
				button_tuto("cont","tutorial_continue",0,6,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide9plus")
			end,
			
			structure =
			{
				{
					{{"cont"}},
				}
			},
		},
		
		slide9plus = 
		{
			-- 9+. Level Is Auto
			init = function()
				editor4.values[SELECTIONX] = -1
				editor4.values[SELECTIONY] = -1
				editor4.values[SELECTIONWIDTH] = 0
				editor4.values[SELECTIONHEIGHT] = 0
				editor4.values[SELECTION_ON] = 0
				
				MF_showtileplacer(0)
				
				submenu("editorsettingsmenu")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_8_9a_extra",0,-7,true,nil,nil,screenw * 0.75)
				
				MF_removebutton("closemenu")
				MF_removebutton("rename")
				MF_removebutton("author")
				MF_removebutton("subtitle")
				MF_removebutton("music")
				MF_removebutton("particles")
				MF_removebutton("palette")
				MF_removebutton("levelsize")
				MF_removebutton("mapsetup")
				
				button_tuto("cont","tutorial_continue",0,8,16,2)
			end,
			
			button_cont = function()
				tutorial_load("slide10")
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
			-- 10. To currobjlist
			init = function()
				closemenu()
				submenu("currobjlist")
				MF_tutorialbackground(true,0)
				
				text_tuto("tutorial_8_10a",0,-3,true,nil,nil,screenw * 0.6)
				
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
			-- 11. Quick delete & edit & swap
			init = function()
				text_tuto({"tutorial_8_11a","tutorial_8_11a_gpad"},0,-3,true,nil,nil,screenw * 0.6)
				
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
			-- 12. Quick add
			init = function()
				text_tuto({"tutorial_8_12a","tutorial_8_12a_gpad"},0,-3,true,nil,nil,screenw * 0.6)
				
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
			-- 13. The end
			init = function()
				clearunits()
				clearobjlist()
				generaldata.values[ROOMSIZEX] = 35
				generaldata.values[ROOMSIZEY] = 20
				MF_loop("clear",1)
				MF_loop("changelevelsize",1)
				changemenu("tutorial_intro")
				MF_clearborders()
				
				text_tuto("tutorial_8_13a",0,-4,true)
				MF_showtileplacer(0)
				
				button_tuto("end","tutorial_end",0,4,16,4)
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