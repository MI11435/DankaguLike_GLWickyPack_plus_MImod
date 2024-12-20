local execute = {}
execute.active = true
local High_Score = 0
local Note_id = -1
local theoretical_value = 1000000 --理論値
local ALL_Noteindex = 0
execute.start = function()
    ALL_Noteindex = GAMESTATE:GetNotes().Length
    if (APPMAN:IsNotePreview()) then
        return
    end

    local scoreData = CS.ScoreDataPrefas.instance:FindScore(
        CS.GameManager.Instance.SelectSongInfo.FolderName,
        CS.GameManager.Instance.SelectDifficulty
    )

    if (scoreData == nil) then
        return
    end

    --[[
    SCREENMAN:SystemMessage(
        "Score : " .. scoreData.Score .. " | " ..
        "Combo : " .. scoreData.Combo .. " | " ..
        "ClearState : " .. scoreData.ClearState .. " | " ..
        "Rank : " .. scoreData.Rank
    )
    ]]
    High_Score = scoreData.Score
end

execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
    if Note_id < id then
        Note_id = id
    end
end

execute.onMissedNote = function(id, lane, noteType)
    if Note_id < id then
        Note_id = id
    end
end

execute.update = function()
    local score = PLAYERSTATS:GetScore()
    if High_Score <= theoretical_value then --ハイスコアが理論値より大きかったらこのluaは実行しない。
        local hantei, dec = math.modf((theoretical_value - High_Score) -
            (((Note_id + 1) / ALL_Noteindex) * theoretical_value - score))
        if hantei < 0 then
            local platform = APPMAN:GetPlatformInt()
            if platform == 3 or platform == 4 then
                CS.UnityEngine.SceneManagement.SceneManager.LoadScene(2)
            else
                CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Game")
            end
        end
    end
end

return execute
