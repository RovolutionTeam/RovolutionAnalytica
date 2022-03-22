-- Compiled with roblox-ts v1.2.3
local function fetchDeviceType(plr)
	local deviceType = plr:FindFirstChild("ROVOLUTION_DEVICE_TYPE")
	-- Verify it is the right type
	if not (deviceType and deviceType:IsA("StringValue")) then
		return "N/A"
	end
	return deviceType.Value
end
return {
	fetchDeviceType = fetchDeviceType,
}
