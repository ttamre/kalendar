/* Calendar Component */

function generateTimeSlots() {
    const timeSlots = [];
    const startTime = new Date();
    const endTime = new Date();

    startTime.setHours(8, 0, 0, 0); // Start at 8:00 AM
    endTime.setHours(18, 0, 0, 0);  // End at 6:00 PM

    while (startTime <= endTime) {
        const slot = startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        timeSlots.push(slot.replaceAll('.', ''));
        startTime.setMinutes(startTime.getMinutes() + 30);
    }

    return timeSlots;
}

function Calendar() {
    return (
        <div className="container bordered calendarContainer">
            <div className="row calendarHeader">
                <h5 className="two columns" />
                <h5 className="two columns">TIRES 1</h5>
                <h5 className="two columns">TIRES 2</h5>
                <h5 className="two columns">MECH 1</h5>
                <h5 className="two columns">MECH 2</h5>
                <h5 className="two columns">ALIGNMENT</h5>
            </div>
            {generateTimeSlots().map((time, index) => (
                <div key={index} className="row">
                    <div className="two columns">{time}</div>

                    <div className="appointment two columns">SWAP</div>
                    <div className="appointment two columns">REPAIR</div>
                    <div className="appointment two columns">BRAKES</div>
                    <div className="appointment two columns">FRONT END</div>
                    <div className="appointment two columns">ALIGNMENT</div>
                </div>
            ))}
        </div>
    );
}

export default Calendar;