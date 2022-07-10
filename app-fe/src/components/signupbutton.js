import React, { useState } from 'react';
import validator from 'validator';
import { useDispatch, useSelector } from 'react-redux';
import { sendData } from '../redux/actions';
import { NEW_SIGNUP_DATA_TYPE } from '../redux/api/constants';
import { Link, useNavigate } from 'react-router-dom';

function SignUpButton() {
	const navigate = useNavigate();
	const [email, setEmail] = useState("");
	const [emailError, setEmailError] = useState("");
	const [password, setPassword] = useState("");
	const [passwordError, setPasswordError] = useState("");
	const dispatch = useDispatch()
	const isAuthenticated = useSelector(state => state.API.isAuthenticated);


	const validateAndSubmit = (e) => {
		e.preventDefault();

		setEmailError(null)
		setPasswordError(null)

		if (!validator.isEmail(email)) {
			setEmailError('Please enter a valid email address.')
			return;
		}
		if (password === "") {
			setPasswordError('Password can not be empty.')
			return;
		}

		dispatch(sendData(NEW_SIGNUP_DATA_TYPE,
			{
				email: email, password: password, navigate: navigate
			}
		));

	}

	if (isAuthenticated) {
		return (<h1>You are authenticated.</h1>)
	}
	return (
		<form onSubmit={validateAndSubmit}>
			<fieldset>
				<legend className="text-center text-primary">Sign Up To Be Rad</legend>
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
					<button type="submit" className="btn btn-lg btn-primary mx-auto">Sign Up!</button>
				</div>
				<div className="mt-3 text-center">
					Already Have an Account? <Link to="/signin">Sign In</Link>
				</div>
			</fieldset>
		</form>
	)
}

export default SignUpButton;