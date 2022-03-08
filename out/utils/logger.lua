-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- This file reports all data back to the RovolutionAnalytica API --
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
local fetchGlobals = TS.import(script, script.Parent.Parent, "globals").fetchGlobals
local RL_LOG = TS.import(script, script.Parent, "consoleLogging").RL_LOG
local root_api = "https://analytics.rovolution.me/api/v1"
-- --------------------------------------------------------------------
local function mainLogger(typeOfReq, message)
	local _binding = fetchGlobals()
	local ProjectID = _binding.ProjectID
	local API_KEY = _binding.API_KEY
	-- Create the data packet
	local data = {
		message = message,
		timestamp = os.time() * 1000,
		project_id = ProjectID,
		api_key = API_KEY,
	}
	local json_Serialised = ""
	local _exitType, _returns = TS.try(function()
		-- Serialise the JSON
		json_Serialised = HttpService:JSONEncode(data)
	end, function()
		-- If it fails, log it
		RL_LOG("Failed to serialise JSON")
		return TS.TRY_RETURN, {}
	end)
	if _exitType then
		return unpack(_returns)
	end
	-- Send the data packet to the API
	TS.try(function()
		HttpService:PostAsync(root_api .. typeOfReq, json_Serialised)
	end, function(e)
		-- If it fails, log it
		RL_LOG("Failed to send data to API " .. tostring(e))
	end)
end
return {
	mainLogger = mainLogger,
}
