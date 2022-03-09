-- Compiled with roblox-ts v1.2.3
-- Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --
local function checkInParentGroup(plr, group, isGroup)
	if isGroup == "User" then
		return nil
	end
	return plr:GetRankInGroup(group) > 0
end
return {
	checkInParentGroup = checkInParentGroup,
}
