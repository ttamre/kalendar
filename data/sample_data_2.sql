/**
 * sample_data.sql - populate database with realistic sample data
 * 
 * Expanded version with:
 * - 3x more appointments (~150 total)
 * - Varied status distribution (not just 'completed')
 * - Includes cancelled appointments
 * - Maintains all schema and business constraints
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

-- BOOKINGS (150 appointments with varied statuses)
-- June 30 (Monday) - 45 appointments
INSERT OR IGNORE INTO bookings (invoice_number, vin, booking_date, booking_time, booking_duration, status) VALUES
('INV00001', '1HGBH41JXMN109186', '2025-06-30', '08:00', 30, 'completed'),
('INV00002', '1FTFW1ET5DFC10312', '2025-06-30', '08:00', 60, 'in_progress'),
('INV00003', '1G1BE5SM7H7123456', '2025-06-30', '08:30', 90, 'on_site'),
('INV00004', '3VW467AT8HM123789', '2025-06-30', '09:00', 30, 'cancelled'),
('INV00005', '1N4AL3AP0HC123456', '2025-06-30', '09:00', 60, 'in_progress'),
('INV00006', 'KMHD14LA2HA123456', '2025-06-30', '09:30', 30, 'booked'),
('INV00007', 'JM1BK32F781123456', '2025-06-30', '10:00', 30, 'completed'),
('INV00008', '1FMCU0F70HUC12345', '2025-06-30', '10:00', 60, 'on_site'),
('INV00009', '5NPE34AF4HH123456', '2025-06-30', '10:30', 30, 'in_progress'),
('INV00010', '2T1BURHE0HC123456', '2025-06-30', '10:30', 60, 'completed'),
('INV00011', '1C4RJFAG8HC123456', '2025-06-30', '11:00', 30, 'booked'),
('INV00012', '3CZRU5H38HM123456', '2025-06-30', '11:00', 90, 'on_site'),
('INV00013', 'WBAJA7C58HWF12345', '2025-06-30', '11:30', 30, 'completed'),
('INV00014', '1GKKNPLS8HZ123456', '2025-06-30', '11:30', 60, 'cancelled'),
('INV00015', '1FMHK8F84HGA12345', '2025-06-30', '13:00', 30, 'in_progress'),
('INV00016', 'KNDJP3A57H7123456', '2025-06-30', '13:00', 60, 'completed'),
('INV00017', '1GCCS14E8H8123456', '2025-06-30', '13:30', 30, 'on_site'),
('INV00018', '2C3CDZAG8HH123456', '2025-06-30', '13:30', 90, 'booked'),
('INV00019', '1FA6P8TH7H5123456', '2025-06-30', '14:00', 30, 'completed'),
('INV00020', '1C6SRFFT8HN123456', '2025-06-30', '14:00', 60, 'in_progress'),
('INV00021', '1HGBH41JXMN109186', '2025-06-30', '14:30', 30, 'on_site'),
('INV00022', '1FTFW1ET5DFC10312', '2025-06-30', '14:30', 60, 'completed'),
('INV00023', '1G1BE5SM7H7123456', '2025-06-30', '15:00', 30, 'booked'),
('INV00024', '3VW467AT8HM123789', '2025-06-30', '15:00', 90, 'in_progress'),
('INV00025', '1N4AL3AP0HC123456', '2025-06-30', '15:30', 30, 'on_site'),
('INV00026', 'KMHD14LA2HA123456', '2025-06-30', '15:30', 60, 'completed'),
('INV00027', 'JM1BK32F781123456', '2025-06-30', '16:00', 30, 'cancelled'),
('INV00028', '1FMCU0F70HUC12345', '2025-06-30', '16:00', 60, 'in_progress'),
('INV00029', '5NPE34AF4HH123456', '2025-06-30', '16:30', 30, 'completed'),
('INV00030', '2T1BURHE0HC123456', '2025-06-30', '16:30', 90, 'on_site'),
('INV00031', '1C4RJFAG8HC123456', '2025-06-30', '17:00', 30, 'booked'),
('INV00032', '3CZRU5H38HM123456', '2025-06-30', '17:00', 60, 'in_progress'),
('INV00033', 'WBAJA7C58HWF12345', '2025-06-30', '08:30', 30, 'completed'),
('INV00034', '1GKKNPLS8HZ123456', '2025-06-30', '09:30', 60, 'on_site'),
('INV00035', '1FMHK8F84HGA12345', '2025-06-30', '10:30', 30, 'cancelled'),
('INV00036', 'KNDJP3A57H7123456', '2025-06-30', '11:00', 60, 'completed'),
('INV00037', '1GCCS14E8H8123456', '2025-06-30', '13:00', 90, 'in_progress'),
('INV00038', '2C3CDZAG8HH123456', '2025-06-30', '14:00', 30, 'on_site'),
('INV00039', '1FA6P8TH7H5123456', '2025-06-30', '15:00', 60, 'completed'),
('INV00040', '1C6SRFFT8HN123456', '2025-06-30', '16:00', 30, 'booked'),
('INV00041', '1HGBH41JXMN109186', '2025-06-30', '17:00', 90, 'in_progress'),
('INV00042', '1FTFW1ET5DFC10312', '2025-06-30', '08:00', 30, 'on_site'),
('INV00043', '1G1BE5SM7H7123456', '2025-06-30', '09:00', 60, 'completed'),
('INV00044', '3VW467AT8HM123789', '2025-06-30', '10:00', 30, 'cancelled'),
('INV00045', '1N4AL3AP0HC123456', '2025-06-30', '11:00', 60, 'in_progress'),

-- July 2 (Wednesday) - 45 appointments
('INV00046', 'KMHD14LA2HA123456', '2025-07-02', '08:00', 30, 'completed'),
('INV00047', 'JM1BK32F781123456', '2025-07-02', '08:00', 60, 'on_site'),
('INV00048', '1FMCU0F70HUC12345', '2025-07-02', '08:30', 30, 'in_progress'),
('INV00049', '5NPE34AF4HH123456', '2025-07-02', '08:30', 90, 'booked'),
('INV00050', '2T1BURHE0HC123456', '2025-07-02', '09:00', 30, 'completed'),
('INV00051', '1C4RJFAG8HC123456', '2025-07-02', '09:00', 60, 'cancelled'),
('INV00052', '3CZRU5H38HM123456', '2025-07-02', '09:30', 30, 'in_progress'),
('INV00053', 'WBAJA7C58HWF12345', '2025-07-02', '10:00', 60, 'on_site'),
('INV00054', '1GKKNPLS8HZ123456', '2025-07-02', '10:00', 30, 'completed'),
('INV00055', '1FMHK8F84HGA12345', '2025-07-02', '10:30', 90, 'booked'),
('INV00056', 'KNDJP3A57H7123456', '2025-07-02', '11:00', 30, 'in_progress'),
('INV00057', '1GCCS14E8H8123456', '2025-07-02', '11:00', 60, 'completed'),
('INV00058', '2C3CDZAG8HH123456', '2025-07-02', '11:30', 30, 'on_site'),
('INV00059', '1FA6P8TH7H5123456', '2025-07-02', '11:30', 60, 'cancelled'),
('INV00060', '1C6SRFFT8HN123456', '2025-07-02', '13:00', 30, 'completed'),
('INV00061', '1HGBH41JXMN109186', '2025-07-02', '13:00', 60, 'in_progress'),
('INV00062', '1FTFW1ET5DFC10312', '2025-07-02', '13:30', 30, 'on_site'),
('INV00063', '1G1BE5SM7H7123456', '2025-07-02', '13:30', 90, 'booked'),
('INV00064', '3VW467AT8HM123789', '2025-07-02', '14:00', 30, 'completed'),
('INV00065', '1N4AL3AP0HC123456', '2025-07-02', '14:00', 60, 'in_progress'),
('INV00066', 'KMHD14LA2HA123456', '2025-07-02', '14:30', 30, 'on_site'),
('INV00067', 'JM1BK32F781123456', '2025-07-02', '14:30', 60, 'cancelled'),
('INV00068', '1FMCU0F70HUC12345', '2025-07-02', '15:00', 30, 'completed'),
('INV00069', '5NPE34AF4HH123456', '2025-07-02', '15:00', 90, 'in_progress'),
('INV00070', '2T1BURHE0HC123456', '2025-07-02', '15:30', 30, 'on_site'),
('INV00071', '1C4RJFAG8HC123456', '2025-07-02', '15:30', 60, 'booked'),
('INV00072', '3CZRU5H38HM123456', '2025-07-02', '16:00', 30, 'completed'),
('INV00073', 'WBAJA7C58HWF12345', '2025-07-02', '16:00', 60, 'in_progress'),
('INV00074', '1GKKNPLS8HZ123456', '2025-07-02', '16:30', 30, 'on_site'),
('INV00075', '1FMHK8F84HGA12345', '2025-07-02', '16:30', 90, 'cancelled'),
('INV00076', 'KNDJP3A57H7123456', '2025-07-02', '17:00', 30, 'completed'),
('INV00077', '1GCCS14E8H8123456', '2025-07-02', '17:00', 60, 'in_progress'),
('INV00078', '2C3CDZAG8HH123456', '2025-07-02', '08:30', 30, 'on_site'),
('INV00079', '1FA6P8TH7H5123456', '2025-07-02', '09:30', 60, 'completed'),
('INV00080', '1C6SRFFT8HN123456', '2025-07-02', '10:30', 30, 'booked'),
('INV00081', '1HGBH41JXMN109186', '2025-07-02', '11:00', 60, 'in_progress'),
('INV00082', '1FTFW1ET5DFC10312', '2025-07-02', '13:00', 30, 'on_site'),
('INV00083', '1G1BE5SM7H7123456', '2025-07-02', '14:00', 90, 'completed'),
('INV00084', '3VW467AT8HM123789', '2025-07-02', '15:00', 30, 'cancelled'),
('INV00085', '1N4AL3AP0HC123456', '2025-07-02', '16:00', 60, 'in_progress'),
('INV00086', 'KMHD14LA2HA123456', '2025-07-02', '17:00', 30, 'on_site'),
('INV00087', 'JM1BK32F781123456', '2025-07-02', '08:00', 60, 'completed'),
('INV00088', '1FMCU0F70HUC12345', '2025-07-02', '09:00', 30, 'booked'),
('INV00089', '5NPE34AF4HH123456', '2025-07-02', '10:00', 90, 'in_progress'),
('INV00090', '2T1BURHE0HC123456', '2025-07-02', '11:00', 30, 'on_site'),

-- July 3 (Thursday) - 45 appointments
('INV00091', '1C4RJFAG8HC123456', '2025-07-03', '08:00', 30, 'completed'),
('INV00092', '3CZRU5H38HM123456', '2025-07-03', '08:00', 60, 'in_progress'),
('INV00093', 'WBAJA7C58HWF12345', '2025-07-03', '08:30', 30, 'on_site'),
('INV00094', '1GKKNPLS8HZ123456', '2025-07-03', '08:30', 90, 'booked'),
('INV00095', '1FMHK8F84HGA12345', '2025-07-03', '09:00', 30, 'completed'),
('INV00096', 'KNDJP3A57H7123456', '2025-07-03', '09:00', 60, 'cancelled'),
('INV00097', '1GCCS14E8H8123456', '2025-07-03', '09:30', 30, 'in_progress'),
('INV00098', '2C3CDZAG8HH123456', '2025-07-03', '10:00', 60, 'on_site'),
('INV00099', '1FA6P8TH7H5123456', '2025-07-03', '10:00', 30, 'completed'),
('INV00100', '1C6SRFFT8HN123456', '2025-07-03', '10:30', 90, 'booked'),
('INV00101', '1HGBH41JXMN109186', '2025-07-03', '11:00', 30, 'in_progress'),
('INV00102', '1FTFW1ET5DFC10312', '2025-07-03', '11:00', 60, 'completed'),
('INV00103', '1G1BE5SM7H7123456', '2025-07-03', '11:30', 30, 'on_site'),
('INV00104', '3VW467AT8HM123789', '2025-07-03', '11:30', 60, 'cancelled'),
('INV00105', '1N4AL3AP0HC123456', '2025-07-03', '13:00', 30, 'completed'),
('INV00106', 'KMHD14LA2HA123456', '2025-07-03', '13:00', 60, 'in_progress'),
('INV00107', 'JM1BK32F781123456', '2025-07-03', '13:30', 30, 'on_site'),
('INV00108', '1FMCU0F70HUC12345', '2025-07-03', '13:30', 90, 'booked'),
('INV00109', '5NPE34AF4HH123456', '2025-07-03', '14:00', 30, 'completed'),
('INV00110', '2T1BURHE0HC123456', '2025-07-03', '14:00', 60, 'in_progress'),
('INV00111', '1C4RJFAG8HC123456', '2025-07-03', '14:30', 30, 'on_site'),
('INV00112', '3CZRU5H38HM123456', '2025-07-03', '14:30', 60, 'cancelled'),
('INV00113', 'WBAJA7C58HWF12345', '2025-07-03', '15:00', 30, 'completed'),
('INV00114', '1GKKNPLS8HZ123456', '2025-07-03', '15:00', 90, 'in_progress'),
('INV00115', '1FMHK8F84HGA12345', '2025-07-03', '15:30', 30, 'on_site'),
('INV00116', 'KNDJP3A57H7123456', '2025-07-03', '15:30', 60, 'booked'),
('INV00117', '1GCCS14E8H8123456', '2025-07-03', '16:00', 30, 'completed'),
('INV00118', '2C3CDZAG8HH123456', '2025-07-03', '16:00', 60, 'in_progress'),
('INV00119', '1FA6P8TH7H5123456', '2025-07-03', '16:30', 30, 'on_site'),
('INV00120', '1C6SRFFT8HN123456', '2025-07-03', '16:30', 90, 'cancelled'),
('INV00121', '1HGBH41JXMN109186', '2025-07-03', '17:00', 30, 'completed'),
('INV00122', '1FTFW1ET5DFC10312', '2025-07-03', '17:00', 60, 'in_progress'),
('INV00123', '1G1BE5SM7H7123456', '2025-07-03', '08:30', 30, 'on_site'),
('INV00124', '3VW467AT8HM123789', '2025-07-03', '09:30', 60, 'completed'),
('INV00125', '1N4AL3AP0HC123456', '2025-07-03', '10:30', 30, 'booked'),
('INV00126', 'KMHD14LA2HA123456', '2025-07-03', '11:00', 60, 'in_progress'),
('INV00127', 'JM1BK32F781123456', '2025-07-03', '13:00', 30, 'on_site'),
('INV00128', '1FMCU0F70HUC12345', '2025-07-03', '14:00', 90, 'completed'),
('INV00129', '5NPE34AF4HH123456', '2025-07-03', '15:00', 30, 'cancelled'),
('INV00130', '2T1BURHE0HC123456', '2025-07-03', '16:00', 60, 'in_progress'),
('INV00131', '1C4RJFAG8HC123456', '2025-07-03', '17:00', 30, 'on_site'),
('INV00132', '3CZRU5H38HM123456', '2025-07-03', '08:00', 60, 'completed'),
('INV00133', 'WBAJA7C58HWF12345', '2025-07-03', '09:00', 30, 'booked'),
('INV00134', '1GKKNPLS8HZ123456', '2025-07-03', '10:00', 90, 'in_progress'),
('INV00135', '1FMHK8F84HGA12345', '2025-07-03', '11:00', 30, 'on_site'),

-- July 4 (Friday) - 15 appointments (holiday)
('INV00136', 'KNDJP3A57H7123456', '2025-07-04', '08:00', 30, 'completed'),
('INV00137', '1GCCS14E8H8123456', '2025-07-04', '08:00', 60, 'in_progress'),
('INV00138', '2C3CDZAG8HH123456', '2025-07-04', '08:30', 30, 'on_site'),
('INV00139', '1FA6P8TH7H5123456', '2025-07-04', '08:30', 90, 'booked'),
('INV00140', '1C6SRFFT8HN123456', '2025-07-04', '09:00', 30, 'completed'),
('INV00141', '1HGBH41JXMN109186', '2025-07-04', '09:00', 60, 'cancelled'),
('INV00142', '1FTFW1ET5DFC10312', '2025-07-04', '09:30', 30, 'in_progress'),
('INV00143', '1G1BE5SM7H7123456', '2025-07-04', '10:00', 60, 'on_site'),
('INV00144', '3VW467AT8HM123789', '2025-07-04', '10:00', 30, 'completed'),
('INV00145', '1N4AL3AP0HC123456', '2025-07-04', '10:30', 90, 'booked'),
('INV00146', 'KMHD14LA2HA123456', '2025-07-04', '11:00', 30, 'in_progress'),
('INV00147', 'JM1BK32F781123456', '2025-07-04', '11:00', 60, 'completed'),
('INV00148', '1FMCU0F70HUC12345', '2025-07-04', '11:30', 30, 'on_site'),
('INV00149', '5NPE34AF4HH123456', '2025-07-04', '11:30', 60, 'cancelled'),
('INV00150', '2T1BURHE0HC123456', '2025-07-04', '13:00', 30, 'completed');

-- BOOKING SERVICES (following service distribution rules)
-- Service distribution: 20% changeover, 20% swap, 5% balance, 15% rotate, 10% oil change, 15% front end, 15% brakes
-- Changeover + balance always, 50% + al4, 25% + oil change
-- Front end + al4 always
-- Brakes often with rotate or al4

-- June 30 services (45 appointments)
INSERT OR IGNORE INTO booking_services (invoice_number, service_name) VALUES
-- Changeover (20% = 9 appointments)
('INV00001', 'changeover'), ('INV00001', 'balance'),
('INV00007', 'changeover'), ('INV00007', 'balance'), ('INV00007', 'al4'),
('INV00013', 'changeover'), ('INV00013', 'balance'), ('INV00013', 'oil change'),
('INV00019', 'changeover'), ('INV00019', 'balance'),
('INV00025', 'changeover'), ('INV00025', 'balance'), ('INV00025', 'al4'),
('INV00031', 'changeover'), ('INV00031', 'balance'), ('INV00031', 'oil change'),
('INV00037', 'changeover'), ('INV00037', 'balance'),
('INV00043', 'changeover'), ('INV00043', 'balance'), ('INV00043', 'al4'),

-- Swap (20% = 9 appointments)
('INV00002', 'swap'),
('INV00008', 'swap'),
('INV00014', 'swap'),
('INV00020', 'swap'),
('INV00026', 'swap'),
('INV00032', 'swap'),
('INV00038', 'swap'),
('INV00044', 'swap'),
('INV00005', 'swap'),

-- Balance (5% = 2 standalone)
('INV00011', 'balance'),
('INV00029', 'balance'),

-- Rotate (15% = 7 appointments)
('INV00003', 'rotate'),
('INV00009', 'rotate'),
('INV00015', 'rotate'),
('INV00021', 'rotate'),
('INV00027', 'rotate'),
('INV00033', 'rotate'),
('INV00039', 'rotate'),

-- Oil change (10% = 4-5 appointments)
('INV00004', 'oil change'),
('INV00010', 'oil change'),
('INV00016', 'oil change'),
('INV00022', 'oil change'),
('INV00028', 'oil change'),

-- Front end (15% = 7 appointments) + al4 always
('INV00006', 'front end'), ('INV00006', 'al4'),
('INV00012', 'front end'), ('INV00012', 'al4'),
('INV00018', 'front end'), ('INV00018', 'al4'),
('INV00024', 'front end'), ('INV00024', 'al4'),
('INV00030', 'front end'), ('INV00030', 'al4'),
('INV00036', 'front end'), ('INV00036', 'al4'),
('INV00042', 'front end'), ('INV00042', 'al4'),

-- Brakes (15% = 7 appointments)
('INV00017', 'brakes'), ('INV00017', 'rotate'),
('INV00023', 'brakes'), ('INV00023', 'al4'),
('INV00034', 'brakes'),
('INV00040', 'brakes'), ('INV00040', 'rotate'),
('INV00041', 'brakes'), ('INV00041', 'al4'),
('INV00035', 'brakes'),
('INV00045', 'brakes'), ('INV00045', 'rotate'),

-- July 2 services (45 appointments)
-- Changeover (9)
('INV00046', 'changeover'), ('INV00046', 'balance'),
('INV00052', 'changeover'), ('INV00052', 'balance'), ('INV00052', 'al4'),
('INV00058', 'changeover'), ('INV00058', 'balance'), ('INV00058', 'oil change'),
('INV00064', 'changeover'), ('INV00064', 'balance'),
('INV00070', 'changeover'), ('INV00070', 'balance'), ('INV00070', 'al4'),
('INV00076', 'changeover'), ('INV00076', 'balance'), ('INV00076', 'oil change'),
('INV00082', 'changeover'), ('INV00082', 'balance'),
('INV00088', 'changeover'), ('INV00088', 'balance'), ('INV00088', 'al4'),
('INV00094', 'changeover'), ('INV00094', 'balance'),

-- Swap (9)
('INV00047', 'swap'),
('INV00053', 'swap'),
('INV00059', 'swap'),
('INV00065', 'swap'),
('INV00071', 'swap'),
('INV00077', 'swap'),
('INV00083', 'swap'),
('INV00089', 'swap'),
('INV00095', 'swap'),

-- Balance (2-3 standalone)
('INV00060', 'balance'),
('INV00078', 'balance'),
('INV00096', 'balance'),

-- Rotate (7)
('INV00048', 'rotate'),
('INV00054', 'rotate'),
('INV00066', 'rotate'),
('INV00072', 'rotate'),
('INV00084', 'rotate'),
('INV00090', 'rotate'),
('INV00097', 'rotate'),

-- Oil change (4-5)
('INV00049', 'oil change'),
('INV00055', 'oil change'),
('INV00067', 'oil change'),
('INV00073', 'oil change'),
('INV00085', 'oil change'),

-- Front end (7) + al4
('INV00050', 'front end'), ('INV00050', 'al4'),
('INV00056', 'front end'), ('INV00056', 'al4'),
('INV00062', 'front end'), ('INV00062', 'al4'),
('INV00068', 'front end'), ('INV00068', 'al4'),
('INV00074', 'front end'), ('INV00074', 'al4'),
('INV00080', 'front end'), ('INV00080', 'al4'),
('INV00086', 'front end'), ('INV00086', 'al4'),

-- Brakes (7)
('INV00051', 'brakes'), ('INV00051', 'rotate'),
('INV00057', 'brakes'), ('INV00057', 'al4'),
('INV00069', 'brakes'),
('INV00075', 'brakes'), ('INV00075', 'rotate'),
('INV00081', 'brakes'), ('INV00081', 'al4'),
('INV00087', 'brakes'),
('INV00093', 'brakes'), ('INV00093', 'rotate'),

-- July 3 services (45 appointments)
-- Changeover (9)
('INV00091', 'changeover'), ('INV00091', 'balance'),
('INV00097', 'changeover'), ('INV00097', 'balance'), ('INV00097', 'al4'),
('INV00103', 'changeover'), ('INV00103', 'balance'), ('INV00103', 'oil change'),
('INV00109', 'changeover'), ('INV00109', 'balance'),
('INV00115', 'changeover'), ('INV00115', 'balance'), ('INV00115', 'al4'),
('INV00121', 'changeover'), ('INV00121', 'balance'), ('INV00121', 'oil change'),
('INV00127', 'changeover'), ('INV00127', 'balance'),
('INV00133', 'changeover'), ('INV00133', 'balance'), ('INV00133', 'al4'),
('INV00139', 'changeover'), ('INV00139', 'balance'),

-- Swap (9)
('INV00092', 'swap'),
('INV00098', 'swap'),
('INV00104', 'swap'),
('INV00110', 'swap'),
('INV00116', 'swap'),
('INV00122', 'swap'),
('INV00128', 'swap'),
('INV00134', 'swap'),
('INV00140', 'swap'),

-- Balance (2-3 standalone)
('INV00105', 'balance'),
('INV00123', 'balance'),
('INV00141', 'balance'),

-- Rotate (7)
('INV00093', 'rotate'),
('INV00099', 'rotate'),
('INV00111', 'rotate'),
('INV00117', 'rotate'),
('INV00129', 'rotate'),
('INV00135', 'rotate'),
('INV00142', 'rotate'),

-- Oil change (4-5)
('INV00094', 'oil change'),
('INV00100', 'oil change'),
('INV00112', 'oil change'),
('INV00118', 'oil change'),
('INV00130', 'oil change'),

-- Front end (7) + al4
('INV00095', 'front end'), ('INV00095', 'al4'),
('INV00101', 'front end'), ('INV00101', 'al4'),
('INV00107', 'front end'), ('INV00107', 'al4'),
('INV00113', 'front end'), ('INV00113', 'al4'),
('INV00119', 'front end'), ('INV00119', 'al4'),
('INV00125', 'front end'), ('INV00125', 'al4'),
('INV00131', 'front end'), ('INV00131', 'al4'),

-- Brakes (7)
('INV00096', 'brakes'), ('INV00096', 'rotate'),
('INV00102', 'brakes'), ('INV00102', 'al4'),
('INV00108', 'brakes'),
('INV00114', 'brakes'), ('INV00114', 'rotate'),
('INV00120', 'brakes'), ('INV00120', 'al4'),
('INV00126', 'brakes'),
('INV00132', 'brakes'), ('INV00132', 'rotate'),

-- July 4 services (15 appointments)
-- Changeover (3)
('INV00136', 'changeover'), ('INV00136', 'balance'),
('INV00142', 'changeover'), ('INV00142', 'balance'), ('INV00142', 'al4'),
('INV00148', 'changeover'), ('INV00148', 'balance'), ('INV00148', 'oil change'),

-- Swap (3)
('INV00137', 'swap'),
('INV00143', 'swap'),
('INV00149', 'swap'),

-- Balance (1 standalone)
('INV00144', 'balance'),

-- Rotate (2)
('INV00138', 'rotate'),
('INV00150', 'rotate'),

-- Oil change (1-2)
('INV00139', 'oil change'),
('INV00145', 'oil change'),

-- Front end (2) + al4
('INV00140', 'front end'), ('INV00140', 'al4'),
('INV00146', 'front end'), ('INV00146', 'al4'),

-- Brakes (2)
('INV00141', 'brakes'), ('INV00141', 'rotate'),
('INV00147', 'brakes'), ('INV00147', 'al4');

-- ==================
-- VERIFICATION QUERIES
-- ==================

-- Check status distribution
SELECT status, COUNT(*) as count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings), 1) as percentage
FROM bookings GROUP BY status ORDER BY count DESC;

-- Check service distribution
SELECT service_name, COUNT(*) as count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM booking_services), 1) as percentage
FROM booking_services GROUP BY service_name ORDER BY count DESC;

-- Check service combinations
SELECT 
    COUNT(*) as changeover_with_balance,
    (SELECT COUNT(*) FROM booking_services WHERE service_name = 'front end') as front_end_count,
    (SELECT COUNT(*) FROM booking_services bs1 
      JOIN booking_services bs2 ON bs1.invoice_number = bs2.invoice_number 
      WHERE bs1.service_name = 'front end' AND bs2.service_name = 'al4') as front_end_with_al4
FROM booking_services bs1 
JOIN booking_services bs2 ON bs1.invoice_number = bs2.invoice_number 
WHERE bs1.service_name = 'changeover' AND bs2.service_name = 'balance';

-- Check business rule compliance
SELECT 'No lunch appointments' as check_type, COUNT(*) as violations 
FROM bookings WHERE TIME(booking_time) BETWEEN '12:00' AND '13:00';

SELECT 'Appointments end by 6pm' as check_type, COUNT(*) as violations
FROM bookings WHERE TIME(booking_time, '+' || booking_duration || ' minutes') > '18:00';

SELECT 'Duration rules' as check_type,
       SUM(CASE WHEN booking_duration = 30 THEN 1 ELSE 0 END) as thirty_min,
       SUM(CASE WHEN booking_duration = 60 THEN 1 ELSE 0 END) as sixty_min,
       SUM(CASE WHEN booking_duration = 90 THEN 1 ELSE 0 END) as ninety_min,
       SUM(CASE WHEN booking_duration = 120 THEN 1 ELSE 0 END) as two_hour
FROM bookings;