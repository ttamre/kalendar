/**
    * init.sq - initialize fresh db

    * author: Tem Tamre
    * contact: temtamre@gmail.com

    * customers (identified by phone number) own vehicles (identified by VIN)
    * vehicles have bookings (identified by invoice number)
**/


-- ==================
-- SCHEMA
-- ==================

-- CUSTOMER TABLE
-- contains customer contact info
CREATE TABLE IF NOT EXISTS customers (
    phone VARCHAR(10) PRIMARY KEY CHECK(LENGTH(phone) = 10),

    name TEXT NOT NULL,
    email TEXT UNIQUE CHECK(email LIKE '%@%.%'),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VEHICLES TABLE
-- contains owner's phone number and vehicle information
CREATE TABLE IF NOT EXISTS vehicles (
    vin VARCHAR(17) PRIMARY KEY CHECK(LENGTH(vin) = 17),
    phone VARCHAR(10) NOT NULL CHECK(LENGTH(phone) = 10),

    -- year must be between 1900 and current year + 1 (checked at application level)
    year INT NOT NULL CHECK(year >= 1900),
    make TEXT NOT NULL,
    model TEXT NOT NULL,
    plate TEXT UNIQUE NOT NULL,
    mileage INT DEFAULT 0 CHECK(mileage >= 0),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (phone) REFERENCES customers(phone) ON DELETE CASCADE
);

-- BOOKINGS TABLE
-- contains vehicle's vin and booking information (owner info accessible from vehicle)
CREATE TABLE IF NOT EXISTS bookings (
    invoice_number VARCHAR(8) PRIMARY KEY CHECK(LENGTH(invoice_number) = 8),
    vin VARCHAR(17) NOT NULL CHECK(LENGTH(vin) = 17),

    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    booking_duration INT NOT NULL CHECK(booking_duration > 0 AND booking_duration <= 480), -- max 8 hours
    status TEXT CHECK(status IN ('booked', 'on_site', 'in_progress', 'completed', 'cancelled')) DEFAULT 'booked',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vin) REFERENCES vehicles(vin) ON DELETE CASCADE
);

-- SERVICES TABLE
-- contains list of services offered
-- has it's own table to allow for multiple services per booking
CREATE TABLE IF NOT EXISTS services (
    service_name TEXT PRIMARY KEY CHECK(service_name IN (
        'changeover', 'balance', 'repair', 'rotate', 'swap',
        'alignment', 'oil change', 'brakes', 'front end'
    ))
);

INSERT OR IGNORE INTO services (service_name) VALUES
('changeover'), ('balance'), ('repair'), ('rotate'), ('swap'),
('alignment'), ('oil change'), ('brakes'), ('front end');

-- BOOKING SERVICES TABLE
-- connects services to bookings, where 1 booking can have multiple services
-- since services are being used as a "label" and not a unique item, 1 service can apply to multiple bookings
CREATE TABLE IF NOT EXISTS booking_services (
    invoice_number VARCHAR(8),
    service_name TEXT,

    PRIMARY KEY (invoice_number, service_name),
    FOREIGN KEY (invoice_number) REFERENCES bookings(invoice_number) ON DELETE CASCADE,
    FOREIGN KEY (service_name) REFERENCES services(service_name) ON DELETE CASCADE
);


-- ==================
-- TRIGGERS
-- ==================

-- auto-update the updated_at timestamp when customer data is updated
CREATE TRIGGER IF NOT EXISTS update_customers_timestamp
    AFTER UPDATE ON customers
    BEGIN
        UPDATE customers SET updated_at = CURRENT_TIMESTAMP WHERE phone = NEW.phone;
    END;

-- auto-update the updated_at timestamp when vehicle data is updated
CREATE TRIGGER IF NOT EXISTS update_vehicles_timestamp
    AFTER UPDATE ON vehicles
    BEGIN
        UPDATE vehicles SET updated_at = CURRENT_TIMESTAMP WHERE vin = NEW.vin;
    END;

-- auto-update the updated_at timestamp when booking data is updated
CREATE TRIGGER IF NOT EXISTS update_bookings_timestamp
    AFTER UPDATE ON bookings
    BEGIN
        UPDATE bookings SET updated_at = CURRENT_TIMESTAMP WHERE invoice_number = NEW.invoice_number;
    END;




-- ==================
-- INDEXES
-- ==================
CREATE INDEX IF NOT EXISTS idx_customers ON customers(phone);
CREATE INDEX IF NOT EXISTS idx_vehicles ON vehicles(phone, vin);
CREATE INDEX IF NOT EXISTS idx_bookings ON bookings(vin);


-- ==================
-- VIEWS   
-- ==================

-- schedule view for shop operations
-- use case(s): daily appointments, list appointments for specific customer
CREATE VIEW IF NOT EXISTS schedule AS
SELECT 
    -- identifying info
    b.invoice_number,
    b.vin,
    v.phone,

    -- position info
    b.booking_date,
    b.booking_time,
    b.booking_duration,
    b.status,

    -- displayed info
    c.name,
    GROUP_CONCAT(bs.service_name, ', ') AS services

FROM bookings b
JOIN vehicles v ON b.vin = v.vin
JOIN customers c ON v.phone = c.phone
LEFT JOIN booking_services bs ON b.invoice_number = bs.invoice_number
GROUP BY b.invoice_number
ORDER BY b.booking_date, b.booking_time;

-- fetch relevant customer, booking, and vehicle info
-- use case(s): detailed appointment view, invoices, work orders
CREATE VIEW IF NOT EXISTS detailed_view AS
SELECT 
    -- customer info
    c.name,
    c.phone,
    c.email,

    -- booking info
    b.invoice_number,
    b.booking_date,
    b.booking_time,
    b.booking_duration,
    b.status,

    -- vehicle info
    v.vin,
    v.year,
    v.make,
    v.model,
    v.plate,
    v.mileage,

    -- service info
    -- GROUP_CONCAT() and GROUP_BY() allow for multiple services per booking
    GROUP_CONCAT(bs.service_name, ', ') AS services

FROM bookings b
JOIN vehicles v ON b.vin = v.vin
JOIN customers c ON v.phone = c.phone
LEFT JOIN booking_services bs ON b.invoice_number = bs.invoice_number
GROUP BY b.invoice_number;

-- service statistics view
CREATE VIEW IF NOT EXISTS stats AS
WITH service_counts AS (  -- define a CTE (basically a "table of variables")
    SELECT 
        bs.service_name,
        COUNT(*) as total_bookings,
        COUNT(CASE WHEN b.status = 'booked' THEN 1 END) as booked,
        COUNT(CASE WHEN b.status IN ('on_site', 'in_progress') THEN 1 END) as at_shop,
        COUNT(CASE WHEN b.status = 'completed' THEN 1 END) as completed,
        COUNT(CASE WHEN b.status = 'cancelled' THEN 1 END) as cancelled
    FROM booking_services bs
    JOIN bookings b ON bs.invoice_number = b.invoice_number
    GROUP BY bs.service_name
)
SELECT  -- then, we can select from those variables
    service_name as service,
    booked,
    at_shop,
    completed,
    cancelled,
    total_bookings,
    ROUND((cancelled * 100.0) / total_bookings, 0) as cancellation_rate
FROM service_counts;