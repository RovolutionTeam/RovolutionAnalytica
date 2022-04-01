-- Compiled with roblox-ts v1.2.3
local function fetchDeviceType(plr)
	local _deviceType = plr:FindFirstChild("RovolutionAnalytica")
	if _deviceType ~= nil then
		_deviceType = _deviceType:FindFirstChild("ROVOLUTION_DEVICE_TYPE")
	end
	local deviceType = _deviceType
	-- Verify it is the right type
	if not (deviceType and deviceType:IsA("StringValue")) then
		return "N/A"
	end
	return deviceType.Value
end
return {
	fetchDeviceType = fetchDeviceType,
}
