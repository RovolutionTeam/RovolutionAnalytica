-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
-- This handles all robux transiations --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local MarketplaceService = _services.MarketplaceService
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local GameMainGenre = TS.import(script, script.Parent.Parent, "utils", "genreFinder").genre
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local fetchProductInfo = function(productId, typeOfProduct)
	local productInfo = MarketplaceService:GetProductInfo(productId, typeOfProduct)
	return productInfo
end
local generateReturnObject = TS.async(function(plr, MainId, purchased, typeBought, gamepassInfo)
	return {
		typeBought = typeBought,
		plr = plr.Name,
		userId = plr.UserId,
		inGroup = checkInParentGroup(plr, gamepassInfo.Creator.CreatorTargetId, gamepassInfo.Creator.CreatorType),
		privateServer = game.PrivateServerId == "" and true or false,
		CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr)),
		product_id = MainId,
		product_name = gamepassInfo.Name,
		product_price = gamepassInfo.PriceInRobux,
		purchased = purchased,
		gameId = game.GameId,
		gameName = gameName,
		gameGenre = GameMainGenre,
		UUID = HttpService:GenerateGUID(false),
	}
end)
local SalesHook = TS.async(function()
	-- Gamepass Purchase or prompt failed
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(TS.async(function(plr, gamepassID, purchased)
		-- get the gamepass Info
		local gamepassInfo = fetchProductInfo(gamepassID, Enum.InfoType.GamePass)
		-- Generate return object
		mainLogger("/handle_purchase", TS.await(generateReturnObject(plr, gamepassID, purchased, "GamePass", gamepassInfo)))
	end))
	MarketplaceService.PromptPurchaseFinished:Connect(TS.async(function(plr, productId, purchased)
		-- get the product Info
		local productInfo = fetchProductInfo(productId, Enum.InfoType.Product)
		-- Generate return object
		mainLogger("/handle_purchase", TS.await(generateReturnObject(plr, productId, purchased, "Product", productInfo)))
	end))
end)
local _ = MarketplaceService
return {
	SalesHook = SalesHook,
}
