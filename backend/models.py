
from pydantic import BaseModel, Field 
from typing import Optional
from datetime import datetime


class Customer(BaseModel):
    """
    Validator class for customer information

    parameters
    ------------
        - phone:        exactly 10 digits
        - name:         2-100 characters, letters/spaces/hyphens only
        - email:        proper email format (can be empty)
    """
    phone: str = Field(..., min_length=10, max_length=10, pattern=r'^\d{10}$')
    name: str = Field(..., min_length=2, max_length=100, pattern=r'^[a-zA-Z\s\-\.]+$')
    email: Optional[str] = Field(
        default="", pattern=r'^$|^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    created_at: str = Field(default_factory=lambda: datetime.now().isoformat())
    updated_at: str = Field(default_factory=lambda: datetime.now().isoformat())

    def __repr__(self):
        return f"Customer(name={self.name}, phone={self.phone}, email={self.email})"


class Vehicle(BaseModel):
    """
    Validator class for vehicles

    parameters
    ------------
        - phone:        exactly 10 digits
        - vin:          exactly 17 characters, alphanumeric except for I, O, Q

        - year:         1900 to 2 years into the future
        - make:         2-50 characters, letters/spaces/hyphens only
        - model:        2-50 characters, letters/spaces/hyphens only
        - plate:        1-7 characters, alphanumeric
        - mileage:      non-negative integer
        - created_at:   ISO 8601 date format
        - updated_at:   ISO 8601 date format
    """
    phone: str = Field(..., min_length=10, max_length=10, pattern=r'^\d{10}$')
    vin: str = Field(..., min_length=17, max_length=17, pattern=r'^[A-HJ-NPR-Z0-9]{17}$')
    year: int = Field(..., ge=1900, le=datetime.now().year + 2)
    make: str = Field(..., min_length=1, max_length=50, pattern=r'^[a-zA-Z0-9\s]+$')
    model: str = Field(..., min_length=1, max_length=50, pattern=r'^[a-zA-Z0-9\s]+$')
    plate: str = Field(..., min_length=1, max_length=7, pattern=r'^[a-zA-Z0-9]+$')
    mileage: int = Field(default=0, ge=0)
    created_at: str = Field(default_factory=lambda: datetime.now().isoformat())
    updated_at: str = Field(default_factory=lambda: datetime.now().isoformat())

    def __repr__(self):
        return f"Vehicle({self.year} {self.make} {self.model}, owner_phone={self.phone}, plate={self.plate}, mileage={self.mileage},  vin={self.vin}, created_at={self.created_at}, updated_at={self.updated_at})"


class Bookings(BaseModel):
   """
   Validator class for bookings

   parameters
   ------------
        - invoice_number:   8 characters, alphanumeric
        - vin:              17 characters, alphanumeric except for I, O, Q
        - booking_date:     ISO 8601 date format
        - booking_time:     ISO 8601 time format
        - status:           ['booked', 'on_site', 'in_progress', 'completed', 'cancelled']
        - created_at:       ISO 8601 date format
        - updated_at:       ISO 8601 date format
   """
   invoice_number: str = Field(..., min_length=8, max_length=8, pattern=r'^[a-zA-Z0-9]+$')
   vin: str = Field(..., min_length=17, max_length=17, pattern=r'^[A-HJ-NPR-Z0-9]{17}$')
   booking_date: str = Field(..., pattern=r'^\d{4}-\d{2}-\d{2}$')
   booking_time: str = Field(..., pattern=r'^\d{2}:\d{2}$')
   status: str = Field(..., pattern=r'^(booked|on_site|in_progress|completed|cancelled)$')
   created_at: str = Field(default_factory=lambda: datetime.now().isoformat())
   updated_at: str = Field(default_factory=lambda: datetime.now().isoformat())

   def __repr__(self):
       return (f"Booking(invoice_number={self.invoice_number}, "
               f"booking_date={self.booking_date}, booking_time={self.booking_time}, "
               f"status={self.status}, vin={self.vin}, created_at={self.created_at}, updated_at={self.updated_at})")

class Service(BaseModel):
    """
    Validator class for services offered

    These are essentially being used as labels, no write operations will be performed on this table, however there will be
    write operations to booking_services, and booking_services.service has the same constraints as services.name

    This class could also be merged into BookingService, but since there is a separate service table in the database, it
    should have it's own validator.

    parameters
    ------------
        - name:        ['changeover', 'balance', 'repair', 'rotate', 'swap', 'alignment', 'oil change', 'brakes', 'front end']
    """
    service_name: str = Field(..., pattern=r'^(changeover|balance|repair|rotate|swap|alignment|oil change|brakes|front end)$')

class BookingService(Service):
    """
    Validator class for booking services
    NOTE: this is a child class of Services(), so service_name will be validated in accordance

    The services table is essentially a single-column table of 'labels' that defines which services are offered,
    and we can link those services to a booking by placing them beside an invoice number from the booking table
    
    This table essentially 'links' bookings to services, where every service that is assigned to a booking is logged

    parameters
    ------------
        - invoice_number: 8 characters, alphanumeric
        - service_name:   ['changeover', 'balance', 'repair', 'rotate', 'swap', 'alignment', 'oil change', 'brakes', 'front end']
    """
    invoice_number: str = Field(..., min_length=8, max_length=8, pattern=r'^[a-zA-Z0-9]+$')