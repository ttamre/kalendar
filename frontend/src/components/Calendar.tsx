/* Calendar Component */

import { useState, useEffect } from "react";


export default function Calendar() {
    const [appointments, setAppointments] = useState([]);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        fetchAppointments()
            .then(data => setAppointments(data))
            .catch(err => setError(err.message));
    }, []);

    if (error) {
        return <div className="error container">Error: {error}</div>;
    }

    console.log(appointments)

    return (
        <div className="container calendarContainer">

            <div className="calendarHeader">

                <div className="row">
                    <div className="two columns">&nbsp;</div>
                    <h5 className="two columns">TIRES 1</h5>
                    <h5 className="two columns">TIRES 2</h5>
                    <h5 className="two columns">MECH 1</h5>
                    <h5 className="two columns">MECH 2</h5>
                    <h5 className="two columns">ALIGNMENT</h5>
                </div>

            </div>

            <div className="calendarBody">

                {generateTimeSlots().map((time, index) => (
                    <div key={index} className="row">
                        <div className="two columns time">{time}</div>

                        <div className="two columns appointment booked">
                            <div className="name">JOE<br />SMITH</div>
                            <span className="services">CHANGEOVER</span>
                        </div>

                        <div className="two columns appointment on_site">
                            <div className="name">BOB<br />ROSS</div>
                            <div className="services">REPAIR</div>
                        </div>
                        <div className="two columns appointment in_progress">
                            <div className="name">DAVE<br />JONES</div>
                            <div className="services">BRAKES</div>
                        </div>
                        <div className="two columns appointment complete">
                            <div className="name">MATT<br />MOLE</div>
                            <div className="services">FRONT<br />END</div>
                        </div>
                        <div className="two columns appointment cancelled">
                            <div className="name">SHELLY<br />SUE</div>
                            <div className="services">AL4</div>
                        </div>
                    </div>
                ))}

            </div>
        </div >
    );
}


async function fetchAppointments() {
    const response = await fetch("/api/schedule");
    if (!response.ok) {
        throw new Error("Network response was not ok");
    }
    return response.json();
}

function generateTimeSlots() {
    const timeSlots = [];
    const startTime = new Date();
    const endTime = new Date();

    startTime.setHours(8, 0, 0, 0); // Start at 8:00 AM
    endTime.setHours(18, 0, 0, 0);  // End at 6:00 PM

    while (startTime <= endTime) {
        const slot = startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false });
        timeSlots.push(slot.replaceAll('.', ''));
        startTime.setMinutes(startTime.getMinutes() + 30);
    }

    return timeSlots;
}

