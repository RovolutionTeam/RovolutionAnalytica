-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
local RL_LOG = TS.import(script, script.Parent, "consoleLogging").RL_LOG
local root_api = TS.import(script, script.Parent, "logger").root_api
local fetchGlobals = TS.import(script, script.Parent.Parent, "globals").fetchGlobals
local url = "https://games.roblox.com/v1/games?universeIds="
local genreTemp = nil
local visitsTemp = nil
local favourtiesTemp = nil
local playingTemp = nil
local likesTemp = nil
local dislikesTemp = nil
local function genre()
	return genreTemp
end
local function visits()
	return visitsTemp
end
local function favourties()
	return favourtiesTemp
end
local function playing()
	return playingTemp
end
local function likes()
	return likesTemp
end
local function dislikes()
	return dislikesTemp
end
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
	if data.data == nil then
		RL_LOG("Failed to find game genre!")
		return nil
	end
	genreTemp = data.data.genre
	visitsTemp = data.data.visits
	favourtiesTemp = data.data.favoritedCount
	playingTemp = data.data.playing
	likesTemp = data.data.upVotes
	dislikesTemp = data.data.downVotes
end)
return {
	genre = genre,
	visits = visits,
	favourties = favourties,
	playing = playing,
	likes = likes,
	dislikes = dislikes,
	getGameGenre = getGameGenre,
}
