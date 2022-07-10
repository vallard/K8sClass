import React, { useEffect } from 'react';
import Routes from './routes';
import "./main.css"
import { useDispatch, useSelector } from 'react-redux';
import jwtDecode from 'jwt-decode';
import { fetchAPI, setToken } from './redux/actions';
import { FETCH_USER } from './redux/api/constants';

const App = props => {
  const dispatch = useDispatch();
  const isAuthenticated = useSelector(state => state.API.isAuthenticated);
  useEffect(() => {
    let token = sessionStorage.getItem('ttw-jwt');
    if (token) {
      let tokenExpiration = jwtDecode(token).exp;
      let dateNow = new Date();
      if (tokenExpiration < dateNow.getTime() / 1000) {
        dispatch(setToken(null));
      } else {
        dispatch(setToken(token));
        dispatch(fetchAPI(FETCH_USER, token));
      }
    } else {
      dispatch(setToken(null));
    }
  }, [isAuthenticated]);

  return (
    <Routes />
  );
}

export default App;
