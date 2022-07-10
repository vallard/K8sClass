import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom'
import { setToken } from '../redux/actions';

function UserDropDown({ user }) {
	const dispatch = useDispatch();
	const signout = (e) => {
		e.preventDefault();
		console.log("signout!")
		dispatch(setToken(null));
	}
	return (
		<li className="nav-item dropdown">
			<button className="btn btn-outline-info nav-link dropdown-toggle" id="userDropDownMenu"
				data-bs-toggle="dropdown" aria-expanded="false" aria-label="Toggle navigation">
				{user.email}
			</button>
			<ul class="dropdown-menu" aria-labelledby="userDropdownMenu">
				<li><Link to="/signout" className="dropdown-item" onClick={signout}>Logout</Link></li>
				<li><Link to="/settings" className="dropdown-item">Settings</Link></li>
			</ul>
		</li>
	)
}


function NavBar({ selected, error, message }) {
	const user = useSelector(state => state.API.user);
	const isAuthenticated = useSelector(state => state.API.isAuthenticated);
	return (
		<>
			<nav className="navbar navbar-expand-md navbar-light">
				<div className="container-fluid">
					<a className="navbar-brand" href="/">
						Rad K8S Application
					</a>
					<button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarToggler" aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
						<span className="navbar-toggler-icon"></span>
					</button>
					<div className="collapse navbar-collapse" id="navbarToggler">
						<ul className="navbar-nav ms-auto mb-2 mb-lg-0 d-flex">
							{isAuthenticated && Object.entries(user).length > 0 ?
								<>
									<UserDropDown user={user} />
								</>
								:
								<>
									<li className="nav-item">
										<Link to="/signin" className={selected === "signin" ? "nav-link active" : "nav-link"}>Sign In</Link>
									</li>
									<li className="nav-item">
										<Link to="/signup" className={selected === "signup" ? "btn btn-primary active" : "btn btn-primary "}>Sign Up</Link>
									</li>
								</>
							}
						</ul>
					</div>
				</div>
			</nav >
			{error &&
				<div className="alert alert-danger text-center">
					{error.toString()}
				</div>
			}
			{message &&
				<div className="alert alert-info text-center">
					{message.toString()}
				</div>
			}
		</>
	);
}

export default NavBar;