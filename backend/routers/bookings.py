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

example_schedule = [
    {
        "invoice_number": "INV00001",
        "vin": "1HGBH41JXMN109186",
        "phone": "5551234567",
        "booking_date": "2025-06-30",
        "booking_time": "07:30",
        "booking_duration": 30,
        "status": "completed",
        "name": "John Mitchell",
        "services": "balance, changeover"
    },
    {
        "invoice_number": "INV00002",
        "vin": "1FTFW1ET5DFC10312",
        "phone": "5552345678",
        "booking_date": "2025-06-30",
        "booking_time": "08:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "Sarah Johnson",
        "services": "swap"
    },
    {
        "invoice_number": "INV00004",
        "vin": "3VW467AT8HM123789",
        "phone": "5554567890",
        "booking_date": "2025-06-30",
        "booking_time": "09:00",
        "booking_duration": 60,
        "status": "completed",
        "name": "Emily Chen",
        "services": "oil change"
    },
    {
        "invoice_number": "INV00005",
        "vin": "1N4AL3AP0HC123456",
        "phone": "5555678901",
        "booking_date": "2025-06-30",
        "booking_time": "10:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "David Thompson",
        "services": "rotate"
    },
    {
        "invoice_number": "INV00006",
        "vin": "KMHD14LA2HA123456",
        "phone": "5556789012",
        "booking_date": "2025-06-30",
        "booking_time": "10:30",
        "booking_duration": 30,
        "status": "cancelled",
        "name": "Lisa Wilson",
        "services": "rotate"
    },
    {
        "invoice_number": "INV00007",
        "vin": "JM1BK32F781123456",
        "phone": "5557890123",
        "booking_date": "2025-06-30",
        "booking_time": "11:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "Robert Brown",
        "services": "alignment, balance, changeover"
    },
    {
        "invoice_number": "INV00008",
        "vin": "1FMCU0F70HUC12345",
        "phone": "5558901234",
        "booking_date": "2025-06-30",
        "booking_time": "11:30",
        "booking_duration": 30,
        "status": "completed",
        "name": "Jennifer Davis",
        "services": "balance"
    },
    {
        "invoice_number": "INV00009",
        "vin": "5NPE34AF4HH123456",
        "phone": "5559012345",
        "booking_date": "2025-06-30",
        "booking_time": "13:00",
        "booking_duration": 120,
        "status": "completed",
        "name": "Michael Garcia",
        "services": "alignment, front end"
    },
    {
        "invoice_number": "INV00011",
        "vin": "1C4RJFAG8HC123456",
        "phone": "5551357908",
        "booking_date": "2025-06-30",
        "booking_time": "14:00",
        "booking_duration": 60,
        "status": "completed",
        "name": "Chris Anderson",
        "services": "brakes"
    },
    {
        "invoice_number": "INV00012",
        "vin": "3CZRU5H38HM123456",
        "phone": "5552468097",
        "booking_date": "2025-06-30",
        "booking_time": "15:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "Nicole Taylor",
        "services": "rotate"
    },
    {
        "invoice_number": "INV00014",
        "vin": "1GKKNPLS8HZ123456",
        "phone": "5554702581",
        "booking_date": "2025-06-30",
        "booking_time": "16:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "Rachel Green",
        "services": "balance, changeover, oil change"
    },
    {
        "invoice_number": "INV00015",
        "vin": "1FMHK8F84HGA12345",
        "phone": "5555813692",
        "booking_date": "2025-06-30",
        "booking_time": "16:30",
        "booking_duration": 30,
        "status": "cancelled",
        "name": "Daniel Lee",
        "services": "rotate"
    },
    {
        "invoice_number": "INV00016",
        "vin": "KNDJP3A57H7123456",
        "phone": "5556924703",
        "booking_date": "2025-06-30",
        "booking_time": "17:00",
        "booking_duration": 30,
        "status": "completed",
        "name": "Ashley Clark",
        "services": "swap"
    }
]

example_stats = [
    {
        "service": "alignment",
        "booked": 1, "at_shop": 0,
        "completed": 10, "cancelled": 1,
        "total_bookings": 12, "cancellation_rate": 8
    },
    {
        "service": "balance",
        "booked": 5, "at_shop": 1,
        "completed": 9,"cancelled": 0,
        "total_bookings": 15, "cancellation_rate": 0
    },
    {
        "service": "brakes",
        "booked": 1, "at_shop": 1,
        "completed": 2, "cancelled": 1,
        "total_bookings": 5, "cancellation_rate": 20
    },
    {
        "service": "changeover",
        "booked": 3, "at_shop": 0,
        "completed": 8, "cancelled": 0,
        "total_bookings": 11, "cancellation_rate": 0
    },
    {
        "service": "front end",
        "booked": 0, "at_shop": 0,
        "completed": 7, "cancelled": 1,
        "total_bookings": 8, "cancellation_rate": 13
    },
    {
        "service": "oil change",
        "booked": 4, "at_shop": 0,
        "completed": 4, "cancelled": 1,
        "total_bookings": 9, "cancellation_rate": 11
    },
    {
        "service": "rotate",
        "booked": 3, "at_shop": 0,
        "completed": 4, "cancelled": 1,
        "total_bookings": 8, "cancellation_rate": 13
    },
    {
        "service": "swap",
        "booked": 4, "at_shop": 1,
        "completed": 5, "cancelled": 0,
        "total_bookings": 10, "cancellation_rate": 0
    }
]


@router.get('/booking/{invoice_number}',
        response_model=Booking,
        responses={
            200: get_error_response(200, example_booking),
            404: get_error_response(404, example_booking["invoice_number"])
        })
def get_booking(invoice_number: str) -> Booking:
    print(f"Retrieving booking with invoice: {invoice_number}")
    logger.info(f"Retrieving booking with invoice: {invoice_number}")
    try:
        booking = db.select_booking(invoice_number)
        logger.info(f"Booking retrieved: {booking}")
        return booking

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

@router.get('/schedule', responses={200: get_error_response(200, example_schedule)})
def get_schedule():
    today = "2025-06-30"  # or date.today().strftime('%Y-%m-%d')
    schedule = db.select_schedule(today)
    logger.info(f"{'-' * 10}\n{today}:\n{'-' * 10}\n{schedule}")
    return JSONResponse(content=schedule)

@router.get('/stats', responses={200: get_error_response(200, example_stats)})
def get_stats():
    stats = db.select_stats()
    logger.info(f"{'-' * 10}\nStatistics:\n{'-' * 10}\n{stats}")
    return JSONResponse(content=stats)
