local execute = {}
execute.active = true
function _InfiniteLife()
    PLAYERSTATS:SetLife(1)
end
execute.onloaded = function(e)
    _InfiniteLife()
end
execute.update = function()
    _InfiniteLife()
end
execute.onHitNote = function(id, lane, noteType, judgeType)
    _InfiniteLife()
end
execute.onMissedNote = function(id, lane, noteType)
    _InfiniteLife()
end
return execute