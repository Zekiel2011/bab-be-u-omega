function setundo_editor()
	undobuffer_editor = {{}}
	
	--MF_alert("Editor undo reset!")
end

function resetundo_editor()
	setundo_editor()
	MF_disablebutton("undo",1)
end

function updateundo_editor()
	table.insert(undobuffer_editor, 1, {})
	
	MF_disablebutton("undo",0)
end

function addundo_editor(id,data)
	local currundo = undobuffer_editor[1]
	
	table.insert(currundo, {})
	local thisundo = currundo[#currundo]
	
	table.insert(thisundo, id)
	
	--MF_alert(tostring(#undobuffer_editor) .. ", " .. tostring(#currundo) .. ", " .. id)
	
	for i,v in ipairs(data) do
		table.insert(thisundo, v)
	end
end

function doundo_editor()
	if (#undobuffer_editor > 1) then
		local currundo = undobuffer_editor[2]
		
		local test = ""
		
		for i,data_ in ipairs(currundo) do
			local data = currundo[#currundo - (i - 1)]
			local id = data[1]
			
			test = test .. id .. ","
			
			if (id == "placetile") then
				local name,x,y,z = data[2],data[3],data[4],data[5]
				
				local unitid = MF_findunit_editor(name,x,y,z)
				
				if (unitid ~= 0) then
					removetile(unitid,x,y,nil,true)
				end
			elseif (id == "changedir") then
				local name,x,y,z,newdir,olddir = data[2],data[3],data[4],data[5],data[6],data[7]
				
				local unitid = MF_findunit_editor(name,x,y,z)
				
				if (unitid ~= 0) then
					local unit = mmf.newObject(unitid)
					unit.values[DIR] = olddir
					MF_setsublayer(0,x,y,z,olddir)
					
					if (unit.values[TILING] == 0) or (unit.values[TILING] == 2) or (unit.values[TILING] == 3) then
						unit.direction = olddir * 8
					end
				end
			elseif (id == "removetile") then
				local name,x,y,z,dir = data[2],data[3],data[4],data[5],data[6]
				
				if inbounds(x,y,1) then
					placetile(name,x,y,z,dir,nil,nil,true,true)
				end
			elseif (id == "moveall") then
				local reversed = {2,3,0,1}
				
				local dir = data[2] + 1
				
				editor_moveall(reversed[dir],true)
			elseif (id == "dragunit") then
				local name,x,y,z = data[2],data[3],data[4],data[5]
				local ox,oy,oz = data[6],data[7],data[8]
				
				local unitid = MF_findunit_editor(name,x,y,z)
				
				if (unitid ~= 0) and inbounds(x,y) and (z >= 0) and (z < 3) then
					local unit = mmf.newObject(unitid)
					unit.values[XPOS] = ox
					unit.values[YPOS] = oy
					unit.values[LAYER] = oz
					
					local l = map[z]
					local tx = l:get_x(x,y)
					local ty = l:get_y(x,y)
					
					l:unset(x,y)
					MF_setsublayer(0,x,y,z,0)
					
					updateunitmap(unitid,x,y,ox,oy,unit.strings[UNITNAME])
					dynamicat(x,y)
					dynamic(unitid)
					
					l = map[oz]
					l:set(ox,oy,tx,ty)
					MF_setsublayer(0,ox,oy,oz,unit.values[DIR])
				end
				
				if (inbounds(x,y) == false) then
					timedmessage("Undo was out of bounds. Report this! " .. tostring(x) .. ", " .. tostring(y))
				end
			end
		end
		
		--MF_alert(test)
		
		table.remove(undobuffer_editor, 1)
		
		if (#undobuffer_editor > 1) then
			table.remove(undobuffer_editor, 1)
			table.insert(undobuffer_editor, 1, {})
		end
	end
	
	if (#undobuffer_editor == 1) then
		MF_disablebutton("undo",1)
	end
end