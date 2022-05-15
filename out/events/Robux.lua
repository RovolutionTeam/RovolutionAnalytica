-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
-- This handles all robux transiations --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local MarketplaceService = _services.MarketplaceService
local Players = _services.Players
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local GameMainGenre = TS.import(script, script.Parent.Parent, "utils", "genreFinder").genre
local getUserSessionDuration = TS.import(script, script.Parent.Parent, "utils", "sessionDuration").getUserSessionDuration
local checkPlayerJoinedBefore = TS.import(script, script.Parent.Parent, "utils", "NewVsReturning").checkPlayerJoinedBefore
local gameName = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
local fetchProductInfo = function(productId, typeOfProduct)
	local productInfo = MarketplaceService:GetProductInfo(productId, typeOfProduct)
	return productInfo
end
local generateReturnObject = TS.async(function(plr, MainId, purchased, typeBought, gamepassInfo)
	local _ptr = {
		typeBought = typeBought,
		plr = plr.Name,
		userId = plr.UserId,
		inGroup = checkInParentGroup(plr, gamepassInfo.Creator.CreatorTargetId, gamepassInfo.Creator.CreatorType),
	}
	local _left = "privateServer"
	local _result
	if game.PrivateServerId == "" then
		_result = false
	else
		_result = true
	end
	_ptr[_left] = _result
	_ptr.CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr))
	_ptr.product_id = MainId
	_ptr.product_name = gamepassInfo.Name
	_ptr.product_price = gamepassInfo.PriceInRobux
	_ptr.purchased = purchased
	_ptr.gameId = game.GameId
	_ptr.gameName = gameName
	_ptr.gameGenre = GameMainGenre()
	_ptr.UUID = HttpService:GenerateGUID(false)
	_ptr.firstTime = checkPlayerJoinedBefore(plr)
	_ptr.currentSession = getUserSessionDuration(plr)
	_ptr.premiumPlayer = plr.MembershipType == Enum.MembershipType.Premium
	return _ptr
end)
local SalesHook = TS.async(function()
	-- Gamepass Purchase or prompt failed
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(TS.async(function(plr, gamepassID, purchased)
		-- get the gamepass Info
		local gamepassInfo = fetchProductInfo(gamepassID, Enum.InfoType.GamePass)
		-- Generate return object
		mainLogger("/handle_purchase", TS.await(generateReturnObject(plr, gamepassID, purchased, "GamePass", gamepassInfo)))
	end))
	-- Yes its deprecated but it is the only way to detect when a product is purchased or closed
	-- https://developer.roblox.com/en-us/api-reference/event/MarketplaceService/PromptProductPurchaseFinished
	MarketplaceService.PromptProductPurchaseFinished:Connect(TS.async(function(userId, productId, purchased)
		local plr = Players:GetPlayerByUserId(userId)
		if plr == nil then
			return nil
		end
		-- get the product Info
		local productInfo = fetchProductInfo(productId, Enum.InfoType.Product)
		-- Generate return object
		mainLogger("/handle_purchase", TS.await(generateReturnObject(plr, productId, purchased, "Product", productInfo)))
	end))
end)
return {
	SalesHook = SalesHook,
}
