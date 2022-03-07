-- Compiled with roblox-ts v1.2.3
-- This file creates globals for the entire project --
local ProjectID = nil
local API_KEY = nil
local function setupGlobals(projectID, apiKey)
	ProjectID = projectID
	API_KEY = apiKey
end
local function fetchGlobals()
	return {
		ProjectID = ProjectID,
		API_KEY = API_KEY,
	}
end
return {
	setupGlobals = setupGlobals,
	fetchGlobals = fetchGlobals,
}
