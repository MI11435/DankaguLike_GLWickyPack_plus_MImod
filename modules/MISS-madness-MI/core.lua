local execute = {}
execute.active = true
local _actorAudio = nil

execute.onloaded = function()
  _actorAudio = ACTORFACTORY:CreateAudio()
  execute.LoadAudio("sakebi.ogg",_actorAudio)
  _actorAudio:SetVolume(0.3)
  MISSmadnessMI = 1
end

execute.onHitNote = function ()
  if GAMESTATE:GetPlayMode()==1 then
    _actorAudio:Play()
  end
end

execute.onMissedNote = function ()
  _actorAudio:Play()
end

return execute