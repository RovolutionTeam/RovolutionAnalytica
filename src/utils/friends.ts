export function fetchFriends(plr: Player): NumberValue | 'N/A' {
    let deviceType = plr.FindFirstChild('RovolutionAnalytica')?.FindFirstChild('Rovolution_Analytica_FriendsJoined');

    // Verify it is the right type
    if (!(deviceType && deviceType.IsA('NumberValue'))) return 'N/A';

    return deviceType;
}

export function incrementFriends(plr: Player) {
    let dataObj = fetchFriends(plr);
    if (dataObj === 'N/A') return;

    dataObj.Value = dataObj.Value + 1;
}

export function fetchFriendsValue(plr: Player): number {
    let dataObj = fetchFriends(plr);
    if (dataObj === 'N/A') return 0;

    return dataObj.Value;
}
