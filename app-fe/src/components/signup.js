import React from 'react';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import NavBar from './navbar';
import SignUpButton from './signupbutton';

function SignUp() {
	const navigate = useNavigate();
	const error = useSelector(state => state.API.error);
	const isAuthenticated = useSelector(state => state.API.isAuthenticated);
	if (isAuthenticated) {
		navigate("/");
	}
	return (
		<>
			<NavBar selected="signup" error={error} />
			<div className="container">
				<SignUpButton />
			</div>
		</>
	)
}

export default SignUp;