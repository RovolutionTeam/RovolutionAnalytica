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
local _serverSession = TS.import(script, script, "events", "serverSession")
local cleanUpServer = _serverSession.cleanUpServer
local getAverageHeartbeat = _serverSession.getAverageHeartbeat
local getAveragePlayers = _serverSession.getAveragePlayers
local StartUptime = _serverSession.StartUptime
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
	-- Server session handler
	StartUptime()
	game:BindToClose(function()
		cleanUpServer()
		mainLogger("/unregister_server", {
			gameId = gameId,
		})
	end)
	-- Real time data stuff
	while true do
		local tps = TS.await(getServerVitals())
		local _ptr = {
			players = #Players:GetPlayers(),
			serverSpeed = tps,
			physicsSpeed = Workspace:GetRealPhysicsFPS(),
			uptime = os.time() - startTime,
			gameId = gameId,
		}
		local _left = "premiumPlayers"
		local _exp = Players:GetPlayers()
		local _arg0 = function(p)
			return p.MembershipType == Enum.MembershipType.Premium
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in ipairs(_exp) do
			if _arg0(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		_ptr[_left] = #_newValue
		local _left_1 = "privateServer"
		local _result
		if game.PrivateServerId == "" then
			_result = false
		else
			_result = true
		end
		_ptr[_left_1] = _result
		_ptr.avgPlayers = getAveragePlayers()
		_ptr.avgHeartbeat = getAverageHeartbeat()
		mainLogger("/register_server", _ptr)
		wait(60 * 2)
	end
end)
return {
	default = RovolutionAnalytica,
}
