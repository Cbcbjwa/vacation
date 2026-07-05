CREATE TABLE refreshTokens (
	tokenId int PRIMARY KEY auto_increment,
    userId int,
    token varchar(255),
    expiresAt DateTime,
    createdAt DateTime DEFAULT current_timestamp
    );
    
    SELECT * FROM refreshTokens;