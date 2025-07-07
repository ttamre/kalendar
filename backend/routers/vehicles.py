from fastapi import APIRouter, Form, HTTPException, status
from typing import Annotated
from sqlite3 import DatabaseError, IntegrityError
import logging

from database import db
from models import Vehicle
from errors import get_error_response


logger = logging.getLogger(__name__)
router = APIRouter(tags=["vehicles"])

example_vehicle = {
    "phone": "1234567890",
    "vin": "GEA7DNY5HJ0FJFXTV",
    "year": 2025,
    "make": "Toyota",
    "model": "Camry",
    "plate": "A1B2C3",
    "mileage": 15000,
    "created_at": "2025-10-01T12:00:00Z",
    "updated_at": "2025-10-01T12:00:00Z"
}

@router.get('/vehicle/{vin}',
        response_model=Vehicle,
        responses={
            200: get_error_response(200, example_vehicle),
            404: get_error_response(404, example_vehicle["vin"])
        })
def get_vehicle(vin: str) -> Vehicle:
    print(f"Retrieving vehicle with VIN: {vin}")
    logger.info(f"Retrieving vehicle with VIN: {vin}")
    try:
        vehicle = db.select_vehicle(vin)
        logger.info(f"Vehicle retrieved: {vehicle}")
        return vehicle

    except DatabaseError as e:
        raise HTTPException(status_code=404, detail=str(e))
    

@router.post('/vehicle',
             status_code=status.HTTP_201_CREATED,
             responses={
                 201: get_error_response(201, example_vehicle),
                 409: get_error_response(409, example_vehicle)
             })
def add_vehicle(vehicle: Annotated[Vehicle, Form()]) -> Vehicle:
    try:
        db.insert_vehicle(vehicle)
        logger.info(f"Vehicle added: {vehicle}")
        return vehicle

    except IntegrityError as e:
        raise HTTPException(status_code=409, detail=str(e))