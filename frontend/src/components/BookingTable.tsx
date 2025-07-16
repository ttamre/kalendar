/* Bookings component */

import { useEffect, useState } from 'react';
import { readablePhoneNumber, readableStatus } from '../utils/formUtils';

import { FaClipboard, FaClipboardCheck } from 'react-icons/fa6';
import { Booking } from './BookingWindow';


export default function BookingTable() {
    const [bookings, setBookings] = useState<Booking[]>([]);
    const [copiedItem, setCopiedItem] = useState<string | null>(null);
    const [error, setError] = useState<string | null>(null);
    const clipboardSize = "15px";

    useEffect(() => {
        fetchBookings()
            .then(data => setBookings(data))
            .catch(err => setError(err.message));
    }, []);

    if (error) {
        return <div className="error container">{error}</div>;
    }

    const handleCopyToClipboard = async (text: string, itemId: string) => {
        try {
            await navigator.clipboard.writeText(text);
            setCopiedItem(itemId);
            setTimeout(() => setCopiedItem(null), 2000); // Reset after 2 seconds
        } catch (err) {
            console.error('Failed to copy: ', err);
        }
    };

    return (
        <div className="container">
            <h2>bookings</h2>
            <table className="bookings">
                <thead>
                    <tr>
                        <th>Invoice</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>VIN</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    {bookings.map((booking, index) => (
                        <tr className="bookingsList" key={index}>
                            <td>
                                <button className="small-button">
                                    {booking.invoice_number}
                                </button>
                            </td>
                            <td>{booking.name}</td>
                            <td>{readablePhoneNumber(booking.phone)}</td>
                            <td>
                                <button className="small-button" onClick={() => handleCopyToClipboard(booking.vin, booking.invoice_number)}>
                                    {copiedItem === booking.invoice_number ? <FaClipboardCheck size={clipboardSize} /> : <FaClipboard size={clipboardSize} />}
                                </button>
                            </td>
                            <td>{booking.booking_date}</td>
                            <td>{booking.booking_time}</td>
                            <td className={`${booking.status}`}>{readableStatus(booking.status)}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

async function fetchBookings() {
    const response = await fetch('/api/bookings');
    if (!response.ok) {
        throw new Error('Failed to fetch bookings');
    }
    return response.json();
}