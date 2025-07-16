from fastapi import APIRouter, Form, HTTPException, status
from fastapi.responses import JSONResponse
from typing import Annotated
from sqlite3 import DatabaseError, IntegrityError
import logging

from database import db
from models import Booking
from errors import get_error_response


logger = logging.getLogger(__name__)
router = APIRouter(tags=["bookings"])

example_booking = {
    "invoice_number": "INV123456",
    "vin": "GEA7DNY5HJ0FJFXTV",
    "booking_date": "2025-06-30",
    "booking_time": "10:00",
    "booking_duration": 60,
    "status": "booked",
    "services": [
        {"invoice_number": "INV123456", "service_name": "Oil Change"},
        {"invoice_number": "INV123456", "service_name": "Tire Rotation"},
        {"invoice_number": "INV123456", "service_name": "Brake Inspection"}
    ],
    "created_at": "2025-06-30T10:00:00Z",
    "updated_at": "2025-06-30T10:00:00Z"
}


@router.get('/booking/{invoice_number}',
        response_model=Booking,
        responses={
            200: get_error_response(200, example_booking),
            404: get_error_response(404, example_booking["invoice_number"])
        })
def get_booking(invoice_number: str) -> Booking:
    try:
        booking = db.select_booking(invoice_number)
        logger.info(f"Booking retrieved: {booking}")
        return booking

    except DatabaseError as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.get('/bookings')
def get_bookings() -> list[Booking]:
    try:
        bookings = db.select_bookings()
        logger.info(f"Booking retrieved: {bookings}")
        return JSONResponse(content=bookings)

    except DatabaseError as e:
        raise HTTPException(status_code=404, detail=str(e)) 

@router.post('/booking',
             status_code=status.HTTP_201_CREATED,
             responses={
                 201: get_error_response(201, example_booking),
                 409: get_error_response(409, example_booking)
             })
def add_booking(booking: Annotated[Booking, Form()]) -> Booking:
    try:
        db.insert_booking(booking)
        logger.info(f"Booking added: {booking}")
        return booking

    except IntegrityError as e:
        raise HTTPException(status_code=409, detail=str(e))
    

@router.delete('/booking/{invoice_number}',
             status_code=status.HTTP_201_CREATED,
             responses={})
def delete_booking(invoice_number: str):
    try:
        db.delete_booking(invoice_number)
        logger.info(f"Booking deleted: {invoice_number}")

    except IntegrityError as e:
        raise HTTPException(status_code=409, detail=str(e))