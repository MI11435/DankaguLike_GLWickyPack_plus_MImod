local execute = {}
execute.active = true
execute.onloaded = function(e)
    CS.UnityEngine.GameObject.Find("SingletonPrefabs/GameManager"):GetComponent("GameManager").NotesOption.Size = execute.GetOption("SIZE")
    CS.UnityEngine.GameObject.Find("SingletonPrefabs/GameManager"):GetComponent("GameManager").NotesOption.HiSpeed = execute.GetOption("SPEED")
end
return execute
