// This file creates globals for the entire project --

let ProjectID:string|undefined = undefined;
let API_KEY:string|undefined = undefined;

export function setupGlobals(projectID:string, apiKey:string){
    ProjectID = projectID;
    API_KEY = apiKey;
}

export function fetchGlobals(){
    return {
        ProjectID,
        API_KEY
    }
}