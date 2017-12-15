CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`book_BEFORE_INSERT` BEFORE INSERT ON `book` FOR EACH ROW
BEGIN
	IF (NEW.start_date > NEW.end_date OR NEW.end_data > NEW.release_date) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid dates';
	END IF;
END