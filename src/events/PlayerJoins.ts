// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

import { HttpService, LocalizationService, MarketplaceService, Players } from '@rbxts/services';
import { fetchDeviceType } from 'utils/deviceType';
import { fetchFriendsValue } from 'utils/friends';
import { genre as GameMainGenre } from 'utils/genreFinder';
import { checkInParentGroup } from 'utils/InParentGroup';
import { mainLogger } from 'utils/logger';
import { addPlayer, checkPlayerJoinedBefore, cleanUpPlayerJoined } from 'utils/NewVsReturning';
import { getUserSessionDuration } from 'utils/sessionDuration';

// This handles players joining and leaving --

let gameName = MarketplaceService.GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name;

const ownerType = game.CreatorType === Enum.CreatorType.User ? 'User' : 'Group';

export async function PlayerJoinHook() {
    // Ok we want to track session length
    let handlePlayerJoin = (plr: Player) => {
        // Create Data Folder
        let dataFolder = new Instance('Folder', plr);
        dataFolder.Name = 'RovolutionAnalytica';

        // Create a timestamp element
        let timestamp = new Instance('NumberValue', dataFolder);
        timestamp.Name = 'Rovolution_Analytica_Timestamp';
        timestamp.Value = os.time();

        let friendsJoined = new Instance('NumberValue', dataFolder);
        friendsJoined.Name = 'Rovolution_Analytica_FriendsJoined';
        friendsJoined.Value = 0;

        // Check if first time in game
        addPlayer(plr);
    };

    // Lets also record all players are in the game when we start up
    Players.GetPlayers().forEach(async (plr: Player) => {
        handlePlayerJoin(plr);
    });

    Players.PlayerAdded.Connect(async (plr: Player) => {
        handlePlayerJoin(plr);
    });

    Players.PlayerRemoving.Connect(async (plr: Player) => {
        let joinData = plr.GetJoinData();
        let data: {
            [key: string]: any;
        } = {
            plr: plr.Name,
            userId: plr.UserId,
            sessionDuration: getUserSessionDuration(plr),
            inGroup: checkInParentGroup(plr, game.CreatorId, ownerType),
            CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
            gameId: game.GameId,
            privateServer: game.PrivateServerId === '' ? false : true,
            gameGenre: GameMainGenre(),
            gameName,
            deviceType: fetchDeviceType(plr),
            UUID: HttpService.GenerateGUID(false),
            accountAge: plr.AccountAge, // This is not to do with real irl age
            friendsJoined: fetchFriendsValue(plr),
            firstTime: checkPlayerJoinedBefore(plr),
            premiumPlayer: plr.MembershipType === Enum.MembershipType.Premium,
        };

        if (joinData !== undefined && joinData.SourcePlaceId !== undefined) {
            let lookupGame = MarketplaceService.GetProductInfo(joinData.SourcePlaceId, Enum.InfoType.Asset);
            data = {
                ...data,
                teleported: true,
                joinedGame: lookupGame.AssetId,
                joinedGameName: lookupGame.Name,
            };
        } else {
            data = {
                ...data,
                teleported: false,
            };
        }

        mainLogger('/handle_leave', data);

        cleanUpPlayerJoined(plr);
    });
}
