-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema payments
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema payments
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `payments` ;

-- -----------------------------------------------------
-- Schema payments
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `payments` DEFAULT CHARACTER SET utf8 ;
USE `payments` ;

-- -----------------------------------------------------
-- Table `Bank`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Bank` ;

CREATE TABLE IF NOT EXISTS `Bank` (
  `routing_id` INT(11) NOT NULL,
  `bank_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`routing_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `PaymentMethod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PaymentMethod` ;

CREATE TABLE IF NOT EXISTS `PaymentMethod` (
  `method_id` INT(11) NOT NULL,
  `method_desc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`method_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CustomerPaymentMethod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CustomerPaymentMethod` ;

CREATE TABLE IF NOT EXISTS `CustomerPaymentMethod` (
  `cid` INT(11) NOT NULL,
  `method_id` INT(11) NOT NULL,
  PRIMARY KEY (`cid`, `method_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Checking`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Checking` ;

CREATE TABLE IF NOT EXISTS `Checking` (
  `cid` INT(11) NOT NULL,
  `method_id` INT(11) NOT NULL,
  `acct_id` BIGINT(16) NOT NULL,
  `routing_id` INT(11) NOT NULL,
  PRIMARY KEY (`method_id`, `cid`, `acct_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CustCard`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CustCard` ;

CREATE TABLE IF NOT EXISTS `CustCard` (
  `card_number` BIGINT(16) NOT NULL,
  `card_name` VARCHAR(45) NOT NULL,
  `card_ccv2` CHAR(4) NOT NULL,
  `card_zip` CHAR(5) NOT NULL,
  `card_month` CHAR(2) NOT NULL,
  `card_year` CHAR(4) NOT NULL,
  PRIMARY KEY (`card_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `CreditDebit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CreditDebit` ;

CREATE TABLE IF NOT EXISTS `CreditDebit` (
  `cid` INT(11) NOT NULL,
  `method_id` INT(11) NOT NULL,
  `card_number` BIGINT(16) NOT NULL,
  PRIMARY KEY (`cid`, `method_id`, `card_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `GiftCardAmt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GiftCardAmt` ;

CREATE TABLE IF NOT EXISTS `GiftCardAmt` (
  `gift_card_number` BIGINT(16) NOT NULL,
  `card_amt` INT(11) NOT NULL,
  PRIMARY KEY (`gift_card_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `GiftCard`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GiftCard` ;

CREATE TABLE IF NOT EXISTS `GiftCard` (
  `cid` INT(11) NOT NULL,
  `method_id` INT(11) NOT NULL,
  `gift_card_number` BIGINT(16) NOT NULL,
  PRIMARY KEY (`cid`, `method_id`, `gift_card_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `GiftCardHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `GiftCardHistory` ;

CREATE TABLE IF NOT EXISTS `GiftCardHistory` (
  `gift_card_number` BIGINT(16) NOT NULL,
  `date_used` DATETIME NOT NULL,
  `amount_used` INT(11) NOT NULL,
  PRIMARY KEY (`gift_card_number`, `date_used`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
