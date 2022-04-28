-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
-- This file reports all data back to the RovolutionAnalytica API --
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local HttpService = _services.HttpService
local Players = _services.Players
local fetchGlobals = TS.import(script, script.Parent.Parent, "globals").fetchGlobals
local RL_LOG = TS.import(script, script.Parent, "consoleLogging").RL_LOG
local fetchDeviceType = TS.import(script, script.Parent, "deviceType").fetchDeviceType
local root_api = "https://analytics.rovolution.me/api/v1"
-- --------------------------------------------------------------------
local function mainLogger(typeOfReq, message)
	local _binding = fetchGlobals()
	local ProjectID = _binding.ProjectID
	local API_KEY = _binding.API_KEY
	-- Create the data packet
	local include = {}
	local _condition = message.userId ~= nil
	if _condition then
		local _userId = message.userId
		_condition = type(_userId) == "number"
	end
	if _condition then
		local plr = Players:GetPlayerByUserId(message.userId)
		if plr then
			include = {
				deviceType = fetchDeviceType(plr),
			}
		end
	end
	local _ptr = {}
	local _left = "message"
	local _ptr_1 = {}
	if type(message) == "table" then
		for _k, _v in pairs(message) do
			_ptr_1[_k] = _v
		end
	end
	if type(include) == "table" then
		for _k, _v in pairs(include) do
			_ptr_1[_k] = _v
		end
	end
	_ptr[_left] = _ptr_1
	_ptr.timestamp = os.time() * 1000
	_ptr.project_id = ProjectID
	_ptr.api_key = API_KEY
	local data = _ptr
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
		RL_LOG("Failed to send data to API " .. tostring(e) .. ", debug url " .. typeOfReq .. "!")
	end)
end
return {
	mainLogger = mainLogger,
	root_api = root_api,
}
