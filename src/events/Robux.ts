// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

// This handles all robux transiations --

import { MarketplaceService } from "@rbxts/services";
import { mainLogger } from "utils/logger";
import { checkInParentGroup } from "utils/InParentGroup";


let fetchProductInfo = (productId: number, typeOfProduct:Enum.InfoType) => {
    let productInfo = MarketplaceService.GetProductInfo(productId, typeOfProduct);

    return productInfo
}

export function SalesHook() {
    
    // Gamepass Purchase or prompt failed
    MarketplaceService.PromptGamePassPurchaseFinished.Connect((plr:Player, gamepassID:number, purchased:boolean) => {
        // get the gamepass Info
        let gamepassInfo = fetchProductInfo(gamepassID, Enum.InfoType.GamePass);

        let object = {
            plr: plr.Name,
            userId: plr.UserId,
            inGroup: checkInParentGroup(plr, gamepassInfo.Creator.CreatorTargetId, gamepassInfo.Creator.CreatorType),
            gamepass_id: gamepassID,
            gamepass_name: gamepassInfo.Name,
            gamepass_price: gamepassInfo.PriceInRobux,
            purchased,
        }

        mainLogger("/handle_gamepass", object)
    })

    MarketplaceService.PromptPurchaseFinished.Connect((plr:Player, productId:number, purchased:boolean) => {
        // get the product Info
        let productInfo = fetchProductInfo(productId, Enum.InfoType.Product);

        let object = {
            plr: plr.Name,
            userId: plr.UserId,
            inGroup: checkInParentGroup(plr, productInfo.Creator.CreatorTargetId, productInfo.Creator.CreatorType),
            product_id: productId,
            product_name: productInfo.Name,
            product_price: productInfo.PriceInRobux,
            purchased,
        }

        mainLogger("/handle_product", object)
    })

}
MarketplaceService