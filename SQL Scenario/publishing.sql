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
-- Table `mydb`.`author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`author`;
CREATE TABLE IF NOT EXISTS `mydb`.`author` (
  `author_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`author_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`book`;
CREATE TABLE IF NOT EXISTS `mydb`.`book` (
  `book_id` INT NOT NULL AUTO_INCREMENT,
  `fk_author_id` INT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `genre` ENUM('Fantasy', 'Sci-fi', 'Action', 'Mystery', 'Horror', 'Biography', 'Historic', 'Non-fiction', 'Other') NULL,
  `pages` INT NULL,
  `backing` ENUM('paperback', 'hardback', 'libraryback') NULL,
  `price` FLOAT NULL,
  `status` ENUM('Finished', 'Unfinished', 'Postponed', 'On Hold') NOT NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `release_date` DATE NULL,
  `sales` INT NULL,
  PRIMARY KEY (`book_id`),
  INDEX `fk_author_id_idx` (`fk_author_id` ASC),
  CONSTRAINT `fk_author_id`
    FOREIGN KEY (`fk_author_id`)
    REFERENCES `mydb`.`author` (`author_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb`;

DROP TRIGGER IF EXISTS `mydb`.`book_BEFORE_INSERT`;
DELIMITER $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`book_BEFORE_INSERT` BEFORE INSERT ON `book` FOR EACH ROW
BEGIN
	IF (NEW.start_date > NEW.end_date OR NEW.end_date > NEW.release_date) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid dates';
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


INSERT INTO author(name) VALUES('Patrick Rothfuss');
INSERT INTO author(name) VALUES('Jim Butcher');
INSERT INTO author(name) VALUES('J.K. Rowling');

INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(1,'The Name of the Wind','Fantasy',662,'Hardback',10.00,'Finished','2005-11-02','2007-01-15','2007-03-27',3141592);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(1,'The Wise Man\'s Fear','Fantasy',994,'Hardback',10.00,'Finished','2007-11-01','2011-01-15','2011-03-01',1414213);
INSERT INTO book(fk_author_id,title,genre,price,status,start_date,end_date,release_date) VALUES(1,'The Doors of Stone','Fantasy',10.00,'Unfinished','2011-11-01','2019-02-28','2019-03-05');

INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Storm Front','Fantasy',322,'Paperback',7.89,'Finished','1999-05-05','2000-03-01','2000-04-01',5867433);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Fool Moon','Fantasy',352,'Paperback',7.89,'Finished','2000-05-05','2000-11-25','2001-01-01',5556431);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Grave Peril','Fantasy',378,'Paperback',7.89,'Finished','2001-02-05','2001-08-25','2001-09-01',3345414);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Summer Knight','Fantasy',371,'Paperback',7.89,'Finished','2001-09-25','2002-08-25','2002-09-02',4122017);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Death Mask','Fantasy',374,'Paperback',7.89,'Finished','2002-09-25','2003-07-25','2003-08-05',1513141);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Blood Rites','Fantasy',372,'Paperback',7.89,'Finished','2003-08-25','2004-07-25','2004-08-03',1725463);
INSERT INTO book(fk_author_id,title,genre,pages,backing,price,status,start_date,end_date,release_date,sales) VALUES(2,'Dead Beat','Fantasy',396,'Paperback',7.89,'Finished','2004-08-25','2005-04-25','2005-05-03',3876547);

INSERT INTO book(fk_author_id, title, genre, pages, backing, price, status, start_date, end_date, release_date, sales) VALUES(3,'Harry Potter and the Order of the Phoenix', 'Fantasy', 766, 'Hardback', 30.89, 'Finished', '2003-06-21', '2008-06-21', '2010-06-21', 27182818);
INSERT INTO book(fk_author_id, title, genre, pages, backing, price, status, start_date, end_date, release_date, sales) VALUES(3,'Harry Potter and the Chamber of Secrets', 'Fantasy', 251, 'Paperback', 9.99, 'Finished', '1998-07-02', '1999-06-02', '2000-01-01', 6273598);
INSERT INTO book(fk_author_id, title, genre, status, start_date, end_date, release_date) VALUES(3,'Harry Potter and the Cursed Child', 'Fantasy', 'Unfinished', '2016-07-31', '2017-12-31', '2018-08-23');


SELECT a.name, SUM(b.sales) as total_sales FROM book b JOIN author a ON b.fk_author_id = a.author_id GROUP BY a.name ORDER BY total_sales DESC;
SELECT genre, sum(sales) as total_sales FROM book GROUP BY genre ORDER BY total_sales DESC;
SELECT title, end_date, release_date FROM book WHERE status != 'Finished';
SELECT a.name, SUM(b.sales) as total_sales FROM book b JOIN author a ON b.fk_author_id = a.author_id GROUP BY a.name ORDER BY total_sales ASC;
SELECT b.title, b.sales FROM book b JOIN author a ON b.fk_author_id = a.author_id WHERE status='Finished' AND a.name="Jim Butcher";
SELECT b.title, b.sales FROM book b JOIN author a ON b.fk_author_id = a.author_id WHERE status='Finished' AND a.name="Patrick Rothfuss";
SELECT b.title, b.sales FROM book b JOIN author a ON b.fk_author_id = a.author_id WHERE status='Finished' AND a.name="J.K. Rowling";
SELECT title, price, pages, release_date FROM book WHERE title='The Doors of Stone'; 
SELECT title, price, pages, release_date FROM book WHERE title='Harry Potter and the Cursed Child'; 
SELECT genre, sum(sales) as total_sales FROM book GROUP BY genre ORDER BY total_sales ASC;
SELECT b.title, b.end_date, b.status FROM book b JOIN author a ON b.fk_author_id = a.author_id WHERE a.name='Patrick Rothfuss' AND status != 'Finished';

Select * FROM author;
