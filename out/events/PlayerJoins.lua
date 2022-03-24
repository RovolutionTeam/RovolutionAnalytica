-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local MarketplaceService = _services.MarketplaceService
local Players = _services.Players
local RL_LOG = TS.import(script, script.Parent.Parent, "utils", "consoleLogging").RL_LOG
local fetchDeviceType = TS.import(script, script.Parent.Parent, "utils", "deviceType").fetchDeviceType
local GameMainGenre = TS.import(script, script.Parent.Parent, "utils", "genreFinder").genre
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
-- This handles players joining and leaving --
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local ownerType = game.CreatorType == Enum.CreatorType.User and "User" or "Group"
local PlayerJoinHook = TS.async(function()
	-- Ok we want to track session length
	local handlePlayerJoin = function(plr)
		-- Create a timestamp element
		local timestamp = Instance.new("NumberValue")
		timestamp.Name = "Rovolution_Analytica_Timestamp"
		timestamp.Value = os.time()
		timestamp.Parent = plr
	end
	-- Lets also record all players are in the game when we start up
	local _exp = Players:GetPlayers()
	local _arg0 = TS.async(function(plr)
		handlePlayerJoin(plr)
	end)
	-- ▼ ReadonlyArray.forEach ▼
	for _k, _v in ipairs(_exp) do
		_arg0(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.forEach ▲
	Players.PlayerAdded:Connect(TS.async(function(plr)
		handlePlayerJoin(plr)
	end))
	Players.PlayerRemoving:Connect(TS.async(function(plr)
		-- Get the timestamp
		local timestamp = plr:FindFirstChild("Rovolution_Analytica_Timestamp")
		-- Verify it is the right type
		if timestamp and timestamp:IsA("NumberValue") then
			-- Get the timestamp value
			local timestampValue = timestamp.Value
			local _ptr = {
				plr = plr.Name,
				userId = plr.UserId,
				sessionDuration = os.time() - timestampValue,
				inGroup = checkInParentGroup(plr, game.CreatorId, ownerType),
				CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr)),
				gameId = game.GameId,
			}
			local _left = "privateServer"
			local _result
			if game.PrivateServerId == "" then
				_result = false
			else
				_result = true
			end
			_ptr[_left] = _result
			_ptr.gameGenre = GameMainGenre()
			_ptr.gameName = gameName
			_ptr.deviceType = fetchDeviceType(plr)
			_ptr.UUID = HttpService:GenerateGUID(false)
			mainLogger("/handle_leave", _ptr)
		else
			RL_LOG("Could not find Rovolution_Analytica_Timestamp")
		end
	end))
end)
return {
	PlayerJoinHook = PlayerJoinHook,
}
