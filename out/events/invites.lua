-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local MarketplaceService = _services.MarketplaceService
local SocialService = _services.SocialService
local genre = TS.import(script, script.Parent.Parent, "utils", "genreFinder").genre
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local getUserSessionDuration = TS.import(script, script.Parent.Parent, "utils", "sessionDuration").getUserSessionDuration
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local ownerType = game.CreatorType == Enum.CreatorType.User and "User" or "Group"
local gameInvites = TS.async(function()
	SocialService.GameInvitePromptClosed:Connect(TS.async(function(plr, invited)
		local _ptr = {
			currentSession = getUserSessionDuration(plr),
			plr = plr.Name,
			userId = plr.UserId,
			invited = invited,
			UUID = HttpService:GenerateGUID(false),
		}
		local _left = "privateServer"
		local _result
		if game.PrivateServerId == "" then
			_result = false
		else
			_result = true
		end
		_ptr[_left] = _result
		_ptr.gameId = game.GameId
		_ptr.gameName = gameName
		_ptr.gameGenre = genre()
		_ptr.CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr))
		_ptr.inGroup = checkInParentGroup(plr, game.CreatorId, ownerType)
		mainLogger("/game_invites", _ptr)
	end))
end)
return {
	gameInvites = gameInvites,
}
