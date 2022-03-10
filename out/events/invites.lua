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
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local ownerType = game.CreatorType == Enum.CreatorType.User and "User" or "Group"
local gameInvites = TS.async(function()
	SocialService.GameInvitePromptClosed:Connect(TS.async(function(plr, invited)
		local timestamp = plr:FindFirstChild("Rovolution_Analytica_Timestamp")
		-- Verify it is the right type
		if not (timestamp and timestamp:IsA("NumberValue")) then
			return nil
		end
		mainLogger("/game_invites", {
			currentSession = os.time() - timestamp.Value,
			plr = plr.Name,
			userId = plr.UserId,
			invited = invited,
			UUID = HttpService:GenerateGUID(false),
			privateServer = game.PrivateServerId == "" and true or false,
			gameId = game.GameId,
			gameName = gameName,
			gameGenre = genre,
			CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr)),
			inGroup = checkInParentGroup(plr, game.CreatorId, ownerType),
		})
	end))
end)
return {
	gameInvites = gameInvites,
}
