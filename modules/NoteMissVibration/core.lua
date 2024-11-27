--著者: Wicky

local execute = {}
execute.active = true

execute.onHitNote = function (id, lane, noteType, judgeType, isAttack)
	if util.IsPlatformMobile() and GAMESTATE:GetPlayMode() == 1 and MISSmadnessMI == 1 then
		CS.UnityEngine.Handheld.Vibrate()
	end
end

execute.onMissedNote = function(id, lane, noteType)
	if util.IsPlatformMobile() then
		CS.UnityEngine.Handheld.Vibrate()
		--ノーツが多すぎると動作が不安定になる可能性があります。--MI
	end
end

return execute