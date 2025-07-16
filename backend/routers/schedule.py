from fastapi import APIRouter
from fastapi.responses import JSONResponse
from datetime import date, datetime, timedelta
import logging

from database import db
from errors import get_error_response


logger = logging.getLogger(__name__)
router = APIRouter(tags=["schedule"])

example_schedule = {}


# returns {"8:00": {}, "8:30": {}, ..., "17:30": {}}
def generate_time_slots():
    start = datetime.strptime("08:00", "%H:%M")
    end = datetime.strptime("17:30", "%H:%M")
    delta = timedelta(minutes=30)

    time_slots = {}

    while start <= end:
        time_str = start.strftime("%H:%M")
        time_slots[time_str] = {
            # "TIRES 1": {},
            # "TIRES 2": {},
            # "MECH 1": {},
            # "MECH 2": {},
            # "ALIGNMENT": {}
        }
        start += delta

    return time_slots


@router.get('/schedule/', responses={200: get_error_response(200, example_schedule)})
def get_schedule(booking_date: str = date.today().strftime("%Y-%m-%d")):

    schedule = db.select_schedule(booking_date)
    formatted_schedule = generate_time_slots()
    
    for booking in schedule:

        if not booking["services"]:
            booking["services"] = ""
            logger.warning(f"Booking {booking['invoice_number']} has no services assigned.")
            
        services = booking["services"].split(", ")

        tire_services = ["changeover", "balance", "repair", "swap", "rotate"]
        mech_services = ["brakes", "front end", "oil change"]
        alignment_services = ["al4"]

        # TODO handle multiple services in a single booking
        # For now, just assign the first service to a bay
        bay = ""
        booking_time = booking["booking_time"]
        
        if any(service in tire_services for service in services):
            bay = "TIRES 1" if "TIRES 1" not in formatted_schedule[booking_time] else "TIRES 2"
        if any(service in mech_services for service in services):
            bay = "MECH 1" if "MECH 1" not in formatted_schedule[booking_time] else "MECH 2"
        if any(service in alignment_services for service in services):
            bay = "ALIGNMENT"

        formatted_schedule[booking_time][bay] = booking

    logger.info(f"{'-' * 10}\n{booking_date}:\n{'-' * 10}\n{formatted_schedule}")
    return JSONResponse(content=formatted_schedule)