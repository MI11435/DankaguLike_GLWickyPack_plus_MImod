local execute = {}
execute.active = true
local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local Color = UnityEngine.Color
local Vector2 = UnityEngine.Vector2

local StartNote_id = 0
local ALL_Noteindex = 0
local RemainingCountText
local judgeNote = 0

local function CreateRemainingCountCanvas(parentCanvas, name, pos)
	local JudgeImg = GameObject(name)
	JudgeImg.gameObject.transform:SetParent(parentCanvas.transform, false)
	JudgeImg:AddComponent(typeof(UnityEngine.CanvasRenderer))
	JudgeImgComp = JudgeImg:AddComponent(typeof(UnityEngine.UI.Image))
	JudgeImgComp.color = Color(0, 0, 0, 0)
	JudgeImgComp.transform.anchorMin = Vector2(0, 1)
	JudgeImgComp.transform.anchorMax = Vector2(0, 1)
	JudgeImgComp.transform.sizeDelta = Vector2(230, 60)
	JudgeImgComp.transform.anchoredPosition = pos

	local TextCanvas = ACTORFACTORY:CreateUIText()
	TextCanvas.name = (name .. "_b")
	TextCanvas.gameObject.transform:SetParent(JudgeImg.transform, false)
	TextCanvas.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	local _TextCanvasText = TextCanvas:GetTextMeshProUGUI()
	TextCanvas.transform.anchoredPosition = Vector2(0, 0)
	_TextCanvasText.fontSize = 26
	_TextCanvasText.outlineWidth = 0.2
	_TextCanvasText.color = Color(1, 1, 1, 1)
	_TextCanvasText.text = util.GetString("RemainingCount-MI")

	local TextCanvas1 = ACTORFACTORY:CreateUIText()
	TextCanvas.name = (name .. "Text")
	TextCanvas1.gameObject.transform:SetParent(JudgeImg.transform, false)
	TextCanvas1.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	_TextCanvasText1 = TextCanvas1:GetTextMeshProUGUI()
	TextCanvas1.transform.sizeDelta = Vector2(200, 100)
	TextCanvas1.transform.anchoredPosition = Vector2(220, -22)
	_TextCanvasText1.fontSize = 37
	_TextCanvasText1.outlineWidth = 0.2
	_TextCanvasText1.color = Color(1, 1, 1, 1)
	_TextCanvasText1.alignment = CS.TMPro.TextAlignmentOptions.TopLeft
	return _TextCanvasText1
end

function execute.onloaded()
	local WickyCanvas = util.GetCanvas()
	ALL_Noteindex = GAMESTATE:GetNotes().Length
	StartNote_id = ALL_Noteindex
	local RemainingCountCanvas = GameObject("RemainingCountCanvas")
	RemainingCountCanvas.gameObject.transform:SetParent(WickyCanvas.transform, false)
	RemainingCountCanvasComp = RemainingCountCanvas:AddComponent(typeof(UnityEngine.Canvas))
	RemainingCountCanvasComp.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera
	RemainingCountCanvas.transform.anchorMin = Vector2(0, 1)
	RemainingCountCanvas.transform.anchorMax = Vector2(0, 1)
	RemainingCountCanvas.transform.pivot = Vector2(0, 1)
	RemainingCountText = CreateRemainingCountCanvas(RemainingCountCanvas, "RemainingCount", Vector2(150, -280 - (7 * 60)))
	RemainingCountText.text = ALL_Noteindex
end

function execute.onSpawnNote(noteController)
	if StartNote_id > noteController.NoteIndex then
		StartNote_id = noteController.NoteIndex
	end
end

local RemainingCount = function()
	RemainingCountText.text = ALL_Noteindex - judgeNote - StartNote_id
end
execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
	judgeNote = judgeNote + 1
	RemainingCount()
end

execute.onMissedNote = function(id, lane, noteType)
	judgeNote = judgeNote + 1
	RemainingCount()
end

return execute
