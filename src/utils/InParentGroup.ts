// Written By GeraldIn2016, RovolutionAnalytica "Its what you don't see" --

export function checkInParentGroup(plr: Player, group: number, isGroup?: 'User' | 'Group'): boolean | undefined {
    if (isGroup === 'User') {
        return undefined;
    }
    return plr.GetRankInGroup(group) > 0;
}
