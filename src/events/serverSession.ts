import { Players, ReplicatedStorage } from '@rbxts/services';
import { mainLogger } from 'utils/logger';
import { getServerVitals } from './ServerVitals';

let plrJoinedArray: number[] = [];
let heartbeat: number[] = [];
let startTime = os.time();

export function cleanUpServer() {
    // Lazy fix so maths doesn't break
    let uptime = os.time() - startTime;

    mainLogger('/server_session', {
        privateServer: game.PrivateServerId === '' ? false : true,
        uptime,

        // :vomits: reduce, i guess it works :shrug:
        avgPlayers: plrJoinedArray.reduce((a, b) => a + b, 0) / plrJoinedArray.size(),
        avgHeartbeat: heartbeat.reduce((a, b) => a + b, 0) / heartbeat.size(),
    });
}

export function StartUptime() {
    // Look away please :EYES:
    (async () => {
        while (true) {
            plrJoinedArray.push(Players.GetPlayers().size());

            // cheeky as number, but it always will be
            heartbeat.push((await getServerVitals()) as number);
            // 20 sec cause Rovolution is #LightWeight #BlazinglyFast #CuttingEdge
            wait(20);
        }
    })();
}
