function writetext(text_,owner,xoffset,yoffset,type,centered_,layer_,absolute_,colours_,credits_,sliding_,forcecustom_,nocodes_)
	local text = text_
	local letterw = 10
	local letterh = 16
	local length = string.len(text)
	local usecustom = generaldata4.values[CUSTOMFONT]
	
	if (forcecustom_ ~= nil) and forcecustom_ then
		usecustom = 1
	end
	
	local credits = credits_ or 0
	if (credits > 0) and (credits ~= 2) and (credits ~= 4) then
		if (generaldata.strings[LANG] ~= "it") then
			letterw = 20
		else
			letterw = 18
		end
		letterh = 22
	elseif (credits == 2) then
		letterw = 26
		letterh = 22
	elseif (credits == 4) then
		letterw = 24
		letterh = 22
	end
	
	if (generaldata.strings[BUILD] == "m") and (credits == 0) and (type ~= "arttext") then
		if (generaldata.strings[LANG] == "en") then
			letterw = letterw * 2
			letterh = letterh * 2
		else
			letterw = letterw * 1.2
			letterh = letterh * 2
		end
	end
	
	local sliding = sliding_ or 0
	
	local colourization = {}
	local currcolour = 1
	
	local centered = centered_ or false
	local nocodes = nocodes_ or false
	local absolute = true
	
	if (absolute_ ~= nil) then
		absolute = absolute_
	end
	
	local x,y = 0,0
	local finalx,finaly = 0,0
	local vi = 0
	
	local offx,offy = Xoffset,Yoffset
	if absolute or ((owner ~= 0) and (owner ~= -1)) then
		offx,offy = 0,0
	end
	
	local layer = 2
	if (owner == -1) or (owner == 0) then
		layer = 3
	end
	
	if (layer_ ~= nil) then
		layer = layer_
	end
	
	local texticonlist = {}
	
	local vislength = length
	local i = 1
	while (i <= length) do
		local letter = string.sub(text, i, i)
		
		if (letter == "$") then
			vislength = vislength - 4
			local cdata = string.sub(text, i+1, i+3)
			
			c1 = tonumber(string.sub(cdata, 1, 1))
			c2 = tonumber(string.sub(cdata, 3, 3))
			
			table.insert(colourization, {c1, c2})
			
			if (i == 1) then
				colourization.customfont = {c1, c2}
			end
		end
		
		if (letter == "#") and (nocodes == false) then
			local sublength = 0
			local command = ""
			
			for j=i,length do
				local subletter = ""
				
				if (j < length) then
					subletter = string.sub(text, j+1, j+1)
				end
				
				if (subletter ~= " ") then
					sublength = sublength + 1
				end
				
				if (subletter == " ") or (j == length) then
					command = string.sub(text, i+1, j)
					local commandresult = langtext(command)
					
					vislength = vislength - ((string.len(command) + 1) - string.len(commandresult))
					
					text = string.gsub(text, "#" .. command, commandresult, 1)
					local lengthdelta = length - string.len(text)
					length = string.len(text)
					i = i - lengthdelta
					break
				end
			end
		end
		
		if (letter == "@") and (nocodes == false) then
			local sublength = 0
			local command = ""
			
			for j=i,length do
				local subletter = ""
				
				if (j < length) then
					subletter = string.sub(text, j+1, j+1)
				end
				
				if (subletter ~= " ") and (subletter ~= ":") then
					sublength = sublength + 1
				end
				
				if (subletter == " ") or (subletter == ":") or (j == length) then
					command = string.sub(text, i+1, j)
					
					vislength = vislength - sublength + 8
					
					local iconid = MF_specialcreate("ControlIcon")
					local icon = mmf.newObject(iconid)
					
					icon.values[ICON_INLEVEL] = 0
					icon.layer = layer
					icon.x = xoffset + offx + (i+0.5) * letterw 
					icon.y = yoffset + offy
					
					setupcontrolicon(icon,command)
					
					table.insert(texticonlist, {icon, i})
					
					if (usecustom == 1) then
						text = string.gsub(text, "@" .. command, "        ", 1)
					else
						text = string.gsub(text, "@" .. command, "    ", 1)
					end
					
					local lengthdelta = length - string.len(text)
					length = string.len(text)
					i = i - 1
					break
				end
			end
		end
		
		i = i + 1
	end
	
	local prunedtext = string.gsub(text, "[$][0-9][,][0-9]", "")
	local prunedtext_utf,invalid = decode(prunedtext)
	
	if centered then
		for i,v in ipairs(texticonlist) do
			local icon = v[1]
			icon.x = icon.x - ((string.len(prunedtext) - 1) * letterw * 0.5)
		end
	end
	
	if invalid and (usecustom == 0) then
		--MF_alert(prunedtext)
		prunedtext = string.lower(prunedtext)
		prunedtext_utf,invalid = decode(prunedtext)
	end
	
	if invalid and (credits == 0) then
		usecustom = 1
	end
	
	if (usecustom == 0) then
		text = string.lower(text)
	end
	
	local text_utf = decode(text)
	vislength = #prunedtext_utf
	
	local c1,c2 = getuicolour("default")
	
	if (colours_ ~= nil) then
		c1 = colours_[1]
		c2 = colours_[2]
	end
	local offset = 0
	
	local letters = {}
	
	-- 56 = $, 57 = Space
	
	if (usecustom == 0) then
		for i=1,#text_utf do
			local j = i + offset
			local letter = text_utf[j]
			
			if (letter >= 165) and (letter <= 172) then
				--letterw = 27
			end
			
			if (letter ~= 56) then
				x = x + letterw
				vi = vi + 1
			else
				local cdata = colourization[currcolour]
				
				c1 = cdata[1]
				c2 = cdata[2]
				
				currcolour = currcolour + 1
				offset = offset + 3
			end
			
			if (centered == false) then
				finalx = x
				finaly = y
			else
				finalx = (0 - (vislength * 0.5) + vi) * letterw
			end
			
			if (letter ~= 57) and (letter ~= 56) then
				local tid = 0
				
				if (credits == 0) then
					local letter_utf = text_utf[j]
					
					if (letter == 8) and (generaldata.strings[LANG] == "tr") then
						letter_utf = 157
					end
					
					tid = MF_letter(letter_utf,owner,type,offx+xoffset+finalx-4,offy+yoffset+finaly,layer,sliding)
				else
					local letter_utf = text_utf[j]
					
					if (letter == 8) and (generaldata.strings[LANG] == "tr") then
						letter_utf = 157
					end
					
					tid = MF_creditsletter(letter_utf,offx+xoffset+finalx-4,offy+yoffset+finaly,layer,credits,vi,type)
				end
				
				if (c1 ~= nil) and (c2 ~= nil) and ((c1 ~= 0) or (c2 ~= 3) and (tid ~= 0)) then
					MF_setcolour(tid, c1, c2)
				end
				
				table.insert(letters, {tid, vi})
			end
			
			j = i + offset
			if (j >= #text_utf) then
				break
			end
		end
	else
		local customfontid = MF_specialcreate("Hud_customtext")
		local customfont = mmf.newObject(customfontid)
		
		customfont.x = xoffset + offx
		customfont.y = yoffset + offy
		customfont.values[1] = owner
		customfont.values[14] = credits
		customfont.strings[1] = prunedtext
		customfont.strings[2] = type
		
		customfont.values[15] = customfont.x
		customfont.values[16] = customfont.y
		customfont.values[17] = sliding
		
		if (credits > 0) then
			customfont.values[4] = letterh * 1.5
			
			if (credits == 1) then
				customfont.values[11] = -7
			elseif (credits == 2) then
				customfont.strings[3] = "congrats"
			elseif (credits == 3) then
				customfont.strings[3] = "wave"
			end
		end
		
		if centered then
			customfont.values[2] = 1
		end
		
		for a,b in ipairs(texticonlist) do
			local icon = b[1]
			local pos = b[2]
			
			local w = MF_gettextwidth(string.sub(prunedtext, 1, pos),16)
			
			icon.x = xoffset + offx + w + 12
			
			if centered then
				icon.x = icon.x - MF_gettextwidth(prunedtext,16) * 0.5
			end
		end
		
		if (colourization.customfont ~= nil) then
			local c_ = colourization.customfont
			local c1_ = c_[1]
			local c2_ = c_[2]
			
			customfont.values[12] = c1_
			customfont.values[13] = c2_
		else
			if (colours_ ~= nil) then
				customfont.values[12] = c1
				customfont.values[13] = c2
			end
		end
		
		finalx = string.len(prunedtext) * customfont.values[4]
		table.insert(letters, customfontid)
	end
	
	return finalx,letters
end

function erase(text)
	local result = string.sub(text, 1, string.len(text) - 1)
	
	return result
end

function createbutton(func,x,y,layer,xscale_,yscale,text,menu,c1_,c2_,id_,disabled_,selected_,tooltip_,icon_,nocheckmark_,sliding_,defaultxscale_,forcecustom_)
	local buttonid = MF_create("Editor_editorbutton")
	local button = mmf.newObject(buttonid)
	button.x = x
	button.y = y
	button.values[ONLINE] = 1
	button.values[YORIGIN] = y
	button.layer = layer
	button.strings[BUTTONFUNC] = func
	button.values[BUTTON_STOREDX] = x
	button.values[BUTTON_STOREDY] = y
	
	local prunedtext = string.gsub(text, "[$][0-9][,][0-9]", "")
	local hm,invalid = decode(prunedtext)
	
	button.strings[BUTTONTEXT] = prunedtext
	
	local xscale = xscale_
	local dxscale = defaultxscale_ or 0
	local bwidth = xscale - (8 / f_tilesize)
	local bitxscale = xscale
	
	local forcecustom = forcecustom_ or false
	
	if (xscale == 0) then
		xscale = #hm + 2
		
		if (generaldata4.values[CUSTOMFONT] == 0) and (forcecustom == false) then
			bwidth = math.max(xscale / f_tilesize * 10.0, dxscale)
		else
			bwidth = math.max(MF_gettextwidth(prunedtext .. "M", 16 + generaldata5.values[LETTERMULTIPLIER] * 6) / f_tilesize, dxscale)
		end
		
		bitxscale = bwidth
		bwidth = bwidth - (8 / f_tilesize)
	end
	
	button.scaleX = bwidth
	button.scaleY = yscale - (8 / f_tilesize)
	
	local icon = icon_ or nil
	local nocheckmark = false
	
	if (nocheckmark_ ~= nil) then
		nocheckmark = nocheckmark_
	end
	
	if (sliding_ ~= nil) then
		button.flags[BUTTON_SLIDING] = sliding_
	end
	
	if (generaldata4.values[CUSTOMFONT] == 0) and (text ~= "<empty>") and (icon == nil) and (invalid == false) and (forcecustom == false) then
		--MF_alert(text .. ", " .. menu)
		writetext(text,buttonid,0,0,menu,true,nil,nil,nil,nil,nil,nil,true)
	end
	
	if invalid or forcecustom then
		button.flags[BUTTON_USECUSTOMFONT] = true
	end
	
	if (icon ~= nil) then
		MF_buttonicon(buttonid,icon,menu)
	end
	
	local c = colours["editorui"]
	local c1 = c1_ or c[1]
	local c2 = c2_ or c[2]
	
	local colour = tostring(c1) .. "," .. tostring(c2)
	button.strings[UI_CUSTOMCOLOUR] = colour
	
	local tooltip = tooltip_ or ""
	button.strings[BUTTONTOOLTIP] = tooltip
	
	button.values[BUTTON_SELECTED] = selected_ or 0
	
	if (button.values[BUTTON_SELECTED] == 1) then
		c = colours["toggle_on"]
		c1 = c[1]
		c2 = c[2]
	end
	
	MF_setcolour(buttonid, c1, c2)
	
	button.values[XPOS] = x
	button.values[YPOS] = y
	
	local disabled = 0
	if (disabled_ ~= nil) then
		if disabled_ then
			disabled = 1
		end
	end
	
	local id = "EditorButton"
	
	if (id_ ~= nil) then
		id = id_
	end
	
	button.strings[BUTTONID] = id
	button.values[BUTTON_DISABLED] = disabled
	button.flags[BUTTON_NOCHECKMARK] = nocheckmark
	
	local bits = {{"ul", -1, -1},{"u", 0, -1},{"ur", 1, -1},{"l", -1, 0},{"r", 1, 0},{"dl", -1, 1},{"d", 0, 1},{"dr", 1, 1},{"s", -1, 0}}
	
	for i,v in ipairs(bits) do
		local bdir = v[1]
		local bxoffset = v[2]
		local byoffset = v[3]
		
		local bid = MF_specialcreate("Editor_button_" .. bdir .. "_edge")
		local b = mmf.newObject(bid)
		
		b.strings[BUTTONFUNC] = func
		b.values[ONLINE] = buttonid
		b.layer = layer
		b.values[XPOS] = bxoffset
		b.values[YPOS] = byoffset
		b.values[XVEL] = bitxscale
		b.values[YVEL] = yscale
		b.values[YORIGIN] = y
		b.strings[BUTTONID] = id
		b.values[BUTTON_DISABLED] = disabled
		
		if (bdir == "u") or (bdir == "d") then
			b.scaleX = bwidth
		elseif (bdir == "l") or (bdir == "r") then
			b.scaleY = yscale - (8 / f_tilesize)
		end
	end
	
	return buttonid,bitxscale
end

function updatebuttontext(func,text,menu)
	local buttons = MF_getbutton(func)
	
	if (#buttons > 0) then
		for i,v in ipairs(buttons) do
			if (generaldata4.values[CUSTOMFONT] == 0) then
				MF_buttonletterclear(v)
				
				writetext(text,v,0,0,menu,true,nil,nil,nil,nil,nil,nil,true)
			else
				local button = mmf.newObject(v)
				
				button.strings[BUTTONTEXT] = text
			end
		end
	end
end

function updatebuttontext_lang(func,text_,menu)
	local buttons = MF_getbutton(func)
	local text = langtext(text_)
	
	if (#buttons > 0) then
		for i,v in ipairs(buttons) do
			if (generaldata4.values[CUSTOMFONT] == 0) then
				MF_buttonletterclear(v)
				
				writetext(text,v,0,0,menu,true,nil,nil,nil,nil,nil,nil,true)
			else
				local button = mmf.newObject(v)
				
				button.strings[BUTTONTEXT] = text
			end
		end
	end
end

function updatebuttontext_fromlist(value,func,menu,opts)
	local opt = value + 1
	local langtext_key = opts[opt] or "-"
	
	local result = langtext(langtext_key)
	
	updatebuttontext(func,result,menu)
end

function updatebuttoncolour(unitid,value,iconopts)
	local s,c,icon = gettoggle(value,iconopts)
	
	if (generaldata.strings[BUILD] ~= "m") or ((generaldata.strings[BUILD] == "m") and (iconopts == nil)) then
		local unit = mmf.newObject(unitid)
		unit.values[BUTTON_SELECTED] = s
		
		MF_setcolour(unitid, c[1],c[2])
	else
		local iconopt = bicons[icon]
		MF_updatebuttonicon(unitid, iconopt)
	end
end

function slider(func,x,y,width,colour,colour2,id,minimum,maximum,current)
	local barid = MF_create("Editor_slider")
	local knobid = MF_create("Editor_sliderknob")
	local bar = mmf.newObject(barid)
	local knob = mmf.newObject(knobid)
	
	MF_setcolour(barid,colour[1],colour[2])
	MF_setcolour(knobid,colour2[1],colour2[2])
	
	local mult = 1.0
	if (generaldata.strings[BUILD] == "m") then
		mult = 1.75
	end
	
	bar.scaleX = width * mult
	bar.scaleY = mult
	bar.x = x
	bar.y = y
	bar.layer = 2
	bar.values[ONLINE] = 1
	bar.values[YORIGIN] = y
	bar.strings[BUTTONFUNC] = func
	bar.strings[BUTTONID] = id
	bar.values[12] = mult
	
	bar.values[BUTTON_STOREDX] = x
	bar.values[BUTTON_STOREDY] = y
	
	bar.values[SLIDER_MIN] = minimum
	bar.values[SLIDER_CURR] = current
	bar.values[SLIDER_MAX] = maximum
	
	knob.scaleX = mult
	knob.scaleY = mult
	knob.x = -24
	knob.y = -24
	knob.layer = 2
	knob.values[ONLINE] = 1
	knob.values[YORIGIN] = y
	knob.values[SLIDERKNOB_OWNER] = barid
	knob.strings[BUTTONFUNC] = func
	knob.strings[BUTTONID] = id
	knob.values[12] = mult
	
	knob.values[BUTTON_STOREDX] = x
	knob.values[BUTTON_STOREDY] = y
	
	bar.strings[UI_CUSTOMCOLOUR] = tostring(colour[1]) .. "," .. tostring(colour[2])
	knob.strings[UI_CUSTOMCOLOUR] = tostring(colour2[1]) .. "," .. tostring(colour2[2])
end

function displaylevelname(name_,level,layer_,group_,x_,y_,absolute_,prefix_,suffix_)
	local xoffset = x_ or f_tilesize * 0.5
	local yoffset = y_ or f_tilesize * 0.5
	local centered = false
	local absolute = absolute_ or false
	
	if (generaldata.strings[BUILD] == "m") then
		xoffset = xoffset + f_tilesize * 0.8
		yoffset = yoffset + f_tilesize * 1.5
	end
	
	yoffset = math.max(f_tilesize * 0.5, yoffset)
	
	local actual_name = name_ or generaldata.strings[LEVELNAME]
	local prefix = prefix_ or ""
	local suffix = suffix_ or ""
	
	if (#suffix > 0) then
		suffix = " " .. suffix
	end
	
	local name = prefix .. actual_name .. suffix
	
	if (x_ ~= nil) then
		centered = true
	end
	
	local layer = 2
	if (layer_ ~= nil) then
		layer = layer_
	end
	
	local group = "editorname"
	if (group_ ~= nil) then
		group = group_
	end
	
	if (string.len(level) >= 5) and (string.sub(level, -5) == "level") then
		local world = generaldata.strings[WORLD]
		
		local levelcode = world .. "_" .. level
		if (generaldata.strings[WORLD] == generaldata.strings[BASEWORLD]) then
			levelcode = level
		end
		
		if (generaldata.strings[LANG] ~= "en") then
			local langlevelname = MF_read("lang","texts",levelcode)
			
			if (string.len(langlevelname) > 0) then
				name = prefix .. langlevelname
			end
		end
	end

	MF_letterclear(group)
	
	writetext(name,-1,xoffset,yoffset,group,centered,layer,absolute,nil,nil,nil,nil,true)
end

function submenu(menuitem,extra)
	local currmenu = menu[1]
	table.insert(menu, 1, menuitem)
	MF_letterhide(currmenu,0)
	editor.strings[MENU] = menu[1]
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_visible(buttonid,0)
			MF_visible_thumbnail(buttonid,0)
		end
		
		if (func.submenu_leave ~= nil) then
			func.submenu_leave(currmenu,menuitem,buttonid,extra)
		end
	end
	
	editor2.values[ALLOWSCROLL] = 0
	generaldata2.values[INMENU] = 0
	editor3.strings[ESCBUTTON] = ""
	
	if (menufuncs[menuitem] ~= nil) then
		local func = menufuncs[menuitem]
		local buttonid = func.button or nil
		
		if (func.enter ~= nil) then
			func.enter(currmenu,menuitem,buttonid,extra)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
		
		if (func.scrolling ~= nil) then
			editor2.values[ALLOWSCROLL] = func.scrolling
		end
		
		if (func.escbutton ~= nil) then
			editor3.strings[ESCBUTTON] = func.escbutton
		end
		
		if (func.slide ~= nil) then
			local slide = func.slide
			editor2.values[MENU_XOFFSET] = slide[1] * screenw or 0
			editor2.values[MENU_YOFFSET] = slide[2] * screenh or 0
		end
	end
	
	--MF_alert("Submenu " .. menuitem)
	
	editor.values[SCROLLAMOUNT] = 0
end

function changemenu(menuitem,extra)
	local currmenu = menu[1]
	MF_letterclear(currmenu,0)
	menu[1] = menuitem
	editor.strings[MENU] = menu[1]
	MF_clearcontrolicons(0)
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_delete(buttonid)
			MF_clearthumbnails(buttonid)
		end
		
		if (func.leave ~= nil) then
			func.leave(menu[2],currmenu,buttonid,extra)
		end
	end
	
	editor2.values[ALLOWSCROLL] = 0
	generaldata2.values[INMENU] = 0
	editor3.strings[ESCBUTTON] = ""
	
	if (menufuncs[menuitem] ~= nil) then
		local func = menufuncs[menuitem]
		local buttonid = func.button or nil
		
		if (func.enter ~= nil) then
			func.enter(currmenu,menuitem,buttonid,extra)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
		
		if (func.scrolling ~= nil) then
			editor2.values[ALLOWSCROLL] = func.scrolling
		end
		
		if (func.escbutton ~= nil) then
			editor3.strings[ESCBUTTON] = func.escbutton
		end
		
		if (func.slide ~= nil) then
			local slide = func.slide
			editor2.values[MENU_XOFFSET] = slide[1] * screenw or 0
			editor2.values[MENU_YOFFSET] = slide[2] * screenh or 0
		end
	end
	
	--MF_alert("Changed to menu " .. menuitem)
	
	editor.values[SCROLLAMOUNT] = 0
end

function closemenu(extra)
	local currmenu = menu[1]
	local deleted = menu[1]
	MF_letterclear(currmenu)
	table.remove(menu, 1)
	currmenu = menu[1]
	MF_letterhide(currmenu,1)
	editor.strings[MENU] = menu[1]
	MF_clearcontrolicons(0)
	
	--MF_alert("Closed menu " .. deleted)
	
	if (menufuncs[deleted] ~= nil) then
		local func = menufuncs[deleted]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_delete(buttonid)
			MF_clearthumbnails(buttonid)
		end
		
		if (func.leave ~= nil) then
			func.leave(currmenu,deleted,buttonid,extra)
		end
		
		if (func.slide_leave ~= nil) then
			local slide = func.slide_leave
			editor2.values[MENU_XOFFSET] = slide[1] * screenw or 0
			editor2.values[MENU_YOFFSET] = slide[2] * screenh or 0
		end
		
		if (func.menuitem_leave ~= nil) then
			editor4.strings[CURRMENUITEM] = func.menuitem
		end
	end
	
	editor2.values[ALLOWSCROLL] = 0
	generaldata2.values[INMENU] = 0
	editor3.strings[ESCBUTTON] = ""
	
	if (menufuncs[currmenu] ~= nil) then
		local func = menufuncs[currmenu]
		local buttonid = func.button or nil
		
		if (buttonid ~= nil) then
			MF_visible(buttonid,1)
			MF_visible_thumbnail(buttonid,1)
		end
		
		--MF_alert(currmenu .. ", " .. tostring(buttonid))
		
		if (func.submenu_return ~= nil) then
			func.submenu_return(deleted,currmenu,buttonid,extra)
		end
		
		if (func.structure ~= nil) then
			generaldata2.values[INMENU] = 1
		end
		
		if (func.scrolling ~= nil) then
			editor2.values[ALLOWSCROLL] = func.scrolling
		end
		
		if (func.escbutton ~= nil) then
			editor3.strings[ESCBUTTON] = func.escbutton
		end
	end
	
	editor.values[SCROLLAMOUNT] = 0
end

function scrollarea(list)
	local miny = 0
	local maxy = 0
	
	local scroll = 0
	
	if (#list > 0) then
		for i,unitid in ipairs(list) do
			local unit = mmf.newObject(unitid)
			
			if (unit.yTop < miny) or (miny == 0) then
				miny = unit.yTop
			end
			
			if (unit.yBottom > maxy) or (maxy == 0) then
				maxy = unit.yBottom
			end
		end
	else
		print("No list")
	end
	
	scroll = maxy - miny
	
	editor.values[SCROLLAREA] = scroll
end

function gettoggle(value_,iconopts)
	local value = tonumber(value_)
	if (value == 1) then
		local icon = nil
		
		if (iconopts ~= nil) then
			icon = iconopts[2]
		end
		
		return 1,colours["toggle_on"],icon
	else
		local icon = nil
		
		if (iconopts ~= nil) then
			icon = iconopts[1]
		end
		
		return 0,colours["editorui"],icon
	end
end

function makeselection(options,choice)
	for i,option in ipairs(options) do
		if (string.sub(option, 1, 1) ~= "_") then
			local buttons = MF_getbutton(option)
			
			local selected = 0
			if (i == choice) then
				selected = 1
			end
			
			local s,c = gettoggle(selected)
			
			if (#buttons > 0) then
				for a,b in ipairs(buttons) do
					local unit = mmf.newObject(b)
					
					if (unit ~= nil) then
						unit.values[BUTTON_SELECTED] = selected
						
						if unit.visible or (editor.strings[MENU] == "currobjlist") then
							MF_setcolour(b, c[1], c[2])
						end
					end
				end
			end
		end
	end
end

function creditstext(text_,id)
	local x = screenw * 0.5
	local y = screenh + f_tilesize * 2 + id * 48
	
	local text = text_
	
	if (generaldata4.values[CUSTOMFONT] == 0) then
		text = string.lower(text_)
	end
	
	writetext(text,0,x,y,"credits",true,3,nil,nil,1)
end

function clearletters(group)
	MF_letterclear(group)
end

function controlicon_editor(group,name,x,y,buttonid,text_,textdir,bybuttonname_,altname,alttext_,alttext_2)
	local iconid = MF_specialcreate("ControlIcon")
	local icon = mmf.newObject(iconid)
	
	local namecheck = name
	local text = text_ or ""
	local alttext = alttext_ or ""
	local alttext2 = alttext_2 or ""
	
	icon.x = x
	icon.y = y
	icon.layer = 2
	icon.visible = false
	
	icon.values[8] = x
	icon.values[9] = y
	icon.values[1] = -1
	
	local bybuttonname = false
	if (bybuttonname_ ~= nil) then
		bybuttonname = bybuttonname_
	end
	
	local groups = 
	{
	keyboard_ingame = 1,
	gamepad_ingame = 2,
	gamepad_editor = 3,
	gamepad_currobjlist = 4,
	}
	
	local groupnum = 1
	if (groups[group] ~= nil) then
		groupnum = groups[group]
	end
	
	local button = MF_read("settings",group,name)
	local gpad = MF_profilefound()
	
	if bybuttonname and (gpad ~= nil) and gpad then
		local altcutoff = 17
		local count = 0
		
		if (generaldata.strings[BUILD] == "n") then
			if (name == "x") then
				namecheck = "b"
			elseif (name == "b") then
				namecheck = "x"
			end
		end
		
		MF_alert(tostring(group) .. ", " .. tostring(groupnum) .. ", " .. tostring(buttonid))
		local data = controlnames[groupnum]
		
		for i,v in ipairs(data) do
			local btn = MF_read("settings",group,v)
			local inpt = MF_gamepadprofilename_string(btn)
			
			if (inpt == namecheck) then
				if (count == 0) then
					text = langtext(text_ .. "_" .. v,true)
				elseif (count == 1) then
					alttext = langtext(text_ .. "_" .. v,true)
				else
					MF_alert(tostring(name) .. " found a third option?")
				end
				count = count + 1
			end
			
			if (inpt == name) then
				button = btn
			end
			
			if (namecheck == "a") and (generaldata.strings[BUILD] == "n") then
				alttext2 = langtext("buttons_editor_selection_place",true)
			elseif (namecheck == "b") and (generaldata.strings[BUILD] == "n") then
				alttext2 = langtext("buttons_editor_selection_cancel",true)
			elseif (namecheck == "x") and (generaldata.strings[BUILD] == "n") then
				alttext2 = langtext("buttons_editor_selection_cancel",true)
			elseif (namecheck == "y") and (generaldata.strings[BUILD] == "n") then
				alttext2 = langtext("buttons_editor_selection_ignore",true)
			end
		end
	end
	
	local bindgroup = "raw"
	
	if (gpad ~= nil) then
		if gpad then
			bindgroup = "named"
		end
	else
		--MF_alert("Loading keyboard input for control icon!")
	end
	
	local input = MF_gamepadprofilename_string(button)
	local inputtable = binds[bindgroup]
	local data = inputtable[input] or {45, 2, 14}
	
	--MF_alert(name .. ", " .. button .. ", " .. bindgroup .. ", " .. tostring(input) .. ", " .. tostring(data[3]))
	
	icon.animSet = data[2]
	icon.direction = data[3]
	icon.strings[5] = text or ""
	icon.strings[6] = alttext or ""
	icon.strings[7] = alttext2 or ""
	
	icon.strings[BUTTONFUNC] = input
	icon.strings[BUTTONID] = buttonid
	icon.strings[BUTTONNAME] = name
	icon.values[10] = 1
	icon.values[11] = textdir or 0
	
	return iconid
end

function createcontrolicon(name,gamepad,x,y,iid,update_,layer_,tiledata,icontext_)
	local iconid = 0
	local create = true
	
	if (update_ ~= nil) then
		iconid = update_
		create = false
	end
	
	if create then
		iconid = MF_specialcreate("ControlIcon")
	end
	
	local icon = mmf.newObject(iconid)
	
	if create then
		icon.x = x
		icon.y = y
		
		icon.values[8] = x
		icon.values[9] = y
	end
	
	local group = "keyboard"
	local bindgroup = "raw"
	
	if gamepad then
		group = "gamepad"
		
		if MF_profilefound() then
			bindgroup = "named"
		end
	end
	
	--MF_alert(tostring(group) .. ", " .. tostring(name))
	
	local buttonstring = MF_read("settings",group,name)
	local buttonid = -1
	local buttonname = ""
	local anim = 5
	local dir = 31
	local frame = 0
	
	if (buttonstring ~= "") then
		if gamepad then
			if (string.sub(buttonstring, 1, 1) ~= "a") and (buttonstring ~= "dpad") then
				buttonid = tonumber(buttonstring)
			end
		end
	else
		buttonstring = nil
		buttonid = nil
	end
	
	if gamepad then
		anim = 0
	end
	
	if (group == "gamepad") and (buttonstring ~= nil) then
		local thesebinds = binds[bindgroup]
		
		if (buttonstring ~= "dpad") then
			if (bindgroup == "named") then
				if (buttonid > -1) then
					local bindname = MF_gamepadprofilename(buttonid)
					local thisbind = thesebinds[bindname] or {0, 2, 31}
					
					buttonname = bindname
					anim = thisbind[2]
					dir = thisbind[3]
				else
					buttonid = MF_gamepadbuttonid(buttonstring .. "+")
					
					local bindname = MF_gamepadprofilename(buttonid)
					local thisbind = thesebinds[bindname] or {0, 2, 31}
					
					buttonname = bindname
					anim = thisbind[2]
					dir = thisbind[3]
				end
			else
				for i,v in pairs(thesebinds) do
					if (buttonid > -1) then
						if (v[1] == buttonid + 1) then
							buttonname = i
							anim = v[2]
							dir = v[3]
						end
					elseif (i == buttonstring) then
						buttonname = buttonstring
						anim = v[2]
						dir = v[3]
					end
				end
			end
		else
			buttonname = buttonstring
			anim = 2
			dir = 13
		end
	elseif (group == "keyboard") and (buttonstring ~= nil) then
		bindgroup = "keyboard"
		buttonid = tonumber(buttonstring)
		
		if (buttonid ~= 8) and (buttonid ~= -1) then
			buttonstring = MF_keyid(buttonid)
		elseif (buttonid == 8) then
			buttonstring = "Backspace"
		else
			buttonstring = "Esc"
		end
		
		local thesebinds = binds[bindgroup]
		
		for i,v in pairs(thesebinds) do
			if (string.lower(v) == string.lower(buttonstring)) then
				buttonname = tostring(i)
				frame = i
			end
		end
	end
	
	if (tiledata ~= nil) then
		icon.values[MISC_A] = tiledata[1]
		icon.values[MISC_B] = tiledata[2]
		icon.values[7] = 1
	else
		icon.values[7] = -1
	end
	
	icon.animSet = anim
	icon.direction = dir
	icon.strings[BUTTONFUNC] = buttonname
	icon.strings[BUTTONID] = iid
	icon.strings[BUTTONNAME] = name
	icon.values[NOTABSOLUTE] = 1
	icon.layer = layer_ or 2
	
	if (icontext_ ~= nil) then
		icon.strings[5] = icontext_
	end
	
	if (group == "keyboard") then
		icon.animFrame = frame
	end
	
	if gamepad then
		--icon.values[1] = buttonid
	end
	
	return iconid
end

function updatecontrolicons(gamepad)
	local allbuttons = MF_getbuttongroup("KeyConfigButton")
	local icons = {}
	
	for i,v in ipairs(allbuttons) do
		local unit = mmf.newObject(v)
		
		if (unit.className == "ControlIcon") then
			table.insert(icons, unit)
		end
	end
	
	for i,unit in ipairs(icons) do
		createcontrolicon(unit.strings[BUTTONNAME],gamepad,nil,nil,unit.strings[BUTTONID],unit.fixed)
	end
end

function getcontrolname(category,id)
	--MF_alert(tostring(category) .. ", " .. tostring(id))
	local result = controlnames[category + 1][id + 1]
	
	return result
end

function getcontrolid(style,id)
	local group = 1
	local result = -1
	
	if (style == "gamepad") then
		group = 2
	end
	
	for i,v in ipairs(controlnames[group]) do
		if (v == id) then
			result = i
		end
	end
	
	return group - 1,result - 1
end

function geticon(mode,rawname_,name_)
	local name = name_
	local rawname = rawname_
	
	if (string.sub(rawname_, 1, 1) == "a") and (string.len(rawname_) == 3) then
		rawname = string.sub(rawname_, 1, 2)
		name = MF_getprofileID(rawname .. "+")
	end
	
	local result = -1
	
	if (mode == 0) then
		result = binds["raw"][rawname][1]
	elseif (mode == 1) then
		result = binds["named"][name][1] or binds["raw"][rawname][1]
	end
	
	if (result ~= nil) then
		return result,name
	else
		return -1,name
	end
end

function undotooltip(state)
	local build = generaldata.strings[BUILD]
	
	if (state == 1) then
		local x = screenw * 0.5
		local y = f_tilesize * 0.8
		
		if (build == "m") then
			y = f_tilesize * 2.5
			
			local unitid1 = MF_specialcreate("Editor_ebutton_icon")
			local unit1 = mmf.newObject(unitid1)
			unit1.x = x + f_tilesize * 3.6
			unit1.y = y
			unit1.values[XPOS] = unit1.x
			unit1.values[YPOS] = unit1.y
			unit1.strings[1] = "UndoTooltip"
			unit1.layer = 2
			
			unit1.direction = 3
			
			local unitid2 = MF_specialcreate("Editor_ebutton_icon")
			local unit2 = mmf.newObject(unitid2)
			unit2.x = x - f_tilesize * 3.6
			unit2.y = y
			unit2.values[XPOS] = unit2.x
			unit2.values[YPOS] = unit2.y
			unit2.strings[1] = "UndoTooltip"
			unit2.layer = 2
			
			unit2.direction = 2
			
			particles("glow",((x + tilesize * 3.6) - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
			particles("glow",((x - tilesize * 3.6) - Xoffset) / tilesize,(y - Yoffset) / tilesize,10,{0,3},2,0)
		else
			local gamepad = MF_profilefound()
			local gamepad_ = false
			if (gamepad ~= nil) then
				gamepad_ = true
			end
			
			x = screenw * 0.5 - f_tilesize * 6
			
			createcontrolicon("undo",gamepad_,x,y,"UndoTooltip")
			particles("glow",(x - Xoffset) / f_tilesize,(y - Yoffset) / f_tilesize,10,{0,3},2,0)
			
			if (generaldata.strings[LANG] == "en") then
				local unitid1 = MF_specialcreate("customsprite")
				local unit1 = mmf.newObject(unitid1)
				
				unit1.values[ONLINE] = 1
				unit1.values[XPOS] = x + f_tilesize * 1.6
				unit1.values[YPOS] = y
				unit1.values[ZLAYER] = 30
				unit1.strings[OBJECTID] = "UndoTooltip"
				unit1.layer = 3
				unit1.direction = 0
				MF_loadsprite(unitid1,"button_undo_0",0,false)
			else
				writetext(langtext("undo"),0,x + f_tilesize * 0.6,y,"UndoTooltip",false,2,true)
			end
			
			particles("glow",((x + f_tilesize * 1.6) - Xoffset) / f_tilesize,(y - Yoffset) / f_tilesize,10,{0,3},2,0)
			
			x = screenw * 0.5 + f_tilesize * 4.5
			
			createcontrolicon("restart",gamepad_,x,y,"UndoTooltip")
			particles("glow",(x - Xoffset) / f_tilesize,(y - Yoffset) / f_tilesize,10,{0,3},2,0)
			
			if (generaldata.strings[LANG] == "en") then
				local unitid2 = MF_specialcreate("customsprite")
				local unit2 = mmf.newObject(unitid2)
				
				unit2.values[ONLINE] = 1
				unit2.values[XPOS] = x + f_tilesize * 1.6
				unit2.values[YPOS] = y
				unit2.values[ZLAYER] = 30
				unit2.strings[OBJECTID] = "UndoTooltip"
				unit2.layer = 3
				unit2.direction = 1
				MF_loadsprite(unitid2,"button_restart_0",1,false)
			else
				writetext(langtext("restart"),0,x + f_tilesize * 0.6,y,"UndoTooltip",false,2,true)
			end
			
			particles("glow",((x + f_tilesize * 1.6) - Xoffset) / f_tilesize,(y - Yoffset) / f_tilesize,10,{0,3},2,0)
		end
	else
		local tooltips = MF_findspecial("UndoTooltip")
		
		for i,v in ipairs(tooltips) do
			local unit = mmf.newObject(v)
			particles("glow",((unit.x + f_tilesize * 0.2) - Xoffset) / f_tilesize,((unit.y + f_tilesize * 0.2) - Yoffset) / f_tilesize,10,{0,3},2,0)
			MF_cleanspecialremove(v)
		end
		
		MF_letterclear("UndoTooltip")
	end
end

function menu_position(menu,x,y,build)
	local thismenu = menufuncs[menu]
	local structurelist = thismenu.structure or {}
	
	if (structurelist == nil) then
		MF_alert(menu .. " has no structurelist!")
		
		generaldata.values[INMENU] = 0
	end
	
	local structure = structurelist[build] or structurelist[1] or {}
	
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
			extra = target[4] or ""
			
			if (tostring(type(target[2])) == "string") then
				ox = 0
				extra = target[2]
			end
		else
			print("column " .. tostring(x) .. " doesn't exist on row " .. tostring(y) .. " in menu " .. menu)
		end
	else
		print("Row " .. tostring(y) .. " doesn't exist in menu " .. menu)
	end
	
	return target[1],xdim,ydim,ox,oy,extra
end

function findmenupos(item)
	local menu = editor.strings[MENU]
	local build = generaldata.strings[BUILD]
	local thismenu = menufuncs[menu]
	local structurelist = thismenu.structure
	
	if (structurelist == nil) then
		MF_alert(menu .. " has no structurelist!")
	end
	
	local structure = structurelist[build] or structurelist[1] or {}
	
	MF_alert("Looking for " .. item .. " in " .. menu)
	
	for y,a in ipairs(structure) do
		for x,b in ipairs(a) do
			if (b[1] == item) then
				MF_alert("found " .. item .. " at " .. tostring(x-1) .. ", " .. tostring(y-1))
				editor2.values[MENU_XPOS] = x-1
				editor2.values[MENU_YPOS] = y-1
				return
			end
		end
	end
end

function langtext(id,caps_,emptyreturn_)
	local result = MF_read("lang","texts",id)
	
	local caps_override = true
	local caps = caps_override
	
	if (caps_ ~= nil) then
		caps = caps_
	end
	
	local emptyreturn = emptyreturn_ or false
	
	if (result == "") then
		MF_alert(id .. " gave an empty langtext string!")
		
		MF_setfile("lang","lang_en.txt")
		result = MF_read("lang","texts",id)
		
		if (result == "") then
			result = "not found"
		end
		
		MF_setfile("lang","lang_" .. generaldata.strings[LANG] .. ".txt")
	elseif (result == "$s") then
		result = id
	elseif (result == "__") then
		result = ""
	end
	
	if (generaldata4.values[CUSTOMFONT] == 0) and (caps == false) then
		result = string.lower(result)
	end
	
	if emptyreturn and (result == "not found") then
		result = ""
	end
	
	return result
end

function langtext_multiple(ids)
	local result = {}
	
	for i,id in ipairs(ids) do
		local result_ = MF_read("lang","texts",id)
		
		if (result_ == "") then
			MF_alert(id .. " gave an empty langtext string!")
			result_ = "not found"
		elseif (result_ == "$s") then
			result_ = id
		elseif (result == "__") then
			result_ = ""
		end
		
		if (generaldata4.values[CUSTOMFONT] == 0) then
			result_ = string.lower(result_)
		end
		
		table.insert(result, result_)
	end
	
	return result
end

function hack_baba_world_langtext(id1,id2)
	local stuff = langtext_multiple({id1,id2})
	local result = stuff[1] .. "," .. stuff[2]
	
	return result
end

function introlangtext()
	local text1 = langtext("intro_mp2")
	local text2 = langtext("intro_mmf2")
	local text3 = ""
	local text4 = ""
	
	local language = generaldata.strings[LANG]
	
	if (language ~= "de") then
		text3 = langtext("intro_charity")
	else
		text3 = langtext("intro_charity_de_1")
		text4 = langtext("intro_charity_de_2")
	end
	
	local x = screenw * 0.5
	local y = screenh * 0.5
	
	local type = "IntroText"
	
	writetext(text1,0,x,y + f_tilesize * 3.2,type,true,2)
	writetext(text2,0,x,y * 2 - f_tilesize * 0.8,type,true,2)
	
	if (language ~= "de") then
		writetext(text3,0,x,y - f_tilesize * 0.5,type,true,2)
	else
		writetext(text3,0,x,y - f_tilesize * 1.5,type,true,2)
		writetext(text4,0,x,y - f_tilesize * 0.5,type,true,2)
	end
end

function menusetx()
	local currmenu = editor.strings[MENU]
	local build = generaldata.strings[BUILD]
	
	local menudata = menufuncs[currmenu]
	local structurelist = menudata.structure
	local structure = structurelist[1]
	
	if (string.len(build) > 0) and (structurelist[build] ~= nil) then
		structure = structurelist[build]
	end
	
	local x = editor2.values[MENU_XPOS] + 1
	local y = editor2.values[MENU_YPOS] + 1
	
	if (structure[y] ~= nil) then
		local xdim = #structure[y]
		
		x = math.min(xdim, x)
		
		local struct = structure[y]
		if (struct.defaultx ~= nil) then
			x = struct.defaultx + 1
		end
	else
		x = 1
	end
	
	x = x - 1
	
	return x
end

function buildmenustructure(data)
	local currmenu = editor.strings[MENU]
	local build = generaldata.strings[BUILD]
	
	local menudata = menufuncs[currmenu]
	
	menudata.structure = {}
	
	local structurelist = menudata.structure
	local structure = {}
	
	if (string.len(build) > 0) then
		structurelist[build] = {}
		structure = structurelist[build]
	else
		structurelist[1] = {}
		structure = structurelist[1]
	end
	
	for i,menu_y in ipairs(data) do
		table.insert(structure, {})
		local struct_y = structure[#structure]
		
		for a,menu_x in ipairs(menu_y) do
			table.insert(struct_y, {})
			local struct_x = struct_y[#struct_y]
			
			for b,opt in ipairs(menu_x) do
				table.insert(struct_x, opt)
			end
		end
		
		if (menu_y.defaultx ~= nil) then
			struct_y.defaultx = menu_y.defaultx
		end
	end
	
	generaldata2.values[INMENU] = 1
	structurelist.dynamic = true
	
	editor2.values[MENU_YDIM] = #data
	
	MF_cursorvisible(1)
end

function rebuildmenu()
	local lang = generaldata.strings[LANG]
	generaldata4.values[CUSTOMFONT] = tonumber(MF_read("lang","general","customfont")) or 0
	
	local menustruct = {}
	
	for i,v in ipairs(menu) do
		if (i < #menu) then
			table.insert(menustruct, 1, v)
		end
	end
	
	collapsemenu(menu[#menu])
	
	for i,v in ipairs(menustruct) do
		submenu(v)
	end
end

function collapsemenu(root_)
	local menucount = #menu - 1
	
	for i=1,menucount do
		closemenu()
	end
	
	local root = root_ or "main"
	
	changemenu(root)
end

function setupcontrolicon(icon,id)
	local i = 0
	local style = ""
	local menu = ""
	local group = ""
	local item = ""
	
	for word in string.gmatch(id, "%a+") do
		i = i + 1
		
		if (i == 1) then
			style = word
		elseif (i == 2) then
			menu = word
		elseif (i == 3) then
			item = word
		else
			item = item .. "_" .. word
		end
	end
	
	if (menu == "ingame") then
		if (style == "keyboard") then
			group = "keyboard"
		elseif (style == "gamepad") then
			group = "gamepad"
		end
	else
		if (style == "gamepad") then
			group = "gamepad_" .. menu
		end
	end
	
	if (string.len(item) > 0) and (string.len(group) > 0) then
		local button_raw = MF_read("settings",group,item)
		local button = ""
		local data = {}
		
		if (string.len(button_raw) > 0) then
			if (style == "gamepad") then
				local profile = MF_profilefound() or false
				
				if profile then
					data = binds["named"]
					
					if (menu ~= "ingame") then
						if (generaldata.strings[BUILD] == "n") then
							if (button_raw == "b2") then
								button_raw = "b1"
							elseif (button_raw == "b1") then
								button_raw = "b2"
							end
						end
						
						local buttonid = MF_gpad_string_to_raw(button_raw)
						button = MF_gpad_profile_raw_to_string(buttonid)
						
						local bdata = data[button]
						
						if (bdata ~= nil) then
							icon.animSet = bdata[2]
							icon.direction = bdata[3]
						else
							MF_alert("Couldn't find valid profile icon data for " .. button .. ", " .. tostring(buttonid))
						end
					else
						button_raw = tonumber(button_raw) or 0
						button = MF_gpad_profile_raw_to_string(button_raw)
						
						local bdata = data[button]
						
						if (bdata ~= nil) then
							icon.animSet = bdata[2]
							icon.direction = bdata[3]
						else
							MF_alert("Couldn't find valid profile icon data for " .. button .. ", " .. tostring(button_raw))
						end
					end
				else
					data = binds["raw"]
					
					if (menu ~= "ingame") then
						if (generaldata.strings[BUILD] == "n") then
							if (button_raw == "b2") then
								button_raw = "b1"
							elseif (button_raw == "b1") then
								button_raw = "b2"
							end
						end
						
						local buttonid = MF_gpad_string_to_raw(button_raw)
						button = MF_gpad_raw_to_string(buttonid)
						
						if (string.sub(button, 1, 1) == "a") and ((string.sub(button, -1) == "+") or (string.sub(button, -1) == "-")) then
							button = string.sub(button, 1, string.len(button)-1)
						end
						
						local bdata = data[button]
						
						if (bdata ~= nil) then
							icon.animSet = bdata[2]
							icon.direction = bdata[3]
						else
							MF_alert("Couldn't find valid raw icon data for " .. button .. ", " .. tostring(buttonid))
						end
					else
						button_raw = tonumber(button_raw) or 0
						button = MF_gpad_raw_to_string(button_raw)
						
						if (string.sub(button, 1, 1) == "a") and ((string.sub(button, -1) == "+") or (string.sub(button, -1) == "-")) then
							button = string.sub(button, 1, string.len(button)-1)
						end
						
						local bdata = data[button]
						
						if (bdata ~= nil) then
							icon.animSet = bdata[2]
							icon.direction = bdata[3]
						else
							MF_alert("Couldn't find valid raw icon data for " .. button .. ", " .. tostring(button_raw))
						end
					end
				end
			end
		end
	end
end

function getdynamicbuttonwidth(text,default_,maximum_,minimum_)
	local prunedtext = string.gsub(text, "[$][0-9][,][0-9]", "")
	local hm,invalid = decode(prunedtext)
	local minimum = minimum_ or 1
	local xscale = math.max(#hm + 2, minimum)
	local default = default_ or 0
	local maximum = maximum_ or 32
	local beyond_maximum = false
	
	if (generaldata4.values[CUSTOMFONT] == 0) then
		local result = math.max(xscale / f_tilesize * 10.0, default)
		
		if (result > maximum) then
			beyond_maximum = true
			result = maximum
		end
		
		return result,beyond_maximum
	else
		local result = math.max(MF_gettextwidth(prunedtext .. "M", 16 + generaldata5.values[LETTERMULTIPLIER] * 6) / f_tilesize, default)
		
		if (result > maximum) then
			beyond_maximum = true
			result = maximum
		end
		
		return result,beyond_maximum
	end
end

function getdistancebetweenbuttons(t1,t2,d1,d2)
	local r1 = getdynamicbuttonwidth(t1,d1)
	local r2 = getdynamicbuttonwidth(t2,d2)
	local result = r1 * 0.5 + r2 * 0.5
	
	return result
end

function gettextwidth(text,customfont_)
	local customfont = customfont_ or false
	if (generaldata4.values[CUSTOMFONT] == 1) then
		customfont = true
	end
	
	local prunedtext = string.gsub(text, "[$][0-9][,][0-9]", "")
	local hm,invalid = decode(prunedtext)
	local xscale = #hm
	local default = default_ or 0
	
	if (customfont == false) then
		return xscale * 10
	else
		return MF_gettextwidth(prunedtext, 16 + generaldata5.values[LETTERMULTIPLIER] * 6)
	end
end

function findmaxtextwidth(data)
	local result = 0
	
	for i,v in ipairs(data) do
		local r = gettextwidth(v)
		
		result = math.max(result, r)
	end
	
	return result
end

function wordwrap(text_,wraplimit,nolangtext)
	local result = {}
	local text = text_
	local lang = generaldata.strings[LANG]
	
	if (nolangtext == nil) or (nolangtext == false) then
		text = langtext(text_,true,true)
	end
	
	local textlines = {}
	local wrapthese = {":", ";", "」", "』", "，", "。", "？", "！", "、", "”", "】", "》", "）"}
	
	if (string.len(text) * 8 > wraplimit) then
		local subtext = ""
		
		for i=1,string.len(text) do
			local l = string.sub(text, i, i)
			
			if ((l == " ") and (string.len(subtext) * 8 > wraplimit * 0.875) and (lang ~= "tha")) or (l == "^") then
				table.insert(textlines, subtext)
				subtext = ""
			else
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
	
	return textlines
end

function continuetext(unitid,iconid)
	local unit = mmf.newObject(unitid)
	local icon = mmf.newObject(iconid)
	
	local world = unit.strings[1]
	local slot = unit.values[2] + 1
	local name = langtext("world_" .. world,true,true)
	
	if (#name == 0) then
		MF_setfile("world","Data/Worlds/" .. world .. "/world_data.txt")
		name = MF_read("world","general","name")
		MF_setfile("world","Data/map0.m")
	end
	
	local cutoff_limit = 21
	local ox = 164
	
	if (icon.values[1] == 0) then
		cutoff_limit = 25
		ox = 140
	end
	
	if (#name > 0) then
		if (#name > cutoff_limit) then
			local cutoff = cutoff_limit - 3
			
			for i=2,#name do
				if (string.sub(name, i, i) == " ") and (i <= cutoff_limit - 3) then
					cutoff = i-1
				end
			end
			
			name = string.sub(name, 1, cutoff) .. "..."
		end
		
		writetext(name,unitid,ox,-12,"ContinueText",true,2,true)
	end
	
	local slotname = ""
	if (world ~= "levels") then
		slotname = MF_read("settings","slotnames",tostring(slot - 1))
	end
	
	if (#slotname == 0) then
		slotname = langtext("slot") .. " " .. tostring(slot)
	end
	
	writetext(slotname,unitid,ox,12,"ContinueText",true,2,true,{4,4})
end

function geteditorkey_n(keyset,keynum)

	local n_names = 
	{
		{"move","rotate","place","copy","drag","undo","scrollright_hotbar","scrollleft_hotbar","scrollright_tool","scrollleft_tool","currobjlist","quickmenu","swap","scrollright_layer","scrollleft_layer","moveall","altpress","emptytile","showdir","cut","autopick","pickempty","lock","empty_hotbar","save","test"},
		{"move","select","swap","drag","tooltip","scrollleft","scrollright","closemenu","tags","remove","edit","addnew","search","autoadd","altsave","settings","menu"},
	}
	
	local n_keys =
	{
		{"a0","a2","b1","b0","b3","b2","a5+","a4+","b7","b6","b8","b9","b1","h0.2","h0.8","h0.4","h0.1","b2","b3","b0","a5+","a4+","b7","b6","b9","b8"},
		{"a0","b1","b0","b3","b2","a4+","a5+","b8","b9","h0.1","h0.2","h0.4","h0.8","b6","b5","b4","b5"},
	}
	
	local ks = n_keys[keyset + 1] or {}
	local k = ks[keynum + 1] or "b0"
	
	local ns = n_names[keyset + 1] or {}
	local n = ns[keynum + 1] or "nothing"
	
	return k,n
end