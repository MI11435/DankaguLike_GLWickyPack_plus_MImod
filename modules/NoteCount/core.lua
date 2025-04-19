local UnityEngine = CS.UnityEngine
local GameObject = UnityEngine.GameObject
local TMPro = CS.TMPro
local RectTransform = UnityEngine.RectTransform

local execute = {}
execute.active = true

local FontJP = nil
local noteTextEntries = {}
local TextSize = 0.75

execute.onloaded = function()
  TextSize = execute.GetOption("size") or 0.75
  FontJP = util.GetFontJP_TMP()
end

execute.update = function()
  for i = #noteTextEntries, 1, -1 do
    local entry = noteTextEntries[i]
    if entry.noteObj and entry.textObj and entry.noteObj.activeInHierarchy then
    else
      if entry.textObj then
        GameObject.Destroy(entry.textObj)
      end
      table.remove(noteTextEntries, i)
    end
  end
end

local function Destroy_textObj(id)
  for i = #noteTextEntries, 1, -1 do
    local entry = noteTextEntries[i]
    if entry.noteObj and entry.textObj and entry.noteObj.activeInHierarchy then
      local noteid = entry.textObj:GetComponent(typeof(TMPro.TextMeshPro)).text
      if noteid == tostring(id) .. "\n\n" then
        GameObject.Destroy(entry.textObj)
        table.remove(noteTextEntries, i)
      end
    end
  end
end

execute.onHitNote = function(id, lane, noteType, judgeType, isAttack)
  Destroy_textObj(id)
end

function execute.onMissedNote(id, lane, noteType)
  Destroy_textObj(id)
end

execute.onSpawnNote = function(noteController)
  local index = noteController.NoteIndex
  local noteObj = noteController.gameObject

  for i, entry in ipairs(noteTextEntries) do
    if entry.noteObj == noteObj then
      entry.textObj:GetComponent(typeof(TMPro.TextMeshPro)).text = tostring(index)
      return
    end
  end

  local textObj = GameObject("NoteText_" .. index)
  textObj.transform:SetParent(noteObj.transform)

  local textComponent = textObj:AddComponent(typeof(TMPro.TextMeshPro))
  textComponent.text = tostring(index) .. "\n\n"
  textComponent.font = FontJP
  textComponent.fontSize = 3
  textComponent.alignment = TMPro.TextAlignmentOptions.Center
  textComponent.color = UnityEngine.Color.white
  textComponent.enableWordWrapping = false
  textComponent.overflowMode = TMPro.TextOverflowModes.Overflow

  -- Set sorting layer and order
  local renderer = textObj:GetComponent(typeof(UnityEngine.Renderer))
  if renderer then
    renderer.sortingOrder = 10
  end

  local rectTransform = textObj:GetComponent(typeof(RectTransform))
  rectTransform.sizeDelta = UnityEngine.Vector2(1, 1)
  rectTransform.localPosition = UnityEngine.Vector3(0, 0, 0)

  textObj.transform.localScale = UnityEngine.Vector3(TextSize, TextSize, TextSize)

  table.insert(noteTextEntries, {
    noteObj = noteObj,
    textObj = textObj
  })
end

return execute
