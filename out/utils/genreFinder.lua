-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local exports = {}
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
local RL_LOG = TS.import(script, script.Parent, "consoleLogging").RL_LOG
local root_api = TS.import(script, script.Parent, "logger").root_api
local fetchGlobals = TS.import(script, script.Parent.Parent, "globals").fetchGlobals
local url = "https://games.roblox.com/v1/games?universeIds="
exports.genre = nil
exports.visits = nil
exports.favourties = nil
exports.playing = nil
local getGameGenre = TS.async(function()
	local _binding = fetchGlobals()
	local ProjectID = _binding.ProjectID
	local API_KEY = _binding.API_KEY
	local gameID = game.GameId
	local data
	local _exitType, _returns = TS.try(function()
		local json_Serialised = HttpService:JSONEncode({
			gameId = gameID,
			project_id = ProjectID,
			api_key = API_KEY,
		})
		data = (TS.await(HttpService:JSONDecode(TS.await(HttpService:PostAsync(root_api .. "/gameGenre", json_Serialised)))))
	end, function(e)
		RL_LOG("Failed to fetch game genre!")
		return TS.TRY_RETURN, {}
	end)
	if _exitType then
		return unpack(_returns)
	end
	print(data)
	if #data.data == 0 then
		RL_LOG("Failed to find game genre!")
		return nil
	end
	exports.genre = data.data[1].genre
	exports.visits = data.data[1].visits
	exports.favourties = data.data[1].favoritedCount
	exports.playing = data.data[1].playing
end)
exports.getGameGenre = getGameGenre
return exports
