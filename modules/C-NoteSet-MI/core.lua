local execute = {}
execute.active = true
local GameObject = CS.UnityEngine.GameObject
local _Size_rog = nil
local _HiSpeed_rog = nil
local _GameManager = GameObject.Find("SingletonPrefabs/GameManager"):GetComponent("GameManager")
local _songPlay = nil
local platform = nil
execute.onloaded = function()
    platform = APPMAN:GetPlatformInt()
    if platform == 3 or platform == 4 then
        _Size_rog = execute.ReturnparentDir() .. "modules/C-NoteSet-MI/Sizerog.txt"
        _HiSpeed_rog = execute.ReturnparentDir() .. "modules/C-NoteSet-MI/HiSpeedrog.txt"
    else
        _Size_rog = execute.ReturnparentDir() .. [[modules\C-NoteSet-MI\Sizerog.txt]]
        _HiSpeed_rog = execute.ReturnparentDir() .. [[modules\C-NoteSet-MI\HiSpeedrog.txt]]
    end
    local ReSize = CS.System.IO.File.ReadAllText(_Size_rog)
    local ReHiSpeed = CS.System.IO.File.ReadAllText(_HiSpeed_rog)
    if ReSize == "nam" and ReHiSpeed == "nam" then
        _songPlay = 0
        CS.System.IO.File.WriteAllText(_Size_rog, "" .. PLAYERSTATS:GetNoteSizeOption())
        CS.System.IO.File.WriteAllText(_HiSpeed_rog, "" .. PLAYERSTATS:GetNoteSpeedOption())

        _GameManager.NotesOption.Size = execute.GetOption("SIZE")
        _GameManager.NotesOption.HiSpeed = execute.GetOption("SPEED")
        --start関数以降でないとファイルパスが伝わらない
        --一応残しておく
        --[[if platform == 3 or platform == 4 then
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene(2)
        else
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Game")
        end]]
    else
        _songPlay = 1
    end
end

execute.start = function()
    if _songPlay == 0 then
        if platform == 3 or platform == 4 then
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene(2)
        else
            CS.UnityEngine.SceneManagement.SceneManager.LoadScene("Game")
        end
    end
end

execute.ondestroy = function()
    if _songPlay == 1 then
        local ReSize = tonumber(CS.System.IO.File.ReadAllText(_Size_rog))
        local ReHiSpeed = tonumber(CS.System.IO.File.ReadAllText(_HiSpeed_rog))
        _GameManager.NotesOption.Size = ReSize
        _GameManager.NotesOption.HiSpeed = ReHiSpeed
        CS.System.IO.File.WriteAllText(_Size_rog, "nam")
        CS.System.IO.File.WriteAllText(_HiSpeed_rog, "nam")
    end
end
return execute
