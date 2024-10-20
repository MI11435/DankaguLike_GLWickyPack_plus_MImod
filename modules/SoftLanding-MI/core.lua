local execute = {}
execute.active = true
execute.onSpawnNote = function(noteController)
    if (noteController.NoteType == CS.NoteType.Fuzzy or noteController.NoteType == CS.NoteType.Normal) and _SoftLanding_MI == true then
        noteController:EnableDefaultMove(false)
        noteController:SetLanePosition(noteController.Lane)
        if noteController.NoteIndex % 3 == 0 then
            noteController:SetDelegate(MIpozZ)
        elseif noteController.NoteIndex % 3 == 1 then
            noteController:SetDelegate(MIpozZ2)
        else
            noteController:SetDelegate(MIpozZ3)
        end
    end
end
MIpozZ = function(noteController)
    local noteZ = noteController.JustBeat -
        UTIL:CalculateScrolledBeat(GAMESTATE:GetSongBeat())

    return noteController:SetBeatPosition(noteZ)
end
MIpozZ2 = function(noteController)
    local noteZ = noteController.JustBeat -
        UTIL:CalculateScrolledBeat(GAMESTATE:GetSongBeat())

    return noteController:SetBeatPosition(noteZ * 0.75)
end
MIpozZ3 = function(noteController)
    local noteZ = noteController.JustBeat -
        UTIL:CalculateScrolledBeat(GAMESTATE:GetSongBeat())

    return noteController:SetBeatPosition(noteZ * 0.5)
end
execute.onloaded = function()
    GAMESTATE:SetActiveSameTimeBar(false)
    GAMESTATE:SetVisibleRate(18)
    _SoftLanding_MI = true
end
execute.ondestroy = function()
    _SoftLanding_MI = false
end
return execute
