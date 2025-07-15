from fastapi import APIRouter
from fastapi.responses import JSONResponse
import logging

from database import db
from errors import get_error_response


logger = logging.getLogger(__name__)
router = APIRouter(tags=["stats"])

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

@router.get('/stats', responses={200: get_error_response(200, example_stats)})
def get_stats():
    stats = db.select_stats()
    logger.info(f"{'-' * 10}\nStatistics:\n{'-' * 10}\n{stats}")
    return JSONResponse(content=stats)
