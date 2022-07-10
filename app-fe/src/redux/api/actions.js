import {
    FETCH_API,
    GOT_RESPONSE,
    ERROR,
    SEND_DATA,
    GET_CURRENT_SESSION,
    CURRENT_AUTHENTICATED_USER,
    SET_TOKEN,
    DELETE_API,
    SET_USER,
} from './constants';


/* temp hack to set user with email somewhere */
export const setUser = (email) => ({
    type: SET_USER,
    email,
})
export const fetchAPI = (fetchType, fetchVar1, fetchVar2) => ({
    type: FETCH_API,
    fetchType,
    fetchVar1,
    fetchVar2,
});

export const deleteAPI = (dataType, data) => ({
    type: DELETE_API,
    dataType,
    data,
})

export const gotResponse = (responseType, response) => ({
    type: GOT_RESPONSE,
    responseType,
    response,
})

export const apiError = (error) => ({
    type: ERROR,
    error,
})

export const sendData = (dataType, data) => ({
    type: SEND_DATA,
    dataType,
    data,
})

/* see if there are cookies that have the latest session */
export const getCurrentSession = () => ({
    type: GET_CURRENT_SESSION,
})

/* go and fetch the user id info */
export const currentAuthenticatedUser = () => ({
    type: CURRENT_AUTHENTICATED_USER,
})

export const setToken = (token) => ({
    type: SET_TOKEN,
    token,
})