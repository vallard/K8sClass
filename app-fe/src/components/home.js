import React from 'react';
import { useSelector } from 'react-redux'
import NavBar from './navbar';
import Emoji from './emoji';
import SignUpButton from './signupbutton';

function Home() {
    const error = useSelector(state => state.API.error);
    const isAuthenticated = useSelector(state => state.API.isAuthenticated);
    return (
        <>
            <NavBar selected="home" error={error} />
            <header className="py-5 border-bottom">
                <div className="container pt-md-1 pb-md-4">
                    <div className="row">
                        <div className="col-md-12 text-center">
                            <h1 className="display-4 mt-0">
                                <Emoji label="surf" emoji="🏄‍♀️" />
                                Such a Rad App on Kubernetes
                                <Emoji label="surf" emoji="🏄‍♀️" />
                            </h1>
                            <div className="text-center">
                                {isAuthenticated ?
                                    <p className="display-6 lead text-green">
                                        <span className="fw-bold text-success">You are logged in!</span>
                                    </p>
                                    :
                                    <p className="display-6 lead text-purple">
                                        <span className="fw-bold text-secondary">You are not logged in!</span>
                                    </p>
                                }
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <header className="py-5 border-bottom">
                <div className="container pt-md-1 pb-md-4">
                    <div className="row">
                        <div className="col align-self-center">
                            <SignUpButton />
                        </div>
                    </div>
                </div>
            </header>
        </>
    );
}

export default Home;
