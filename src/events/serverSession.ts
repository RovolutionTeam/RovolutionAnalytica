import { Players, ReplicatedStorage, Workspace } from '@rbxts/services';
import { mainLogger } from 'utils/logger';
import { getServerVitals } from './ServerVitals';

let plrJoinedArray: number[] = [];
let premiumJoinedArray: number[] = [];
let heartbeat: number[] = [];
let startTime = os.time();

export function cleanUpServer() {
    // Lazy fix so maths doesn't break
    let uptime = os.time() - startTime;

    mainLogger('/server_session', {
        privateServer: game.PrivateServerId === '' ? false : true,
        uptime,
        physicsSpeed: Workspace.GetRealPhysicsFPS(),

        // :vomits: reduce, i guess it works :shrug:
        avgPlayers: plrJoinedArray.reduce((a, b) => a + b, 0) / plrJoinedArray.size(),
        avgPremiumPlayers: premiumJoinedArray.reduce((a, b) => a + b, 0) / premiumJoinedArray.size(),
        avgHeartbeat: heartbeat.reduce((a, b) => a + b, 0) / heartbeat.size(),
    });
}

export function getAveragePlayers() {
    // :VOMIT: Reduce, its like art respect the Process
    return plrJoinedArray.reduce((a, b) => a + b, 0) / plrJoinedArray.size();
}
export function getAverageHeartbeat() {
    // Same here EWWWWW
    return heartbeat.reduce((a, b) => a + b, 0) / heartbeat.size();
}

export function StartUptime() {
    // Look away please :EYES:

    // Async self calling function cause it doesn't block main thread :)
    (async () => {
        // I know while true loop, but it super slow
        while (true) {
            plrJoinedArray.push(Players.GetPlayers().size());
            premiumJoinedArray.push(
                Players.GetPlayers()
                    .filter((p) => p.MembershipType === Enum.MembershipType.Premium)
                    .size(),
            );

            // cheeky as number, but it always will be
            heartbeat.push((await getServerVitals()) as number);
            // 120 sec cause Rovolution is #LightWeight #BlazinglyFast #CuttingEdge

            wait(120);
        }
    })();
}
