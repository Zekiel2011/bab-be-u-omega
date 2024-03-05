function tutorial_start(id)
	local tdata = tutodata[id]
	
	tutomenu = {}
	unitreference = {}
	
	if (tdata ~= nil) then
		editor4.values[EDITOR_TUTORIAL] = 1
		editor4.strings[TUTORIAL] = id
		
		if (tdata.init ~= nil) then
			tdata.init()
		end
	end
end

function tutorial_end()
	MF_tutorialbackground(false,1)
	MF_letterclear("tutorial",0)
	MF_delete("tutorial")
	MF_clearthumbnails("tutorial")
	MF_clearcontrolicons(0)
	
	editor4.strings[TUTORIAL] = ""
	editor4.strings[TUTORIALSLIDE] = ""
	editor4.values[EDITOR_TUTORIAL] = 0
	
	changemenu("editor_start")
	submenu("editor_start_settings")
	submenu("editor_start_settings_help")
end

function tutorial_load(slide,id_)
	if (id_ ~= nil) then
		tutorial_start(id_)
	end
	
	local tname = editor4.strings[TUTORIAL]
	local tdata = tutodata[tname]
	
	local build = generaldata.strings[BUILD]
	local gamepad_ = MF_profilefound()
	local gamepad = false
	local buildtype = "keyboard"
	if (gamepad_ ~= nil) then
		gamepad = true
	end
	
	if (generaldata2.values[BUTTONPROMPTTYPE] == 0) then
		gamepad = false
		gamepad_ = nil
	end
	
	if (build == "n") then
		buildtype = "n"
	elseif gamepad then
		buildtype = "gpad"
	else
		buildtype = "keyboard"
	end
	
	if (tdata ~= nil) then
		if (tdata[slide] ~= nil) then
			MF_letterclear("tutorial",0)
			MF_delete("tutorial")
			MF_clearthumbnails("tutorial")
			MF_clearcontrolicons(0)
			
			editor4.strings[TUTORIALSLIDE] = slide
			
			local sdata = tdata[slide]
			
			sdata.init(buildtype)
		end
	end
	
	editor2.values[MENU_XPOS] = 0
	editor2.values[MENU_YPOS] = 0
	generaldata2.values[INMENU] = 1
end

function tutorial_nextslide()
	local current = editor4.strings[TUTORIALSLIDE]
	
	local num = tonumber(string.match(current, "%d+")) or 0
	num = num + 1
	
	tutorial_load("slide" .. tostring(num))
end

