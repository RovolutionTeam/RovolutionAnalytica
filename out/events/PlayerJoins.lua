-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local MarketplaceService = _services.MarketplaceService
local Players = _services.Players
local fetchDeviceType = TS.import(script, script.Parent.Parent, "utils", "deviceType").fetchDeviceType
local fetchFriendsValue = TS.import(script, script.Parent.Parent, "utils", "friends").fetchFriendsValue
local GameMainGenre = TS.import(script, script.Parent.Parent, "utils", "genreFinder").genre
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local _NewVsReturning = TS.import(script, script.Parent.Parent, "utils", "NewVsReturning")
local addPlayer = _NewVsReturning.addPlayer
local checkPlayerJoinedBefore = _NewVsReturning.checkPlayerJoinedBefore
local cleanUpPlayerJoined = _NewVsReturning.cleanUpPlayerJoined
local getUserSessionDuration = TS.import(script, script.Parent.Parent, "utils", "sessionDuration").getUserSessionDuration
-- This handles players joining and leaving --
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local ownerType = game.CreatorType == Enum.CreatorType.User and "User" or "Group"
local PlayerJoinHook = TS.async(function()
	-- Ok we want to track session length
	local handlePlayerJoin = function(plr)
		-- Create Data Folder
		local dataFolder = Instance.new("Folder", plr)
		dataFolder.Name = "RovolutionAnalytica"
		-- Create a timestamp element
		local timestamp = Instance.new("NumberValue", dataFolder)
		timestamp.Name = "Rovolution_Analytica_Timestamp"
		timestamp.Value = os.time()
		local friendsJoined = Instance.new("NumberValue", dataFolder)
		friendsJoined.Name = "Rovolution_Analytica_FriendsJoined"
		friendsJoined.Value = 0
		-- Check if first time in game
		addPlayer(plr)
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
		local joinData = plr:GetJoinData()
		local _ptr = {
			plr = plr.Name,
			userId = plr.UserId,
			sessionDuration = getUserSessionDuration(plr),
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
		_ptr.accountAge = plr.AccountAge
		_ptr.friendsJoined = fetchFriendsValue(plr)
		_ptr.firstTime = checkPlayerJoinedBefore(plr)
		_ptr.premiumPlayer = plr.MembershipType == Enum.MembershipType.Premium
		local data = _ptr
		if joinData ~= nil and joinData.SourcePlaceId ~= nil then
			local lookupGame = MarketplaceService:GetProductInfo(joinData.SourcePlaceId, Enum.InfoType.Asset)
			local _ptr_1 = {}
			if type(data) == "table" then
				for _k, _v in pairs(data) do
					_ptr_1[_k] = _v
				end
			end
			_ptr_1.teleported = true
			_ptr_1.joinedGame = lookupGame.AssetId
			_ptr_1.joinedGameName = lookupGame.Name
			data = _ptr_1
		else
			local _ptr_1 = {}
			if type(data) == "table" then
				for _k, _v in pairs(data) do
					_ptr_1[_k] = _v
				end
			end
			_ptr_1.teleported = false
			data = _ptr_1
		end
		mainLogger("/handle_leave", data)
		cleanUpPlayerJoined(plr)
	end))
end)
return {
	PlayerJoinHook = PlayerJoinHook,
}
