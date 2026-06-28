CREATE TABLE timerState (
	timerId int PRIMARY KEY auto_increment,
    timerIsActive boolean,
    turnEndTime DateTime
    );
    
    SELECT * FROM timerState;
    
    INSERT INTO timerState (timerId, timerIsActive, turnEndTime)
    VALUES (1, false, NULL);