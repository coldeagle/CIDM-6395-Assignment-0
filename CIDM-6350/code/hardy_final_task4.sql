-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod` AS select `cont`.`ContNo` AS `ContNo`,`pr`.`ReadDate` AS `PreviousReadDate`,`pr`.`ReadingValue` AS `PreviousReading`,`r`.`ReadDate` AS `CurrentReadDate`,`r`.`ReadingValue` AS `CurrentReading`,(`r`.`ReadingValue` - `pr`.`ReadingValue`) AS `Consumption` from ((`CIDM_6350_FINAL`.`Contract` `cont` join `CIDM_6350_FINAL`.`Reading` `r` on(`cont`.`ContNo`)) join `CIDM_6350_FINAL`.`Reading` `pr` on(((`pr`.`NextReadDate` = `r`.`ReadDate`) and (`cont`.`ContNo` = `pr`.`ContNo`))));

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance` AS select `b`.`ContNo` AS `ContNo`,`cust`.`Name` AS `Name`,`m`.`address` AS `address`,`p`.`SumPayments` AS `SumPayments`,(((`cr`.`ReadingValue` - `pr`.`ReadingValue`) * `b`.`BillingRate`) - `p`.`SumPayments`) AS `Balance` from ((((((`CIDM_6350_FINAL`.`Bill` `b` join (select `CIDM_6350_FINAL`.`Payment`.`BillNo` AS `BillNo`,sum(`CIDM_6350_FINAL`.`Payment`.`PaymentAmount`) AS `SumPayments` from `CIDM_6350_FINAL`.`Payment` group by `CIDM_6350_FINAL`.`Payment`.`BillNo`) `p` on((`p`.`BillNo` = `b`.`BillNo`))) join `CIDM_6350_FINAL`.`Reading` `cr` on((`b`.`CurrentRead` = `cr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Reading` `pr` on((`b`.`PreviousRead` = `pr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Contract` `con` on((`b`.`ContNo` = `con`.`ContNo`))) join `CIDM_6350_FINAL`.`Customer` `cust` on((`cust`.`CustID` = `con`.`CustID`))) join `CIDM_6350_FINAL`.`Meter` `m` on((`con`.`Meter_Number` = `m`.`Meter_Number`))) having (`Balance` > 0);

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ2_MyReadings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ2_MyReadings`;
USE `CIDM_6350_FINAL`;
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `cidm_6350_final`.`iq2_myreadings` AS
    SELECT 
        `r`.`ReadDate` AS `ReadDate`,
        `m`.`Meter_Number` AS `Meter_Number`,
        `m`.`address` AS `address`
    FROM
        (((`cidm_6350_final`.`reading` `r`
        JOIN `cidm_6350_final`.`employee` `e` ON ((`r`.`EmpNo` = `e`.`EmplNo`)))
        JOIN `cidm_6350_final`.`contract` `cont` ON ((`cont`.`ContNo` = `r`.`ContNo`)))
        JOIN `cidm_6350_final`.`meter` `m` ON ((`m`.`Meter_Number` = `cont`.`Meter_Number`)))
    WHERE
        (`e`.`UserName` = REPLACE(SESSION_USER(), '@localhost', ''));

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments` AS select `cons`.`ContNo` AS `ContNo`,`cust`.`Name` AS `Name`,`m`.`address` AS `address`,`cons`.`PreviousReadDate` AS `PreviousReadDate`,`cons`.`PreviousReading` AS `PreviousReading`,`cons`.`CurrentReadDate` AS `CurrentReadDate`,`cons`.`CurrentReading` AS `CurrentReading`,`b`.`BillNo` AS `BillNo`,`b`.`BillDate` AS `BillDate`,(`b`.`BillingRate` * `cons`.`Consumption`) AS `BillTotal`,`p`.`PaymentAmount` AS `PaymentAmount`,`p`.`Payment_date` AS `Payment_date`,((`b`.`BillingRate` * `cons`.`Consumption`) - `psum`.`SumPayments`) AS `Balance` from ((((((`CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod` `cons` left join `CIDM_6350_FINAL`.`Bill` `b` on(((`b`.`BillDate` = `cons`.`CurrentReadDate`) and (`b`.`ContNo` = `cons`.`ContNo`)))) left join `CIDM_6350_FINAL`.`Payment` `p` on((`b`.`BillNo` = `p`.`BillNo`))) left join (select `CIDM_6350_FINAL`.`Payment`.`BillNo` AS `BillNo`,sum(`CIDM_6350_FINAL`.`Payment`.`PaymentAmount`) AS `SumPayments` from `CIDM_6350_FINAL`.`Payment` group by `CIDM_6350_FINAL`.`Payment`.`BillNo`) `psum` on((`psum`.`BillNo` = `b`.`BillNo`))) join `CIDM_6350_FINAL`.`Contract` `cont` on((`cons`.`ContNo` = `cont`.`ContNo`))) join `CIDM_6350_FINAL`.`Meter` `m` on((`cont`.`Meter_Number` = `m`.`Meter_Number`))) join `CIDM_6350_FINAL`.`Customer` `cust` on((`cont`.`CustID` = `cust`.`CustID`))) order by `cons`.`ContNo`,`cons`.`PreviousReadDate`;

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019` AS select count(0) AS `COUNT(*)` from (`CIDM_6350_FINAL`.`Reading` `r` join `CIDM_6350_FINAL`.`Employee` `e` on((`e`.`EmplNo` = `r`.`EmpNo`))) where ((`r`.`ReadDate` >= '2019-05-01') and (`r`.`ReadDate` <= '2019-12-30') and (`e`.`UserName` = 'gcreighton'));

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ5_BillsByReaders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ5_BillsByReaders`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ5_BillsByReaders` AS select `b`.`BillNo` AS `BillNo`,`lastReadBy`.`Name` AS `PreviouslyReadBy`,`thisReadBy`.`Name` AS `CurrentlyReadBy` from ((((`CIDM_6350_FINAL`.`Bill` `b` join `CIDM_6350_FINAL`.`Reading` `lastRead` on((`lastRead`.`ReadingId` = `b`.`PreviousRead`))) join `CIDM_6350_FINAL`.`Reading` `thisRead` on((`thisRead`.`ReadingId` = `b`.`CurrentRead`))) join `CIDM_6350_FINAL`.`Employee` `lastReadBy` on((`lastReadBy`.`EmplNo` = `lastRead`.`EmpNo`))) join `CIDM_6350_FINAL`.`Employee` `thisReadBy` on((`thisReadBy`.`EmplNo` = `thisRead`.`EmpNo`))) where (`b`.`BillNo` in (1004,1005,1002));

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019` AS select `cust`.`Name` AS `Name`,sum((`cr`.`ReadingValue` - `pr`.`ReadingValue`)) AS `consumption` from ((((`CIDM_6350_FINAL`.`Bill` `b` join `CIDM_6350_FINAL`.`Reading` `cr` on((`b`.`CurrentRead` = `cr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Reading` `pr` on((`b`.`PreviousRead` = `pr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Contract` `cont` on((`cont`.`ContNo` = `b`.`ContNo`))) join `CIDM_6350_FINAL`.`Customer` `cust` on((`cont`.`CustID` = `cust`.`CustID`))) where ((`cr`.`ReadDate` >= '2019-05-01') and (`cr`.`ReadDate` <= '2019-12-30')) group by `cust`.`Name` order by `consumption` desc limit 1;

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019` AS select avg((`cr`.`ReadingValue` - `pr`.`ReadingValue`)) AS `consumption` from ((`CIDM_6350_FINAL`.`Bill` `b` join `CIDM_6350_FINAL`.`Reading` `cr` on((`b`.`CurrentRead` = `cr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Reading` `pr` on((`b`.`PreviousRead` = `pr`.`ReadingId`))) where ((`cr`.`ReadDate` >= '2019-05-01') and (`cr`.`ReadDate` <= '2019-12-30'));

-- -----------------------------------------------------
-- View `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019`;
USE `CIDM_6350_FINAL`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019` AS select `cust`.`Name` AS `Name`,sum((`cr`.`ReadingValue` - `pr`.`ReadingValue`)) AS `consumption` from ((((`CIDM_6350_FINAL`.`Bill` `b` join `CIDM_6350_FINAL`.`Reading` `cr` on((`b`.`CurrentRead` = `cr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Reading` `pr` on((`b`.`PreviousRead` = `pr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Contract` `cont` on((`cont`.`ContNo` = `b`.`ContNo`))) join `CIDM_6350_FINAL`.`Customer` `cust` on((`cont`.`CustID` = `cust`.`CustID`))) where ((`cr`.`ReadDate` >= '2019-05-01') and (`cr`.`ReadDate` <= '2019-12-30')) group by `cust`.`Name` having (`consumption` > (select `avgCon`.`consumption` from `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019` `avgCon`));

-- -----------------------------------------------------
-- Updates 4.2 UQ1
-- -----------------------------------------------------
INSERT INTO Customer(CustID, Name) VALUES(1111,'John Doe');
-- -----------------------------------------------------
-- Updates 4.2 UQ2
-- -----------------------------------------------------
UPDATE Reading
SET EmpNo = (SELECT EmplNo FROM Employee WHERE Name = 'Genvieve Creighton' LIMIT 1),
ReadDate = (SELECT ActivationDate  FROM Contract WHERE Meter_Number = 40)
WHERE ReadingId = 1;

UPDATE Reading
SET EmpNo = (SELECT EmplNo FROM Employee WHERE Name = 'Genvieve Creighton' LIMIT 1),
ReadDate = (SELECT ActivationDate  FROM Contract WHERE Meter_Number = 34)
WHERE ReadingId = 15;
-- -----------------------------------------------------
-- Updates 4.2 UQ3
-- -----------------------------------------------------
UPDATE Reading
SET ReadingValue = 1001.00,
NextReadDate = '2018-10-03'
WHERE ReadingId = 1;

UPDATE Reading
SET ReadingValue = 1000.00,
NextReadDate = '2020-01-13'
WHERE ReadingId = 15;
-- -----------------------------------------------------
-- Updates 4.2 UQ4 - It can't be done, there aren't two readings to compare! Both of the customers are getting read on their activation dates
-- -----------------------------------------------------