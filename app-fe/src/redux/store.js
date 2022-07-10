import { createStore, applyMiddleware, compose } from 'redux';
import createSagaMiddleware from 'redux-saga';
import { rootReducer } from './reducers';
import sagas from './sagas';

const sagaMiddleware = createSagaMiddleware();
const middlewares = [sagaMiddleware];

export function configureStore(initialState: {}) {
    const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

    const store = createStore(rootReducer, initialState, composeEnhancers(applyMiddleware(...middlewares)));
    sagaMiddleware.run(sagas);
    return store;
}
