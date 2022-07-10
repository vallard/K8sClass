import { all, call, fork, put, takeEvery } from 'redux-saga/effects';
import api from './api';


import {
    FETCH_API,
    SEND_DATA,
    NEW_SIGNUP_DATA_TYPE,
    SIGNIN_DATA_TYPE,
    GET_CURRENT_SESSION,
    FETCH_USER,
} from './constants';


import {
    gotResponse,
    apiError,
} from './actions';

/* checks if there is a saved auth token. */
function* getCurrentSession() {
    const jwt = sessionStorage.getItem('ttw-jwt');
    yield (gotResponse(GET_CURRENT_SESSION, jwt));
}

function* getAPI({ fetchType, fetchVar1, fetchVar2 }) {
    var path = "/home"
    var headers = null;
    if (fetchType === FETCH_USER) {
        headers = {
            "Authorization": "Bearer " + fetchVar1,
            "Content-Type": "application/json",
        }
        path = "/user"
    }
    try {
        const response = yield call(api.get, {
            path: path,
            headers: headers,
        });
        yield put(gotResponse(fetchType, response))
    } catch (err) {
        //console.log(err.name)
        if (err.name === 'TypeError' || err.name === 'NetworkError') {
            yield put(apiError("Error connecting to backend API."));
            return
        }

        yield put(apiError(err));
    }
}

function* sendAPI(action) { //{ dataType, data }) {
    var path = "";
    var data = null;
    var headers = null;
    var formData = null;
    if (action.dataType === NEW_SIGNUP_DATA_TYPE) {
        // uses the default path of "/users"
        //console.log("data: ", action.data)
        data = {
            "email": action.data.email,
            "password": action.data.password,
        };
        path = "/auth/signup";
    } else if (action.dataType === SIGNIN_DATA_TYPE) {
        //https://stackoverflow.com/questions/35325370/how-do-i-post-a-x-www-form-urlencoded-request-using-fetch
        var details = {
            "username": action.data.email,
            "password": action.data.password,
            "client_secret": action.data.token,
        }
        formData = [];
        for (var property in details) {
            var encodedKey = encodeURIComponent(property);
            var encodedValue = encodeURIComponent(details[property]);
            formData.push(encodedKey + "=" + encodedValue);
        }
        formData = formData.join("&");
        headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        }
        path = "/auth/login";
    }
    try {
        const response = yield call(api.send, {
            path: path,
            data: data,
            headers: headers,
            formData: formData
        })
        if (action.dataType === NEW_SIGNUP_DATA_TYPE) {
            if (response.detail) {
                yield put(apiError(response.detail));
                return;
            } else {
                action.data.navigate("/signin");
            }
        } else if (action.dataType === SIGNIN_DATA_TYPE) {
            if (response.access_token) {
                //console.log(response);
                sessionStorage.setItem('ttw-jwt', response.access_token)
            } else {
                yield put(apiError(response.detail))
                return
            }
        }
        yield put(gotResponse(action.dataType, response))
    } catch (err) {
        yield put(apiError(err));
    }
}

export function* watchAPIActions() {
    yield takeEvery(FETCH_API, getAPI);
    yield takeEvery(SEND_DATA, sendAPI);
    yield takeEvery(GET_CURRENT_SESSION, getCurrentSession);
}

function* apiSaga() {
    yield all([
        fork(watchAPIActions),
    ]);
}

export default apiSaga;
