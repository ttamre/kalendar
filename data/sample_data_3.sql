/**
 * sample_data.sql - populate database with realistic sample data
 * 
 * Revised version with:
 * - Dynamic date generation for current and next week's weekdays
 * - AL4 service appointments added
 * - Fixed 6pm violations (all appointments end by 6pm)
 * - All other constraints maintained
 */

-- ==================
-- SAMPLE DATA
-- ==================

-- CUSTOMERS
INSERT OR IGNORE INTO customers (phone, name, email) VALUES
('5551234567', 'John Mitchell', 'john.mitchell@email.com'),
('5552345678', 'Sarah Johnson', 'sarah.johnson@gmail.com'),
('5553456789', 'Mike Rodriguez', ''),
('5554567890', 'Emily Chen', 'emily.chen@outlook.com'),
('5555678901', 'David Thompson', 'david.thompson@email.com'),
('5556789012', 'Lisa Wilson', 'lisa.wilson@gmail.com'),
('5557890123', 'Robert Brown', 'robert.brown@yahoo.com'),
('5558901234', 'Jennifer Davis', 'jennifer.davis@outlook.com'),
('5559012345', 'Michael Garcia', 'michael.garcia@email.com'),
('5550123456', 'Amanda Martinez', ''),
('5551357908', 'Chris Anderson', 'chris.anderson@yahoo.com'),
('5552468097', 'Nicole Taylor', 'nicole.taylor@outlook.com'),
('5553691470', 'Kevin White', ''),
('5554702581', 'Rachel Green', 'rachel.green@gmail.com'),
('5555813692', 'Daniel Lee', 'daniel.lee@yahoo.com'),
('5556924703', 'Ashley Clark', 'ashley.clark@outlook.com'),
('5557035814', 'Jason Hall', ''),
('5558146925', 'Melissa Young', 'melissa.young@gmail.com'),
('5559258036', 'Brandon King', 'brandon.king@yahoo.com'),
('5550369147', 'Stephanie Wright', 'stephanie.wright@outlook.com');

-- VEHICLES
INSERT OR IGNORE INTO vehicles (vin, phone, year, make, model, plate, mileage) VALUES
('1HGBH41JXMN109186', '5551234567', 2020, 'Honda', 'Civic', 'ABC123', 25000),
('1FTFW1ET5DFC10312', '5552345678', 2019, 'Ford', 'F-150', 'XYZ789', 45000),
('1G1BE5SM7H7123456', '5553456789', 2017, 'Chevrolet', 'Cruze', 'DEF456', 38000),
('3VW467AT8HM123789', '5554567890', 2017, 'Volkswagen', 'Jetta', 'GHI789', 32000),
('1N4AL3AP0HC123456', '5555678901', 2017, 'Nissan', 'Altima', 'JKL012', 41000),
('KMHD14LA2HA123456', '5556789012', 2017, 'Hyundai', 'Elantra', 'MNO345', 29000),
('JM1BK32F781123456', '5557890123', 2008, 'Mazda', 'Mazda3', 'PQR678', 85000),
('1FMCU0F70HUC12345', '5558901234', 2017, 'Ford', 'Escape', 'STU901', 52000),
('5NPE34AF4HH123456', '5559012345', 2017, 'Hyundai', 'Sonata', 'VWX234', 47000),
('2T1BURHE0HC123456', '5550123456', 2017, 'Toyota', 'Corolla', 'YZA567', 35000),
('1C4RJFAG8HC123456', '5551357908', 2017, 'Jeep', 'Cherokee', 'BCD890', 58000),
('3CZRU5H38HM123456', '5552468097', 2017, 'Honda', 'Pilot', 'EFG123', 44000),
('WBAJA7C58HWF12345', '5553691470', 2017, 'BMW', '328i', 'HIJ456', 31000),
('1GKKNPLS8HZ123456', '5554702581', 2017, 'GMC', 'Acadia', 'KLM789', 49000),
('1FMHK8F84HGA12345', '5555813692', 2017, 'Ford', 'Explorer', 'NOP012', 55000),
('KNDJP3A57H7123456', '5556924703', 2017, 'Kia', 'Sorento', 'QRS345', 42000),
('1GCCS14E8H8123456', '5557035814', 2017, 'Chevrolet', 'Silverado', 'TUV678', 63000),
('2C3CDZAG8HH123456', '5558146925', 2017, 'Dodge', 'Charger', 'WXY901', 39000),
('1FA6P8TH7H5123456', '5559258036', 2017, 'Ford', 'Mustang', 'ZAB234', 28000),
('1C6SRFFT8HN123456', '5550369147', 2017, 'Ram', '1500', 'CDE567', 71000);

-- Function to generate weekdays for current and next week
WITH RECURSIVE dates(date) AS (
  SELECT DATE('now', 'weekday 0', '-7 days') -- Start from last Sunday
  UNION ALL
  SELECT DATE(date, '+1 day')
  WHERE date < DATE('now', 'weekday 0', '+13 days') -- Go 2 weeks ahead
),
weekdays AS (
  SELECT date 
  FROM dates 
  WHERE strftime('%w', date) BETWEEN '1' AND '5' -- Monday to Friday
  ORDER BY date
),
booking_slots AS (
  SELECT 
    date as booking_date,
    CASE 
      WHEN row_number() OVER (PARTITION BY date) % 4 = 0 THEN '08:00'
      WHEN row_number() OVER (PARTITION BY date) % 4 = 1 THEN '10:00'
      WHEN row_number() OVER (PARTITION BY date) % 4 = 2 THEN '13:00'
      ELSE '15:00'
    END as booking_time,
    CASE 
      WHEN row_number() OVER (PARTITION BY date) % 3 = 0 THEN 60
      WHEN row_number() OVER (PARTITION BY date) % 3 = 1 THEN 90
      ELSE 120
    END as booking_duration,
    row_number() OVER () as slot_num
  FROM weekdays
  CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) as slots
  WHERE booking_time <= '16:00' -- Ensure all appointments end by 6pm
  LIMIT 100 -- Limit total appointments
)

