-- Compiled with roblox-ts v1.2.3
local function getUserSessionDuration(plr)
	local timestamp = plr:FindFirstChild("Rovolution_Analytica_Timestamp")
	if not (timestamp and timestamp:IsA("NumberValue")) then
		return 0
	end
	return os.time() - timestamp.Value
end
return {
	getUserSessionDuration = getUserSessionDuration,
}
