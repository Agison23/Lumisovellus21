-- Ensure test database exists and user has privileges
CREATE DATABASE IF NOT EXISTS northstar_test;
GRANT ALL PRIVILEGES ON northstar_test.* TO 'app'@'%';
FLUSH PRIVILEGES;


