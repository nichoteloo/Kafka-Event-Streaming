CREATE TABLE IF NOT EXISTS test ( 
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    name VARCHAR(100), 
    email VARCHAR(200), 
    department VARCHAR(200),
    updated_id BIGINT UNSIGNED,
    modified TIMESTAMP default current_timestamp NOT NULL, 
    INDEX `modified_index` (`modified`) 
);