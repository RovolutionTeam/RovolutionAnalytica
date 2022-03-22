import { HttpService, LocalizationService, MarketplaceService, SocialService } from '@rbxts/services';
import { genre } from 'utils/genreFinder';
import { checkInParentGroup } from 'utils/InParentGroup';
import { mainLogger } from 'utils/logger';
import { getUserSessionDuration } from 'utils/sessionDuration';

let gameName = MarketplaceService.GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name;
const ownerType = game.CreatorType === Enum.CreatorType.User ? 'User' : 'Group';

export async function gameInvites() {
    SocialService.GameInvitePromptClosed.Connect(async (plr: Player, invited: number[]) => {
        mainLogger('/game_invites', {
            currentSession: getUserSessionDuration(plr),
            plr: plr.Name,
            userId: plr.UserId,
            invited,
            UUID: HttpService.GenerateGUID(false),
            privateServer: game.PrivateServerId === '' ? false : true,
            gameId: game.GameId,
            gameName,
            gameGenre: genre(),
            CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
            inGroup: checkInParentGroup(plr, game.CreatorId, ownerType),
        });
    });
}
