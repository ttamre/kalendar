from fastapi import APIRouter, Form, HTTPException, status
from typing import Annotated
from sqlite3 import DatabaseError, IntegrityError
import logging

from database import db
from models import Customer
from errors import get_error_response


logger = logging.getLogger(__name__)
router = APIRouter(tags=["customers"])

example_customer = {
    "phone": "1234567890",
    "name": "John Doe",
    "email": "johndoe@example.com",
    "created_at": "2025-10-01T12:00:00Z",
    "updated_at": "2025-10-01T12:00:00Z"
}


@router.get('/customer/{phone}',
        response_model=Customer,
        responses={
            200: get_error_response(200, example_customer),
            404: get_error_response(404, example_customer["phone"])
        })
def get_customer(phone: str) -> Customer:
    print(f"Retrieving customer with phone: {phone}")
    logger.info(f"Retrieving customer with phone: {phone}")
    try:
        customer = db.select_customer(phone)
        logger.info(f"Customer retrieved: {customer}")
        return customer
    
    except DatabaseError as e:
        raise HTTPException(status_code=404, detail=str(e))


@router.post('/customer',
        status_code=status.HTTP_201_CREATED,
        responses={
            201: get_error_response(201, example_customer),
            409: get_error_response(409, example_customer)
        })
def add_customer(customer: Annotated[Customer, Form()]):
    try:
        db.insert_customer(customer)
        logger.info(f"Customer added: {customer}")
        return customer

    except IntegrityError as e:
        raise HTTPException(status_code=409, detail=str(e))