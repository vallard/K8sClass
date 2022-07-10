import {
    FETCH_API,
    SEND_DATA,
    NEW_SIGNUP_DATA_TYPE,
    GOT_RESPONSE,
    ERROR,
    SIGNIN_DATA_TYPE,
    GET_CURRENT_SESSION,
    SET_TOKEN,
    FETCH_USER,
    DELETE_API,
    SET_USER,
} from './constants';

const initState = {
    loading: false,
    home: {},
    user: {},
    error: null,
    isAuthenticated: false,
    message: "",
}

const API = (state = initState, action) => {
    switch (action.type) {
        case SET_TOKEN:
            // if token is cleared, clear everything else. 
            if (!action.token) {
                sessionStorage.removeItem('ttw-jwt');
                return {
                    ...state, token: action.token,
                    isAuthenticated: false,
                    preferences: {},
                    user: {},
                    subscriptions: [],
                    subscriptionPrices: []
                };
            } else {
                return { ...state, token: action.token, isAuthenticated: action.token !== null };
            }
        case SET_USER:
            return { ...state, user: { "email": action.email } }
        case FETCH_API:
            return { ...state, loading: true, destination: {}, error: null, message: null };
        case DELETE_API:
            return { ...state, loading: true, error: null };
        case SEND_DATA:
            return { ...state, loading: true, error: null, message: null };
        case GOT_RESPONSE:
            if (action.responseType === NEW_SIGNUP_DATA_TYPE) {
                return { ...state, loading: false, error: null, user: action.response }
            } else if (action.responseType === SIGNIN_DATA_TYPE) {
                return { ...state, loading: false, error: null, isAuthenticated: true, user: action.response }
            } else if (action.responseType === GET_CURRENT_SESSION) {
                return { ...state, token: action.response }
            } else if (action.responseType === FETCH_USER) {
                return { ...state, user: action.response, loading: false, error: null }
            } else {
                console.log("uncaptured...", action.responseType)
            }

            // unknown response type. 
            return { ...state, loading: false, error: "unimplemented response" }
        case ERROR:
            return { ...state, loading: false, error: action.error }
        default:
            return { ...state };
    }
};

export default API;
