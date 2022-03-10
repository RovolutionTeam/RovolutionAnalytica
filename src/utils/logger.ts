// This file reports all data back to the RovolutionAnalytica API --

import { HttpService } from '@rbxts/services';
import { fetchGlobals } from 'globals';
import { RL_LOG } from './consoleLogging';

const root_api = 'https://analytics.rovolution.me/api/v1';

// --------------------------------------------------------------------

export function mainLogger(typeOfReq: string, message: any) {
    const { ProjectID, API_KEY } = fetchGlobals();
    // Create the data packet

    let data = {
        message,
        timestamp: os.time() * 1000,
        project_id: ProjectID,
        api_key: API_KEY,
    };

    let json_Serialised: string = '';
    try {
        // Serialise the JSON
        json_Serialised = HttpService.JSONEncode(data);
    } catch {
        // If it fails, log it
        RL_LOG('Failed to serialise JSON');
        return;
    }

    // Send the data packet to the API
    try {
        HttpService.PostAsync(root_api + typeOfReq, json_Serialised);
    } catch (e) {
        // If it fails, log it
        RL_LOG(`Failed to send data to API ${e}`);
    }
}

export { root_api };
