CREATE TABLE round (
	roundId int PRIMARY KEY auto_increment,
    roundNumber int
    );
    
    SELECT * FROM round;
    
    INSERT INTO round (roundId, roundNumber)
    VALUES (0, 0);
    
    ALTER TABLE round
    ADD COLUMN roundName varchar(255);
    
    UPDATE round
    SET roundName = "Round 9"
    WHERE roundNumber = 9;