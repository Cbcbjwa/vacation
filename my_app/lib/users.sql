CREATE TABLE users (
	id int PRIMARY KEY auto_increment,
    userName varchar(255),
    email varchar(255),
    docRole enum('admin', 'physician'),
    passwordHash varchar(255)
    );
    
    SELECT * FROM users;
    
    ALTER TABLE users
    ADD phoneNumber varchar(255);
    
    ALTER TABLE users
    ADD priorityNumber int;
    
    UPDATE users
    SET label2 = "N/A"
    WHERE id = 34;

	DELETE FROM users WHERE userName = "Freddy Krueger";
    
    ALTER TABLE users
    ADD label2 varchar(255);
    
    ALTER TABLE users DROP COLUMN totalSlots;
    
    DELETE FROM users WHERE email='jasonvoorhees@gmail.com';