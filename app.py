# app.py
from flask import Flask, request, jsonify
from pydantic import ValidationError
from backend.db import SchedulerDB
from backend.models import *


app = Flask(__name__)
db = SchedulerDB(dev_mode=True)


@app.route('/api/schedule', methods=['GET'])
def get_schedule():
    today = "2025-06-30"  # or date.today().strftime('%Y-%m-%d')
    schedule = db.select_schedule(today)
    return jsonify(schedule)

@app.route('/api/stats', methods=['GET'])
def get_stats():
    stats = db.select_stats()
    return jsonify(stats)


@app.route('/api/add_customer', methods=['POST'])
def add_customer():
    if request.method == 'POST':
        try:
            # first, validate form data
            customer = Customer(
                name=request.form.get('name'),
                phone=request.form.get('phone'),
                email=request.form.get('email'),
            )

            # if valid, use class object for database operations
            db.insert_customer(customer)
            app.logger.info(f"Customer added: {customer.name}, {customer.phone}, {customer.email}")

            return jsonify({
                "success": True,
                "message": "Customer created successfully",
                "data": customer.model_dump(mode="json")
            }), 201

        except ValidationError as e:
            app.logger.error(f"Validation error: {e}")
            return str(e), 400


@app.route('/api/add_vehicle', methods=['GET', 'POST'])
def add_vehicle():
    if request.method == 'POST':
        try:
            # first, validate form data
            vehicle = Vehicle(
                phone=request.form.get('phone'),
                vin=request.form.get('vin'),
                year=int(request.form.get('year')),
                make=request.form.get('make'),
                model=request.form.get('model'),
                plate=request.form.get('plate'),
                mileage=int(request.form.get('mileage')),
            )

            # if valid, use class object for database operations
            db.insert_vehicle(vehicle)
            app.logger.info(f"Vehicle added: {vehicle}")

            return jsonify({
                "success": True,
                "message": "Vehicle created successfully",
                "data": vehicle.model_dump(mode="json")
            }), 201

        except ValidationError as e:
            app.logger.error(f"Validation error: {e}")
            return str(e), 400

@app.route('/api/add_booking', methods=['POST'])
def add_booking():
    if request.method == 'POST':
        try:
            # first, validate form data
            booking = Bookings(
                invoice_number=request.form.get('invoice_number'),
                vin=request.form.get('vin'),
                booking_date=request.form.get('booking_date'),
                booking_time=request.form.get('booking_time'),
                booking_duration=request.form.get('booking_duration'),
                status=request.form.get('status', 'booked'),
            )
            #  services=request.form.getlist('services'),

            # then, validate all services being booked
            booked_services = []
            for service_name in request.form.getlist('services'):
                booked_services.append(BookingService(
                        invoice_number=booking.invoice_number,
                        service_name=service_name.strip()
                ))

            # if valid, use class object for database operations
            db.insert_booking(booking, booked_services)
            app.logger.info(f"Booking added: {booking.invoice_number}, {[bs.service_name for bs in booked_services]}")

            return jsonify({
                "success": True,
                "message": "Booking  added successfully",
                "data": {
                    **booking.model_dump(mode="json"),
                    "services": [bs.service_name for bs in booked_services]
                }
            }), 201

        except ValidationError as e:
            app.logger.error(f"Validation error: {e}")
            return str(e), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
