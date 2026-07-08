CREATE TABLE weeks (
	weekId int PRIMARY KEY auto_increment,
    weekNumber int,
    weekDate varchar(255),
    availableSlots int,
    specialSpecification varchar(255)
    );
    
    SELECT * FROM weeks;
    
    INSERT INTO weeks (weekId, weekNumber, weekDate, availableSlots, specialSpecification)
    VALUES (1, 1, "1/4 - 1/8", 8, "N/A");
    
    ALTER TABLE weeks
    ADD totalSlots int;
    
    UPDATE weeks
    SET availableSlots = 8
    WHERE weekId = 11;
    