# app.py
from flask import Flask, render_template
from backend import SchedulerDB

app = Flask(__name__)
db = SchedulerDB(development=True)

@app.route('/')
def dashboard():
    today = "2025-06-30"  # or date.today().strftime('%Y-%m-%d')
    schedule = db.get_daily_schedule(today)
    return render_template('frontend/dashboard.html', schedule=schedule)


@app.route('/new_customer', methods=['GET', 'POST'])
def new_customer():
    return render_template('frontend/new_customer.html')

@app.route('/new_vehicle', methods=['GET', 'POST'])
def new_vehicle():
    phone = request.form.get('phone')
    return render_template('frontend/new_vehicle.html', phone=phone)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)