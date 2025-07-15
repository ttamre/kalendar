/* Header Component */

function Header() {
    return (
        <div className="header">

            <div className="headerIcons">
                <a href="/">
                    <img className="logo" src="images/kalendar-transparent.png" alt="Kalendar" />
                </a>

                <a href="https://github.com/ttamre/kalendar" target="_blank" rel="noopener noreferrer">
                    <img className="github" src="images/github-logo.svg" alt="GitHub Logo" />
                </a>
            </div>

            <div className="headerButtons">
                <button className="button" >Stats</button>
                <button className="button" >Orders </button>
            </div>

        </div>
    );
}

export default Header;