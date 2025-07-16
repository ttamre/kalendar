/* BookingDetails component */

import { Booking } from './BookingWindow';
import { readablePhoneNumber, readableStatus } from '../utils/formUtils';
import { readableDateString } from '../utils/dateUtils';

export default function BookingDetails({ booking }: { booking: Booking }) {
    return (
        <div className="container bookingDetails">
            <h4>{booking.name} [{booking.invoice_number}]</h4>
            <h6>
                <span>{readableDateString(booking.booking_date)} - {booking.booking_time} ({booking.booking_duration}min)</span>
                <p className="services">{booking.services}</p>
            </h6>
            <div>
                <p><span className="bookingDetailsKey">Status:</span> <span className={`${booking.status}`}>{readableStatus(booking.status)}</span></p>
                <p><span className="bookingDetailsKey">Phone:</span> {readablePhoneNumber(booking.phone)}</p>
                <p><span className="bookingDetailsKey">VIN:</span> {booking.vin}</p>
            </div>
        </div>
    );
}