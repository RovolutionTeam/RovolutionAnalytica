// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

export function checkInParentGroup(plr:Player, group:number, isGroup?:"User" | "Group"):boolean{
    if(isGroup === "User"){
        return false
    }
    return plr.GetRankInGroup(group) > 0
}