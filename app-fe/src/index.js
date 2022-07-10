import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { BrowserRouter as Router } from 'react-router-dom';

import { Provider } from 'react-redux';
import { configureStore } from './redux/store';

ReactDOM.render(
  <Provider store={configureStore()}>
    <Router>
      <React.StrictMode>
        <App />
      </React.StrictMode>
    </Router>
  </Provider>,
  document.getElementById('root')
);
reportWebVitals();
