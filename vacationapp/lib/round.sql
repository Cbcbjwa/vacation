CREATE TABLE round (
	roundId int PRIMARY KEY auto_increment,
    roundNumber int
    );
    
    SELECT * FROM round;
    
    INSERT INTO round (roundId, roundNumber)
    VALUES (0, 0);
    
    ALTER TABLE round
    ADD COLUMN isComplete boolean;
    
    UPDATE round
    SET isActive = false
    WHERE roundNumber = -1;