/* Header Component */

function Header({ logoImg }: { logoImg: string }) {
    return (
        <>
            <div className="header">
                <img className="logo" src={logoImg} alt="Kalendar" />
                <div className="headerButtons">
                    <button className="button headerButton" >Parts</button>
                    <button className="button headerButton" >Orders </button>
                </div>
            </div>
        </>
    );
}

export default Header;