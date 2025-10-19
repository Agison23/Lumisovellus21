-- Implement UUID primary key for User table
-- This migration resets the database with the new UUID structure

-- Drop all tables to start fresh with UUID structure
DROP TABLE IF EXISTS `nearby_users`;
DROP TABLE IF EXISTS `help_requests`;
DROP TABLE IF EXISTS `location_data`;
DROP TABLE IF EXISTS `updates`;
DROP TABLE IF EXISTS `userReviews`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `snowTypes`;
DROP TABLE IF EXISTS `coordinates`;
DROP TABLE IF EXISTS `segments`;
DROP TABLE IF EXISTS `role`;
DROP TABLE IF EXISTS `rescue`;

-- Create users table with UUID primary key
CREATE TABLE `users` (
    `id` VARCHAR(191) NOT NULL,
    `firstName` VARCHAR(255) NOT NULL,
    `lastName` VARCHAR(255),
    `email` VARCHAR(255) UNIQUE,
    `password` VARCHAR(255),
    `role` ENUM('NORMAL', 'PREMIUM', 'ADMIN', 'RESCUE') NOT NULL DEFAULT 'NORMAL',
    `dev_id` VARCHAR(255) UNIQUE,
    `ip_address` VARCHAR(255),
    `phone_number` VARCHAR(255),
    `low_battery` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create segments table
CREATE TABLE `segments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `terrain` VARCHAR(100) NOT NULL,
    `avalancheDanger` BOOLEAN NOT NULL DEFAULT false,
    `isLowerSegment` INTEGER,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create coordinates table
CREATE TABLE `coordinates` (
    `segment` INTEGER NOT NULL,
    `order` INTEGER NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`order`, `segment`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create snowTypes table
CREATE TABLE `snowTypes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `colour` VARCHAR(15) NOT NULL,
    `skiability` INTEGER,
    `categoryId` INTEGER,
    `explanation` TEXT,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create userReviews table
CREATE TABLE `userReviews` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `segment` INTEGER NOT NULL,
    `snowType` INTEGER,
    `details` INTEGER,
    `comment` TEXT,
    `user_id` VARCHAR(255),
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create updates table
CREATE TABLE `updates` (
    `creator` VARCHAR(255) NOT NULL,
    `segment` INTEGER NOT NULL,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `description` TEXT,
    `snowTypeId1` INTEGER,
    `snowTypeId2` INTEGER,
    `secondaryId1` INTEGER,
    `secondaryId2` INTEGER,
    `reviewId1` INTEGER,
    `reviewId2` INTEGER,
    `reviewId3` INTEGER,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`time`, `segment`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create location_data table
CREATE TABLE `location_data` (
    `user_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`user_id`, `timestamp`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create help_requests table
CREATE TABLE `help_requests` (
    `user_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `help_type` VARCHAR(100) NOT NULL,
    `room_id` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create nearby_users table
CREATE TABLE `nearby_users` (
    `help_giver` VARCHAR(255) NOT NULL,
    `help_requester` VARCHAR(255) NOT NULL,
    `state` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`help_giver`, `help_requester`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create role table
CREATE TABLE `role` (
    `name` VARCHAR(50) NOT NULL,
    `permissions` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`name`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create rescue table
CREATE TABLE `rescue` (
    `user_id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `is_admin` BOOLEAN NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Add foreign key constraints
ALTER TABLE `coordinates` ADD CONSTRAINT `coordinates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_snowType_fkey` FOREIGN KEY (`snowType`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_creator_fkey` FOREIGN KEY (`creator`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_snowTypeId1_fkey` FOREIGN KEY (`snowTypeId1`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_snowTypeId2_fkey` FOREIGN KEY (`snowTypeId2`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_secondaryId1_fkey` FOREIGN KEY (`secondaryId1`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_secondaryId2_fkey` FOREIGN KEY (`secondaryId2`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId1_fkey` FOREIGN KEY (`reviewId1`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId2_fkey` FOREIGN KEY (`reviewId2`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId3_fkey` FOREIGN KEY (`reviewId3`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `location_data` ADD CONSTRAINT `location_data_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `help_requests` ADD CONSTRAINT `help_requests_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_giver_fkey` FOREIGN KEY (`help_giver`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_receiver_fkey` FOREIGN KEY (`help_requester`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_request_fkey` FOREIGN KEY (`help_requester`) REFERENCES `help_requests`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;