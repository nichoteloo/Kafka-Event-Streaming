CREATE TABLE IF NOT EXISTS test ( 
    id serial NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(100), 
    email VARCHAR(200), 
    department VARCHAR(200), 
    modified TIMESTAMP default current_timestamp NOT NULL, 
    INDEX `modified_index` (`modified`) 
);