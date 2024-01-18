-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema CIDM_6350_FINAL
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CIDM_6350_FINAL
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CIDM_6350_FINAL` DEFAULT CHARACTER SET latin1 ;
USE `CIDM_6350_FINAL` ;

-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Customer` (
  `CustID` INT(11) NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustID`),
  UNIQUE INDEX `CustID_UNIQUE` (`CustID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Meter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Meter` (
  `Meter_Number` INT(11) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Meter_Number`),
  UNIQUE INDEX `Meter_Number_UNIQUE` (`Meter_Number` ASC) VISIBLE,
  UNIQUE INDEX `address_UNIQUE` (`address` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Contract` (
  `ContNo` INT(11) NOT NULL,
  `CustID` INT(11) NOT NULL,
  `Meter_Number` INT(11) NOT NULL,
  `ActivationDate` DATE NOT NULL,
  `BillRate` DECIMAL(5,5) NOT NULL,
  `DeactivatedDate` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`ContNo`),
  UNIQUE INDEX `ContNo_UNIQUE` (`ContNo` ASC) VISIBLE,
  INDEX `ContractedCustomer_idx` (`CustID` ASC) VISIBLE,
  INDEX `ContractedMeter_idx` (`Meter_Number` ASC) VISIBLE,
  CONSTRAINT `ContractedCustomer`
    FOREIGN KEY (`CustID`)
    REFERENCES `CIDM_6350_FINAL`.`Customer` (`CustID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ContractedMeter`
    FOREIGN KEY (`Meter_Number`)
    REFERENCES `CIDM_6350_FINAL`.`Meter` (`Meter_Number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Employee` (
  `EmplNo` INT(11) NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Job` ENUM('Manager', 'Reader', 'Customer Service') NOT NULL,
  `UserName` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`EmplNo`),
  UNIQUE INDEX `EmplNo_UNIQUE` (`EmplNo` ASC) VISIBLE,
  UNIQUE INDEX `UserName_UNIQUE` (`UserName` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Reading`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Reading` (
  `ReadingId` INT(11) NOT NULL,
  `ContNo` INT(11) NOT NULL,
  `ReadDate` DATE NULL DEFAULT NULL,
  `ReadingValue` DECIMAL(13,5) NULL DEFAULT NULL,
  `EmpNo` INT(11) NULL DEFAULT NULL,
  `NextReadDate` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`ReadingId`),
  INDEX `Reading_Employee_idx` (`EmpNo` ASC) VISIBLE,
  INDEX `ContractNumber_idx` (`ContNo` ASC) VISIBLE,
  INDEX `ReadDate_idx` (`ReadDate` ASC) VISIBLE,
  INDEX `This_Reading_idx` (`ReadDate` ASC) VISIBLE,
  INDEX `Next_Read_Date_idx` (`NextReadDate` ASC) VISIBLE,
  INDEX `PreviousRead_idx` (`ContNo` ASC, `NextReadDate` ASC) VISIBLE,
  INDEX `ThisRead_idx` (`ContNo` ASC, `ReadDate` ASC) VISIBLE,
  CONSTRAINT `ReadBy`
    FOREIGN KEY (`EmpNo`)
    REFERENCES `CIDM_6350_FINAL`.`Employee` (`EmplNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `RealtedContract`
    FOREIGN KEY (`ContNo`)
    REFERENCES `CIDM_6350_FINAL`.`Contract` (`ContNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Bill`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Bill` (
  `BillNo` INT(11) NOT NULL,
  `ContNo` INT(11) NOT NULL,
  `BillDate` DATE NULL DEFAULT NULL,
  `PreviousRead` INT(11) NULL DEFAULT NULL,
  `CurrentRead` INT(11) NULL DEFAULT NULL,
  `BillingRate` DECIMAL(5,5) NULL DEFAULT NULL,
  PRIMARY KEY (`BillNo`),
  UNIQUE INDEX `BillNo_UNIQUE` (`BillNo` ASC) VISIBLE,
  INDEX `PreviousRead_idx` (`ContNo` ASC, `BillDate` ASC) VISIBLE,
  INDEX `PrevRead_idx` (`PreviousRead` ASC) VISIBLE,
  INDEX `ThisRead_idx` (`CurrentRead` ASC) VISIBLE,
  CONSTRAINT `Contract`
    FOREIGN KEY (`ContNo`)
    REFERENCES `CIDM_6350_FINAL`.`Contract` (`ContNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PrevRead`
    FOREIGN KEY (`PreviousRead`)
    REFERENCES `CIDM_6350_FINAL`.`Reading` (`ReadingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ThisRead`
    FOREIGN KEY (`CurrentRead`)
    REFERENCES `CIDM_6350_FINAL`.`Reading` (`ReadingId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `CIDM_6350_FINAL`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`Payment` (
  `PaymentId` INT(11) UNSIGNED NOT NULL,
  `BillNo` INT(11) NOT NULL,
  `Payment_date` DATE NOT NULL,
  `PaymentAmount` DECIMAL(16,2) NOT NULL,
  `PaymentMethod` ENUM('check', 'ach', 'card') NULL DEFAULT NULL,
  PRIMARY KEY (`PaymentId`),
  UNIQUE INDEX `PaymentId_UNIQUE` (`PaymentId` ASC) VISIBLE,
  INDEX `BillPaid_idx` (`BillNo` ASC) VISIBLE,
  CONSTRAINT `BillPaid`
    FOREIGN KEY (`BillNo`)
    REFERENCES `CIDM_6350_FINAL`.`Bill` (`BillNo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `CIDM_6350_FINAL` ;

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`CustomerConsumptionByBillingPeriod` (`ContNo` INT, `PreviousReadDate` INT, `PreviousReading` INT, `CurrentReadDate` INT, `CurrentReading` INT, `Consumption` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance` (`ContNo` INT, `Name` INT, `address` INT, `SumPayments` INT, `Balance` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ2_MyReadings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ2_MyReadings` (`ReadDate` INT, `Meter_Number` INT, `address` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments` (`ContNo` INT, `Name` INT, `address` INT, `PreviousReadDate` INT, `PreviousReading` INT, `CurrentReadDate` INT, `CurrentReading` INT, `BillNo` INT, `BillDate` INT, `BillTotal` INT, `PaymentAmount` INT, `Payment_date` INT, `Balance` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019` (`COUNT(*)` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ5_BillsByReaders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ5_BillsByReaders` (`BillNo` INT, `PreviouslyReadBy` INT, `CurrentlyReadBy` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019` (`Name` INT, `consumption` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019` (`consumption` INT);

-- -----------------------------------------------------
-- Placeholder table for view `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019` (`Name` INT, `consumption` INT);

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
        (`e`.`UserName` = REPLACE(CURRENT_USER(), '@%', ''));

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
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019` AS select `cust`.`Name` AS `Name`,sum((`cr`.`ReadingValue` - `pr`.`ReadingValue`)) AS `consumption` from ((((`CIDM_6350_FINAL`.`Bill` `b` join `CIDM_6350_FINAL`.`Reading` `cr` on((`b`.`CurrentRead` = `cr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Reading` `pr` on((`b`.`PreviousRead` = `pr`.`ReadingId`))) join `CIDM_6350_FINAL`.`Contract` `cont` on((`cont`.`ContNo` = `b`.`ContNo`))) join `CIDM_6350_FINAL`.`Customer` `cust` on((`cont`.`CustID` = `cust`.`CustID`))) where ((`cr`.`ReadDate` >= '2019-05-01') and (`cr`.`ReadDate` <= '2019-12-30')) group by `cust`.`Name` having (`consumption` > (select `avgCon`.`consumption` from `CIDM-6350-FINAL`.`IQ7_AvgConsumption_MayToDec_2019` `avgCon`));
USE `CIDM_6350_FINAL`;

DELIMITER $$
USE `CIDM_6350_FINAL`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `CIDM-6350-FINAL`.`Bill_BEFORE_INSERT`
BEFORE INSERT ON `CIDM-6350-FINAL`.`Bill`
FOR EACH ROW
BEGIN
	SET NEW.CurrentRead	 = (SELECT ReadingId FROM Reading WHERE ReadDate = NEW.BillDate LIMIT 1);
    SET NEW.PreviousRead = (SELECT ReadingId FROM Reading WHERE NextReadDate = NEW.BillDate LIMIT 1);
    SET NEW.BillingRate = (SELECT BillRate FROM Contract WHERE ContNo = NEW.ContNo LIMIT 1);
END$$


DELIMITER ;
CREATE USER 'gcreighton' IDENTIFIED BY 'gcreighton';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'gcreighton';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'gcreighton';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'gcreighton';
CREATE USER 'ltschiersch' IDENTIFIED BY 'ltschiersch';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'ltschiersch';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'ltschiersch';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'ltschiersch';
CREATE USER 'rastill' IDENTIFIED BY 'rastill';

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE CIDM-6350-FINAL.* TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ4_NumReadingsByGCreighton_MayToDec2019` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ5_BillsByReaders` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ6_HighestConsumer_MayToDec_2019` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ7_AvgConsumption_MayToDec_2019` TO 'rastill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ8_AboveAverageConsumersMayToDec2019` TO 'rastill';
CREATE USER 'rskip' IDENTIFIED BY 'rskip';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'rskip';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'rskip';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'rskip';
CREATE USER 'lfessby' IDENTIFIED BY 'lfessby';

GRANT INSERT, UPDATE, SELECT ON TABLE `CIDM_6350_FINAL`.`Bill` TO 'lfessby';
GRANT INSERT, SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Customer` TO 'lfessby';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance` TO 'lfessby';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments` TO 'lfessby';
CREATE USER 'bmunson' IDENTIFIED BY 'bmunson';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'bmunson';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'bmunson';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'bmunson';
CREATE USER 'cbuey' IDENTIFIED BY 'cbuey';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'cbuey';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'cbuey';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'cbuey';
CREATE USER 'wcritcher' IDENTIFIED BY 'wcritcher';

GRANT INSERT, UPDATE, SELECT ON TABLE `CIDM_6350_FINAL`.`Bill` TO 'wcritcher';
GRANT INSERT, SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Customer` TO 'wcritcher';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ1_CustomersWithBalance` TO 'wcritcher';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`IQ3_AllReadingsBillsAndPayments` TO 'wcritcher';
CREATE USER 'emadelin' IDENTIFIED BY 'emadelin';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'emadelin';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'emadelin';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'emadelin';
CREATE USER 'gmccaskill' IDENTIFIED BY 'gmccaskill';

GRANT SELECT, INSERT, UPDATE ON TABLE `CIDM_6350_FINAL`.`Reading` TO 'gmccaskill';
GRANT SELECT ON TABLE `CIDM_6350_FINAL`.`Meter` TO 'gmccaskill';
GRANT SELECT, UPDATE ON TABLE `CIDM_6350_FINAL`.`IQ2_MyReadings` TO 'gmccaskill';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
