local scene = {}
game = require '../game/scene'

local scrollx = 0
local scrolly = 0

local music_on = true

local oldmousex = 0
local oldmousey = 0

local buttons = {}--{"play", "editor", "options", "exit"}
local git_btn = nil

math.randomseed(os.time())
local splash = math.random()
  -- love.timer.getTime() % 1 old splash

local tweens = {}
local buttonPos = {}
local buttonTweens = {}

function scene.load()
  metaClear()
  clear()
  was_using_editor = false
  if getTheme() == "halloween" then
    resetMusic("bab spoop u", 0.5)
  elseif music_path["bab be u them - "..getTheme()] then
    resetMusic("bab be u them - "..getTheme(), 0.5)
  else
    resetMusic("bab be u them", 0.5)
  end
  love.graphics.setBackgroundColor(0.10, 0.1, 0.11)
  local now = os.time(os.date("*t"))
  presence = {
    state = "main menu",
    details = "idling",
    largeImageKey = "titlescreen",
    largeimageText = "main menu",
    startTimestamp = now
  }
  nextPresenceUpdate = 0
  love.keyboard.setKeyRepeat(false)
  scene.buildUI()
  scene.selecting = true
  if settings["menu_anim"] then
    babtitletween = love.timer.getTime()
    babtitlespeen = math.random(1,1000) == 1
  end
  settings["seen_menu"] = true
  saveAll()

  -- tweens
  -- the tween table on each update call updates every updatable tween, so you dont have to worry about updating anything else upon adding a tween
  tweens['git'] = {x = 10, y = love.graphics.getHeight() + sprites["ui/github"]:getHeight() + 10}
  tweens['gitTween'] = tween.new(0.5, tweens['git'], {y = love.graphics.getHeight() - sprites["ui/github"]:getHeight() - 10}, 'outCirc')

  tweens['title'] = {rotate = -math.pi*2, scale = 0}
  tweens['titleRotateTween'] = tween.new(1.6, tweens['title'], {rotate = (math.random(1,1000) == 1) and 999999 or math.pi*2}, 'outBack')
  tweens['titleScaleTween'] = tween.new(1.6, tweens['title'], {scale = 1}, 'outBack')

  tweens['textOpacity'] = {0}
  tweens['textOpacityTween'] = tween.new(1, tweens['textOpacity'], {1})

  local height = love.graphics.getFont():getHeight()
  tweens['buildnumber'] = {y = -height}
  tweens['buildnumberTween'] = tween.new(0.5, tweens['buildnumber'], {y = 0}, 'outCirc')
end

function scene.buildUI()
  buttons = {}
  if getTheme() == "halloween" then
    if not settings["lessflashing"] and (love.timer.getTime()%10 > 8.7 and love.timer.getTime()%10 < 8.8 or love.timer.getTime()%10 > 8.9 and love.timer.getTime()%10 < 9) then
        giticon = sprites["ui/github_halloween_blood"]
    else
        giticon = sprites["ui/github_halloween"]
    end
  else
    giticon = sprites["ui/github"]
  end
  
  git_btn = ui.component.new()
    :setSprite(giticon)
    :setColor(1, 1, 1)
    :setPos(10, love.graphics.getHeight()-sprites["ui/github"]:getHeight()-10)
    :setPivot(0.5, 0.5)
    :onPreDraw(function(o) ui.buttonFX(o, {rotate = false}) end)
    :onReleased(function() love.system.openURL("https://github.com/lilybeevee/bab-be-u") end)

  local ox, oy
  if not options then
    scene.addButton("play", function() switchScene("play") end)
    scene.addButton("edit", function() switchScene("edit") end)
    scene.addButton("options", function() options = true; scene.buildUI() end)
    scene.addButton("exit", function() love.event.quit() end)
    ox, oy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
  else
    buildOptions()
    ox, oy = love.graphics.getWidth() * (3/4) , buttons[1]:getHeight()+10
  end

  for i,button in ipairs(buttons) do
    local width, height = button:getSize()
    
    button:setPos(ox - width/2, oy - height/2)
    if settings["menu_anim"] then
      buttonPos[i] = {x = (i % 2 == 0) and love.graphics.getWidth() + width or -width, y = oy - height/2}
      local mult = 1
      if options then mult = 0.000001 end -- this is a stupid hack. whatever
  
      tick.delay(function()
        buttonTweens[i] = tween.new(0.8 * mult, buttonPos[i], {x = ox - width/2}, 'outCirc')
      end, (i * 0.1 + 0.2) * mult)
    end
    oy = oy + height + 10
  end
