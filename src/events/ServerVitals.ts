// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

import { LocalizationService, Players, ReplicatedStorage, RunService, StarterPlayer } from '@rbxts/services';
import { RL_LOG } from 'utils/consoleLogging';
import { mainLogger } from 'utils/logger';

// lets make a cache to stop users spamming
let cache: {
    [key: string]: number;
} = {};

async function getServerVitals() {
    // Wrap in promise
    let prom = () => {
        let connection: RBXScriptConnection;
        let count = 0;
        let loopCount = 10; // Basically sample rate

        return new Promise((resolve, reject) => {
            let startTimeStamp = os.clock();
            function onHeartbeat(step: number) {
                if (count < loopCount) {
                    count = count + 1;
                } else {
                    let timeNow = os.clock();
                    let timeDiff = timeNow - startTimeStamp;
                    let timePeriod = timeDiff / loopCount;
                    let frequency = 1 / timePeriod;
                    resolve(frequency);
                    connection?.Disconnect();
                }
            }
            connection = RunService.Heartbeat.Connect(onHeartbeat);
        });
    };

    return await prom();
}

export async function serverVitalsHook() {
    // self running function to create a simple thread
    (async () => {
        wait(60); // Wait 60 seconds to calm down
        while (true) {
            let heartBeat = await getServerVitals();

            mainLogger('/server_vitals', {
                heartBeat,
                playerCount: Players.GetPlayers().size(),
            });
            wait(60 * 5); // Every 5 mins update heartbeat
        }
    })();
    // Ok we will now add a client side script to give us more indepth info

    // first create a remote event
    let remoteEvent = new Instance('RemoteEvent', ReplicatedStorage);
    remoteEvent.Name = 'ROVOLUTION_ANAYLTICA_CLIENT_DATA';

    remoteEvent.OnServerEvent.Connect(async (plr: Player, data: any) => {
        // Check in cache
        if (cache[plr.UserId] === undefined || cache[plr.UserId] + 5 * 60 < os.time()) {
            // Ok lets update the cache
            cache[plr.UserId] = os.time();

            // Ik ik lazy but fixes it
            let newData = data as {
                ping: number;
                fps: number;
            };

            // Now log to server
            mainLogger('/client_data', {
                plr: plr.Name,
                userId: plr.UserId,
                FPS: newData.fps,
                ping: newData.ping,
                CountryCode: await LocalizationService.GetCountryRegionForPlayerAsync(plr),
            });
        } else {
            // We are in the cache
            RL_LOG('Potential user spamming API, ' + plr.Name + ' is in the prefetch cache!');
            return;
        }
    });

    let client = script.Parent?.FindFirstChild('client');
    if (client) {
        client.Parent = StarterPlayer.FindFirstChild('StarterPlayerScripts');
    }

    Players.PlayerRemoving.Connect((plr: Player) => {
        // Remove from cache, lets not get a memory overflow
        delete cache[plr.UserId];
    });

    // first create a remote event
    let RemoteFunction = new Instance('RemoteFunction', ReplicatedStorage);
    RemoteFunction.Name = 'ROVOLUTION_ANAYLTICA_PING_TEST';

    RemoteFunction.OnServerInvoke = async () => {
        return os.clock();
    };
}
