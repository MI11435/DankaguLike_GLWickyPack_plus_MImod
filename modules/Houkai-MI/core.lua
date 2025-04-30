--Houkai_Ver.3
local Vector3 = CS.UnityEngine.Vector3
local Vector2 = CS.UnityEngine.Vector2
local Quaternion = CS.UnityEngine.Quaternion

local GameObject = CS.UnityEngine.GameObject
local MI_JudgeArea1 = nil
local MI_JudgeArea2 = nil
local MI_JudgeArea3 = nil
local MI_JudgeArea4 = nil
local MI_JudgeArea5 = nil
local MI_JudgeArea6 = nil
local MI_JudgeArea7 = nil
local MI_LaneSeparation1 = nil
local MI_LaneSeparation2 = nil
local MI_LaneSeparation3 = nil
local MI_LaneSeparation4 = nil
local MI_LaneSeparation5 = nil
local MI_LaneSeparation6 = nil
local MI_LaneSeparation7 = nil
local MI_LaneSeparation8 = nil
local MI_UnderLane = nil
local MI_ScoreView = nil
local MI_Scoretext = nil
local MI_MusicTimePanel = nil
local MI_ComboView = nil
local MI_LifeView = nil
local MI_Pause = nil
local MI_autoview = nil
local MI_Judge = nil
local MI_State = nil
local PausePanel_SelectPanel_Description = nil
local _ppppp = nil
local MI_Difficulty = nil
local _Difficultytext = nil
local difficulty = nil
local MI_GameManager = nil
local MI_SetGameManager = nil

local MI_cameraManTr = nil

local execute = {}
execute.active = true
execute.onloaded = function()
	MI_JudgeArea1 = GameObject.Find("JudgeArea/JudgeArea (0)")
	MI_JudgeArea2 = GameObject.Find("JudgeArea/JudgeArea (1)")
	MI_JudgeArea3 = GameObject.Find("JudgeArea/JudgeArea (2)")
	MI_JudgeArea4 = GameObject.Find("JudgeArea/JudgeArea (3)")
	MI_JudgeArea5 = GameObject.Find("JudgeArea/JudgeArea (4)")
	MI_JudgeArea6 = GameObject.Find("JudgeArea/JudgeArea (5)")
	MI_JudgeArea7 = GameObject.Find("JudgeArea/JudgeArea (6)")
	MI_LaneSeparation1 = GameObject.Find("Lane/LaneSeparation (0)")
	MI_LaneSeparation2 = GameObject.Find("Lane/LaneSeparation (1)")
	MI_LaneSeparation3 = GameObject.Find("Lane/LaneSeparation (2)")
	MI_LaneSeparation4 = GameObject.Find("Lane/LaneSeparation (3)")
	MI_LaneSeparation5 = GameObject.Find("Lane/LaneSeparation (4)")
	MI_LaneSeparation6 = GameObject.Find("Lane/LaneSeparation (5)")
	MI_LaneSeparation7 = GameObject.Find("Lane/LaneSeparation (6)")
	MI_LaneSeparation8 = GameObject.Find("Lane/LaneSeparation (7)")
	MI_UnderLane = GameObject.Find("Lane/JudgeLaneSeparation")
	MI_ScoreView = GameObject.Find("CameraCanvas/ScoreView")
	MI_Scoretext = GameObject.Find("CameraCanvas/ScoreView/ScorePanel/Text (TMP)")
	MI_MusicTimePanel = GameObject.Find("CameraCanvas/MusicTimePanel")
	MI_ComboView = GameObject.Find("CameraCanvas/ComboView")
	MI_LifeView = GameObject.Find("CameraCanvas/LifeView")
	-- MI_Pause = GameObject.Find("OverlayCanvas/PauseButton")
	MI_autoview = GameObject.Find("OverlayCanvas/PlayModeImage")
	MI_Judge = GameObject.Find("CameraCanvas/JudgeCanvas")
	MI_State = GameObject.Find("OverlayCanvas/StateView")
	PausePanel_SelectPanel_Description = GameObject.Find(
		"OverlayCanvas/PausePanel/SelectPanel/DescriptionText (TMP) (1)")
	_ppppp = PausePanel_SelectPanel_Description:GetComponent("TMPro.TextMeshProUGUI")

	MI_cameraManTr = CAMERAMAN:GetTransform()

	_Houkai = 1

	if (GAMESTATE:GetPlayMode() > 0) then
		--MI_autoview:SetActive(false)
	end
	MI_Scoretext:GetComponent(typeof(CS.UnityEngine.RectTransform)).sizeDelta = Vector2(5000, 100)
	MI_Scoretext:GetComponent("TMPro.TextMeshProUGUI").text = 40000000.0
	UTIL:DelayAction(3, difficultyhenkou)