-- BOOKINGS with dynamic dates
INSERT OR IGNORE INTO bookings (invoice_number, vin, booking_date, booking_time, booking_duration, status)
SELECT 
  'INV' || substr('00000' || slot_num, -5) as invoice_number,
  CASE 
    WHEN slot_num % 20 = 0 THEN '1HGBH41JXMN109186'
    WHEN slot_num % 20 = 1 THEN '1FTFW1ET5DFC10312'
    WHEN slot_num % 20 = 2 THEN '1G1BE5SM7H7123456'
    WHEN slot_num % 20 = 3 THEN '3VW467AT8HM123789'
    WHEN slot_num % 20 = 4 THEN '1N4AL3AP0HC123456'
    WHEN slot_num % 20 = 5 THEN 'KMHD14LA2HA123456'
    WHEN slot_num % 20 = 6 THEN 'JM1BK32F781123456'
    WHEN slot_num % 20 = 7 THEN '1FMCU0F70HUC12345'
    WHEN slot_num % 20 = 8 THEN '5NPE34AF4HH123456'
    WHEN slot_num % 20 = 9 THEN '2T1BURHE0HC123456'
    WHEN slot_num % 20 = 10 THEN '1C4RJFAG8HC123456'
    WHEN slot_num % 20 = 11 THEN '3CZRU5H38HM123456'
    WHEN slot_num % 20 = 12 THEN 'WBAJA7C58HWF12345'
    WHEN slot_num % 20 = 13 THEN '1GKKNPLS8HZ123456'
    WHEN slot_num % 20 = 14 THEN '1FMHK8F84HGA12345'
    WHEN slot_num % 20 = 15 THEN 'KNDJP3A57H7123456'
    WHEN slot_num % 20 = 16 THEN '1GCCS14E8H8123456'
    WHEN slot_num % 20 = 17 THEN '2C3CDZAG8HH123456'
    WHEN slot_num % 20 = 18 THEN '1FA6P8TH7H5123456'
    ELSE '1C6SRFFT8HN123456'
  END as vin,
  booking_date,
  booking_time,
  booking_duration,
  CASE 
    WHEN slot_num % 5 = 0 THEN 'completed'
    WHEN slot_num % 5 = 1 THEN 'in_progress'
    WHEN slot_num % 5 = 2 THEN 'on_site'
    WHEN slot_num % 5 = 3 THEN 'booked'
    ELSE 'cancelled'
  END as status
FROM booking_slots;

-- BOOKING SERVICES with AL4 appointments
INSERT OR IGNORE INTO booking_services (invoice_number, service_name)
SELECT 
  b.invoice_number,
  CASE 
    WHEN b.invoice_number IN ('INV00005', 'INV00015', 'INV00025', 'INV00035', 'INV00045') THEN 'al4'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 0 THEN 'changeover'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 1 THEN 'balance'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 2 THEN 'rotate'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 3 THEN 'oil change'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 4 THEN 'front end'
    WHEN row_number() OVER (PARTITION BY b.invoice_number) % 7 = 5 THEN 'brakes'
    ELSE 'swap'
  END as service_name
FROM bookings b
WHERE b.invoice_number IN (
  SELECT invoice_number FROM bookings ORDER BY RANDOM() LIMIT (SELECT COUNT(*) FROM bookings) * 0.8
);

-- Add AL4 to specific appointments
INSERT OR IGNORE INTO booking_services (invoice_number, service_name)
VALUES 
('INV00005', 'al4'),
('INV00015', 'al4'),
('INV00025', 'al4'),
('INV00035', 'al4'),
('INV00045', 'al4');

-- Ensure all AL4 appointments have at least one other service
INSERT OR IGNORE INTO booking_services (invoice_number, service_name)
SELECT 
  bs.invoice_number,
  CASE 
    WHEN bs.service_name = 'al4' THEN 'oil change'
    ELSE bs.service_name
  END
FROM booking_services bs
WHERE bs.invoice_number IN (
  SELECT invoice_number FROM booking_services WHERE service_name = 'al4'
)
AND NOT EXISTS (
  SELECT 1 FROM booking_services bs2 
  WHERE bs2.invoice_number = bs.invoice_number 
  AND bs2.service_name != 'al4'
);

-- ==================
-- VERIFICATION QUERIES
-- ==================

-- Check date range (should show current and next week's weekdays)
SELECT DISTINCT booking_date, strftime('%w', booking_date) as day_of_week 
FROM bookings 
ORDER BY booking_date;

-- Check for 6pm violations (should return 0 rows)
SELECT invoice_number, vin, booking_date, booking_time, booking_duration,
       TIME(booking_time, '+' || booking_duration || ' minutes') as end_time
FROM bookings 
WHERE TIME(booking_time, '+' || booking_duration || ' minutes') > '18:00';

-- Check AL4 appointments
SELECT b.invoice_number, b.booking_date, b.booking_time, 
       GROUP_CONCAT(bs.service_name, ', ') as services
FROM bookings b
JOIN booking_services bs ON b.invoice_number = bs.invoice_number
WHERE bs.service_name = 'al4'
GROUP BY b.invoice_number;

-- Check service distribution
SELECT service_name, COUNT(*) as count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM booking_services), 1) as percentage
FROM booking_services 
GROUP BY service_name 
ORDER BY count DESC;