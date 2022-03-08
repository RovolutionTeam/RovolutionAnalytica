-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local LocalizationService = _services.LocalizationService
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local RunService = _services.RunService
local StarterPlayer = _services.StarterPlayer
local Workspace = _services.Workspace
local RL_LOG = TS.import(script, script.Parent.Parent, "utils", "consoleLogging").RL_LOG
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
-- lets make a cache to stop users spamming
local cache = {}
local getServerVitals = function()
	local prom = function()
		local connection
		local count = 0
		local loopCount = 10
		return TS.Promise.new(function(resolve, reject)
			local startTimeStamp = os.clock()
			local function onHeartbeat(step)
				if count < loopCount then
					count = count + 1
				else
					local timeNow = os.clock()
					local timeDiff = timeNow - startTimeStamp
					local timePeriod = timeDiff / loopCount
					local frequency = 1 / timePeriod
					resolve(frequency)
					local _result = connection
					if _result ~= nil then
						_result:Disconnect()
					end
				end
			end
			connection = RunService.Heartbeat:Connect(onHeartbeat)
		end)
	end
	return prom()
end
local serverVitalsHook = TS.async(function(gameId)
	-- Ok we will now add a client side script to give us more indepth info
	-- first create a remote event
	local remoteEvent = Instance.new("RemoteEvent", ReplicatedStorage)
	remoteEvent.Name = "ROVOLUTION_ANAYLTICA_CLIENT_DATA"
	remoteEvent.OnServerEvent:Connect(TS.async(function(plr, data)
		-- Check in cache
		if cache[plr.UserId] == nil or cache[plr.UserId] + 5 * 60 < os.time() then
			-- Ok lets update the cache
			cache[plr.UserId] = os.time()
			-- Ik ik lazy but fixes it
			local newData = data
			-- Now log to server
			mainLogger("/client_data", {
				plr = plr.Name,
				userId = plr.UserId,
				FPS = newData.fps,
				ping = newData.ping,
				CountryCode = TS.await(LocalizationService:GetCountryRegionForPlayerAsync(plr)),
				gameId = gameId,
			})
		else
			-- We are in the cache
			RL_LOG("Potential user spamming API, " .. plr.Name .. " is in the prefetch cache!")
			return nil
		end
	end))
	local _client = script.Parent
	if _client ~= nil then
		_client = _client:FindFirstChild("client")
	end
	local client = _client
	if client then
		client.Parent = StarterPlayer:FindFirstChild("StarterPlayerScripts")
	end
	Players.PlayerRemoving:Connect(function(plr)
		-- Remove from cache, lets not get a memory overflow
		cache[plr.UserId] = nil
	end)
	-- first create a remote event
	local RemoteFunction = Instance.new("RemoteFunction", ReplicatedStorage)
	RemoteFunction.Name = "ROVOLUTION_ANAYLTICA_PING_TEST"
	RemoteFunction.OnServerInvoke = TS.async(function()
		return os.clock()
	end)
	-- self running function to create a simple thread
	TS.async(function()
		wait(60)
		while true do
			local heartBeat = TS.await(getServerVitals())
			mainLogger("/server_vitals", {
				heartBeat = heartBeat,
				playerCount = #Players:GetPlayers(),
				physicsSpeed = Workspace:GetRealPhysicsFPS(),
				UUID = HttpService:GenerateGUID(false),
			})
			wait(60 * 5)
		end
	end)()
end)
return {
	serverVitalsHook = serverVitalsHook,
	getServerVitals = getServerVitals,
}