end

function difficultyhenkou()
	MI_Difficulty = GameObject.Find("OverlayCanvas/WaitPlayPanel/TopPanel/DifficultyPanel/Text (TMP)")
	_Difficultytext = MI_Difficulty:GetComponent("TMPro.TextMeshProUGUI")
	difficulty = SONGMAN:GetDifficultyToInt()
	if difficulty == 0 then
		_Difficultytext.text = "壊:Easy"
	elseif difficulty == 1 then
		_Difficultytext.text = "壊:Normal"
	elseif difficulty == 2 then
		_Difficultytext.text = "壊:Hard"
	elseif difficulty == 3 then
		_Difficultytext.text = "壊:Extra"
	elseif difficulty == 4 then
		_Difficultytext.text = "壊:Lunatic"
	end
end

execute.onPause = function()
	if difficulty == 0 then
		_ppppp.text = SONGMAN:GetTitle() .. "\n<color=#1ECC1EFF>壊:Easy"
	elseif difficulty == 1 then
		_ppppp.text = SONGMAN:GetTitle() .. "\n<color=#0084FFFF>壊:Normal"
	elseif difficulty == 2 then
		_ppppp.text = SONGMAN:GetTitle() .. "\n<color=#FFB900FF>壊:Hard"
	elseif difficulty == 3 then
		_ppppp.text = SONGMAN:GetTitle() .. "\n<color=#DB2222FF>壊:Extra"
	elseif difficulty == 4 then
		_ppppp.text = SONGMAN:GetTitle() .. "\n<color=#8D1ECAFF>壊:Lunatic"
	end
end

execute.update = function()
	MI_Scoretext:GetComponent("TMPro.TextMeshProUGUI").text = PLAYERSTATS:GetScore() * math.pi + 40000000
	local songBeat = GAMESTATE:GetSongBeat()
	UTIL:TweenRotateQuaternion(MI_UnderLane.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, 0, songBeat * 700), 0)
	UTIL:TweenRotateQuaternion(MI_ScoreView.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, 0, songBeat * -50), 0)
	UTIL:TweenRotateQuaternion(MI_Judge.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, songBeat * -1000, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LifeView.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, songBeat * -2000, 0), 0)
	UTIL:TweenRotateQuaternion(MI_ComboView.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, songBeat * 1000, 0), 0)
	UTIL:TweenRotateQuaternion(MI_MusicTimePanel.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(0, songBeat * 100, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea1.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea2.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 - 45, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea3.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 - 90, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea4.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 - 135, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea5.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 - 180, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea6.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 + 135, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_JudgeArea7.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100 + 90, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation1.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * -100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation2.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation3.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * -100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation4.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation5.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * -100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation6.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation7.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * -100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_LaneSeparation8.transform,
		MI_cameraManTr.transform.rotation * Quaternion.Euler(songBeat * 100, 0, 0), 0)
	UTIL:TweenRotateQuaternion(MI_State.transform, MI_cameraManTr.transform.rotation * Quaternion.Euler(0, -30, 30), 0)
	UTIL:TweenLocalPosition(MI_State.transform, Vector3(-50, 0, 0), 0)
	UTIL:TweenScale(MI_State.transform, Vector3(1.5, 1.5, 1.5), 0)

	if (5 * songBeat % 2 > 1) then
		local postEffect = CAMERAMAN:GetPostEffect()
		postEffect:SetMaterial(Greyscale)
		Greyscale:SetFloat("_Strength", -20)
		postEffect:SetEnable(true)
	else
		local postEffect = CAMERAMAN:GetPostEffect()
		postEffect:SetMaterial(Greyscale)
		Greyscale:SetFloat("_Strength", 20)
		postEffect:SetEnable(true)
	end
end

execute.ondestroy = function()
	_Houkai = 0
	MI_GameManager = GameObject.Find("SingletonPrefabs/GameManager")
	MI_SetGameManager = MI_GameManager:GetComponent("GameManager")
	MI_SetGameManager.ResultData.Score = math.floor(PLAYERSTATS:GetScore() * math.pi) + 40000000
end

return execute
