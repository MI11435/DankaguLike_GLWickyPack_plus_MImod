local execute = {}
execute.active = true
function execute.onloaded()
	expansion = (16 / 9) / (SCREENMAN:GetScreenWidth() / SCREENMAN:GetScreenHeight())
	if expansion < 1 then
		_cameraManTr = CAMERAMAN:GetTransform()
		_y = _cameraManTr.localPosition.y
		_z = _cameraManTr.localPosition.z
		_cameraManTr.localPosition = CS.UnityEngine.Vector3(0, _y * expansion, _z * expansion)
	end
end

return execute