function text_tuto(text_,x,y,centered_,wrapping_,colour_,wraplimit_)
	local centered = centered_ or false
	local wrapping = true
	local lang = generaldata.strings[LANG]
	
	if (wrapping_ ~= nil) then
		wrapping = wrapping_
	end
	
	local xpos = screenw * 0.5 + f_tilesize * x
	local ypos = screenh * 0.5 + f_tilesize * y
	local text = ""
	
	if (type(text_) == "string") then
		text = langtext(text_,true)
	elseif (type(text_) == "table") then
		local basetext = text_[1]
		local gpadtext = text_[2] or basetext
		local ntext = text_["n"] or gpadtext
		
		local build = generaldata.strings[BUILD]
		local gamepad_ = MF_profilefound()
		local gamepad = false
		if (gamepad_ ~= nil) then
			gamepad = true
		end
		
		if (generaldata2.values[BUTTONPROMPTTYPE] == 0) then
			gamepad = false
			gamepad_ = nil
		end
		
		if (build == "n") then
			text = langtext(ntext,true)
		elseif gamepad then
			text = langtext(gpadtext,true)
		else
			text = langtext(basetext,true)
		end
	end
	
	local colour = colour_ or {0,3}
	local wraplimit = wraplimit_ or screenw * 0.8
	
	--MF_alert(tostring(wraplimit) .. ", " .. tostring(wraplimit_) .. ", " .. tostring(wrapping))
	
	local textlines = {}
	local wrapthese = {":", ";", "!", "?", "»"}
	local rarewraps = {"！）。", "！！", "）、", "）。", "，", "。", "？", "！", "、", "”", "】", "》", "）",} --, "」", "』", }
	local rarewraps_codes = {"_A", "_B", "_C", "_D", "_E", "_F", "_G", "_H", "_I", "_J", "_K", "_L", "_M", "_N", "_O" }
	
	if (string.len(text) * 8 > wraplimit) and wrapping then
		local subtext = ""
		
		for i,v in ipairs(rarewraps) do
			text = string.gsub(text, v, rarewraps_codes[i] .. "~")
		end
		
		for i=1,string.len(text) do
			local l = string.sub(text, i, i)
			local nl = string.sub(text, i+1, i+1)
			local pl = string.sub(text, i-1, i-1)
			
			local preventspacewrap = false
			if (generaldata.strings[LANG] == "fr") and (l == " ") then
				if (nl ~= nil) then
					for a,b in ipairs(wrapthese) do
						if (b == nl) then
							preventspacewrap = true
							break
						end
					end
				end
				
				if (pl ~= nil) and (pl == "«") then
					preventspacewrap = true
				end
			end
			
			if ((l == " ") and (string.len(subtext) * 8 > wraplimit * 0.875) and (preventspacewrap == false) and (lang ~= "tha")) or ((l == "~") and (string.len(subtext) * 8 > wraplimit * 0.75)) or (l == "^") then
				table.insert(textlines, subtext)
				subtext = ""
			elseif (l ~= "~") then
				subtext = subtext .. l
				if (string.len(subtext) * 8 > wraplimit * 0.875) and (lang ~= "tha") then
					for a,b in ipairs(wrapthese) do
						if (b == l) then
							table.insert(textlines, subtext)
							subtext = ""
							break
						end
					end
				end
			end
			
			if (i == string.len(text)) and (string.len(subtext) > 0) then
				table.insert(textlines, subtext)
				subtext = ""
			end
		end
	else
		table.insert(textlines, text)
	end
	
	local forcecustom = false
	if (generaldata.strings[LANG] ~= "en") then
		forcecustom = true
	end
	
	for i,v in ipairs(textlines) do
		local vtext = v
		
		for a,b in ipairs(rarewraps_codes) do
			if (rarewraps[a] ~= nil) then
				vtext = string.gsub(vtext, b, rarewraps[a])
			end
		end
		
		writetext(vtext,0,xpos,ypos + 24 * (i - 1),"tutorial",centered,2,true,colour,nil,nil,forcecustom)
	end
	
	return #textlines
end

