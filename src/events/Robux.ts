// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

// This handles all robux transiations --

import { HttpService, LocalizationService, MarketplaceService } from '@rbxts/services';
import { mainLogger } from 'utils/logger';
import { checkInParentGroup } from 'utils/InParentGroup';

let fetchProductInfo = (productId: number, typeOfProduct: Enum.InfoType) => {
    let productInfo = MarketplaceService.GetProductInfo(productId, typeOfProduct);

    return productInfo;
};

let generateReturnObject = async (
    plr: Player,
    MainId: number,
    purchased: boolean,
    typeBought: string,
    gamepassInfo: AssetProductInfo | DeveloperProductInfo,
) => {
    return {
        typeBought: typeBought,
        plr: plr.Name,
        userId: plr.UserId,
        inGroup: checkInParentGroup(plr, gamepassInfo.Creator.CreatorTargetId, gamepassInfo.Creator.CreatorType),
        privateServer: game.PrivateServerId === '' ? true : false,
        CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
        product_id: MainId,
        product_name: gamepassInfo.Name,
        product_price: gamepassInfo.PriceInRobux,
        purchased,
        gameId: game.GameId,
        gameName: game.Name,
        gameGenre: game.Genre.Name,
        UUID: HttpService.GenerateGUID(false),
    };
};

export async function SalesHook() {
    // Gamepass Purchase or prompt failed
    MarketplaceService.PromptGamePassPurchaseFinished.Connect(async (plr: Player, gamepassID: number, purchased: boolean) => {
        // get the gamepass Info
        let gamepassInfo = fetchProductInfo(gamepassID, Enum.InfoType.GamePass);

        // Generate return object
        mainLogger('/handle_purchase', await generateReturnObject(plr, gamepassID, purchased, 'GamePass', gamepassInfo));
    });

    MarketplaceService.PromptPurchaseFinished.Connect(async (plr: Player, productId: number, purchased: boolean) => {
        // get the product Info
        let productInfo = fetchProductInfo(productId, Enum.InfoType.Product);

        // Generate return object
        mainLogger('/handle_purchase', await generateReturnObject(plr, productId, purchased, 'Product', productInfo));
    });
}
MarketplaceService;
