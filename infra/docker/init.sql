-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS lumisovellus;
USE lumisovellus;

-- Grant broad privileges for the development user.
-- This is necessary for Prisma Migrate to create and manage the shadow database.
GRANT ALL PRIVILEGES ON *.* TO 'lumisovellus'@'%';
FLUSH PRIVILEGES;
