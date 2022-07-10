import React, { useState, useEffect } from 'react';
import validator from 'validator';
import { useDispatch, useSelector } from 'react-redux';
import { sendData, setUser } from '../redux/actions';
import { SIGNIN_DATA_TYPE } from '../redux/api/constants';
import { Link, useNavigate } from 'react-router-dom';
import NavBar from './navbar';
import Emoji from './emoji';

function SignIn() {
	const [email, setEmail] = useState("");
	const [emailError, setEmailError] = useState("");
	const [password, setPassword] = useState("");
	const [passwordError, setPasswordError] = useState("");
	const dispatch = useDispatch()
	const navigate = useNavigate();
	const error = useSelector(state => state.API.error);
	const message = useSelector(state => state.API.message);
	const isAuthenticated = useSelector(state => state.API.isAuthenticated);
	if (isAuthenticated) {
		navigate("/");
	}

	useEffect(() => {
		console.log("error: ", error)
		if (error === "User not validated") {
			dispatch(setUser(email));
			navigate("/auth/confirm");
		}
	}, [error])


	const validateAndSubmit = (e) => {
		e.preventDefault();

		setEmailError(null)
		setPasswordError(null)

		if (!validator.isEmail(email)) {
			setEmailError('Please enter a valid email address.')
			return;
		}
		if (password === "") {
			setPasswordError('Please enter your password.')
			return;
		}

		dispatch(sendData(SIGNIN_DATA_TYPE, { email: email, password: password }));

	}

	return (
		<>
			<NavBar error={error} message={message} selected="signin" />
			<div className="container">
				<form onSubmit={validateAndSubmit}>
					<fieldset>
						<legend className="text-center">Sign In To Be Rad!</legend>
						<div className="mb-3 col-md-4 offset-md-4">
							<input
								className={emailError ? "form-control form-control-lg is-invalid" :
									"form-control form-control-lg"}
								type="text"
								placeholder="email"
								value={email}
								onChange={(e) => setEmail(e.target.value)}
								aria-label="enter email" />
							<div className="invalid-feedback">
								{emailError}
							</div>
							<input
								className={passwordError ? "my-2 form-control form-control-lg is-invalid" :
									"form-control form-control-lg my-2"}
								type="password"
								placeholder="password"
								value={password}
								onChange={(e) => setPassword(e.target.value)}
								aria-label="enter password" />
							<div className="invalid-feedback">
								{passwordError}
							</div>
						</div>
						<div className="mt-3 text-center" >
							<button type="submit" className="btn btn-lg btn-primary mx-auto">Sign In!</button>
						</div>
						<div className="mt-3 text-center text-muted" >
							<Emoji text="no account" emoji="😢" /> No Account? <Link to="/signup" >Sign Up!</Link> <Emoji text="sign up" emoji="😃" />
						</div>
					</fieldset>
				</form>
			</div>
		</>
	)
}

export default SignIn;