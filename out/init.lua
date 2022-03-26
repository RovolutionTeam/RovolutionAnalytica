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
-- RovolutionAnalytica is a library for reporting data to the RovolutionLogistcs API, for everything from visits to robux generated and much more. --
local setupGlobals = TS.import(script, script, "globals").setupGlobals
local RL_LOG = TS.import(script, script, "utils", "consoleLogging").RL_LOG
local PlayerJoinHook = TS.import(script, script, "events", "PlayerJoins").PlayerJoinHook
local SalesHook = TS.import(script, script, "events", "Robux").SalesHook
local _ServerVitals = TS.import(script, script, "events", "ServerVitals")
local getServerVitals = _ServerVitals.getServerVitals
local serverVitalsHook = _ServerVitals.serverVitalsHook
local mainLogger = TS.import(script, script, "utils", "logger").mainLogger
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local Workspace = _services.Workspace
local getGameGenre = TS.import(script, script, "utils", "genreFinder").getGameGenre
local startTime = os.time()
local gameId = HttpService:GenerateGUID(false)
local RovolutionAnalytica = TS.async(function(projectID, apiKey)
	RL_LOG("RovolutionAnalytica is starting up.")
	-- First setup globals
	setupGlobals(projectID, apiKey)
	getGameGenre()
	-- Call all listening hooks
	SalesHook()
	PlayerJoinHook()
	serverVitalsHook(gameId)
	game:BindToClose(function()
		mainLogger("/unregister_server", {
			gameId = gameId,
		})
	end)
	-- Real time data stuff
	while true do
		local tps = TS.await(getServerVitals())
		mainLogger("/register_server", {
			players = #Players:GetPlayers(),
			serverSpeed = tps,
			physicsSpeed = Workspace:GetRealPhysicsFPS(),
			uptime = os.time() - startTime,
			gameId = gameId,
		})
		wait(60 * 2)
	end
end)
return {
	default = RovolutionAnalytica,
}
