import { combineReducers } from 'redux';
import API from './api/reducers';

export const rootReducer = (state, action) => {
  /*if (action.type === LOGOUT_USER) {
    //const { } = state;
    //logout
    state = { };
  };*/
  return appReducer(state, action)
}

const appReducer = combineReducers({
  API,
});

