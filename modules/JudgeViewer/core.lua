--著者: Wicky

local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local Vector2 = UnityEngine.Vector2
local Vector3 = UnityEngine.Vector3
local Color = UnityEngine.Color
local Material = UnityEngine.Material
local Time = UnityEngine.Time
local Resources = UnityEngine.Resources

local execute = {}
execute.active = true

local Judges = {
	{
		name = "Brillant",
		spriteID = "judge_0",
		type = 0
	},
	{
		name = "Great",
		spriteID = "judge_1",
		type = 1
	},
	{
		name = "Fast",
		spriteID = "judge_2",
		type = 2
	},
	{
		name = "Slow",
		spriteID = "judge_3",
		type = 3
	},
	{
		name = "Bad",
		spriteID = "judge_4",
		type = 4
	},
	{
		name = "Miss",
		spriteID = "judge_5",
		type = 5
	}
}

local function CreateJudgeCanvas(parentCanvas, name, pos, sprite)
	local JudgeImg = GameObject(name)
	JudgeImg.gameObject.transform:SetParent(parentCanvas.transform, false)
	JudgeImg:AddComponent(typeof(UnityEngine.CanvasRenderer))
	JudgeImgComp = JudgeImg:AddComponent(typeof(UnityEngine.UI.Image))
	JudgeImgComp.sprite = sprite
	JudgeImgComp.transform.anchorMin = Vector2(0, 1)
	JudgeImgComp.transform.anchorMax = Vector2(0, 1)
	JudgeImgComp.transform.sizeDelta = Vector2(230, 60)
	JudgeImgComp.transform.anchoredPosition = pos

	local TextCanvas = ACTORFACTORY:CreateUIText()
	TextCanvas.name = name .. "Text"
	TextCanvas.gameObject.transform:SetParent(JudgeImg.transform, false)
	TextCanvas.gameObject:AddComponent(typeof(UnityEngine.CanvasRenderer))
	local _TextCanvasText = TextCanvas:GetTextMeshProUGUI()
	TextCanvas.transform.sizeDelta = Vector2(200, 100)
	TextCanvas.transform.anchoredPosition = Vector2(220, -22)
	_TextCanvasText.outlineWidth = 0.2
	_TextCanvasText.fontSize = 37
	_TextCanvasText.text = "0"
	_TextCanvasText.color = Color(1, 1, 1, 1)
	_TextCanvasText.alignment = CS.TMPro.TextAlignmentOptions.TopLeft
	return _TextCanvasText
end

execute.onloaded = function()
	local WickyCanvas = util.GetCanvas()
	local spriteObj = CS.UnityEngine.Resources.FindObjectsOfTypeAll(typeof(UnityEngine.Sprite))

	local JudgementCanvas = GameObject("JudgementCanvas")
	JudgementCanvas.gameObject.transform:SetParent(WickyCanvas.transform, false)
	JudgementCanvasComp = JudgementCanvas:AddComponent(typeof(UnityEngine.Canvas))
	JudgementCanvasComp.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera
	JudgementCanvas.transform.anchorMin = Vector2(0, 1)
	JudgementCanvas.transform.anchorMax = Vector2(0, 1)
	JudgementCanvas.transform.pivot = Vector2(0, 1)

	for i = 0, spriteObj.Length - 1 do
		for j, v in pairs(Judges) do
			if spriteObj[i].name == v.spriteID then
				v.sprite = spriteObj[i]
				v.text = CreateJudgeCanvas(JudgementCanvas, v.name, Vector2(150, -280 - (j * 60)), v.sprite)
				break
			end
		end
	end

	for _, v in pairs(Judges) do
		v.count = 0
	end
end

execute.update = function()
	for _, judge in pairs(Judges) do
		judge.text.text = judge.count
	end
end

execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
	for _, judge in pairs(Judges) do
		if judge.type == judgeType then
			judge.count = judge.count + 1
			break
		end
	end
end

execute.onMissedNote = function(id, lane, noteType)
	Judges[6].count = Judges[6].count + 1
end

return execute
