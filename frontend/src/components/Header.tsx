/* Header Component */
import { useNavigate } from 'react-router-dom';

function Header() {
    const navigate = useNavigate();

    return (
        <div className="header">

            <div className="headerIcons">
                <img onClick={() => navigate('/')} className="logo" src="images/kalendar-transparent.png" alt="Kalendar" />


                <a href="https://github.com/ttamre/kalendar" target="_blank" rel="noopener noreferrer">
                    <img className="github" src="images/github-logo.svg" alt="GitHub Logo" />
                </a>
            </div>

            <div className="headerButtons">
                <button className="button" onClick={() => navigate('/stats')}>Stats</button>
                <button className="button" onClick={() => navigate('/')}>Orders</button>
            </div>

        </div>
    );
}

export default Header;