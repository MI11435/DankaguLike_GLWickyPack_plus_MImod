--著者: Wicky

local _TextCanvasText = nil
local UnityEngine = CS.UnityEngine
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local GameObject = UnityEngine.GameObject

local WickyCanvas = nil
local diffText = nil
local diffColor = nil
local diffType = nil

local execute = {}
execute.active = true

--=================================
--		 MAIN SCRIPT
--=================================

local function CreateCanvas(WickyCanvas, name, pos, color, text, size)
	local TextCanvas = ACTORFACTORY:CreateUIText()
	TextCanvas.gameObject.name = name
	TextCanvas.gameObject.transform:SetParent(WickyCanvas.transform, false)
	TextCanvas.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	_TextCanvasText = TextCanvas:GetTextMeshProUGUI()
	TextCanvas.transform.anchorMin = Vector2(0, 0)
	TextCanvas.transform.anchorMax = Vector2(1, 1)
	TextCanvas.transform.localPosition = pos
	TextCanvas.transform.sizeDelta = Vector2(0, 0)
	_TextCanvasText.fontSize = size
	_TextCanvasText.alignment = CS.TMPro.TextAlignmentOptions.BottomLeft
	_TextCanvasText.text = text
	_TextCanvasText.color = color
end

execute.onloaded = function()
	WickyCanvas = util.GetCanvas()
	diffColor = util.ColorRGB(0, 0, 0)
	diffType = SONGMAN:GetDifficultyToInt()
	if diffType == 0 then
		diffColor = util.ColorRGB(0, 255, 32)
	elseif diffType == 1 then
		diffColor = util.ColorRGB(0, 133, 255)
	elseif diffType == 2 then
		diffColor = util.ColorRGB(255, 235, 0)
	elseif diffType == 3 then
		diffColor = util.ColorRGB(255, 0, 34)
	elseif diffType == 4 then
		diffColor = util.ColorRGB(222, 0, 255)
	end
	UTIL:DelayAction(1, SongTitle_DelayAction)
end

function SongTitle_DelayAction()
	diffText = GameObject.Find("OverlayCanvas").transform:GetChild(5):GetChild(4):GetChild(1):GetChild(0)
		:GetComponent(typeof(CS.TMPro.TextMeshProUGUI)).text

	CreateCanvas(WickyCanvas, "SongTitleShadow", Vector3(33, 28, 0), diffColor,
		diffText, execute.GetOption("size"))
	CreateCanvas(WickyCanvas, "SongTitle", Vector3(35, 30, 0), util.ColorRGB(255, 255, 255),
		diffText, execute.GetOption("size"))
end

return execute
