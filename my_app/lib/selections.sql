CREATE TABLE selections (
	selectionId int PRIMARY KEY auto_increment,
    userId int,
    weekId int,
    roundNumber int
    );
    
    SELECT * FROM selections;
    
    INSERT INTO selections (selectionId, userId, weekId, roundNumber)
    VALUES (1, 1, 1, 1);
    
    DELETE FROM selections WHERE selectionId = 23;