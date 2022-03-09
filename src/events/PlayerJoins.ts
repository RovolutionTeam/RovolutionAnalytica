// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

import { HttpService, LocalizationService, Players } from '@rbxts/services';
import { RL_LOG } from 'utils/consoleLogging';
import { checkInParentGroup } from 'utils/InParentGroup';
import { mainLogger } from 'utils/logger';

// This handles players joining and leaving --

const ownerType = game.CreatorType === Enum.CreatorType.User ? 'User' : 'Group';

export async function PlayerJoinHook() {
    // Ok we want to track session length

    // Lets also record all players are in the game when we start up
    Players.GetPlayers().forEach(async (plr: Player) => {
        // Create a timestamp element
        let timestamp = new Instance('NumberValue');
        timestamp.Name = 'Rovolution_Analytica_Timestamp';
        timestamp.Value = os.time();
        timestamp.Parent = plr;
    });

    Players.PlayerAdded.Connect(async (plr: Player) => {
        // Create a timestamp element
        let timestamp = new Instance('NumberValue');
        timestamp.Name = 'Rovolution_Analytica_Timestamp';
        timestamp.Value = os.time();
        timestamp.Parent = plr;
    });

    Players.PlayerRemoving.Connect(async (plr: Player) => {
        // Get the timestamp
        let timestamp = plr.FindFirstChild('Rovolution_Analytica_Timestamp');

        // Verify it is the right type
        if (timestamp && timestamp.IsA('NumberValue')) {
            // Get the timestamp value
            let timestampValue = timestamp.Value;
            mainLogger('/handle_leave', {
                plr: plr.Name,
                userId: plr.UserId,
                sessionDuration: os.time() - timestampValue,
                inGroup: checkInParentGroup(plr, game.CreatorId, ownerType),
                CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
                gameId: game.GameId,
                privateServer: game.PrivateServerId === '' ? true : false,
                gameGenre: game.Genre.Name,
                gameName: game.Name,
                UUID: HttpService.GenerateGUID(false),
            });
        } else {
            RL_LOG('Could not find Rovolution_Analytica_Timestamp');
        }
    });
}
