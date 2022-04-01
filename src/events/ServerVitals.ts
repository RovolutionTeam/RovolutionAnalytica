// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

import { HttpService, LocalizationService, Players, ReplicatedStorage, RunService, StarterPlayer, Stats, Workspace } from '@rbxts/services';
import { RL_LOG } from 'utils/consoleLogging';
import { incrementFriends } from 'utils/friends';
import { visits, playing, favourties, genre, likes, dislikes } from 'utils/genreFinder';
import { mainLogger } from 'utils/logger';

// lets make a cache to stop users spamming
let cache: {
    [key: string]: number;
} = {};

// Handle total visits
let visitObject: {
    [key: string]: number;
} = {
    PC: 0,
    Mobile: 0,
    Console: 0,
};

export const getServerVitals = () => {
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

    return prom();
};

export async function serverVitalsHook(gameId: string) {
    // Ok we will now add a client side script to give us more indepth info

    // also create folder for all the remote events
    let mainFolder = new Instance('Folder', ReplicatedStorage);
    mainFolder.Name = 'RovolutionAnalytica';

    // first create a remote event
    let remoteEvent = new Instance('RemoteEvent', mainFolder);
    remoteEvent.Name = 'ROVOLUTION_ANAYLTICA_CLIENT_DATA';

    let DeviceType = new Instance('RemoteEvent', mainFolder);
    DeviceType.Name = 'ROVOLUTION_ANAYLTICA_DEVICE_DATA';

    let UpdateFriendsJoined = new Instance('RemoteEvent', mainFolder);
    UpdateFriendsJoined.Name = 'ROVOLUTION_ANAYLTICA_FRIEND_DATA';

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
                gameId: gameId,
            });
        } else {
            // We are in the cache
            RL_LOG('Potential user spamming API, ' + plr.Name + ' is in the prefetch cache!');
            return;
        }
    });

    UpdateFriendsJoined.OnServerEvent.Connect(async (plr: Player) => {
        incrementFriends(plr);
    });

    DeviceType.OnServerEvent.Connect(async (plr: Player, data: any) => {
        if (typeIs(data, 'string')) {
            visitObject[data] = visitObject[data] + 1;

            // Now add that to the player
            let deviceType = new Instance('StringValue', plr.FindFirstChild('RovolutionAnalytica'));
            deviceType.Name = 'ROVOLUTION_DEVICE_TYPE';
            deviceType.Value = data;
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
    let RemoteFunction = new Instance('RemoteFunction', mainFolder);
    RemoteFunction.Name = 'ROVOLUTION_ANAYLTICA_PING_TEST';

    RemoteFunction.OnServerInvoke = async () => {
        return os.clock();
    };

    // self running function to create a simple thread
    (async () => {
        wait(60); // Wait 60 seconds to calm down
        while (true) {
            let heartBeat = await getServerVitals();

            mainLogger('/server_vitals', {
                heartBeat,
                playerCount: Players.GetPlayers().size(),
                physicsSpeed: Workspace.GetRealPhysicsFPS(),
                UUID: HttpService.GenerateGUID(false),
                primitivesCount: Stats.PrimitivesCount,
                dataSent: Stats.DataSendKbps,
                dataReceived: Stats.DataReceiveKbps,
                movingPrimatives: Stats.MovingPrimitivesCount,
                ContactsCount: Stats.ContactsCount,
                ...visitObject,
                visits: visits(),
                playing: playing(),
                favourties: favourties(),
                genre: genre(),
                gameId,
                likes: likes(),
                dislikes: dislikes(),
            });
            wait(60 * 5); // Every 5 mins update heartbeat
        }
    })();
}
