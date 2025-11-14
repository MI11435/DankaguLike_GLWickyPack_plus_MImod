local execute = {}
execute.active = true
local ClearState = nil
local High_Score = 0
local StartNote_id = 0
local Note_id = -1
local theoretical_value = 1000000 --理論値
local ALL_Noteindex = 0

local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local Vector2 = UnityEngine.Vector2
local Path = CS.System.IO.Path

local LifeView2

function execute.onloaded()
    local LifeView = GameObject.Find("CameraCanvas/LifeView")
    LifeView2 = GameObject.Instantiate(LifeView)
    LifeView2.name = "LifeView2"
    LifeView2.gameObject.transform:SetParent(GameObject.Find("CameraCanvas").transform, false)
    LifeView2.gameObject.transform.anchoredPosition = LifeView.gameObject.transform.anchoredPosition - Vector2(0, 150)
    LifeView2.transform:GetChild(2).transform.anchorMin = Vector2(0, 1)
    LifeView2.transform:GetChild(2):GetComponent(typeof(CS.TMPro.TextMeshProUGUI)).text = "Δ High Score"
    LifeView2.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Slider)).normalizedValue = 1
    if APPMAN:IsNotePreview() == true or GAMESTATE:GetPlayMode() ~= 3 then
        GameObject.Find("OverlayCanvas/PauseButton/Image"):GetComponent(typeof(UnityEngine.UI.Image)).color
        = UnityEngine.Color(1, 1, 1, 40 / 225)
    end
end

execute.start = function()
    ALL_Noteindex = GAMESTATE:GetNotes().Length
    StartNote_id = ALL_Noteindex

    if (APPMAN:IsNotePreview()) then
        return
    end
    local scoreData = PLAYERSTATS:GetHighScore()

    if (scoreData == nil) then
        return
    end

    ClearState = scoreData.ClearState
    High_Score = scoreData.Score
    LifeView2.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Slider)).maxValue = theoretical_value - High_Score
    LifeView2.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Slider)).normalizedValue = 1
end

---
--- @param noteController CS.NoteController
---
function execute.onSpawnNote(noteController)
    if StartNote_id > noteController.NoteIndex then
        StartNote_id = noteController.NoteIndex
    end
end

local function retry()
    local platform = APPMAN:GetPlatformInt()
    if execute.GetOption("SCENE") == 2 then
        if platform == 3 or platform == 4 then
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene(2)
        else
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Game")
        end
    elseif execute.GetOption("SCENE") == 1 then
        if platform == 3 or platform == 4 then
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene(1)
        else
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene("SelectMusic")
        end
    elseif execute.GetOption("SCENE") == 4 then
        PLAYERSTATS:SetLife(0)
    end
end

local function High_Score_Judge()
    local score = PLAYERSTATS:GetScore()
    if High_Score < theoretical_value then --ハイスコアが理論値より大きかったらこのluaは実行しない。
        local hantei = (theoretical_value - High_Score) -
            (math.floor(((StartNote_id + Note_id + 1) / ALL_Noteindex) * theoretical_value) - score)
        LifeView2.transform:GetChild(1):GetComponent(typeof(UnityEngine.UI.Slider)).value = hantei
        if hantei < 0 then
            retry()
        end
    end
end

execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
    if ClearState == 3 and 0 < judgeType then
        retry()
    end
    Note_id = Note_id + 1
    High_Score_Judge()
end

execute.onMissedNote = function(id, lane, noteType)
    if ClearState == 3 then
        retry()
    end
    Note_id = Note_id + 1
    High_Score_Judge()
end

return execute
