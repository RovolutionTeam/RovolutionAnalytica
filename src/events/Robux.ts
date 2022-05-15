// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

// This handles all robux transiations --

import { HttpService, LocalizationService, MarketplaceService, Players } from '@rbxts/services';
import { mainLogger } from 'utils/logger';
import { checkInParentGroup } from 'utils/InParentGroup';
import { genre as GameMainGenre } from 'utils/genreFinder';
import { getUserSessionDuration } from 'utils/sessionDuration';
import { checkPlayerJoinedBefore } from 'utils/NewVsReturning';

let gameName = MarketplaceService.GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name;

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
        privateServer: game.PrivateServerId === '' ? false : true,
        CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
        product_id: MainId,
        product_name: gamepassInfo.Name,
        product_price: gamepassInfo.PriceInRobux,
        purchased,
        gameId: game.GameId,
        gameName,
        gameGenre: GameMainGenre(),
        UUID: HttpService.GenerateGUID(false),
        firstTime: checkPlayerJoinedBefore(plr),
        currentSession: getUserSessionDuration(plr),
        premiumPlayer: plr.MembershipType === Enum.MembershipType.Premium,
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

    // Yes its deprecated but it is the only way to detect when a product is purchased or closed
    // https://developer.roblox.com/en-us/api-reference/event/MarketplaceService/PromptProductPurchaseFinished
    MarketplaceService.PromptProductPurchaseFinished.Connect(async (userId: number, productId: number, purchased: boolean) => {
        let plr = Players.GetPlayerByUserId(userId);

        if (plr === undefined) return;

        // get the product Info
        let productInfo = fetchProductInfo(productId, Enum.InfoType.Product);

        // Generate return object
        mainLogger('/handle_purchase', await generateReturnObject(plr, productId, purchased, 'Product', productInfo));
    });
}
