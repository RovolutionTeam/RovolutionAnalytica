import { HttpService } from '@rbxts/services';
import { RL_LOG } from './consoleLogging';
import { root_api } from './logger';
import { fetchGlobals } from 'globals';

let url = 'https://games.roblox.com/v1/games?universeIds=';

export interface DataReturned {
    data: Datum;
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
    upVotes: number;
    downVotes: number;
}

export interface Creator {
    id: number;
    name: string;
    type: string;
    isRNVAccount: boolean;
}

let genreTemp: string | undefined = undefined;
let visitsTemp: number | undefined = undefined;
let favourtiesTemp: number | undefined = undefined;
let playingTemp: number | undefined = undefined;
let likesTemp: number | undefined = undefined;
let dislikesTemp: number | undefined = undefined;

export function genre() {
    return genreTemp;
}

export function visits() {
    return visitsTemp;
}

export function favourties() {
    return favourtiesTemp;
}

export function playing() {
    return playingTemp;
}

export function likes() {
    return likesTemp;
}

export function dislikes() {
    return dislikesTemp;
}

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

    if (data.data === undefined) {
        RL_LOG('Failed to find game genre!');
        return;
    }

    genreTemp = data.data.genre;
    visitsTemp = data.data.visits;
    favourtiesTemp = data.data.favoritedCount;
    playingTemp = data.data.playing;
    likesTemp = data.data.upVotes;
    dislikesTemp = data.data.downVotes;
}
