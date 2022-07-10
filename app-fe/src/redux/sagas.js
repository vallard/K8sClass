import { all } from 'redux-saga/effects';
import apiSaga from './api/saga';

export default function* rootSaga(getState: any): any {
    yield all([
        apiSaga(),
    ]);
}