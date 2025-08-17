local execute = {}
execute.active = true
local GameObject = CS.UnityEngine.GameObject

local laneSprite = {}

local laneSprite_a = { 0, 0, 0, 0, 0, 0, 0 }

execute.onloaded = function()
    local _Sprite = UTIL:CreateSprite(execute.LoadTexture("grd.png"))
    local JudgementColor = GameObject("JudgementColor_MImod")
    JudgementColor.gameObject.transform:SetParent(util.GetLaneSpriteCanvas().transform, false)
    for i = 1, 7, 1 do
        laneSprite[i] = GameObject.Instantiate(LaneSpritePrefab)
        laneSprite[i].gameObject.transform:SetParent(JudgementColor.transform, false)
        laneSprite[i].name = "LaneSprite (" .. i .. ")"
        laneSprite[i]:SetColor(0, 0, 0, 0)
        laneSprite[i]:SetLanePosition(i - 1)
        laneSprite[i]:SetSortingLayer(1)
        laneSprite[i]:GetSpriteRenderer().sprite = _Sprite
        laneSprite[i]:GetTransform().localScale = CS.UnityEngine.Vector3(1, 0.2, 1)
    end
end
execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
    if judgeType == 0 then
        laneSprite[lane + 1]:SetColor(util.ColorHexToRGBA(execute.GetOption("judgeType_0_color"),
            tonumber(execute.GetOption("judgeType_0_alpha"))))
        laneSprite_a[lane + 1] = tonumber(execute.GetOption("judgeType_0_alpha"))
    elseif judgeType == 1 then
        laneSprite[lane + 1]:SetColor(util.ColorHexToRGBA(execute.GetOption("judgeType_1_color"),
            tonumber(execute.GetOption("judgeType_1_alpha"))))
        laneSprite_a[lane + 1] = tonumber(execute.GetOption("judgeType_1_alpha"))
    elseif judgeType == 2 or judgeType == 3 then
        laneSprite[lane + 1]:SetColor(util.ColorHexToRGBA(execute.GetOption("judgeType_2_3_color"),
            tonumber(execute.GetOption("judgeType_2_3_alpha"))))
        laneSprite_a[lane + 1] = tonumber(execute.GetOption("judgeType_2_3_alpha"))
    elseif judgeType == 4 then
        laneSprite[lane + 1]:SetColor(util.ColorHexToRGBA(execute.GetOption("judgeType_4_color"),
            tonumber(execute.GetOption("judgeType_4_alpha"))))
        laneSprite_a[lane + 1] = tonumber(execute.GetOption("judgeType_4_alpha"))
    end
end

execute.update = function()
    for i = 1, 7, 1 do
        laneSprite_a[i] = laneSprite_a[i] - tonumber(execute.GetOption("frame_decrease_alpha"))
        laneSprite[i]:SetAlpha(laneSprite_a[i])
    end
end

return execute
