import { LocalizationService, Players } from '@rbxts/services';
import { fetchDeviceType } from 'utils/deviceType';
import { mainLogger } from 'utils/logger';

interface PlayerLocation {
    name: string;
    id: number;
    countryCode: string;
    position: string;
    premium: boolean;
    deviceType: string;
}

function roundTo2DP(num: number) {
    return math.round(num * 100) / 100;
}

// Called from while loop so no loop needed here
export function playerLocation(gameId: string) {
    // Final note from gerald I WANT MINI_MAPS AAHAHHHAHH, i know many requests but u gotta do what u gotta do

    // First fetch players
    let players = Players.GetPlayers();

    // lets map it to the what the server is expecting
    let playerArray: PlayerLocation[] = players.map((e) => {
        let Torso = e.Character?.FindFirstChild('Torso');

        let pos = new Vector3(0, 0, 0); // Fall back if we have no idea where u are

        if (Torso && Torso.IsA('BasePart')) {
            let tempPos = Torso.Position;
            // Round cause RovolutionAnalytica will reject if not
            pos = new Vector3(roundTo2DP(tempPos.X), roundTo2DP(tempPos.Y), roundTo2DP(tempPos.Z));
        }

        return {
            name: e.Name,
            id: e.UserId,
            countryCode: LocalizationService.GetCountryRegionForPlayerAsync(e),
            // Stringified cause the DB wants thats
            position: `${pos.X},${pos.Y},${pos.Z}`,
            premium: e.MembershipType === Enum.MembershipType.Premium,
            deviceType: fetchDeviceType(e),
        };
    });

    mainLogger('/live_players', {
        players: playerArray,
        privateServer: game.PrivateServerId === '' ? false : true,
        gameId,
    });
}
