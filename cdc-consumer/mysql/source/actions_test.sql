-- Do it manually
INSERT INTO test (name, email, department) VALUES ('alice', 'alice@abc.com', 'engineering');
INSERT INTO test (name, email, department) VALUES ('john', 'john@abc.com', 'sales');
UPDATE test SET name='telo' WHERE id=2;
-- DELETE FROM test WHERE id=2;