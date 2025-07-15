/* Calendar Component */

import { useState, useEffect } from "react";
import { getPreviousWeekday, getNextWeekday, getNearestWeekday } from "../utils/dateUtils";

const BAYS = ["TIRES 1", "TIRES 2", "MECH 1", "MECH 2", "ALIGNMENT"];

export default function Calendar() {
    const [appointments, setAppointments] = useState<Record<string, Record<string, any>>>({});
    const [selectedDate, setSelectedDate] = useState<Date>(getNearestWeekday(new Date("2025-06-31")));
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        fetchAppointments(selectedDate)
            .then(data => setAppointments(data))
            .catch(err => setError(err.message));
    }, [selectedDate]);

    if (error) {
        return <div className="error container">Error: {error}</div>;
    }

    console.log(appointments);

    const handlePreviousDay = () => setSelectedDate(getPreviousWeekday(selectedDate));
    const handleNextDay = () => setSelectedDate(getNextWeekday(selectedDate));

    return (
        <div className="container">
            <p className="calendarDate">{selectedDate.toDateString()}</p>

            <div className="calendarHead">

                <div className="row">
                    <div className="two columns calendarButtons">
                        <div onClick={handlePreviousDay} className="button">&lt;</div>
                        <div onClick={handleNextDay} className="button">&gt;</div>
                    </div>

                    {BAYS.map((bay) => (
                        <h5 key={bay} className="two columns">{bay}</h5>
                    ))}
                </div>

            </div>

            <div className="calendarBody">

                {Object.entries(appointments).map(([time, bays]) => (
                    <div key={time} className="row calendarRow">
                        <div className="two columns time">{time}</div>

                        {BAYS.map((bay) => {
                            const appointment = bays[bay];
                            if (!appointment) {
                                return <div key={bay} className="two columns appointment">&nbsp;<br />&nbsp;</div>;
                            }

                            const status = appointment.status || "booked";
                            const name = appointment.name || "";
                            const [first, last] = name.split(" ");
                            const services = appointment.services.split(",").map((service: string) => service.trim());

                            return (
                                <div key={bay} onClick={() => handleAppointmentClick(appointment)} className={`two columns appointment ${status}`}>
                                    <div className="name">
                                        {first}<br />{last}
                                    </div>
                                    <div className="services">{services[0]}</div>
                                </div>
                            );
                        })}
                    </div>
                ))}
            </div>
        </div>
    );
}

async function fetchAppointments(bookingDate: Date = new Date()) {
    const dateString = bookingDate.toLocaleDateString("en-CA");
    const response = await fetch(`/api/schedule/${dateString}`);
    if (!response.ok) {
        throw new Error(`Failed to fetch schedule (${response.status} ${response.statusText})`);
    }
    return response.json();
}

function handleAppointmentClick(appointment: any) {
    console.log(appointment);
}