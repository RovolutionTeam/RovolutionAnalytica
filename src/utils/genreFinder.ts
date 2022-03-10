import { HttpService } from '@rbxts/services';
import { RL_LOG } from './consoleLogging';
import { root_api } from './logger';
import { fetchGlobals } from 'globals';

let url = 'https://games.roblox.com/v1/games?universeIds=';

export interface DataReturned {
    data: Datum[];
}

export interface Datum {
    id: number;
    rootPlaceId: number;
    name: string;
    description: string;
    sourceName: string;
    sourceDescription: string;
    creator: Creator;
    price: null;
    allowedGearGenres: string[];
    allowedGearCategories: any[];
    isGenreEnforced: boolean;
    copyingAllowed: boolean;
    playing: number;
    visits: number;
    maxPlayers: number;
    studioAccessToApisAllowed: boolean;
    createVipServersAllowed: boolean;
    universeAvatarType: string;
    genre: string;
    isAllGenre: boolean;
    isFavoritedByUser: boolean;
    favoritedCount: number;
}

export interface Creator {
    id: number;
    name: string;
    type: string;
    isRNVAccount: boolean;
}

let genre: string | undefined = undefined;
let visits: number | undefined = undefined;
let favourties: number | undefined = undefined;
let playing: number | undefined = undefined;

export { genre, visits, favourties, playing };

export async function getGameGenre() {
    const { ProjectID, API_KEY } = fetchGlobals();
    let gameID = game.GameId;
    let data: DataReturned;

    try {
        let json_Serialised = HttpService.JSONEncode({
            gameId: gameID,
            project_id: ProjectID,
            api_key: API_KEY,
        });
        data = (await HttpService.JSONDecode(await HttpService.PostAsync(`${root_api}/gameGenre`, json_Serialised))) as any as DataReturned;
    } catch (e) {
        RL_LOG('Failed to fetch game genre!');
        return;
    }

    print(data);

    if (data.data.size() === 0) {
        RL_LOG('Failed to find game genre!');
        return;
    }

    genre = data.data[0].genre;
    visits = data.data[0].visits;
    favourties = data.data[0].favoritedCount;
    playing = data.data[0].playing;
}
