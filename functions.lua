local isdigesting = {}
function sfxplay(name,volume,pitch)
  sound = love.sound.newSoundData("assets/audio/sfx/"..name);
  local source = love.audio.newSource(sound, "static")
  source:setVolume(volume)
  source:setPitch(pitch)
  source:play()
end

function hasitem(a, b)
    for _, item in ipairs(a) do
        if item.name == b then
            return true
        end
    end
    return false
end