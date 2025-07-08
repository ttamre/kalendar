/* Calendar Component */

import { useState, useEffect } from "react";

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

function Calendar() {
    const [appointments, setAppointments] = useState([]);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        // Simulate fetching appointments from an API
        const fetchAppointments = async () => {
            try {
                const response = await fetch("/api/schedule");
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                console.log(response.url); // Log the response headers for debugging
                const data = await response.json();
                setAppointments(data);
            } catch (err) {
                setError((err as Error).message);
            }
        };

        fetchAppointments();
    }, []);

    if (error) {
        console.log("Error fetching appointments:", error);
        return <div className="error">Error: {error}</div>;
    }

    if (appointments.length === 0) {
        return <div className="loading">Loading appointments...</div>;
    }

    console.log(appointments);

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
                {/*
                    {
                        "08:00": {
                            "Tires": {...},
                            "Mech": {...},
                            "AL4": {...}
                        },
                        "08:30": {...}
                        "09:00": {...}
                    }
                */}

                {generateTimeSlots().map((time, index) => (
                    <div key={index} className="row">
                        <div className="time two columns">{time}</div>
                        <div className="appointment two columns">SWAP</div>
                        <div className="appointment two columns">REPAIR</div>
                        <div className="appointment two columns">BRAKES</div>
                        <div className="appointment two columns">FRONT END</div>
                        <div className="appointment two columns">ALIGNMENT</div>
                    </div>
                ))}

            </div>
        </div>
    );
}

export default Calendar;