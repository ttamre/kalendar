/* Header Component */
import { readableDateString } from "../utils/dateUtils";
import { readablePhoneNumber, readableStatus } from "../utils/formUtils";

export type Booking = {
    invoice_number: string;
    vin: string;
    phone: string;
    booking_date: string;
    booking_time: string;
    booking_duration: number;
    status: string;
    name: string;
    services: string;
}

export default function BookingWindow({
    booking, onDelete, onClose }: { booking: Booking, onDelete: () => void, onClose: () => void }) {

    return (
        <div className="container bookingWindow">

            <h4>{booking.name} [{booking.invoice_number}]</h4>

            <h6>
                <span>{readableDateString(booking.booking_date)} - {booking.booking_time} ({booking.booking_duration}min)</span>
                <p className="services">{booking.services}</p>
            </h6>

            <div>
                <p><span className="bookingWindowKey">status:</span><span className={`${booking.status}`}>{readableStatus(booking.status)}</span></p>
                <p><span className="bookingWindowKey">phone:</span>{readablePhoneNumber(booking.phone)}</p>
                <p><span className="bookingWindowKey">vin:</span>{booking.vin}</p>

                <div>
                    <button className="button">Edit</button>
                    <button className="button" onClick={onDelete}>Delete</button>
                    <button className="button" onClick={onClose}>Close</button>
                </div>
            </div>
        </div>
    );
}