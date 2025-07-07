
from pydantic import BaseModel, EmailStr, Field, field_validator
from typing import Optional
from datetime import datetime

	
class Customer(BaseModel):
	"""
	Validator class for customer information

	parameters
	------------
		- phone:        exactly 10 digits
		- name:         2-100 characters, letters/spaces/hyphens only
		- email:        proper email format (optional)
		- created_at:   ISO 8601 date format (auto-generated)
		- updated_at:   ISO 8601 date format (auto-generated)
	"""
	phone: str = Field(..., min_length=10, max_length=10, pattern=r'^\d{10}$')
	name: str = Field(..., min_length=2, max_length=100, pattern=r'^[a-zA-Z\s\-\.]+$')
	email: Optional[EmailStr] = Field(default=None)
	created_at: str = Field(default_factory=lambda: datetime.now().isoformat())
	updated_at: str = Field(default_factory=lambda: datetime.now().isoformat())

	def __repr__(self):
		return (
			f"{self.name}\n{self.phone}\n{self.email})"
			f"created {self.created_at}, updated {self.updated_at})"
		)


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
		- created_at:   ISO 8601 date format (auto-generated)
		- updated_at:   ISO 8601 date format (auto-generated)
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
		return (
			f"{self.year} {self.make} {self.model}\n"
			f"{self.phone}: {self.vin}\n"
			f"{self.plate} ({self.mileage})km\n"
			f"created {self.created_at}, updated {self.updated_at})"
		)

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

	def __repr__(self):
		return self.service_name
	
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
		- service:   Service()
	"""
	invoice_number: str = Field(..., min_length=8, max_length=8, pattern=r'^[a-zA-Z0-9]+$')

	def __repr__(self):
		return f"{self.invoice_number}: {self.service_name}"


class Booking(BaseModel):
	"""
	Validator class for bookings

	parameters
	------------
		- invoice_number:   8 characters, alphanumeric
		- vin:              17 characters, alphanumeric except for I, O, Q
		- booking_date:     ISO 8601 date format
		- booking_time:     ISO 8601 time format
		- booking_duration: integer, 30 to 480 minutes
		- status:           ['booked', 'on_site', 'in_progress', 'completed', 'cancelled']
		- services:         list of BookingService() objects
		- created_at:       ISO 8601 date format (auto-generated)
		- updated_at:       ISO 8601 date format (auto-generated)
	"""
	invoice_number: str = Field(..., min_length=8, max_length=8, pattern=r'^[a-zA-Z0-9]+$')
	vin: str = Field(..., min_length=17, max_length=17, pattern=r'^[A-HJ-NPR-Z0-9]{17}$')
	booking_date: str = Field(..., pattern=r'^\d{4}-\d{2}-\d{2}$')
	booking_time: str = Field(..., pattern=r'^\d{2}:\d{2}$')
	booking_duration: Optional[int] = Field(default=60, ge=30, le=480)
	status: str = Field(default='booked', pattern=r'^(booked|on_site|in_progress|completed|cancelled)$')
	services: list[BookingService] = Field(...)
	created_at: str = Field(default_factory=lambda: datetime.now().isoformat())
	updated_at: str = Field(default_factory=lambda: datetime.now().isoformat())


	@classmethod
	@field_validator('booking_duration')
	def _validate_booking_duration(cls, duration):
		"""
		Validator function to ensure that booking duration is a multiple of 15mins
		between 30 and 480 minutes (8 hours)
		"""
		if not duration:
			return 60

		if duration < 30 or duration > 480:
			raise ValueError("Booking duration must be between 30 and 480 minutes")

		if duration % 15 != 0:
			raise ValueError("Booking duration must be a multiple of 15 minutes")

		return duration


	def __repr__(self):
		return (
			f"{self.invoice_number}: {[bs.service_name for bs in self.services]}\n"
			f"{self.vin}\n"
			f"{self.status}: {self.booking_date} at {self.booking_time}\n"
			f"created {self.created_at}, updated {self.updated_at})"
		)
