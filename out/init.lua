-- Compiled with roblox-ts v1.2.3
local TS = require(script.include.RuntimeLib)
local _ = [[
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
                                                                            
]]
local PlayerJoinHook = TS.import(script, script, "events", "PlayerJoins").PlayerJoinHook
local SalesHook = TS.import(script, script, "events", "Robux").SalesHook
local serverVitalsHook = TS.import(script, script, "events", "ServerVitals").serverVitalsHook
-- RovolutionAnalytica is a library for reporting data to the RovolutionLogistcs API, for everything from visits to robux generated and much more. --
local setupGlobals = TS.import(script, script, "globals").setupGlobals
local function RovolutionAnalytica(projectID, apiKey)
	print("RovolutionAnalytica is starting up.")
	-- First setup globals
	setupGlobals(projectID, apiKey)
	-- Call all listening hooks
	SalesHook()
	PlayerJoinHook()
	serverVitalsHook()
	while true do
		wait(5)
		print("still here")
	end
end
return {
	default = RovolutionAnalytica,
}
