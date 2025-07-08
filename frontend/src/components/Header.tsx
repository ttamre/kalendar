/* Header Component */

function Header({ logoImg }: { logoImg: string }) {
    return (
        <>
            <div className="header">
                <a href="/"><img className="logo" src={logoImg} alt="Kalendar" /></a>
                <div className="headerButtons">
                    <button className="button" >Parts</button>
                    <button className="button headerButton" >Orders </button>
                </div>
            </div>
        </>
    );
}

export default Header;