local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3

local nowSpeed = 1.0
local Speed_Num_txt_UGUI
local nowbaseBPM_Division_BPM = 1.0
local nowBPM
local nowScroll = 1.0

local lastBeet = math.huge * -1

local execute = {}
execute.active = true

function execute.onloaded()
	nowBPM = SONGMAN:GetBaseBpm()
	local WickyCanvas = util.GetCanvas()
	local Speed_Num_txt = ACTORFACTORY:CreateUIText()
	Speed_Num_txt_UGUI = Speed_Num_txt:GetTextMeshProUGUI()
	Speed_Num_txt.gameObject.name = "Speed_Num_txt"
	Speed_Num_txt.gameObject.transform:SetParent(WickyCanvas.transform, false)
	Speed_Num_txt.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	Speed_Num_txt.transform.anchorMin = Vector2(0, 0.6)
	Speed_Num_txt.transform.anchorMax = Vector2(1, 0.6)
	Speed_Num_txt.transform.localPosition = Vector3(-35, 30, 0)
	Speed_Num_txt.transform.sizeDelta = Vector2(0, 0)
	Speed_Num_txt_UGUI.alignment = CS.TMPro.TextAlignmentOptions.Right
	if SONGMAN:IsCmod() then
		Speed_Num_txt_UGUI.text =
			"Note Speed\n" ..
			PLAYERSTATS:GetNoteSpeedOption() ..
			"\nSpeed\n" ..
			nowSpeed ..
			"\nBPM\n" ..
			nowBPM
	else
		Speed_Num_txt_UGUI.text =
			"Note Speed\n" ..
			PLAYERSTATS:GetNoteSpeedOption() ..
			"\nSpeed\n" ..
			nowSpeed ..
			"\nBPM\n" ..
			nowBPM ..
			"\nbaseBPM/BPM\n" ..
			nowbaseBPM_Division_BPM ..
			"\nScroll\n" ..
			nowScroll
	end
end

local function CalculateNowSpeed(songBeat)
	local speedPositions = SONGMAN:GetSpeedPositions()
	local speedStretchRatios = SONGMAN:GetSpeedStretchRatios()
	local speedDelayBeats = SONGMAN:GetSpeedDelayBeats()
	if speedPositions.Length == 0 then
		nowSpeed = 1.0
	else
		if songBeat < speedPositions[0] then
			nowSpeed = 1.0
		end
		if speedPositions[0] <= songBeat and songBeat <= speedPositions[0] + speedDelayBeats[0] then
			lastBeet = songBeat
			nowSpeed = 1 + (speedStretchRatios[0] - 1) * (songBeat - speedPositions[0]) / speedDelayBeats[0]
		end
		for i = 1, speedPositions.Length - 1, 1 do
			if speedPositions[i] <= songBeat and songBeat <= speedPositions[i] + speedDelayBeats[i] then
				lastBeet = songBeat
				nowSpeed = speedStretchRatios[i - 1] +
					(speedStretchRatios[i] - speedStretchRatios[i - 1]) * (songBeat - speedPositions[i]) /
					speedDelayBeats[i]
			end
			if lastBeet < speedPositions[i - 1] + speedDelayBeats[i - 1] and speedPositions[i - 1] + speedDelayBeats[i - 1] < songBeat then
				nowSpeed = speedStretchRatios[i - 1]
			end
		end
		if speedPositions[speedPositions.Length - 1] + speedDelayBeats[speedPositions.Length - 1] < songBeat then
			nowSpeed = speedStretchRatios[speedPositions.Length - 1]
		end
	end
end

--baseBPM/BPM
local function CalculatenowbaseBPM_Division_BPM(songBeat)
	local baseBpm = SONGMAN:GetBaseBpm()
	local bpms = SONGMAN:GetBpms()
	local bpmPositions = SONGMAN:GetBpmPositions()
	if bpmPositions.Length == 0 then
		nowbaseBPM_Division_BPM = 1.0
	else
		if songBeat < bpmPositions[0] then
			nowbaseBPM_Division_BPM = 1.0
		end
		for i = 0, bpmPositions.Length - 2, 1 do
			if bpmPositions[i] <= songBeat and songBeat < bpmPositions[i + 1] then
				if not SONGMAN:IsCmod() then
					nowbaseBPM_Division_BPM = bpms[i] / baseBpm
				end
				nowBPM = bpms[i]
			end
		end
		if bpmPositions[bpmPositions.Length - 1] <= songBeat then
			if not SONGMAN:IsCmod() then
				nowbaseBPM_Division_BPM = bpms[bpms.Length - 1] / baseBpm
			end
			nowBPM = bpms[bpms.Length - 1]
		end
	end
end

local function CalculateScroll(songBeat)
	local scrollPositions = SONGMAN:GetScrollPositions()
	local scrolls = SONGMAN:GetScrolls()
	if scrollPositions.Length == 0 then
		nowScroll = 1.0
	else
		if songBeat < scrollPositions[0] then
			nowScroll = 1.0
		end
		for i = 0, scrollPositions.Length - 2, 1 do
			if scrollPositions[i] <= songBeat and songBeat < scrollPositions[i + 1] then
				nowScroll = scrolls[i]
			end
		end
		if scrollPositions[scrollPositions.Length - 1] <= songBeat then
			nowScroll = scrolls[scrolls.Length - 1]
		end
	end
end

function execute.update()
	local songBeat = GAMESTATE:GetSongBeat()
	CalculateNowSpeed(songBeat)
	CalculatenowbaseBPM_Division_BPM(songBeat)
	if not SONGMAN:IsCmod() then
		CalculateScroll(songBeat)
	end
	if SONGMAN:IsCmod() then
		Speed_Num_txt_UGUI.text =
			"Note Speed\n" ..
			nowSpeed * PLAYERSTATS:GetNoteSpeedOption() ..
			"\nSpeed\n" ..
			nowSpeed ..
			"\nBPM\n" ..
			nowBPM
	else
		Speed_Num_txt_UGUI.text =
			"Note Speed\n" ..
			nowSpeed * PLAYERSTATS:GetNoteSpeedOption() * nowbaseBPM_Division_BPM * nowScroll ..
			"\nSpeed\n" ..
			nowSpeed ..
			"\nBPM\n" ..
			nowBPM ..
			"\nbaseBPM/BPM\n" ..
			nowbaseBPM_Division_BPM ..
			"\nScroll\n" ..
			nowScroll
	end
end

return execute
