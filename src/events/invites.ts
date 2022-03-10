import { HttpService, LocalizationService, MarketplaceService, SocialService } from '@rbxts/services';
import { genre } from 'utils/genreFinder';
import { checkInParentGroup } from 'utils/InParentGroup';
import { mainLogger } from 'utils/logger';

let gameName = MarketplaceService.GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name;
const ownerType = game.CreatorType === Enum.CreatorType.User ? 'User' : 'Group';

export async function gameInvites() {
    SocialService.GameInvitePromptClosed.Connect(async (plr: Player, invited: number[]) => {
        let timestamp = plr.FindFirstChild('Rovolution_Analytica_Timestamp');

        // Verify it is the right type
        if (!(timestamp && timestamp.IsA('NumberValue'))) return;

        mainLogger('/game_invites', {
            currentSession: os.time() - timestamp.Value,
            plr: plr.Name,
            userId: plr.UserId,
            invited,
            UUID: HttpService.GenerateGUID(false),
            privateServer: game.PrivateServerId === '' ? true : false,
            gameId: game.GameId,
            gameName,
            gameGenre: genre,
            CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
            inGroup: checkInParentGroup(plr, game.CreatorId, ownerType),
        });
    });
}
