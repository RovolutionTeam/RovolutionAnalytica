-- Compiled with roblox-ts v1.2.3
local TS = require(script.Parent.Parent.include.RuntimeLib)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local mainLogger = TS.import(script, script.Parent.Parent, "utils", "logger").mainLogger
local getServerVitals = TS.import(script, script.Parent, "ServerVitals").getServerVitals
local plrJoinedArray = {}
local premiumJoinedArray = {}
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
	local _left_2 = "avgPremiumPlayers"
	local _premiumJoinedArray = premiumJoinedArray
	local _arg0_1 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result_2 = 0
	local _callback_1 = _arg0_1
	for _i = 1, #_premiumJoinedArray do
		_result_2 = _callback_1(_result_2, _premiumJoinedArray[_i], _i - 1, _premiumJoinedArray)
	end
	-- ▲ ReadonlyArray.reduce ▲
	_ptr[_left_2] = _result_2 / #premiumJoinedArray
	local _left_3 = "avgHeartbeat"
	local _heartbeat = heartbeat
	local _arg0_2 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result_3 = 0
	local _callback_2 = _arg0_2
	for _i = 1, #_heartbeat do
		_result_3 = _callback_2(_result_3, _heartbeat[_i], _i - 1, _heartbeat)
	end
	-- ▲ ReadonlyArray.reduce ▲
	_ptr[_left_3] = _result_3 / #heartbeat
	mainLogger("/server_session", _ptr)
end
local function getAveragePlayers()
	local _plrJoinedArray = plrJoinedArray
	local _arg0 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result = 0
	local _callback = _arg0
	for _i = 1, #_plrJoinedArray do
		_result = _callback(_result, _plrJoinedArray[_i], _i - 1, _plrJoinedArray)
	end
	-- ▲ ReadonlyArray.reduce ▲
	return _result / #plrJoinedArray
end
local function getAverageHeartbeat()
	local _heartbeat = heartbeat
	local _arg0 = function(a, b)
		return a + b
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result = 0
	local _callback = _arg0
	for _i = 1, #_heartbeat do
		_result = _callback(_result, _heartbeat[_i], _i - 1, _heartbeat)
	end
	-- ▲ ReadonlyArray.reduce ▲
	return _result / #heartbeat
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
			local _premiumJoinedArray = premiumJoinedArray
			local _exp = Players:GetPlayers()
			local _arg0_1 = function(p)
				return p.MembershipType == Enum.MembershipType.Premium
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in ipairs(_exp) do
				if _arg0_1(_v, _k - 1, _exp) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			-- ▼ Array.push ▼
			local _arg0_2 = #_newValue
			_premiumJoinedArray[#_premiumJoinedArray + 1] = _arg0_2
			-- ▲ Array.push ▲
			-- cheeky as number, but it always will be
			local _heartbeat = heartbeat
			local _arg0_3 = (TS.await(getServerVitals()))
			-- ▼ Array.push ▼
			_heartbeat[#_heartbeat + 1] = _arg0_3
			-- ▲ Array.push ▲
			-- 120 sec cause Rovolution is #LightWeight #BlazinglyFast #CuttingEdge
			wait(120)
		end
	end)()
end
return {
	cleanUpServer = cleanUpServer,
	getAveragePlayers = getAveragePlayers,
	getAverageHeartbeat = getAverageHeartbeat,
	StartUptime = StartUptime,
}
