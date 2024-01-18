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

-- -----------------------------------------------------
-- Trigger for Bill
-- -----------------------------------------------------
DELIMITER $$
USE `CIDM_6350_FINAL`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `CIDM_6350_FINAL`.`Bill_BEFORE_INSERT`
BEFORE INSERT ON `CIDM_6350_FINAL`.`Bill`
FOR EACH ROW
BEGIN
	SET NEW.CurrentRead	 = (SELECT ReadingId FROM Reading WHERE ReadDate = NEW.BillDate LIMIT 1);
    SET NEW.PreviousRead = (SELECT ReadingId FROM Reading WHERE NextReadDate = NEW.BillDate LIMIT 1);
    SET NEW.BillingRate = (SELECT BillRate FROM Contract WHERE ContNo = NEW.ContNo LIMIT 1);
END$$
