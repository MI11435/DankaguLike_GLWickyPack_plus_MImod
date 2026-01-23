local cs_coroutine = require "cs_coroutine"

local execute = {}
execute.active = true

local UnityEngine = CS.UnityEngine
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3

local F_on = true
local Tag_txt_UGUI
local Tag_txt_table = {}

local lastBeat_Speed ,lastBeat_BPM ,lastBeat_Scroll = -math.huge ,-math.huge ,-math.huge

local function Speed(songBeat)
	local speedPositions = SONGMAN:GetSpeedPositions()
	local speedStretchRatios = SONGMAN:GetSpeedStretchRatios()
	local speedDelayBeats = SONGMAN:GetSpeedDelayBeats()

    for i = 0, speedPositions.Length - 1, 1 do
        if speedPositions[i] <= songBeat and lastBeat_Speed < speedPositions[i] then
            table.insert(Tag_txt_table,
                "<color=red>Speed</color>,"..speedPositions[i]..","..speedStretchRatios[i]..","..speedDelayBeats[i])
        end
    end
    lastBeat_Speed = songBeat
end

local function BPM(songBeat)
	local bpms = SONGMAN:GetBpms()
	local bpmPositions = SONGMAN:GetBpmPositions()

    for i = 0, bpmPositions.Length - 1, 1 do
        if bpmPositions[i] <= songBeat and lastBeat_BPM < bpmPositions[i] then
            table.insert(Tag_txt_table,
                "<color=blue>BPM</color>,"..bpmPositions[i]..","..bpms[i])
        end
    end
    lastBeat_BPM = songBeat
end

local function Scroll(songBeat)
	local scrollPositions = SONGMAN:GetScrollPositions()
	local scrolls = SONGMAN:GetScrolls()

    for i = 0, scrollPositions.Length - 1, 1 do
        if scrollPositions[i] <= songBeat and lastBeat_Scroll < scrollPositions[i] then
            table.insert(Tag_txt_table,
                "<color=green>Scroll</color>,"..scrollPositions[i]..","..scrolls[i])
        end
    end
    lastBeat_Scroll = songBeat
end

local function F_coroutine()
	while true do
		if F_on then
			local songBeat = GAMESTATE:GetSongBeat()
			Speed(songBeat)
			BPM(songBeat)
		    Scroll(songBeat)
            Tag_txt_UGUI.text = table.concat(Tag_txt_table,"<br>")
		end
		coroutine.yield()
	end
end

function execute.onloaded()
	nowBPM = SONGMAN:GetBaseBpm()
	local WickyCanvas = util.GetCanvas()
	local Tag_txt = ACTORFACTORY:CreateUIText()
	Tag_txt_UGUI = Tag_txt:GetTextMeshProUGUI()
	Tag_txt.gameObject.name = "Tag_txt"
	Tag_txt.gameObject.transform:SetParent(WickyCanvas.transform, false)
	Tag_txt.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	Tag_txt.transform.anchorMin = Vector2(0, 0)
	Tag_txt.transform.anchorMax = Vector2(1, 0.8)
	Tag_txt.transform.localPosition = Vector3(-35, 30, 0)
	Tag_txt.transform.sizeDelta = Vector2(0, 0)
	Tag_txt_UGUI.alignment = CS.TMPro.TextAlignmentOptions.BottomRight
	Tag_txt_UGUI.outlineWidth = 0.2
	Tag_txt_UGUI.lineSpacing = -20
    _coroutine = cs_coroutine.start(F_coroutine)
end

function execute.onPause()
	F_on = false
end

function execute.onResume()
	F_on = true
end

function execute.ondestroy()
	cs_coroutine.stop(_coroutine)
end

return execute