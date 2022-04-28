-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local LocalizationService = _services.LocalizationService
local Players = _services.Players
local fetchDeviceType = TS.import(script, script.Parent.Parent, "utils", "deviceType").fetchDeviceType
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local function roundTo2DP(num)
	return math.round(num * 100) / 100
end
-- Called from while loop so no loop needed here
local function playerLocation(gameId)
	-- Final note from gerald I WANT MINI_MAPS AAHAHHHAHH, i know many requests but u gotta do what u gotta do
	-- First fetch players
	local players = Players:GetPlayers()
	-- lets map it to the what the server is expecting
	local _players = players
	local _arg0 = function(e)
		local _Torso = e.Character
		if _Torso ~= nil then
			_Torso = _Torso:FindFirstChild("Torso")
		end
		local Torso = _Torso
		local pos = Vector3.new(0, 0, 0)
		if Torso and Torso:IsA("BasePart") then
			local tempPos = Torso.Position
			-- Round cause RovolutionAnalytica will reject if not
			pos = Vector3.new(roundTo2DP(tempPos.X), roundTo2DP(tempPos.Y), roundTo2DP(tempPos.Z))
		end
		return {
			name = e.Name,
			id = e.UserId,
			countryCode = LocalizationService:GetCountryRegionForPlayerAsync(e),
			position = tostring(pos.X) .. "," .. tostring(pos.Y) .. "," .. tostring(pos.Z),
			premium = e.MembershipType == Enum.MembershipType.Premium,
			deviceType = fetchDeviceType(e),
		}
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_players)
	for _k, _v in ipairs(_players) do
		_newValue[_k] = _arg0(_v, _k - 1, _players)
	end
	-- ▲ ReadonlyArray.map ▲
	local playerArray = _newValue
	local _ptr = {
		players = playerArray,
	}
	local _left = "privateServer"
	local _result
	if game.PrivateServerId == "" then
		_result = false
	else
		_result = true
	end
	_ptr[_left] = _result
	_ptr.gameId = gameId
	mainLogger("/live_players", _ptr)
end
return {
	playerLocation = playerLocation,
}
