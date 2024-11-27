GameObject = CS.UnityEngine.GameObject
Vector3 = CS.UnityEngine.Vector3
Vector2 = CS.UnityEngine.Vector2

local execute = {}
execute.active = true

local SAMPLE_NUM_MI = 128
local _spectrumData_MI = {}

local _LifeFill_MI

local ALL_spectrumData = 0

execute.onloaded = function()
    for i = 1, SAMPLE_NUM_MI do
        _spectrumData_MI[i] = 0
    end

    _BgImage = GameObject.Find("SingletonPrefabs/BgManager/Canvas/BgImage")

    _LifeFill_MI = GameObject.Find("CameraCanvas/LifeView/LifeSlider/Fill Area/Fill")
    _LifeFill_MI.transform.anchorMax = Vector2(0, 1)
    _LifeLabel = GameObject.Find("CameraCanvas/LifeView/LifeLabel (TMP)")
    _LifeLabel.transform.anchorMin = Vector2(0, 1)
    _LifeLabel:GetComponent(typeof(CS.TMPro.TextMeshProUGUI)).text = "AudioSpectrum"
end

execute.update = function()
    _spectrumData_MI = UTIL:GetSpectrumData(SAMPLE_NUM_MI, 0, CS.UnityEngine.FFTWindow.Rectangular)

    if (_spectrumData_MI == nil) then
        return;
    end
    for i = 1, SAMPLE_NUM_MI do
        ALL_spectrumData = ALL_spectrumData + _spectrumData_MI[i - 1]
    end
    _LifeFill_MI.transform.anchorMax = Vector2(ALL_spectrumData / 4, 1)
    _BgImage.transform.localScale = Vector3(1 + (_spectrumData_MI[0] / 10), 1 + (_spectrumData_MI[0] / 10), 1)
    ALL_spectrumData = 0
end

execute.ondestroy = function()
    _BgImage.transform.localScale = Vector3(1, 1, 1)
end
return execute
