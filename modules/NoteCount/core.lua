local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local TMPro = CS.TMPro
local RectTransform = UnityEngine.RectTransform

local execute = {}
execute.active = true

local FontJP = nil
local TextSize = 0.75

execute.onloaded = function()
  TextSize = execute.GetOption("size") or 0.75
  FontJP = util.GetFontJP_TMP()
end

execute.onSpawnNote = function(noteController)
  local index = noteController.NoteIndex
  local noteObj = noteController.gameObject

  if noteObj.name == "Note_Legacy(Clone)" or noteObj.name == "Note(Clone)" then
    local SEttextObj = GameObject("NoteText")
    SEttextObj.transform:SetParent(noteObj.transform)
    SEttextObj.transform:SetSiblingIndex(0)

    local textComponent = SEttextObj:AddComponent(typeof(TMPro.TextMeshPro))
    textComponent.text = index .. "\n\n"
    textComponent.font = FontJP
    textComponent.fontSize = 3
    textComponent.alignment = TMPro.TextAlignmentOptions.Center
    textComponent.color = UnityEngine.Color.white
    textComponent.enableWordWrapping = false
    textComponent.overflowMode = TMPro.TextOverflowModes.Overflow

    -- Set sorting layer and order
    local renderer = SEttextObj:GetComponent(typeof(UnityEngine.Renderer))
    if renderer then
      renderer.sortingOrder = 10
    end

    local rectTransform = SEttextObj:GetComponent(typeof(RectTransform))
    rectTransform.sizeDelta = UnityEngine.Vector2(1, 1)
    rectTransform.localPosition = UnityEngine.Vector3(0, 0, 0)

    SEttextObj.transform.localScale = UnityEngine.Vector3(TextSize, TextSize, TextSize)
    noteObj.name = "Note_Legacy(NoteText)"
  elseif noteObj.name == "Note_Legacy(NoteText)" then
    local Textobj = noteObj.transform:GetChild(0)
    Textobj:GetComponent(typeof(TMPro.TextMeshPro)).text = index .. "\n\n"
  end
end

return execute
