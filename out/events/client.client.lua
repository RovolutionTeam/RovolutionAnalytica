-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
--[[
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
                                                                            
]]--


-- Standard globals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Analytica = ReplicatedStorage:WaitForChild("RovolutionAnalytica")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Me = Players.LocalPlayer


script.Name = "ROVOLUTION_ANAYLTICA_CLIENT_DATA"
local API = Analytica:WaitForChild("ROVOLUTION_ANAYLTICA_CLIENT_DATA")
local ping = Analytica:WaitForChild("ROVOLUTION_ANAYLTICA_PING_TEST")
local deviceType = Analytica:WaitForChild("ROVOLUTION_ANAYLTICA_DEVICE_DATA")
local friendData = Analytica:WaitForChild("ROVOLUTION_ANAYLTICA_FRIEND_DATA")

function roundTo2DP(value)
	value *= 100
	value = math.floor(value)
	value = value / 100
	return value
end

-- We want average FPS and average ping
local pingAverage = 0
local fpsAverage = 0
local checks = 0

Players.PlayerAdded:Connect(function(player)
	if Me:IsFriendsWith(player.UserId) then
		friendData:FireServer()
	end
end)

-- Device Type
function getEnabled()
	return {
		["Keyboard"] = UserInputService.KeyboardEnabled;
		["Gamepad"] = UserInputService.GamepadEnabled;
		["Touch"] = UserInputService.TouchEnabled;
	};
end

function getPlatform()
	local res = getEnabled();

	local isMobile = res.Touch and not res.Gamepad and not res.Keyboard
	local isConsole = res.Gamepad and not res.Touch and not res	.Keyboard

	if isMobile then
		return "Mobile"
	elseif isConsole then
		return "Console"
	else
		return "PC"
	end
end

deviceType:FireServer(getPlatform())



-- Runs once every 6 mins so not very draining, pretty light weight

if not RunService:IsStudio() then
  warn("This game uses the RovolutionAnalytica service, to provide analytics, by playing this game you are agreeing to the privacy policy accessable at https://logistics.rovolution.me/privacy-policy")
end
-- Also no memory leaks thanks to yours truley -- Gerald



while true do
	if API and API:IsA("RemoteEvent") and ping and ping:IsA("RemoteFunction") then
		-- fetch data
		local startTime = os.clock()
		local _ = ping:InvokeServer()
		local totalPing = os.clock() - startTime
		local fps = Workspace:GetRealPhysicsFPS()

    -- Insert into Table
    local averagePing = ((pingAverage * checks) + totalPing) / (checks + 1)
    local averageFPS = ((fpsAverage * checks) + fps) / (checks + 1)

    -- Save averages and increments the total checks
    local checks = checks + 1
    local pingAverage = averagePing
    local fpsAverage = averageFPS


    -- Tell server our data
		API:FireServer({
			ping = roundTo2DP(pingAverage),
			fps = roundTo2DP(fpsAverage),
		})
	end

  -- Lets just wait a bit
	wait(60 * 6)
end
