-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Address` (
  `AddressID` INT NOT NULL,
  `UnitNumber` INT NULL,
  `StreetNumber` INT NOT NULL,
  `StreetName` VARCHAR(45) NOT NULL,
  `SuburbName` VARCHAR(45) NOT NULL,
  `Postcode` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`AddressID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Product` (
  `ProductID` INT NOT NULL,
  `Ingredient` TINYINT(1) NOT NULL,
  PRIMARY KEY (`ProductID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TrafficLightRating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TrafficLightRating` (
  `TrafficLightRatingID` INT NOT NULL,
  PRIMARY KEY (`TrafficLightRatingID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Version`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Version` (
  `VersionNumber` INT NOT NULL,
  `ProductID` INT NOT NULL,
  `TrafficLightRatingID` INT NOT NULL,
  `DateRolledOut` DATETIME NOT NULL,
  `Website` VARCHAR(100) NOT NULL,
  `DateDiscontinued` DATETIME NULL,
  `NetWeight` INT NULL,
  `NetWeightUnit` VARCHAR(5) NULL,
  PRIMARY KEY (`VersionNumber`),
  INDEX `fk_ProductVersion_Product1_idx` (`ProductID` ASC),
  INDEX `fk_Version_TrafficLightRating1_idx` (`TrafficLightRatingID` ASC),
  CONSTRAINT `fk_ProductVersion_Product1`
    FOREIGN KEY (`ProductID`)
    REFERENCES `mydb`.`Product` (`ProductID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Version_TrafficLightRating1`
    FOREIGN KEY (`TrafficLightRatingID`)
    REFERENCES `mydb`.`TrafficLightRating` (`TrafficLightRatingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Date` (
  `DateManufactured` DATETIME NOT NULL,
  `BestBefore` DATETIME NOT NULL,
  `UsedBy` DATETIME NULL,
  PRIMARY KEY (`DateManufactured`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Batch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Batch` (
  `BatchID` INT NOT NULL,
  `VersionNumber` INT NOT NULL,
  `AddressID` INT NOT NULL,
  `DateManufactured` DATETIME NOT NULL,
  `Barcode` INT NOT NULL,
  `CountryOfOrigin` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`BatchID`),
  INDEX `fk_Batch_Address1_idx` (`AddressID` ASC),
  INDEX `fk_Batch_ProductVersion1_idx` (`VersionNumber` ASC),
  INDEX `fk_Batch_Date1_idx` (`DateManufactured` ASC),
  CONSTRAINT `fk_Batch_Address1`
    FOREIGN KEY (`AddressID`)
    REFERENCES `mydb`.`Address` (`AddressID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Batch_ProductVersion1`
    FOREIGN KEY (`VersionNumber`)
    REFERENCES `mydb`.`Version` (`VersionNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Batch_Date1`
    FOREIGN KEY (`DateManufactured`)
    REFERENCES `mydb`.`Date` (`DateManufactured`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Serving`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Serving` (
  `ServingID` INT NOT NULL,
  `NumServing` INT NOT NULL,
  `ServingSize` INT NOT NULL,
  `RecommendedServing` INT NULL,
  PRIMARY KEY (`ServingID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NutritionInformationPanel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`NutritionInformationPanel` (
  `NutritionInformationPanelID` INT NOT NULL,
  `ServingID` INT NOT NULL,
  `VersionNumber` INT NOT NULL,
  `ProductName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NutritionInformationPanelID`),
  INDEX `fk_NutritionInformationPanel_Serving1_idx` (`ServingID` ASC),
  INDEX `fk_NutritionInformationPanel_Version1_idx` (`VersionNumber` ASC),
  CONSTRAINT `fk_NutritionInformationPanel_Serving1`
    FOREIGN KEY (`ServingID`)
    REFERENCES `mydb`.`Serving` (`ServingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NutritionInformationPanel_Version1`
    FOREIGN KEY (`VersionNumber`)
    REFERENCES `mydb`.`Version` (`VersionNumber`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Nutrition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Nutrition` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `NutritionInformationPanelID` INT NOT NULL,
  `NutritionValue` DOUBLE NOT NULL,
  PRIMARY KEY (`NutritionID`),
  INDEX `fk_Nutrition_NutritionInformationPanel1_idx` (`NutritionInformationPanelID` ASC),
  CONSTRAINT `fk_Nutrition_NutritionInformationPanel1`
    FOREIGN KEY (`NutritionInformationPanelID`)
    REFERENCES `mydb`.`NutritionInformationPanel` (`NutritionInformationPanelID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Energy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Energy` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('kJ', 'cal') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Energy_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Fat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Fat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Fat_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SaturatedFat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SaturatedFat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_SaturatedFat_Fat1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Fat` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`UnsaturatedFat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`UnsaturatedFat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_UnsaturatedFat_Fat1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Fat` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Carbohydrate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Carbohydrate` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Carbohydrate_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sugar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sugar` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Sugar_Carbohydrate1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Carbohydrate` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Protein`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Protein` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Protein_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sodium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sodium` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Sodium_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Fibre`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Fibre` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_Fibre_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`VitaminsAndMinerals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`VitaminsAndMinerals` (
  `NutritionID` INT ZEROFILL NOT NULL,
  `Unit` ENUM('mg') NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_VitaminsAndMinerals_Nutrition1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`Nutrition` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Threshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Threshold` (
  `ThresholdID` INT NOT NULL,
  `TrafficLightRatingID` INT NOT NULL,
  PRIMARY KEY (`ThresholdID`),
  INDEX `fk_Threshold_TrafficLightRating1_idx` (`TrafficLightRatingID` ASC),
  CONSTRAINT `fk_Threshold_TrafficLightRating1`
    FOREIGN KEY (`TrafficLightRatingID`)
    REFERENCES `mydb`.`TrafficLightRating` (`TrafficLightRatingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SaturatedFatThreshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SaturatedFatThreshold` (
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `ThresholdID` INT NOT NULL,
  `ThresholdDesc` VARCHAR(45) NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`StartDate`, `ThresholdID`),
  CONSTRAINT `fk_SaturatedFatThreshold_Threshold1`
    FOREIGN KEY (`ThresholdID`)
    REFERENCES `mydb`.`Threshold` (`ThresholdID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SugarThreshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SugarThreshold` (
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `ThresholdID` INT NOT NULL,
  `ThresholdDesc` VARCHAR(45) NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`StartDate`, `ThresholdID`),
  INDEX `fk_SugarThreshold_Threshold1_idx` (`ThresholdID` ASC),
  CONSTRAINT `fk_SugarThreshold_Threshold1`
    FOREIGN KEY (`ThresholdID`)
    REFERENCES `mydb`.`Threshold` (`ThresholdID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FibreThreshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FibreThreshold` (
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `ThresholdID` INT NOT NULL,
  `ThresholdDesc` VARCHAR(45) NULL,
  `Unit` ENUM('g') NOT NULL,
  PRIMARY KEY (`StartDate`, `ThresholdID`),
  INDEX `fk_FibreThreshold_Threshold1_idx` (`ThresholdID` ASC),
  CONSTRAINT `fk_FibreThreshold_Threshold1`
    FOREIGN KEY (`ThresholdID`)
    REFERENCES `mydb`.`Threshold` (`ThresholdID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Green`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Green` (
  `TrafficLightRatingID` INT NOT NULL,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TrafficLightRatingID`),
  CONSTRAINT `fk_Green_TrafficLightRating1`
    FOREIGN KEY (`TrafficLightRatingID`)
    REFERENCES `mydb`.`TrafficLightRating` (`TrafficLightRatingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Amber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Amber` (
  `TrafficLightRatingID` INT NOT NULL,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TrafficLightRatingID`),
  CONSTRAINT `fk_Amber_TrafficLightRating1`
    FOREIGN KEY (`TrafficLightRatingID`)
    REFERENCES `mydb`.`TrafficLightRating` (`TrafficLightRatingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Red`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Red` (
  `TrafficLightRatingID` INT NOT NULL,
  `Description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TrafficLightRatingID`),
  CONSTRAINT `fk_Red_TrafficLightRating1`
    FOREIGN KEY (`TrafficLightRatingID`)
    REFERENCES `mydb`.`TrafficLightRating` (`TrafficLightRatingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EnergyThreshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EnergyThreshold` (
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `ThresholdID` INT NOT NULL,
  `ThresholdDesc` VARCHAR(45) NULL,
  `Unit` ENUM('kJ') NOT NULL,
  PRIMARY KEY (`StartDate`, `ThresholdID`),
  INDEX `fk_EnergyThreshold_Threshold1_idx` (`ThresholdID` ASC),
  CONSTRAINT `fk_EnergyThreshold_Threshold1`
    FOREIGN KEY (`ThresholdID`)
    REFERENCES `mydb`.`Threshold` (`ThresholdID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SodiumThreshold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SodiumThreshold` (
  `StartDate` DATETIME NOT NULL,
  `EndDate` DATETIME NULL,
  `ThresholdID` INT NOT NULL,
  `ThresholdDesc` VARCHAR(45) NULL,
  `Unit` ENUM('mg') NOT NULL,
  PRIMARY KEY (`StartDate`, `ThresholdID`),
  INDEX `fk_SodiumThreshold_Threshold1_idx` (`ThresholdID` ASC),
  CONSTRAINT `fk_SodiumThreshold_Threshold1`
    FOREIGN KEY (`ThresholdID`)
    REFERENCES `mydb`.`Threshold` (`ThresholdID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MonoUnsaturatedFat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MonoUnsaturatedFat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_MonoUnsaturatedFat_UnsaturatedFat1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`UnsaturatedFat` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PolyUnsaturatedFat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PolyUnsaturatedFat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_PolyUnsaturatedFat_UnsaturatedFat1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`UnsaturatedFat` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TransUnsaturatedFat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TransUnsaturatedFat` (
  `NutritionID` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`NutritionID`),
  CONSTRAINT `fk_TransUnsaturatedFat_UnsaturatedFat1`
    FOREIGN KEY (`NutritionID`)
    REFERENCES `mydb`.`UnsaturatedFat` (`NutritionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
