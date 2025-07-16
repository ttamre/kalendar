import sqlite3
import os
from contextlib import contextmanager


class SchedulerDB:
    def __init__(self, dev_mode=False):
        self.dev_mode = dev_mode
        self.data_dir = os.path.join(
            os.path.dirname(__file__), os.path.pardir, "data")
        self.db_path = os.path.join(self.data_dir, "database.db")
        self._init_database()

    # ==============
    # private methods
    # ==============

    @contextmanager
    def _connect(self):
        """
        Establish a connection to sqlite3 database
        """
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row

        # assign connection object, then close connection after use
        try:
            yield conn
        finally:
            conn.close()

    def _init_database(self):
        """
        Create database using pre-defined schema
        in development mode, this will also insert sample data
        """

        # Get paths to SQL files using data directory
        init_path = os.path.join(self.data_dir, "init.sql")
        data_path = os.path.join(self.data_dir, "sample_data.sql")

        with self._connect() as conn:
            # create tables
            with open(init_path, 'r') as f:
                conn.executescript(f.read())

            # add sample data if in dev mode
            if self.dev_mode:
                with open(data_path, 'r') as f:
                    conn.executescript(f.read())

    # ==============
    # public methods
    # ==============

    def select_schedule(self, date_str):
        """
        Get schedule for a specific date

        returns:
        --------
            list: list of appointments for the given date
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT * FROM schedule 
                WHERE booking_date = ? 
            ORDER BY booking_time
            """, (date_str,))

            results = cursor.fetchall()
            return [dict(row) for row in results]
    
        
    def select_stats(self):
        """
        Get summary statistics for services offered

        returns:
        --------
            list: list of service records
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""SELECT * FROM stats""")

            results = cursor.fetchall()
            return [dict(row) for row in results]
        
    def select_customer(self, phone):
        """
        Get customer information by phone number
        can also used to check if a customer exists

        returns:
        --------
            dict: customer information if found, None otherwise
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT * FROM customers 
                WHERE phone = ?
            """, (phone,))

            result = cursor.fetchone()
            return dict(result) if result else None

    def select_vehicle(self, vin):
        """
        Get vehicle information by VIN
        can also used to check if a vehicle exists

        returns:
        --------
            dict: vehicle information if found, None otherwise
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT * FROM vehicles
                WHERE vin = ?
            """, (vin,))

            result = cursor.fetchone()
            return dict(result) if result else None

    def select_booking(self, invoice_number):
        """
        Get detailed information about a specific booking

        returns:
        --------
            dict: booking information if found, None otherwise
        """
        with self._connect() as conn:

            cursor = conn.cursor()
            cursor.execute("""
                SELECT * FROM detailed_view 
                WHERE invoice_number = ?
            """, (invoice_number,))

            result = cursor.fetchone()
            return dict(result) if result else None
    
    def select_bookings(self):
        """
        Get detailed information about a specific booking

        returns:
        --------
            list[dict]: all booking
        """
        with self._connect() as conn:

            cursor = conn.cursor()
            cursor.execute("SELECT * FROM detailed_view")

            results = cursor.fetchall()
            return [dict(row) for row in results]


    def insert_customer(self, customer):
        """
        Insert a new customer into the database

        parameters:
        ------------
            customer: Customer object containing the following validated fields:
                - phone
                - name
                - email
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO customers(phone, name, email) VALUES (?, ?, ?)
            """, (customer.phone, customer.name, customer.email))
            conn.commit()

    def insert_vehicle(self, vehicle):
        """
        Insert a new vehicle into the database

        parameters:
        ------------
            vehicle: Vehicle object containing the following validated fields:
                - phone
                - vin
                - year
                - make
                - model
                - plate
                - mileage
                - created_at
                - updated_at
        """
        with self._connect() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO vehicles(phone, vin, year, make, model, plate, mileage, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (vehicle.phone, vehicle.vin, vehicle.year, vehicle.make, vehicle.model, vehicle.plate, vehicle.mileage, vehicle.created_at, vehicle.updated_at))
            conn.commit()

    def insert_booking(self, booking):
        with self._connect() as conn:
            cursor = conn.cursor()

            # first, query the booking insertion
            cursor.execute("""
                INSERT INTO bookings(invoice_number, vin, booking_date, booking_time, booking_duration, status)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (booking.invoice_number, booking.vin, booking.booking_date, booking.booking_time, booking.booking_duration, booking.status))
            
            # then, query insertion for the services for the booking
            for service in booking.services:
                cursor.execute("""
                    INSERT INTO booking_services(invoice_number, service_name)
                    VALUES(?, ?)""", (service.invoice_number, service.service_name))
                
            # then, commit the entire transaction
            conn.commit()


    def delete_booking(self, invoice_number):
        with self._connect() as conn:
            cursor = conn.cursor()

            cursor.execute("""
                DELETE FROM bookings
                WHERE invoice_number = ?
            """, (invoice_number,))

            cursor.execute("""
                DELETE FROM booking_services
                WHERE invoice_number = ?
            """, (invoice_number,))

            conn.commit()


db = SchedulerDB(dev_mode=True)