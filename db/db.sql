SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `misure` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `misure` ;

-- -----------------------------------------------------
-- Table `misure`.`item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`item` ;

CREATE  TABLE IF NOT EXISTS `misure`.`item` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`model`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`model` ;

CREATE  TABLE IF NOT EXISTS `misure`.`model` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `item` INT NOT NULL ,
  `acquire_date` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_model_item1` (`item` ASC) ,
  CONSTRAINT `fk_model_item1`
    FOREIGN KEY (`item` )
    REFERENCES `misure`.`item` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`production`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`production` ;

CREATE  TABLE IF NOT EXISTS `misure`.`production` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `item` INT NOT NULL ,
  `processed` INT NOT NULL DEFAULT 0 ,
  `fault` INT NOT NULL DEFAULT 0 ,
  `production_date_start` DATETIME NOT NULL ,
  `production_date_end` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_production_item1` (`item` ASC) ,
  CONSTRAINT `fk_production_item1`
    FOREIGN KEY (`item` )
    REFERENCES `misure`.`item` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`parameter`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`parameter` ;

CREATE  TABLE IF NOT EXISTS `misure`.`parameter` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `description` VARCHAR(256) NOT NULL DEFAULT '' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`model_parameter_value`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`model_parameter_value` ;

CREATE  TABLE IF NOT EXISTS `misure`.`model_parameter_value` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `model` INT NOT NULL ,
  `parameter` INT NOT NULL ,
  `value` TEXT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_parameter_value_parameter1` (`parameter` ASC) ,
  INDEX `fk_parameter_value_model1` (`model` ASC) ,
  CONSTRAINT `fk_parameter_value_parameter1`
    FOREIGN KEY (`parameter` )
    REFERENCES `misure`.`parameter` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parameter_value_model1`
    FOREIGN KEY (`model` )
    REFERENCES `misure`.`model` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`sample`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`sample` ;

CREATE  TABLE IF NOT EXISTS `misure`.`sample` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `production` INT NOT NULL ,
  `counter` INT NOT NULL ,
  `acquire_date` DATETIME NOT NULL ,
  `fault` TINYINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sample_production1` (`production` ASC) ,
  CONSTRAINT `fk_sample_production1`
    FOREIGN KEY (`production` )
    REFERENCES `misure`.`production` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `misure`.`sample_parameter_value`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `misure`.`sample_parameter_value` ;

CREATE  TABLE IF NOT EXISTS `misure`.`sample_parameter_value` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `sample` INT NOT NULL ,
  `parameter` INT NOT NULL ,
  `value` TEXT NOT NULL ,
  `type` INT NOT NULL COMMENT '0=regular, 1=fault' ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_sample_parameter_value_parameter1` (`parameter` ASC) ,
  INDEX `fk_sample_parameter_value_sample1` (`sample` ASC) ,
  CONSTRAINT `fk_sample_parameter_value_parameter1`
    FOREIGN KEY (`parameter` )
    REFERENCES `misure`.`parameter` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sample_parameter_value_sample1`
    FOREIGN KEY (`sample` )
    REFERENCES `misure`.`sample` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
