--著者: Wicky

local _TextCanvasText = nil
local UnityEngine = CS.UnityEngine
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local GameObject = UnityEngine.GameObject

local WickyCanvas = nil
local diffText = nil
local diffColor = nil
local diffMeter = nil
local diffX = nil
local size = nil

local execute = {}
execute.active = true

--=================================
--		 MAIN SCRIPT
--=================================

local function CreateLyricCanvas(WickyCanvas, name, pos, color, text, size)
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
	_TextCanvasText.alignment = CS.TMPro.TextAlignmentOptions.BottomRight
	_TextCanvasText.text = text
	_TextCanvasText.color = color
end

execute.onloaded = function()
	WickyCanvas = util.GetCanvas()

	diffText = ''
	diffColor = util.ColorRGB(0, 0, 0)
	local diffType = SONGMAN:GetDifficultyToInt()
	diffMeter = SONGMAN:GetMeterName()
	diffX = false
	size = execute.GetOption("size")

	if diffType == 0 then
		diffText = "Easy"
		diffColor = util.ColorRGB(0, 255, 32)
	elseif diffType == 1 then
		diffText = "Normal"
		diffColor = util.ColorRGB(0, 133, 255)
	elseif diffType == 2 then
		diffText = "Hard"
		diffColor = util.ColorRGB(255, 235, 0)
	elseif diffType == 3 then
		diffText = "Extra"
		diffColor = util.ColorRGB(255, 0, 34)
	elseif diffType == 4 then
		diffText = "Lunatic"
		diffColor = util.ColorRGB(222, 0, 255)
	end
	UTIL:DelayAction(1, MIdelay)
end
function MIdelay()
	if _Houkai == 1 then
		diffText = "壊:" .. diffText
	end
	diffX = diffMeter == 12345678
	if (diffX) then
		diffText = diffText .. " X"
	else
		diffText = diffText .. " " .. diffMeter
	end
	if SONGMAN:GetChartArtist():len() > 0 then
		diffText = diffText .. "<br>Score：" .. SONGMAN:GetChartArtist()
	end
	CreateLyricCanvas(WickyCanvas, "TextDifficultyShadow", Vector3(-33, 28, 0), diffColor, diffText, size)
	CreateLyricCanvas(WickyCanvas, "TextDifficulty", Vector3(-35, 30, 0), util.ColorRGB(255, 255, 255), diffText, size)
end

return execute
