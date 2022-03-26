-- Compiled with roblox-ts v1.2.3
local function fetchFriends(plr)
	local _deviceType = plr:FindFirstChild("RovolutionAnalytica")
	if _deviceType ~= nil then
		_deviceType = _deviceType:FindFirstChild("Rovolution_Analytica_FriendsJoined")
	end
	local deviceType = _deviceType
	-- Verify it is the right type
	if not (deviceType and deviceType:IsA("NumberValue")) then
		return "N/A"
	end
	return deviceType
end
local function incrementFriends(plr)
	local dataObj = fetchFriends(plr)
	if dataObj == "N/A" then
		return nil
	end
	dataObj.Value = dataObj.Value + 1
end
local function fetchFriendsValue(plr)
	local dataObj = fetchFriends(plr)
	if dataObj == "N/A" then
		return 0
	end
	return dataObj.Value
end
return {
	fetchFriends = fetchFriends,
	incrementFriends = incrementFriends,
	fetchFriendsValue = fetchFriendsValue,
}
