USE `CIDM_6350_FINAL`;
INSERT INTO Employee(Name,EmplNo,Job,UserName) VALUES 
('Genvieve Creighton',216,'Reader', 'gcreighton'),
('Lancelot Tschiersch',159,'Reader', 'ltschiersch'),
('Gaspar McCaskill',337,'Reader', 'gmccakill'),
('Renelle Astill',380,'Manager', 'rastill'),
('Rosalia Skip',261,'Reader', 'rskip'),
('Lorettalorna Fessby',245,'Customer Service', 'lfessby'),
('Bernita Munson',154,'Reader', 'bmunson'),
('Cherye Buey',382,'Reader', 'cbuey'),
('Wrennie Critcher',361,'Customer Service', 'wcritcher'),
('Evaleen Madelin',230,'Reader', 'emadelin');

INSERT INTO Customer(CustID,Name) VALUES 
(47,'Melania Hailey'),
(113,'Johnath Dun'),
(454,'Kalie Gratton'),
(856,'Ruperta Horsewood'),
(1010,'Bat Scamel'),
(1125,'Roxi Falvey'),
(2001,'Tulley Reidshaw');

INSERT INTO Meter(Meter_Number,address) VALUES 
(5,'2768 Clarendon Trail Canyon TX 79015'),
(16,'656 Weeping Birch Avenue Canyon TX 79016'),
(24,'86333 Maywood Road Canyon TX 79016'),
(25,'562 Kim Trail Canyon TX 79015'),
(27,'36 Laurel Center Canyon TX 79015'),
(34,'1 Stuart Point Canyon TX 79015'),
(40,'502 Meadow Valley Park Canyon TX 79015'),
(48,'07245 Dottie Junction Canyon TX 79015'),
(56,'22509 Holmberg Point Canyon TX 79016');

INSERT INTO Contract(ContNo,CustID,Meter_Number,BillRate,ActivationDate,DeactivatedDate) VALUES 
(2419,856,40,0.49,'2018-09-03',NULL),
(2420,454,48,0.39,'2018-09-21',NULL),
(2795,1125,56,0.38,'2017-12-04',NULL),
(3336,47,24,0.37,'2018-08-16',NULL),
(3592,454,27,0.49,'2019-04-15',NULL),
(3891,856,34,0.29,'2019-12-13',NULL),
(3955,1010,16,0.26,'2018-08-19','2018-09-19'),
(4283,856,16,0.41,'2019-10-23',NULL),
(4451,2001,25,0.47,'2019-02-11',NULL),
(5085,113,5,0.34,'2020-05-06',NULL);

INSERT INTO Reading(ReadingId,ContNo,ReadingValue,ReadDate,NextReadDate,EmpNo) VALUES 
(1,2419,NULL,NULL,NULL,NULL),
(2,2420,1350,'2018-09-21','2018-10-21',230),
(3,2420,1870,'2018-10-21','2018-11-21',230),
(4,2420,NULL,'2018-11-21','2018-12-21',230),
(5,2795,341,'2017-12-04','2018-01-05',382),
(6,2795,612,'2018-01-05','2018-02-05',337),
(7,2795,890,'2018-02-05','2018-03-05',337),
(8,2795,NULL,'2018-03-15','2018-04-15',NULL),
(9,3336,NULL,NULL,NULL,NULL),
(10,3592,211,'2019-04-15','2019-05-15',216),
(11,3592,411,'2019-05-15','2019-06-15',216),
(12,3592,670,'2019-06-15','2019-07-15',216),
(13,3592,830,'2019-07-15','2019-08-15',216),
(14,3592,NULL,'2019-08-15','2019-09-15',337),
(15,3891,NULL,NULL,NULL,NULL),
(16,3955,269,'2018-08-19','2018-09-19',261),
(17,3955,400,'2018-09-19','2018-10-19',261),
(18,4283,400,'2019-10-23','2019-11-23',382),
(19,4283,730,'2019-11-23','2019-12-23',216),
(20,4283,NULL,'2019-12-23','2020-01-23',NULL),
(21,4451,NULL,NULL,NULL,NULL),
(22,5085,3851,'2020-05-06','2020-06-06',159),
(23,5085,4060,'2020-06-06','2020-07-06',154),
(24,5085,NULL,'2020-07-06','2020-08-06',NULL);

INSERT INTO Bill(BillNo,ContNo,BillDate) VALUES
(1002,5085,'2020-06-06'),
(1001,3592,'2019-05-15'),
(1003,3592,'2019-06-15'),
(1004,3592,'2019-07-15'),
(1007,2420,'2018-10-21'),
(2007,4283,'2019-11-23'),
(2006,3955,'2018-09-19'),
(1005,2795,'2018-01-05'),
(1006,2795,'2018-02-05');

INSERT INTO Payment(PaymentId,BillNo,Payment_date,PaymentAmount) VALUES 
(1,1002,'2020-06-07',71.06),
(2,1001,'2019-05-20',98),
(3,1003,'2019-06-20',126.91),
(4,1004,'2019-07-16',78.4),
(5,1007,'2018-10-22',100),
(6,2007,'2019-11-25',100),
(7,2007,'2019-12-10',35.3),
(8,1005,'2017-12-06',102.98),
(9,1006,'2018-01-08',105.64);
