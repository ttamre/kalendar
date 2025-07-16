/* Calendar Component */

import { useState, useEffect } from "react";
import { getPreviousWeekday, getNextWeekday, getNearestWeekday } from "../utils/dateUtils";
import BookingWindow from "./BookingWindow";
import { Booking } from "./BookingWindow";

const BAYS = ["TIRES 1", "TIRES 2", "MECH 1", "MECH 2", "ALIGNMENT"];

export default function Calendar() {
    const [bookings, setBookings] = useState<Record<string, Record<string, any>>>({});
    const [selectedDate, setSelectedDate] = useState<Date>(getNearestWeekday(new Date("2025-06-31")));
    const [showBookingWindow, setShowBookingWindow] = useState<boolean>(false);
    const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        fetchBookings(selectedDate)
            .then(data => setBookings(data))
            .catch(err => setError(err.message));
    }, [selectedDate]);

    if (error) {
        return <div className="error container">{error}</div>;
    }

    console.log(bookings);

    const handlePreviousDay = () => setSelectedDate(getPreviousWeekday(selectedDate));
    const handleNextDay = () => setSelectedDate(getNextWeekday(selectedDate));
    const openBookingWindow = (booking: Booking) => {
        setSelectedBooking(booking);
        setShowBookingWindow(true);
    };

    const closeBookingWindow = () => {
        setShowBookingWindow(false);
        setSelectedBooking(null);
    };

    const onDeleteHandler = (booking: Booking) => {
        deleteBooking(booking.invoice_number)
            .then(() => {
                setBookings(prevBookings => {
                    const updatedBookings = { ...prevBookings };
                    delete updatedBookings[booking.invoice_number];
                    return updatedBookings;
                });
            })
            .then(() => {
                closeBookingWindow();
            })
            .then(() => {
                return fetchBookings(selectedDate);
            })
            .then(data => {
                setBookings(data);
            })
            .catch(err => {
                setError(err.message);
            });
    };

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

                {Object.entries(bookings).map(([time, bays]) => (
                    <div key={time} className="row calendarRow">
                        <div className="two columns time">{time}</div>

                        {BAYS.map((bay) => {
                            const booking = bays[bay];
                            if (!booking) {
                                return <div key={bay} className="two columns booking">&nbsp;<br />&nbsp;</div>;
                            }

                            const status = booking.status || "booked";
                            const name = booking.name || "";
                            const [first, last] = name.split(" ");
                            const services = booking.services.split(",").map((service: string) => service.trim());

                            return (
                                <div key={bay} onClick={() => openBookingWindow(booking)} className={`two columns booking ${status}`}>
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
            {/* TODO separate toggleBookingWindow() into function that accepts params
            will need to make a single Booking type and pass that around */}
            {showBookingWindow && selectedBooking &&
                <BookingWindow
                    booking={selectedBooking}
                    onDelete={() => onDeleteHandler(selectedBooking)}
                    onClose={closeBookingWindow}
                />}
        </div>
    );
}

async function fetchBookings(bookingDate: Date = new Date()) {
    const dateString = bookingDate.toLocaleDateString("en-CA");
    const response = await fetch(`/api/schedule/?booking_date=${dateString}`);
    if (!response.ok) {
        throw new Error(`${response.status}: ${response.statusText} (failed to fetch schedule)`);
    }
    return response.json();
}

async function deleteBooking(invoice_number: string) {
    const response = await fetch(`/api/booking/${invoice_number}`, {
        method: 'DELETE',
        headers: {
            'Content-Type': 'application/json'
        }
    });
    if (!response.ok) {
        console.error(response)
    }
    return response.json();
}