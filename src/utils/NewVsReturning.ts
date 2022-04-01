import DataStore2, { Combine } from '@rbxts/datastore2';
import { RunService } from '@rbxts/services';

Combine('DATA', 'RovolutionAnalytica_Player_Joining_Data');

// Player Cache
let cache: {
    [key: string]: boolean;
} = {};

export function addPlayer(plr: Player) {
    let playerStore = DataStore2<boolean>('RovolutionAnalytica_Player_Joining_Data', plr);
    cache[plr.UserId] = playerStore.Get(true);

    // We don't actually care what the value is, the fact we are here means its true
    playerStore.Set(false);
}

export function checkPlayerJoinedBefore(plr: Player): boolean | undefined {
    let val = cache[plr.UserId];
    return val;
}
export function cleanUpPlayerJoined(plr: Player) {
    delete cache[plr.UserId];
}
