local execute = {}
execute.active = true
execute.onSpawnNote = function(noteController)
    if (noteController.NoteType == CS.NoteType.Fuzzy or noteController.NoteType == CS.NoteType.Normal) and _SoftLanding_MI == true then
        if noteController.NoteIndex % 3 == 0 then
            noteController:SetIndividualSpeed(1)
        elseif noteController.NoteIndex % 3 == 1 then
            noteController:SetIndividualSpeed(0.75)
        else
            noteController:SetIndividualSpeed(0.5)
        end
    end
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
