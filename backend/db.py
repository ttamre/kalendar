import sqlite3
from datetime import date

class SchedulerDB:
    def __init__(self, db_path="resources/database.db", development=False):
        self.db_path = db_path
        self._init_database(development)

    def _init_database(self, development):
        """Initialize database with schema and sample data"""
        conn = sqlite3.connect(self.db_path)
        
        # Execute init.sql
        with open('resources/init.sql', 'r') as f:
            conn.executescript(f.read())

        # Execute sample_data.sql if in development mode
        if development:
            with open('resources/sample_data.sql', 'r') as f:
                conn.executescript(f.read())

        conn.close()
    
    
    def get_daily_schedule(self, date_str):
        """Get schedule for a specific date"""
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row  # Dict-like access
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM schedule 
            WHERE booking_date = ? 
            ORDER BY booking_time
        """, (date_str,))
        
        results = cursor.fetchall()
        conn.close()
        return [dict(row) for row in results]

    def get_detailed_appointment(self, invoice_number):
        """Get detailed information about a specific appointment"""
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row  # Dict-like access
        
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM detailed_view 
            WHERE invoice_number = ?
        """, (invoice_number,))

        result = cursor.fetchone()
        conn.close()
        return dict(result) if result else None

# Usage
# db = SchedulerDB()
# today_schedule = db.get_daily_schedule("2025-06-30")
# for appointment in today_schedule:
#     print(f"{appointment['booking_time']} - {appointment['name']} ({appointment['services']})")

# print()
# for i in range(5):
#     appointment_details = db.get_detailed_appointment(f"INV0000{i+1}")
#     if appointment_details:
#         print(f"Appointment ID: {appointment_details['invoice_number']}")
#         print(f"Name: {appointment_details['name']}")
#         print(f"Phone: {appointment_details['phone']}")
#         print(f"Email: {appointment_details['email']}")
#         print(f"VIN: {appointment_details['vin']}")
#         print(f"Services: {appointment_details['services']}")
#         print("----------------------")