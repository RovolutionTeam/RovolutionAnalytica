export function getUserSessionDuration(plr: Player) {
    let timestamp = plr.FindFirstChild('Rovolution_Analytica_Timestamp');
    if (!(timestamp && timestamp.IsA('NumberValue'))) {
        return 0;
    }
    return os.time() - timestamp.Value;
}
