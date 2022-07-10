import React from "react";
import { Route, Routes } from 'react-router-dom';

import Home from '../components/home';
import SignIn from '../components/signin';
import SignUp from "../components/signup";


const allRoutes = () =>
    <Routes>
        <Route exact path="/" element={<Home />} />
        <Route exact path="/signin" element={<SignIn />} />
        <Route exact path="/signup" element={<SignUp />} />
    </Routes>

export default allRoutes