CREATE TABLE systemState (
	sysStateId int PRIMARY KEY auto_increment,
	currentRoundNumber int,
    currentTurnPriority int
    );
    
    SELECT * FROM systemState;
    
    INSERT INTO systemState (currentRoundNumber, currentTurnPriority, sysStateId)
    VALUES (100, 1, 1);
    
    