end

function scene.addButton(text, func)
  local button = ui.menu_button.new(text, #buttons%2+1, func)
  table.insert(buttons, button)
  return button
end

function scene.addOption(id, name, options, changed)
  local option = 1
  for i,v in ipairs(options) do
    if settings[id] == v[2] then
      option = i
    end
  end
  scene.addButton(name .. ": " .. options[option][1], function()
    settings[id] = options[(((option-1)+1)%#options)+1][2]
    saveAll()
    if changed then
      changed(settings[id])
    end
    scene.buildUI()
  end)
end

function scene.update(dt)
  if settings["scroll_on"] then
    scrollx = scrollx+dt*50
    scrolly = scrolly+dt*50
  else
    scrollx, scrolly = 0,0
  end

  for _,t in pairs(tweens) do
    if t.update then t:update(dt) end
  end
  
  if settings["menu_anim"] then
    for i,button in ipairs(buttons) do
      if buttonTweens[i] then buttonTweens[i]:update(dt) end
      button:setPos(buttonPos[i].x, buttonPos[i].y)
    end
  end

  git_btn:setPos(tweens['git'].x, tweens['git'].y, sprites["ui/github"]:getHeight()+10, -sprites["ui/github"]:getHeight()-10, 1.2)
end

function scene.draw(dt)
  local bgsprite = sprites["ui/bgs/"..getTheme()]
  if not bgsprite then bgsprite = sprites["ui/bgs/default"] end
  
  if not settings["lessflashing"] and getTheme() == "halloween" and (love.timer.getTime()%10 > 8.6 and love.timer.getTime()%10 < 8.7 or love.timer.getTime()%10 > 8.8 and love.timer.getTime()%10 < 8.9 or love.timer.getTime()%10 > 9)  then
    bgsprite = sprites["ui/bgs/halloween_flash"]
  end

  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  local cells_x = math.ceil(width / bgsprite:getWidth())
  local cells_y = math.ceil(height / bgsprite:getHeight())

  if not spookmode then
    love.graphics.setColor(1, 1, 1, 1)
    setRainbowModeColor(love.timer.getTime()/6, .4)
  else
    love.graphics.setColor(0.2,0.2,0.2,1)
  end

  for x = -1, cells_x do
    for y = -1, cells_y do
      local draw_x = scrollx % bgsprite:getWidth() + x * bgsprite:getWidth()
      local draw_y = scrolly % bgsprite:getHeight() + y * bgsprite:getHeight()
      love.graphics.draw(bgsprite, draw_x, draw_y)
    end
  end

  for _,button in ipairs(buttons) do
    button:draw()
  end
  git_btn:draw()

  if not options then
    local bab_logo = sprites["ui/title/"..getTheme()] or sprites["ui/title/default"]
    if getTheme() == "halloween" and not settings["lessflashing"] and (love.timer.getTime()%10 > 8.7 and love.timer.getTime()%10 < 8.8 or love.timer.getTime()%10 > 8.9 and love.timer.getTime()%10 < 9) then 
      bab_logo = sprites["ui/title/halloween_blood"]
    end
    
    love.graphics.push()
    love.graphics.translate(width/2, height/20 + bab_logo:getHeight()/2)
    love.graphics.rotate(tweens['title'].rotate)
    love.graphics.scale(tweens['title'].scale)

    for _,pair in pairs({{1,0},{0,1},{1,1},{-1,0},{0,-1},{-1,-1},{1,-1},{-1,1}}) do
      local outlineSize = 2
      pair[1] = pair[1] * outlineSize
      pair[2] = pair[2] * outlineSize

      love.graphics.setColor(0,0,0)
      love.graphics.draw(bab_logo, pair[1]-bab_logo:getWidth()/2, pair[2]-bab_logo:getHeight()/2)
    end

    if not spookmode then
      love.graphics.setColor(1, 1, 1)
      setRainbowModeColor(love.timer.getTime()/3, .5)
      love.graphics.draw(bab_logo, -bab_logo:getWidth()/2, -bab_logo:getHeight()/2)
    end
    love.graphics.translate(-width/2, -height/20 + bab_logo:getHeight()/2)
    love.graphics.pop()
    -- Splash text here
    
    love.graphics.push()
    
    if string.find(build_number, "420") or string.find(build_number, "1337") or string.find(build_number, "666") or string.find(build_number, "69") then
      love.graphics.setColor(hslToRgb(love.timer.getTime()%1, .5, .5, .9))
      splashtext = "nice"
    end
    if is_mobile then
      splashtext = "4mobile!"
    elseif getTheme() == "christmas" then
      love.graphics.setColor(0,1,0)
      if splash > 0.66 then
        splashtext = "merery crimsmas!!"
      elseif splash < 0.33 then
        splashtext = "happi hollydays!"
      else
        splashtext = "happi hunnukkah!!"
      end
    elseif getTheme() == "factory" then
      love.graphics.setColor(0,0,1)
      if splash > 0.66 then
        splashtext = "beep boop bap?"
      elseif splash < 0.33 then
        splashtext = "beep?"
      else
        splashtext = "beep bap boop?!"
      end
    elseif getTheme() == "baba" then
      love.graphics.setColor(0,0,1)
      if splash > 0.66 then
        splashtext = "baba is you!"
      elseif splash < 0.33 then
        splashtext = "baba make level!"
      else
        splashtext = "Nordie's gamejam 2017's winner!"
      end
    elseif getTheme() == "babadefault" then
      love.graphics.setColor(0,0,1)
      if splash > 0.66 then
        splashtext = "baba is you!"
      elseif splash < 0.33 then
        splashtext = "baba make level!"
      else
        splashtext = "Nordie's gamejam 2017's winner!"
      end
    elseif getTheme() == "corruption" then
      love.graphics.setColor(0,0,1)
      if splash > 0.1 then
        splashtext = "b4b b3 u!"
      elseif splash < 0.2 then
        splashtext = "b4b b3 u t00: 3l3ctr1c b00g4l00"
      elseif splash < 0.3 then
        splashtext = "b4b cr43t lvl!"
      elseif splash < 0.4 then
        splashtext = "error 404: bab not found"
      elseif splash < 0.5 then
        splashtext = "k33k b3 w4lk!"
      elseif splash < 0.6 then
        splashtext = "Do not delete bab.png, worst mistake of my life."
      elseif splash < 0.7 then
        splashtext = "g4rf13ld - th1s 1s d3m0cr4cy 1n 4ct10n."
      elseif splash < 0.8 then
        splashtext = "f34tur3s 3 un3d1t3d g4rf13ld pngs"
      elseif splash < 0.9 then
        splashtext = "why 1s 1t c4ll3d 0v3n wh3n y0u 0f 1n th3 c0ld f00d 0f 0ut h0t 34t th3 f00d?"
      else
        splashtext = "spl0sh txt!"
      end
    elseif getTheme() == "gramfild" then
      love.graphics.setColor(0,0,1)
      if splash > 0.66 then
        splashtext = "why is it called oven when you of in the cold food of out hot eat the food?"
      elseif splash < 0.33 then
        splashtext = "garfield - this is democracy in action."
      else
        splashtext = "features 3 unedited garfield pngs"
      end
    elseif getTheme() == "redfault" then
      love.graphics.setColor(0,0,1)
      if splash > 0.1 then
        splashtext = "keek be u!"
      elseif splash < 0.2 then
        splashtext = "keek be u too: electric boogaloo!"
      elseif splash < 0.3 then
        splashtext = "keek craet lvl!"
      elseif splash < 0.4 then
        splashtext = "I finally got the wildfire in my sock drawer under control!"
      elseif splash < 0.5 then
        splashtext = "dude, it's called Keek Be U Omega, not Keek Be Omega."
      elseif splash < 0.6 then
        splashtext = "bab be walk!"
      elseif splash < 0.7 then
        splashtext = "eat polish gras"
      elseif splash < 0.8 then
        splashtext = "good for puzzle levels"
      elseif splash < 0.9 then
        splashtext = "boy mode!!!!"
      else
        splashtext = "splosh txt!"
      end
    elseif getTheme() == "halloween" then
      if not settings["lessflashing"] and (love.timer.getTime()%10 > 8.7 and love.timer.getTime()%10 < 8.8 or love.timer.getTime()%10 > 8.9 and love.timer.getTime()%10 < 9) then
        splashtext = "BAB IS DEAD"
      elseif love.filesystem.read("author_name") == "lilybeevee" and splash > 0.5 then
        splashtext = "happy spooky month lily!"
      else
        splashtext = "spooky month!"
      end
    elseif splash < 0.1 then
      splashtext = "bab be u!"
    elseif splash < 0.2 then
      splashtext = "bab be u too: electric boogaloo!"
    elseif splash < 0.3 then
      splashtext = "bab craet lvl!"
    elseif splash < 0.4 then
      splashtext = "I finally got the wildfire in my sock drawer under control!"
    elseif splash < 0.5 then
      splashtext = "dude, it's called Bab Be U Omega, not Bab Be Omega."
    elseif splash < 0.6 then
      splashtext = "keek be walk!"
    elseif splash < 0.7 then
      splashtext = "eat polish gras"
    elseif splash < 0.8 then
      splashtext = "good for puzzle levels"
    elseif splash < 0.9 then
      splashtext = "girl mode!!!!"
    else
      splashtext = "splosh txt!"
    end
    
    local textx = width/2 + bab_logo:getWidth() / 2
    local texty = height/20+bab_logo:getHeight()

    love.graphics.translate(textx+love.graphics.getFont():getWidth(splashtext)/2, texty+love.graphics.getFont():getHeight()/2)
    if settings["shake_on"] then
      love.graphics.rotate(0.7*math.sin(love.timer.getTime()*2))
    else
      love.graphics.rotate(math.pi/4)
    end
    love.graphics.translate(-textx-love.graphics.getFont():getWidth(splashtext)/2, -texty-love.graphics.getFont():getHeight()/2)

    love.graphics.setColor(1,1,1,tweens['textOpacity'][0])
    love.graphics.print(splashtext, textx, texty)
    
    love.graphics.pop()
  else
    local img = sprites["ui/bab cog"]
    if getTheme() == "halloween" then
      img = sprites["ui/bab cog_halloween"]
    elseif getTheme() == "christmas" then
      img = sprites["ui/bab cog_christmas"]
    else
      img = sprites["ui/bab cog"]
    end
    local txt = sprites["ui/many toggls"]
    
    if getTheme() == "halloween" then
        love.graphics.draw(sprites["ui/cobweb"])
    end

    local full_height = img:getHeight()*2 + 10 + txt:getHeight()

    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() * (1/4), love.graphics.getHeight()/2)
    love.graphics.scale(2 * getUIScale())
    love.graphics.translate(0, -full_height/2)
    
    love.graphics.push()
    love.graphics.scale(2)
    love.graphics.translate(0, img:getHeight()/2)
    if settings["shake_on"] then
      love.graphics.rotate(0.1*math.sin(love.timer.getTime()))
    end
    love.graphics.draw(img, -img:getWidth()/2, -img:getHeight()/2)
    love.graphics.pop()
    
    local ox, oy = math.floor(math.random()*4)/2-1, math.floor(math.random()*4)/2-1
    if not settings["shake_on"] then ox, oy = 0,0 end
    if getTheme() == "halloween" then
      love.graphics.setColor(0.5, 0.25, 0.75)
    elseif getTheme() == "christmas" then
      love.graphics.setColor(0.9,0.1,0)
    end
    love.graphics.draw(txt, -txt:getWidth()/2 + ox, full_height - txt:getHeight() + oy)

    love.graphics.pop()
  end

  if build_number and not debug_view then
    love.graphics.setColor(1, 1, 1)
    setRainbowModeColor(love.timer.getTime()/6, .6)
    --if haha number then make it rainbow anyways
    if string.find(build_number, "420") or string.find(build_number, "1337") or string.find(build_number, "666") or string.find(build_number, "69") then
      love.graphics.setColor(hslToRgb(love.timer.getTime()%1, .5, .5, .9))
    end
    local height = love.graphics.getFont():getHeight()
    love.graphics.print(spookmode and "error" or 'v'..build_number, 0, tweens['buildnumber'].y)
  end

  if is_mobile then
    local cursorx, cursory = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1)
    setRainbowModeColor(love.timer.getTime()/6, .5)
    love.graphics.draw(system_cursor, cursorx, cursory)
  end
end

function scene.keyPressed(key)
  if key == "escape" and options then
    if global_menu_state ~= "none" then
      global_menu_state = "none"
    else
      options = false
    end
    scene.buildUI()
  end
end

function scene.resize(w, h)
  scene.buildUI()
end

return scene
