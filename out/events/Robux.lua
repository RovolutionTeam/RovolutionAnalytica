-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
-- This handles all robux transiations --
local MarketplaceService = TS.import(script, TS.getModule(script, "@rbxts", "services")).MarketplaceService
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local checkInParentGroup = TS.import(script, script.Parent.Parent, "utils", "InParentGroup").checkInParentGroup
local fetchProductInfo = function(productId, typeOfProduct)
	local productInfo = MarketplaceService:GetProductInfo(productId, typeOfProduct)
	return productInfo
end
local function SalesHook()
	-- Gamepass Purchase or prompt failed
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(plr, gamepassID, purchased)
		-- get the gamepass Info
		local gamepassInfo = fetchProductInfo(gamepassID, Enum.InfoType.GamePass)
		local object = {
			plr = plr.Name,
			userId = plr.UserId,
			inGroup = checkInParentGroup(plr, gamepassInfo.Creator.CreatorTargetId, gamepassInfo.Creator.CreatorType),
			gamepass_id = gamepassID,
			gamepass_name = gamepassInfo.Name,
			gamepass_price = gamepassInfo.PriceInRobux,
			purchased = purchased,
		}
		mainLogger("/handle_gamepass", object)
	end)
	MarketplaceService.PromptPurchaseFinished:Connect(function(plr, productId, purchased)
		-- get the product Info
		local productInfo = fetchProductInfo(productId, Enum.InfoType.Product)
		local object = {
			plr = plr.Name,
			userId = plr.UserId,
			inGroup = checkInParentGroup(plr, productInfo.Creator.CreatorTargetId, productInfo.Creator.CreatorType),
			product_id = productId,
			product_name = productInfo.Name,
			product_price = productInfo.PriceInRobux,
			purchased = purchased,
		}
		mainLogger("/handle_product", object)
	end)
end
local _ = MarketplaceService
return {
	SalesHook = SalesHook,
}
