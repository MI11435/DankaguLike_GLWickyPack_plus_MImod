local execute = {}
execute.active = true

local _Audio_Reverb_Zone_obj

execute.onloaded = function()
    local assetBundleHash = execute.LoadAssetBundle("modules/" .. util.GetPlatformPath() .. "/audio-reverb-zone")
    local _Audio_Reverb_Zone = ASSETMAN:LoadGameObject(assetBundleHash, "Audio Reverb Zone")
    _Audio_Reverb_Zone_obj = CS.UnityEngine.GameObject.Instantiate(_Audio_Reverb_Zone)
    _Audio_Reverb_Zone_obj:SetActive(false)
    UTIL:DelayAction(1, DelayReverb)
end

function DelayReverb()
    _Audio_Reverb_Zone_obj:SetActive(true)
end

return execute
