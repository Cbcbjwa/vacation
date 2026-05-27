 CREATE TABLE sites (
	siteId int PRIMARY KEY auto_increment,
    siteName varchar(255),
    maxDocsOffPerWeek int
    );
    
    SELECT * FROM sites;
    
    INSERT INTO sites (siteId, siteName, maxDocsOffPerWeek)
    VALUES (1, "EJC", 5);