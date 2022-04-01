-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local getServerVitals = TS.import(script, script.Parent, "ServerVitals").getServerVitals
local plrJoinedArray = {}
local heartbeat = {}
local startTime = os.time()
local function cleanUpServer()
	-- Lazy fix so maths doesn't break
	local uptime = os.time() - startTime
	local _ptr = {}
	local _left = "privateServer"
	local _result
	if game.PrivateServerId == "" then
		_result = false
	else
		_result = true
	end
	_ptr[_left] = _result
	_ptr.uptime = uptime
	local _left_1 = "avgPlayers"
	local _plrJoinedArray = plrJoinedArray
	local _arg0 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result_1 = 0
	local _callback = _arg0
	for _i = 1, #_plrJoinedArray do
		_result_1 = _callback(_result_1, _plrJoinedArray[_i], _i - 1, _plrJoinedArray)
	end
	-- ▲ ReadonlyArray.reduce ▲
	_ptr[_left_1] = _result_1 / #plrJoinedArray
	local _left_2 = "avgHeartbeat"
	local _heartbeat = heartbeat
	local _arg0_1 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result_2 = 0
	local _callback_1 = _arg0_1
	for _i = 1, #_heartbeat do
		_result_2 = _callback_1(_result_2, _heartbeat[_i], _i - 1, _heartbeat)
	end
	-- ▲ ReadonlyArray.reduce ▲
	_ptr[_left_2] = _result_2 / #heartbeat
	mainLogger("/server_session", _ptr)
end
local function StartUptime()
	-- Look away please :EYES:
	TS.async(function()
		while true do
			local _plrJoinedArray = plrJoinedArray
			local _arg0 = #Players:GetPlayers()
			-- ▼ Array.push ▼
			_plrJoinedArray[#_plrJoinedArray + 1] = _arg0
			-- ▲ Array.push ▲
			-- cheeky as number, but it always will be
			local _heartbeat = heartbeat
			local _arg0_1 = (TS.await(getServerVitals()))
			-- ▼ Array.push ▼
			_heartbeat[#_heartbeat + 1] = _arg0_1
			-- ▲ Array.push ▲
			-- 20 sec cause Rovolution is #LightWeight #BlazinglyFast #CuttingEdge
			wait(20)
		end
	end)()
end
return {
	cleanUpServer = cleanUpServer,
	StartUptime = StartUptime,
}
