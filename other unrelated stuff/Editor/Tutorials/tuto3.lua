local tuto_subcontents =
{
	tutorial3 =
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
				text_tuto("tutorial_3_1a",0,-4,true,nil,{1,3})
				text_tuto("tutorial_3_1b",0,-3,true)
				
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
			-- 2. Editor view & tools pointer
			init = function()
				generaldata.strings[WORLD] = "levels"
				editor.values[NAMETARGET] = 3
				editor.strings[NAMETOGIVE] = "Tutorial"
				MF_loop("name2",1)
				MF_loop("newlevel_init",1)
				editor2.values[DOPAIRS] = 0
				MF_tutorialbackground(true,0)
				MF_tutorialbackgroundfade(200)
				
				tuto_pointer(16,-1)
				
				text_tuto("tutorial_3_2a",0,-6,true,nil,nil,screenw * 0.6)
				
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
			-- 3. Pencil
			init = function()
				text_tuto({"tutorial_3_3a","tutorial_3_3a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				MF_showtileplacer(1)
				MF_movetileplacer(10,10)
				
				tutorial_placetile("baba",10,10,0)
				tutorial_placetile("baba",11,10,0)
				tutorial_placetile("baba",12,10,0)
				
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
			-- 4. Eraser
			init = function()
				text_tuto("tutorial_3_4a",0,-7,true,nil,nil,screenw * 0.6)
				
				MF_movetileplacer(11,10)
				
				editor3.values[PREVLAYER] = editor.values[LAYER]
				MF_loop("emptytile",5)
				
				local tool_select = 6
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,4.5)
				
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
			-- 5. Line tool
			init = function()
				text_tuto("tutorial_3_5a",0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_emptytile(10,10)
				
				MF_movetileplacer(12,10)
				
				local tool_select = 1
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,-3)
				
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
			-- 6. Line tool showcase
			init = function()
				text_tuto("tutorial_3_6a",0,-7,true,nil,nil,screenw * 0.6)
				
				editor3.values[PREVLAYER] = editor.values[LAYER]
				MF_loop("emptytile",5)
				
				MF_movetileplacer(7,12)
				tutorial_placetile("flag",12,10,0)
				tutorial_placetile("flag",11,10,0)
				tutorial_placetile("flag",10,11,0)
				tutorial_placetile("flag",9,11,0)
				tutorial_placetile("flag",8,12,0)
				tutorial_placetile("flag",7,12,0)
				
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
			-- 7. Rectangle tool
			init = function()
				text_tuto("tutorial_3_7a",0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_emptytile(7,12)
				tutorial_emptytile(8,12)
				tutorial_emptytile(9,11)
				tutorial_emptytile(10,11)
				tutorial_emptytile(11,10)
				tutorial_emptytile(12,10)
				
				local tool_select = 2
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,-1.5)
				
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
			-- 8. Rectangle tool showcase
			init = function()
				text_tuto("tutorial_3_8a",0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_placetile("text_baba",8,8,0)
				tutorial_placetile("text_baba",9,8,0)
				tutorial_placetile("text_baba",10,8,0)
				tutorial_placetile("text_baba",11,8,0)
				tutorial_placetile("text_baba",12,8,0)
				
				tutorial_placetile("text_baba",8,9,0)
				tutorial_placetile("text_baba",12,9,0)
				tutorial_placetile("text_baba",8,10,0)
				tutorial_placetile("text_baba",12,10,0)
				tutorial_placetile("text_baba",8,11,0)
				tutorial_placetile("text_baba",12,11,0)
				
				tutorial_placetile("text_baba",8,12,0)
				tutorial_placetile("text_baba",9,12,0)
				tutorial_placetile("text_baba",10,12,0)
				tutorial_placetile("text_baba",11,12,0)
				tutorial_placetile("text_baba",12,12,0)
				
				MF_movetileplacer(12,12)
				
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
			-- 9. Filled rectangle
			init = function()
				text_tuto("tutorial_3_9a",0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_placetile("text_baba",9,9,0)
				tutorial_placetile("text_baba",10,9,0)
				tutorial_placetile("text_baba",11,9,0)
				tutorial_placetile("text_baba",9,10,0)
				tutorial_placetile("text_baba",10,10,0)
				tutorial_placetile("text_baba",11,10,0)
				tutorial_placetile("text_baba",9,11,0)
				tutorial_placetile("text_baba",10,11,0)
				tutorial_placetile("text_baba",11,11,0)
				
				local tool_select = 3
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,0)
				
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
			-- 10. Fill tool
			init = function()
				text_tuto("tutorial_3_10a",0,-7,true,nil,nil,screenw * 0.6)
				
				--[[
				tutorial_emptytile(8,8)
				tutorial_emptytile(9,8)
				tutorial_emptytile(10,8)
				tutorial_emptytile(11,8)
				tutorial_emptytile(12,8)
				
				tutorial_emptytile(8,9)
				]]--
				tutorial_emptytile(9,9)
				tutorial_emptytile(10,9)
				tutorial_emptytile(11,9)
				--[[
				tutorial_emptytile(12,9)
				
				tutorial_emptytile(8,10)
				]]--
				tutorial_emptytile(9,10)
				tutorial_emptytile(10,10)
				tutorial_emptytile(11,10)
				--[[
				tutorial_emptytile(12,10)
				
				tutorial_emptytile(8,11)
				]]--
				tutorial_emptytile(9,11)
				tutorial_emptytile(10,11)
				tutorial_emptytile(11,11)
				--[[
				tutorial_emptytile(12,11)
				
				tutorial_emptytile(8,12)
				tutorial_emptytile(9,12)
				tutorial_emptytile(10,12)
				tutorial_emptytile(11,12)
				tutorial_emptytile(12,12)
				]]--
				
				MF_movetileplacer(10,10)
				
				local tool_select = 5
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,3)
				
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
			-- 11. Selection tool intro
			init = function()
				text_tuto("tutorial_3_11a",0,-7,true,nil,nil,screenw * 0.6)
				
				tutorial_emptytile(8,8)
				tutorial_emptytile(9,8)
				tutorial_emptytile(10,8)
				tutorial_emptytile(11,8)
				tutorial_emptytile(12,8)
				
				--[[
				tutorial_emptytile(8,9)
				tutorial_emptytile(12,9)
				
				tutorial_emptytile(8,10)
				tutorial_emptytile(12,10)
				]]--
				
				tutorial_emptytile(8,11)
				tutorial_emptytile(12,11)
				
				tutorial_emptytile(8,12)
				tutorial_emptytile(9,12)
				tutorial_emptytile(10,12)
				tutorial_emptytile(11,12)
				tutorial_emptytile(12,12)
				
				MF_movetileplacer(8,8)
				
				local tool_select = 4
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				tuto_pointer(16,1.5)
				
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
			-- 12. Select an area
			init = function()
				text_tuto("tutorial_3_12a",0,-7,true,nil,nil,screenw * 0.6)
				
				editor4.values[SELECTIONX] = 14
				editor4.values[SELECTIONY] = 12
				editor4.values[SELECTIONWIDTH] = 6
				editor4.values[SELECTIONHEIGHT] = 4
				editor4.values[SELECTION_ON] = 1
				
				editor_setselectionrect(8,8,6,4)
				
				MF_loop("createselectionrect_x", 6)
				
				MF_movetileplacer(14,12)
				
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
			-- 13. Pasting & alt pasting
			init = function()
				text_tuto({"tutorial_3_13a","tutorial_3_13a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				MF_movetileplacer(19,12)
				editor_selectionrect_place(19,12)
				
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
			-- 14. Rotating/flipping/mirroring
			init = function()
				text_tuto({"tutorial_3_14a","tutorial_3_14a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				MF_movetileplacer(21,10)
				editor_flipselection(1)
				
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
			-- 15. Deselecting
			init = function()
				text_tuto({"tutorial_3_15a","tutorial_3_15a_gpad"},0,-7,true,nil,nil,screenw * 0.6)
				
				editor4.values[SELECTIONX] = -1
				editor4.values[SELECTIONY] = -1
				editor4.values[SELECTIONWIDTH] = 0
				editor4.values[SELECTIONHEIGHT] = 0
				editor4.values[SELECTION_ON] = 0
				
				local tool_select = 0
				editor2.values[EDITORTOOL] = tool_select
				makeselection({"tool_normal","tool_line","tool_rectangle","tool_fillrectangle","tool_select","tool_fill","tool_erase"},tool_select + 1)
				
				
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
				
				text_tuto("tutorial_3_16a",0,-4,true)
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