`
                                                            ,(@@&*.....,,**/(@@#                                                                     
                                                        *(.  #   /           /   #    /(/.                                                            
                                                  .**.    .*     .,        .,      *.         ,//&@&,                                                 
                                             ,**.       ,*        *.      /          ,*         .**,*                                                 
                                         *@@&.        *,           (    ,,              /.    ./      *,                                              
                                        ,*       /(&@/              /  (                  *#&/          .(                                            
                                       *       .*, *#.     .*///*,..&@#....,**/////*,.     &&/*/,.        ./.                                         
                                     .*   ,**       ,.              (*/,                 .*  *      .***,    ,,                                       
                                   ,#//,            .*            *.    ,*              ,,    (            ..*/*##,                                   
                                   #@@.              /           /         /           (       /               ,@@/                                   
                                     /../.            /        *,            /.      .,        .*           ,*  /*.                                   
                                      ,,  .*,         (       *.               ,,   /.          .,       *,    *..*                                   
                                       ,,    .*.       *    ,*                   /&@,            .*   /.      ./  /                                   
                                         /       /.    *   *.              ,((,   #/        .*/((%@@(         *   .,                                  
                                         #@@/..     *. ,,./     ..,*/,           ( .*            /  ./       ,,   ./                                  
                                                  .,,,*@@&**,.                 .*   ,,         .,      ,,    *  *.                                    
                                                        .**.,/,                *     ,.       /          .*,(/*                                       
                                                           *.     *(.         (       ,     ,,           *#@@%                                        
                                                             /.        ./*../#        .*  ./     ..**.    *.                                          
                                                                           *&%/,,,,,,. /(/,***,          /                                            
                                                                               ,,      #@%,..,*//*,.   ,,                                             
                                                                                 ./      *                                                            
                                                                                   ./    ,.                                                           
                                                                                      *.  *                                                           
                                                                                        ,,.*                                                          
                                                                                         *@@%.                                                        

                                                                          ,,                                                                          
                    .@&(///#&&*                                          ,@%.                /@/     .(/                                              
                    ,@%.    ,%@.    ,#%&&%(   .##.     .##.   /%&&%#*    ,@%.  ,#/     *#*  (&@&%%%* .#(     /%%&%%*    .##,(%&&%*                    
                    ,@%.    #@*   .%%.    *&#  .%%.    %%.  /@(     #&,  ,@%.  *&(     /@/   /&/     .&%   /@#     #&*  ,&&,    *@(                   
                    ,@&%%%&@/     (@/     .%@,  .%&. .%%.  .&&,     ,&#  ,@%.  *&(     /&/   /@/     .&%  .%@,     ,&#  ,&&.    ,@#                   
                    ,@%.   .%&/   *@(     ,&&.   .&&,%&.    %&*     /@(  ,@%.  *&(     /&/   /@/     .&%.  #@*     /@(  ,&&.    ,@#                   
                    ,@%.     .%@(  ,%&%((%@(      .%@%.      /&&#(#&&*   ,@%.   #@&%%%&&&/   .&@%#%/ .&%    /&&#(#&&*   ,&&.    ,@#                   


                               (@@%.                                 #@.               .#(      %@/                                                   
                              (&/*@#           **,       .,**,.      #@,             ./#&@%((.           .**,      .***,                              
                             /@/  /@(     /@&#.  *&&,   ,.    *&%.   #@,  /@(     #&,  ,@#     .#@*   /@%.   ,#  .,    .%@*                           
                            *&(    (@(    /&(     (@/    ,/#%&@@@,   #@,   *&(  .%&,   .@#.     #@*  *@(          .*(%&@@@(                           
                           *&%((((((%@/   /&(     (@*  (@/     %@,   #@,    *&#,%&.    .@#.     #@,  /@(        ,&%.    *@(                           
                          *@#.       #&*  /&(     (@/  /@#.  ,#@@,   #@,     *@@%.     .%&*     #@*   /&%,   /#.,%&*  ./&@(                           
                                                          ,,.                .&%.                         ..       .,.                                
                                                                            ,&%.    
                                                                            
`;

// RovolutionAnalytica is a library for reporting data to the RovolutionLogistcs API, for everything from visits to robux generated and much more. --

import { setupGlobals } from 'globals';
import { RL_LOG } from 'utils/consoleLogging';
import { PlayerJoinHook } from 'events/PlayerJoins';
import { SalesHook } from 'events/Robux';
import { getServerVitals, serverVitalsHook } from 'events/ServerVitals';
import { mainLogger } from 'utils/logger';
import { HttpService, Players, Workspace } from '@rbxts/services';
import { getGameGenre } from 'utils/genreFinder';
import { cleanUpServer, getAverageHeartbeat, getAveragePlayers, StartUptime } from 'events/serverSession';
import { playerLocation } from 'events/livePlayerLocation';

const startTime = os.time();
const gameId = HttpService.GenerateGUID(false);

export default async function RovolutionAnalytica(projectID: string, apiKey: string) {
    RL_LOG('RovolutionAnalytica is starting up.');

    // First setup globals
    setupGlobals(projectID, apiKey);
    getGameGenre();

    // Call all listening hooks

    SalesHook();
    PlayerJoinHook();
    serverVitalsHook(gameId);

    // Server session handler
    StartUptime();

    // So this will probably fail cause like its capped to 3mins and if server is down etc,
    // but dw RovolutionLogistics serverless function clean up the server if needed
    game.BindToClose(() => {
        // Sends server session data
        cleanUpServer();

        // No strictly necessary cause serverless functions but makes stats more realtime
        mainLogger('/unregister_server', {
            gameId,
        });
    });

    // Real time data stuff
    while (true) {
        let tps = await getServerVitals();
        mainLogger('/register_server', {
            players: Players.GetPlayers().size(),
            serverSpeed: tps,
            physicsSpeed: Workspace.GetRealPhysicsFPS(),
            uptime: os.time() - startTime,
            gameId,
            premiumPlayers: Players.GetPlayers()
                .filter((p) => p.MembershipType === Enum.MembershipType.Premium)
                .size(),
            privateServer: game.PrivateServerId === '' ? false : true,
            avgPlayers: getAveragePlayers(),
            avgHeartbeat: getAverageHeartbeat(),
        });

        playerLocation(gameId);

        wait(60 * 2); // DB wipes every 3 mins so update every 2 mins
    }
}
