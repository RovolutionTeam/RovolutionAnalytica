-- Compiled with roblox-ts v1.2.3
local function getUserSessionDuration(plr)
	local _timestamp = plr:FindFirstChild("ROVOLUTION_ANALYTICA")
	if _timestamp ~= nil then
		_timestamp = _timestamp:FindFirstChild("Rovolution_Analytica_Timestamp")
	end
	local timestamp = _timestamp
	if not (timestamp and timestamp:IsA("NumberValue")) then
		return 0
	end
	return os.time() - timestamp.Value
end
return {
	getUserSessionDuration = getUserSessionDuration,
}