function button_tuto(func,text_,x,y,w,h,dwmin,dwmax_)
	local xpos = screenw * 0.5 + f_tilesize * x
	local ypos = screenh * 0.5 + f_tilesize * y
	local text = ""
	
	if (#text_ > 0) then
		text = langtext(text_)
	end
	
	local toobig = false
	local dynw = w
	if (dwmin ~= nil) then
		local dwmax = dwmax_ or 16
		dynw, toobig = getdynamicbuttonwidth(text,dwmin,dwmax)
	end
	
	createbutton(func,xpos,ypos,2,dynw,h,text,"tutorial",nil,nil,"tutorial",nil,nil,nil,nil,nil,nil,nil,toobig)
end

function tutorial_buttonpress(func)
	local tuto = editor4.strings[TUTORIAL]
	local slide = editor4.strings[TUTORIALSLIDE]
	
	local fullfunc = "button_" .. func
	
	local tdata = tutodata[tuto] or {}
	local sdata = tdata[slide] or {}
	
	if (sdata[fullfunc] ~= nil) then
		local bfunc = sdata[fullfunc]
		
		bfunc()
	end
end

function tuto_pointer(tx_,ty_,l_,x_,y_)
	local tx = screenw * 0.5 + tx_ * f_tilesize
	local ty = screenh * 0.5 + ty_ * f_tilesize
	
	local l = l_ or 48
	local x = x_ or screenw * 0.5
	local y = y_ or screenh * 0.5
	
	local pointerid = MF_specialcreate("Tutorial_arrow_base")
	local pointer = mmf.newObject(pointerid)
	
	pointer.values[2] = x
	pointer.values[3] = y
	pointer.values[XPOS] = tx
	pointer.values[YPOS] = ty
	pointer.values[6] = l
	pointer.layer = 2
	
	pointer.values[24] = tx
	pointer.values[25] = ty
	
	for i=1,2 do
		local sideid = MF_specialcreate("Tutorial_arrow_side")
		local side = mmf.newObject(sideid)
		
		side.values[1] = pointerid
		side.values[2] = i - 1
		side.layer = 2
		side.scaleX = 5
	end
end

function tuto_pointer_button(func,l_,x_,y_)
	local buttons = MF_getbutton(func)
	
	if (#buttons > 0) then
		local bid = buttons[1]
		local button = mmf.newObject(bid)
		local tx = button.x
		local ty = button.y
		
		local l = l_ or 48
		local x = x_ or screenw * 0.5
		local y = y_ or screenh * 0.5
		
		tx = x + (tx - x) * 0.9
		ty = y + (ty - y) * 0.9
		
		local pointerid = MF_specialcreate("Tutorial_arrow_base")
		local pointer = mmf.newObject(pointerid)
		
		pointer.values[2] = x
		pointer.values[3] = y
		pointer.values[XPOS] = tx
		pointer.values[YPOS] = ty
		pointer.values[6] = l
		pointer.layer = 2
		
		pointer.values[24] = tx
		pointer.values[25] = ty
		
		for i=1,2 do
			local sideid = MF_specialcreate("Tutorial_arrow_side")
			local side = mmf.newObject(sideid)
			
			side.values[1] = pointerid
			side.values[2] = i - 1
			side.layer = 2
			side.scaleX = 5
		end
	end
end

function tutomenu_position(tutoname,tutoslide,x,y,build)
	local thistuto = tutodata[tutoname]
	local thisslide = thistuto[tutoslide]
	local structurelist = thisslide.structure
	
	if (structurelist == nil) then
		MF_alert(menu .. " has no structurelist!")
	end
	
	local structure = structurelist[build] or structurelist[1]
	
	local row = structure[y + 1]
	local target = {""}
	
	local xdim,ydim = 0,0
	local ox,oy = 0,0
	local extra = ""
	
	if (row ~= nil) then
		xdim = #row
		ydim = #structure
		
		if (row[x + 1] ~= nil) then
			target = row[x + 1]
			ox = target[2] or 0
			oy = target[3] or 0
			
			if (tostring(type(target[2])) == "string") then
				ox = 0
				extra = target[2]
			end
		else
			print("column " .. tostring(x) .. " doesn't exist on row " .. tostring(y) .. " in tuto " .. tutoname)
		end
	else
		print("Row " .. tostring(y) .. " doesn't exist in tuto " .. tutoname)
	end
	
	return target[1],xdim,ydim,ox,oy
end

function tutorial_placetile(name,x,y,dir_)
	local obj = ""
	for a,b in ipairs(editor_currobjlist) do
		if (b.name == name) then
			obj = b.object
			break
		end
	end
	
	local dir = dir_ or 0
	
	placetile(obj,x,y,0,dir)
end

function tutorial_copytile(x,y,z)
	local tileid = x + y * roomsizex
	
	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			local unit = mmf.newObject(v)
			
			if (unit.values[LAYER] == z) and (unit.className ~= "level") and (unit.className ~= "path") then
				copytile(editor_selector.fixed,v)
				return
			end
		end
	else
		editor_selector.strings[1] = ""
		editor_selector.values[XPOS] = -1
		editor_selector.values[YPOS] = -1
		editor_selector.values[6] = -1
		editor_selector.values[7] = -1
	end
end

function tutorial_updatedir(x,y,dir)
	local tileid = x + y * roomsizex
	
	editor.values[EDITORDIR] = dir
	MF_setsublayer(0,x,y,0,dir)
	
	if (unitmap[tileid] ~= nil) then
		for i,v in ipairs(unitmap[tileid]) do
			local unit = mmf.newObject(v)
			
			unit.values[DIR] = dir
			unit.direction = dir * 8
		end
	end
end

function tutorial_emptytile(x,y)
	MF_movetileplacer(x,y)
	editor3.values[PREVLAYER] = editor.values[LAYER]
	MF_loop("emptytile",5)
end