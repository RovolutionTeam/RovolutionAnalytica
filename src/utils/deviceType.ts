export function fetchDeviceType(plr: Player) {
    let deviceType = plr.FindFirstChild('RovolutionAnalytica')?.FindFirstChild('ROVOLUTION_DEVICE_TYPE');

    // Verify it is the right type
    if (!(deviceType && deviceType.IsA('StringValue'))) return 'N/A';

    return deviceType.Value;
}
