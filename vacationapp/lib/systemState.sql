CREATE TABLE systemState (
	sysStateId int PRIMARY KEY auto_increment,
	currentRoundNumber int,
    currentTurnPriority int
    );
    
    SELECT * FROM systemstate;
    
    INSERT INTO systemState (currentRoundNumber, currentTurnPriority, sysStateId)
    VALUES (100, 1, 1);
    
    UPDATE systemState
    SET currentRoundNumber = 100
    WHERE sysStateId = 1;
    
    