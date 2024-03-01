-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CitySluggers
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CitySluggers
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `CitySluggers` DEFAULT CHARACTER SET utf8 ;
USE `CitySluggers` ;

-- -----------------------------------------------------
-- Table `CitySluggers`.`Part`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Part` (
  `SKU` INT NOT NULL,
  `part_name` VARCHAR(45) NOT NULL,
  `vid (FK)` INT NOT NULL,
  PRIMARY KEY (`SKU`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Product` (
  `pid` INT NOT NULL,
  `product_name` VARCHAR(45) NOT NULL,
  `prod_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ProductInventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ProductInventory` (
  `quantity_on_hand` VARCHAR(45) NOT NULL,
  `as_of_date` DATE NOT NULL,
  `trigger_order` INT NOT NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`pid`),
  INDEX `fk_ProductInventory_Product1_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_ProductInventory_Product1`
    FOREIGN KEY (`pid`)
    REFERENCES `CitySluggers`.`Product` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ProductPart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ProductPart` (
  `SKU` INT NOT NULL,
  `pid` INT NOT NULL,
  `qty_part_on_hand` INT NOT NULL,
  `last_update` DATE NOT NULL,
  PRIMARY KEY (`SKU`, `pid`),
  INDEX `fk_ProductPart_Part_idx` (`SKU` ASC) VISIBLE,
  INDEX `fk_ProductPart_Product1_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_ProductPart_Part`
    FOREIGN KEY (`SKU`)
    REFERENCES `CitySluggers`.`Part` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ProductPart_Product1`
    FOREIGN KEY (`pid`)
    REFERENCES `CitySluggers`.`Product` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ProductPrice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ProductPrice` (
  `price` INT NOT NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`pid`),
  INDEX `fk_ProductPrice_Product1_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_ProductPrice_Product1`
    FOREIGN KEY (`pid`)
    REFERENCES `CitySluggers`.`Product` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ProductPriceHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ProductPriceHistory` (
  `price_date` DATE NOT NULL,
  `last_price` INT NOT NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`price_date`, `pid`),
  INDEX `fk_ProductPriceHistory_ProductPrice1_idx` (`pid` ASC) VISIBLE,
  CONSTRAINT `fk_ProductPriceHistory_ProductPrice1`
    FOREIGN KEY (`pid`)
    REFERENCES `CitySluggers`.`ProductPrice` (`pid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`AddressType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`AddressType` (
  `add_id` INT NOT NULL,
  `address_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`add_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ZipCodeCity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ZipCodeCity` (
  `zip_code` INT NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `st` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`zip_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Customer` (
  `cid` INT NOT NULL,
  `title` CHAR(4) NOT NULL,
  `cfn` VARCHAR(45) NOT NULL,
  `cln` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Address` (
  `street` VARCHAR(45) NOT NULL,
  `zip_code` INT NOT NULL,
  `add_id` INT NOT NULL,
  `cid` INT NOT NULL,
  PRIMARY KEY (`add_id`, `cid`),
  INDEX `fk_Address_Customer1_idx` (`cid` ASC) VISIBLE,
  CONSTRAINT `fk_Address_ZipCodeCity1`
    FOREIGN KEY (`zip_code`)
    REFERENCES `CitySluggers`.`ZipCodeCity` (`zip_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Address_AddressType1`
    FOREIGN KEY (`add_id`)
    REFERENCES `CitySluggers`.`AddressType` (`add_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Address_Customer1`
    FOREIGN KEY (`cid`)
    REFERENCES `CitySluggers`.`Customer` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ContactType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ContactType` (
  `contact_id` INT NOT NULL,
  `contact_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contact_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`CustomerContact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`CustomerContact` (
  `contact` VARCHAR(45) NOT NULL,
  `cid` INT NOT NULL,
  `contact_id` INT NOT NULL,
  PRIMARY KEY (`cid`, `contact_id`),
  INDEX `fk_CustomerContact_ContactType1_idx` (`contact_id` ASC) VISIBLE,
  CONSTRAINT `fk_CustomerContact_Customer1`
    FOREIGN KEY (`cid`)
    REFERENCES `CitySluggers`.`Customer` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CustomerContact_ContactType1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `CitySluggers`.`ContactType` (`contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`PaymentMethod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`PaymentMethod` (
  `method_id` INT NOT NULL,
  `method_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`method_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`CustomerPaymentMethod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`CustomerPaymentMethod` (
  `method_id` INT NOT NULL,
  `cid` INT NOT NULL,
  PRIMARY KEY (`method_id`, `cid`),
  INDEX `fk_CustomerPaymentMethod_Customer1_idx` (`cid` ASC) VISIBLE,
  CONSTRAINT `fk_CustomerPaymentMethod_PaymentMethod1`
    FOREIGN KEY (`method_id`)
    REFERENCES `CitySluggers`.`PaymentMethod` (`method_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CustomerPaymentMethod_Customer1`
    FOREIGN KEY (`cid`)
    REFERENCES `CitySluggers`.`Customer` (`cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Bank`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Bank` (
  `routing_id` INT NOT NULL,
  `bank_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`routing_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Checking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Checking` (
  `acct_id` INT NOT NULL,
  `method_id` INT NOT NULL,
  `cid` INT NOT NULL,
  `routing_id` INT NOT NULL,
  PRIMARY KEY (`acct_id`, `method_id`, `cid`),
  INDEX `fk_Checking_CustomerPaymentMethod1_idx` (`method_id` ASC, `cid` ASC) VISIBLE,
  INDEX `fk_Checking_Bank1_idx` (`routing_id` ASC) VISIBLE,
  CONSTRAINT `fk_Checking_CustomerPaymentMethod1`
    FOREIGN KEY (`method_id` , `cid`)
    REFERENCES `CitySluggers`.`CustomerPaymentMethod` (`method_id` , `cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Checking_Bank1`
    FOREIGN KEY (`routing_id`)
    REFERENCES `CitySluggers`.`Bank` (`routing_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`GiftCardAmt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`GiftCardAmt` (
  `gift_card_number` CHAR(16) NOT NULL,
  `card_amt` INT NOT NULL,
  PRIMARY KEY (`gift_card_number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`GiftCard`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`GiftCard` (
  `gift_card_number` CHAR(16) NOT NULL,
  `method_id` INT NOT NULL,
  `cid` INT NOT NULL,
  PRIMARY KEY (`gift_card_number`, `method_id`, `cid`),
  INDEX `fk_GiftCard_CustomerPaymentMethod1_idx` (`method_id` ASC, `cid` ASC) VISIBLE,
  CONSTRAINT `fk_GiftCard_GiftCardAmt1`
    FOREIGN KEY (`gift_card_number`)
    REFERENCES `CitySluggers`.`GiftCardAmt` (`gift_card_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GiftCard_CustomerPaymentMethod1`
    FOREIGN KEY (`method_id` , `cid`)
    REFERENCES `CitySluggers`.`CustomerPaymentMethod` (`method_id` , `cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Card`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Card` (
  `card_number` CHAR(16) NOT NULL,
  `card_name` VARCHAR(45) NOT NULL,
  `card_ccv2` CHAR(4) NOT NULL,
  `card_zip` CHAR(5) NOT NULL,
  `card_month` CHAR(2) NOT NULL,
  `card_year` CHAR(4) NOT NULL,
  PRIMARY KEY (`card_number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`CreditDebit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`CreditDebit` (
  `card_number` CHAR(16) NOT NULL,
  `method_id` INT NOT NULL,
  `cid` INT NOT NULL,
  PRIMARY KEY (`card_number`, `method_id`, `cid`),
  INDEX `fk_CreditDebit_CustomerPaymentMethod1_idx` (`method_id` ASC, `cid` ASC) VISIBLE,
  CONSTRAINT `fk_CreditDebit_Card1`
    FOREIGN KEY (`card_number`)
    REFERENCES `CitySluggers`.`Card` (`card_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CreditDebit_CustomerPaymentMethod1`
    FOREIGN KEY (`method_id` , `cid`)
    REFERENCES `CitySluggers`.`CustomerPaymentMethod` (`method_id` , `cid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`CurrStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`CurrStatus` (
  `statusID` INT NOT NULL,
  `status_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`statusID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`PlacedOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`PlacedOrder` (
  `order_id` INT NOT NULL,
  `order_date` DATETIME NOT NULL,
  PRIMARY KEY (`order_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`OrderStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`OrderStatus` (
  `order_id` INT NOT NULL,
  `statusID` INT NOT NULL,
  `as_of_date` DATETIME NOT NULL,
  PRIMARY KEY (`order_id`, `statusID`),
  INDEX `fk_OrderStatus_CurrStatus1_idx` (`statusID` ASC) VISIBLE,
  CONSTRAINT `fk_OrderStatus_PlacedOrder1`
    FOREIGN KEY (`order_id`)
    REFERENCES `CitySluggers`.`PlacedOrder` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrderStatus_CurrStatus1`
    FOREIGN KEY (`statusID`)
    REFERENCES `CitySluggers`.`CurrStatus` (`statusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`LineItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`LineItem` (
  `order_id` INT NOT NULL,
  `pid` INT NOT NULL,
  `qty` INT NOT NULL,
  PRIMARY KEY (`order_id`, `pid`),
  CONSTRAINT `fk_LineItem_PlacedOrder1`
    FOREIGN KEY (`order_id`)
    REFERENCES `CitySluggers`.`PlacedOrder` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`table1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`table1` (
  `order_id` INT NOT NULL,
  `cid (FK)` INT NOT NULL,
  `method_id (FK)` INT NOT NULL,
  `payment_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  CONSTRAINT `fk_table1_PlacedOrder1`
    FOREIGN KEY (`order_id`)
    REFERENCES `CitySluggers`.`PlacedOrder` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`VendorCompany`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`VendorCompany` (
  `vid` INT NOT NULL,
  `vendor_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`vid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`VendorContact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`VendorContact` (
  `v_contact_id` INT NOT NULL,
  `v_contact_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`v_contact_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`VendorSalesPerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`VendorSalesPerson` (
  `v_person_id` INT NOT NULL,
  `vfn` VARCHAR(45) NOT NULL,
  `vln` VARCHAR(45) NOT NULL,
  `vid` INT NOT NULL,
  PRIMARY KEY (`v_person_id`),
  INDEX `fk_VendorSalesPerson_VendorCompany1_idx` (`vid` ASC) VISIBLE,
  CONSTRAINT `fk_VendorSalesPerson_VendorCompany1`
    FOREIGN KEY (`vid`)
    REFERENCES `CitySluggers`.`VendorCompany` (`vid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`VendorPersonContact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`VendorPersonContact` (
  `v_person_id` INT NOT NULL,
  `v_contact_id` INT NOT NULL,
  `v_contact` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`v_person_id`, `v_contact_id`),
  INDEX `fk_VendorPersonContact_VendorContact1_idx` (`v_contact_id` ASC) VISIBLE,
  CONSTRAINT `fk_VendorPersonContact_VendorSalesPerson1`
    FOREIGN KEY (`v_person_id`)
    REFERENCES `CitySluggers`.`VendorSalesPerson` (`v_person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VendorPersonContact_VendorContact1`
    FOREIGN KEY (`v_contact_id`)
    REFERENCES `CitySluggers`.`VendorContact` (`v_contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Employee` (
  `eid` INT NOT NULL,
  `efn` VARCHAR(45) NOT NULL,
  `eln` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`eid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Address1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Address1` (
  `eaid` INT NOT NULL,
  `estreet` VARCHAR(45) NOT NULL,
  `ecity` VARCHAR(45) NOT NULL,
  `est` CHAR(2) NOT NULL,
  `ezip` CHAR(5) NOT NULL,
  `eid` INT NOT NULL,
  PRIMARY KEY (`eaid`),
  INDEX `fk_Address_Employee_idx` (`eid` ASC) VISIBLE,
  CONSTRAINT `fk_Address_Employee`
    FOREIGN KEY (`eid`)
    REFERENCES `CitySluggers`.`Employee` (`eid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`ContactType1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`ContactType1` (
  `contact_id` INT NOT NULL,
  `contact_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contact_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`EmpContact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`EmpContact` (
  `eid` INT NOT NULL,
  `contact_id` INT NOT NULL,
  `contact` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`eid`, `contact_id`),
  INDEX `fk_Employee_has_Contact_Contact1_idx` (`contact_id` ASC) VISIBLE,
  INDEX `fk_Employee_has_Contact_Employee1_idx` (`eid` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_has_Contact_Employee1`
    FOREIGN KEY (`eid`)
    REFERENCES `CitySluggers`.`Employee` (`eid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Employee_has_Contact_Contact1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `CitySluggers`.`ContactType1` (`contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`Department` (
  `dept_id` INT NOT NULL,
  `dept_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dept_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`EmpPos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`EmpPos` (
  `pos_id` INT NOT NULL,
  `pos_name` VARCHAR(45) NOT NULL,
  `dept_id` INT NOT NULL,
  PRIMARY KEY (`pos_id`),
  INDEX `1_idx` (`dept_id` ASC) VISIBLE,
  CONSTRAINT `1`
    FOREIGN KEY (`dept_id`)
    REFERENCES `CitySluggers`.`Department` (`dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`SalType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`SalType` (
  `sal_id` INT NOT NULL,
  `sal_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sal_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`SalPos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`SalPos` (
  `pos_id` INT NOT NULL,
  `sal_id` INT NOT NULL,
  `sal_date` DATETIME NOT NULL,
  `sal_value` INT NOT NULL,
  PRIMARY KEY (`pos_id`, `sal_id`, `sal_date`),
  INDEX `2_idx` (`sal_id` ASC) VISIBLE,
  INDEX `3_idx` (`pos_id` ASC) VISIBLE,
  CONSTRAINT `2`
    FOREIGN KEY (`sal_id`)
    REFERENCES `CitySluggers`.`SalType` (`sal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `3`
    FOREIGN KEY (`pos_id`)
    REFERENCES `CitySluggers`.`EmpPos` (`pos_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`HistoryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`HistoryStatus` (
  `status_id` INT NOT NULL,
  `status_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`status_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CitySluggers`.`EmpHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CitySluggers`.`EmpHistory` (
  `eid` INT NOT NULL,
  `pos_id` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `salary` INT NOT NULL,
  `comments` VARCHAR(255) NOT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`eid`, `pos_id`, `start_date`),
  INDEX `4_idx` (`status_id` ASC) VISIBLE,
  INDEX `5_idx` (`eid` ASC) VISIBLE,
  INDEX `6_idx` (`pos_id` ASC) VISIBLE,
  CONSTRAINT `4`
    FOREIGN KEY (`status_id`)
    REFERENCES `CitySluggers`.`HistoryStatus` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `5`
    FOREIGN KEY (`eid`)
    REFERENCES `CitySluggers`.`Employee` (`eid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `6`
    FOREIGN KEY (`pos_id`)
    REFERENCES `CitySluggers`.`EmpPos` (`pos_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
