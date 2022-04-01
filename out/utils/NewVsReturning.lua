-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local _datastore2 = TS.import(script, TS.getModule(script, "@rbxts", "datastore2").src)
local DataStore2 = _datastore2
local Combine = _datastore2.Combine
Combine("DATA", "RovolutionAnalytica_Player_Joining_Data")
-- Player Cache
local cache = {}
local function addPlayer(plr)
	local playerStore = DataStore2("RovolutionAnalytica_Player_Joining_Data", plr)
	cache[plr.UserId] = playerStore:Get(true)
	-- We don't actually care what the value is, the fact we are here means its true
	playerStore:Set(false)
end
local function checkPlayerJoinedBefore(plr)
	local val = cache[plr.UserId]
	return val
end
local function cleanUpPlayerJoined(plr)
	cache[plr.UserId] = nil
end
return {
	addPlayer = addPlayer,
	checkPlayerJoinedBefore = checkPlayerJoinedBefore,
	cleanUpPlayerJoined = cleanUpPlayerJoined,
}
