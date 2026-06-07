CREATE TABLE systemState (
	currentRoundNumber int,
    currentTurnPriority int
    );
    
    SELECT * FROM systemState;
    
    ALTER TABLE systemState
    ADD sysStateId int;
    
    INSERT INTO systemState (currentRoundNumber, currentTurnPriority, sysStateId)
    VALUES (null, 1, 1);