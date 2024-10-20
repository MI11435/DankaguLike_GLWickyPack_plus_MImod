local execute = {}
execute.active = true

execute.onloaded = function()
    local assetBundleHash = execute.LoadAssetBundle("modules/" .. util.GetPlatformPath() .. "/audio-reverb-zone")
    local _Audio_Reverb_Zone = ASSETMAN:LoadGameObject(assetBundleHash, "Audio Reverb Zone")
    CS.UnityEngine.GameObject.Instantiate(_Audio_Reverb_Zone)
end

return execute
