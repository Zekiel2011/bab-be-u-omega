
function sfxplay(name,volume,pitch)
  sound = love.sound.newSoundData("assets/audio/sfx/"..name);
  local source = love.audio.newSource(sound, "static")
  source:setVolume(volume)
  source:setPitch(pitch)
  source:play()
end