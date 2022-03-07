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
import { serverVitalsHook } from 'events/ServerVitals';

export default function RovolutionAnalytica(projectID: string, apiKey: string) {
    RL_LOG('RovolutionAnalytica is starting up.');

    // First setup globals
    setupGlobals(projectID, apiKey);

    // Call all listening hooks

    SalesHook();
    PlayerJoinHook();
    serverVitalsHook();
}
