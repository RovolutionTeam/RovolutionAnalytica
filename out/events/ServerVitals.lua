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
local Stats = _services.Stats
local Workspace = _services.Workspace
local RL_LOG = TS.import(script, script.Parent.Parent, "utils", "consoleLogging").RL_LOG
local incrementFriends = TS.import(script, script.Parent.Parent, "utils", "friends").incrementFriends
local _genreFinder = TS.import(script, script.Parent.Parent, "utils", "genreFinder")
local visits = _genreFinder.visits
local playing = _genreFinder.playing
local favourties = _genreFinder.favourties
local genre = _genreFinder.genre
local likes = _genreFinder.likes
local dislikes = _genreFinder.dislikes
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
-- lets make a cache to stop users spamming
local cache = {}
-- Handle total visits
local visitObject = {
	PC = 0,
	Mobile = 0,
	Console = 0,
}
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
	-- also create folder for all the remote events
	local mainFolder = Instance.new("Folder", ReplicatedStorage)
	mainFolder.Name = "RovolutionAnalytica"
	-- first create a remote event
	local remoteEvent = Instance.new("RemoteEvent", mainFolder)
	remoteEvent.Name = "ROVOLUTION_ANAYLTICA_CLIENT_DATA"
	local DeviceType = Instance.new("RemoteEvent", mainFolder)
	DeviceType.Name = "ROVOLUTION_ANAYLTICA_DEVICE_DATA"
	local UpdateFriendsJoined = Instance.new("RemoteEvent", mainFolder)
	UpdateFriendsJoined.Name = "ROVOLUTION_ANAYLTICA_FRIEND_DATA"
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
	UpdateFriendsJoined.OnServerEvent:Connect(TS.async(function(plr)
		incrementFriends(plr)
	end))
	DeviceType.OnServerEvent:Connect(TS.async(function(plr, data)
		if type(data) == "string" then
			visitObject[data] = visitObject[data] + 1
			-- Now add that to the player
			local deviceType = Instance.new("StringValue", plr:FindFirstChild("RovolutionAnalytica"))
			deviceType.Name = "ROVOLUTION_DEVICE_TYPE"
			deviceType.Value = data
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
	local RemoteFunction = Instance.new("RemoteFunction", mainFolder)
	RemoteFunction.Name = "ROVOLUTION_ANAYLTICA_PING_TEST"
	RemoteFunction.OnServerInvoke = TS.async(function()
		return os.clock()
	end)
	-- self running function to create a simple thread
	TS.async(function()
		wait(60)
		while true do
			local heartBeat = TS.await(getServerVitals())
			local _ptr = {
				heartBeat = heartBeat,
				playerCount = #Players:GetPlayers(),
				physicsSpeed = Workspace:GetRealPhysicsFPS(),
				UUID = HttpService:GenerateGUID(false),
				primitivesCount = Stats.PrimitivesCount,
				dataSent = Stats.DataSendKbps,
				dataReceived = Stats.DataReceiveKbps,
				movingPrimatives = Stats.MovingPrimitivesCount,
				ContactsCount = Stats.ContactsCount,
			}
			if type(visitObject) == "table" then
				for _k, _v in pairs(visitObject) do
					_ptr[_k] = _v
				end
			end
			_ptr.visits = visits()
			_ptr.playing = playing()
			_ptr.favourties = favourties()
			_ptr.genre = genre()
			_ptr.gameId = gameId
			_ptr.likes = likes()
			_ptr.dislikes = dislikes()
			local _left = "privateServer"
			local _result
			if game.PrivateServerId == "" then
				_result = false
			else
				_result = true
			end
			_ptr[_left] = _result
			mainLogger("/server_vitals", _ptr)
			wait(60 * 5)
		end
	end)()
end)
return {
	serverVitalsHook = serverVitalsHook,
	getServerVitals = getServerVitals,
}
