-- CreateTable
CREATE TABLE `users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `firstName` VARCHAR(20) NOT NULL,
    `surname` VARCHAR(30) NOT NULL,
    `email` VARCHAR(30) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `role` ENUM('NORMAL', 'PREMIUM', 'ADMIN', 'RESCUE') NOT NULL DEFAULT 'NORMAL',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `mobile_users` (
    `dev_id` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `ip_address` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(255) NULL,
    `low_battery` INTEGER NOT NULL DEFAULT 0,
    `role` VARCHAR(50) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`dev_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `rescue` (
    `user_id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `is_admin` BOOLEAN NOT NULL,

    UNIQUE INDEX `rescue_username_key`(`username`),
    PRIMARY KEY (`user_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role` (
    `name` VARCHAR(50) NOT NULL,
    `permissions` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`name`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `segments` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `terrain` VARCHAR(100) NOT NULL,
    `avalancheDanger` BOOLEAN NOT NULL DEFAULT false,
    `isLowerSegment` INTEGER NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `segments_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `coordinates` (
    `segment` INTEGER NOT NULL,
    `order` INTEGER NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`order`, `segment`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snowTypes` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `colour` VARCHAR(15) NOT NULL,
    `skiability` INTEGER NULL,
    `categoryId` INTEGER NULL,
    `explanation` TEXT NULL,

    UNIQUE INDEX `snowTypes_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `userReviews` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `segment` INTEGER NOT NULL,
    `snowType` INTEGER NULL,
    `details` INTEGER NULL,
    `comment` TEXT NULL,
    `user_id` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `updates` (
    `creator` INTEGER NOT NULL,
    `segment` INTEGER NOT NULL,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `description` TEXT NULL,
    `snowTypeId1` INTEGER NULL,
    `snowTypeId2` INTEGER NULL,
    `secondaryId1` INTEGER NULL,
    `secondaryId2` INTEGER NULL,
    `reviewId1` INTEGER NULL,
    `reviewId2` INTEGER NULL,
    `reviewId3` INTEGER NULL,

    PRIMARY KEY (`time`, `segment`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `location_data` (
    `dev_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`dev_id`, `timestamp`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `help_requests` (
    `dev_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `help_type` VARCHAR(100) NOT NULL,
    `room_id` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`dev_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `nearby_users` (
    `help_giver` VARCHAR(255) NOT NULL,
    `help_requester` VARCHAR(255) NOT NULL,
    `state` INTEGER NOT NULL,

    PRIMARY KEY (`help_giver`, `help_requester`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `coordinates` ADD CONSTRAINT `coordinates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_snowType_fkey` FOREIGN KEY (`snowType`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_creator_fkey` FOREIGN KEY (`creator`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_snowTypeId1_fkey` FOREIGN KEY (`snowTypeId1`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_snowTypeId2_fkey` FOREIGN KEY (`snowTypeId2`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_secondaryId1_fkey` FOREIGN KEY (`secondaryId1`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_secondaryId2_fkey` FOREIGN KEY (`secondaryId2`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId1_fkey` FOREIGN KEY (`reviewId1`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId2_fkey` FOREIGN KEY (`reviewId2`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `updates` ADD CONSTRAINT `updates_reviewId3_fkey` FOREIGN KEY (`reviewId3`) REFERENCES `userReviews`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `location_data` ADD CONSTRAINT `location_data_dev_id_fkey` FOREIGN KEY (`dev_id`) REFERENCES `mobile_users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_requests` ADD CONSTRAINT `help_requests_dev_id_fkey` FOREIGN KEY (`dev_id`) REFERENCES `mobile_users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_giver_fkey` FOREIGN KEY (`help_giver`) REFERENCES `mobile_users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_receiver_fkey` FOREIGN KEY (`help_requester`) REFERENCES `mobile_users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_request_fkey` FOREIGN KEY (`help_requester`) REFERENCES `help_requests`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
