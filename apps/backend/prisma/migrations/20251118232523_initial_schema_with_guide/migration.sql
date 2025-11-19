-- CreateTable
CREATE TABLE `users` (
    `id` VARCHAR(191) NOT NULL,
    `firstName` VARCHAR(255) NOT NULL,
    `lastName` VARCHAR(255) NULL,
    `email` VARCHAR(255) NULL,
    `password` VARCHAR(255) NULL,
    `role` ENUM('NORMAL', 'PREMIUM', 'ADMIN', 'RESCUE', 'GUIDE') NOT NULL DEFAULT 'NORMAL',
    `dev_id` VARCHAR(255) NULL,
    `ip_address` VARCHAR(255) NULL,
    `phone_number` VARCHAR(255) NULL,
    `low_battery` INTEGER NOT NULL DEFAULT 0,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `users_email_key`(`email`),
    UNIQUE INDEX `users_dev_id_key`(`dev_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `permissions` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `roles_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `segments` (
    `id` VARCHAR(191) NOT NULL,
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
    `id` VARCHAR(191) NOT NULL,
    `segment` VARCHAR(191) NOT NULL,
    `order` INTEGER NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `coordinates_segment_fkey`(`segment`),
    UNIQUE INDEX `coordinates_order_segment_key`(`order`, `segment`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snowTypes` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `colour` VARCHAR(15) NOT NULL,
    `skiability` INTEGER NULL,
    `primary_snow_type_id` VARCHAR(191) NULL,
    `explanation` TEXT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `snowTypes_name_key`(`name`),
    INDEX `snow_types_primary_snow_type_id_fkey`(`primary_snow_type_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snow_type_secondary` (
    `id` VARCHAR(191) NOT NULL,
    `primary_snow_type_id` VARCHAR(191) NOT NULL,
    `secondary_snow_type_id` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `snow_type_secondary_primary_fkey`(`primary_snow_type_id`),
    INDEX `snow_type_secondary_secondary_fkey`(`secondary_snow_type_id`),
    UNIQUE INDEX `snow_type_secondary_primary_snow_type_id_secondary_snow_type_key`(`primary_snow_type_id`, `secondary_snow_type_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `userReviews` (
    `id` VARCHAR(191) NOT NULL,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `segment` VARCHAR(191) NOT NULL,
    `snowType` VARCHAR(191) NULL,
    `secondarySnowType` VARCHAR(191) NULL,
    `hazards` JSON NULL,
    `comment` TEXT NULL,
    `user_id` VARCHAR(255) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `userReviews_segment_fkey`(`segment`),
    INDEX `userReviews_snowType_fkey`(`snowType`),
    INDEX `userReviews_secondarySnowType_fkey`(`secondarySnowType`),
    INDEX `userReviews_user_id_fkey`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snow_updates` (
    `id` VARCHAR(191) NOT NULL,
    `creator` VARCHAR(255) NOT NULL,
    `segment` VARCHAR(191) NOT NULL,
    `time` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `description` TEXT NULL,
    `status` ENUM('DRAFT', 'ACTIVE', 'ARCHIVED', 'DELETED') NOT NULL DEFAULT 'ACTIVE',
    `priority` INTEGER NOT NULL DEFAULT 1,
    `weather` VARCHAR(100) NULL,
    `temperature` DOUBLE NULL,
    `windSpeed` DOUBLE NULL,
    `visibility` INTEGER NULL,
    `hazards` JSON NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `snow_updates_creator_fkey`(`creator`),
    INDEX `snow_updates_segment_fkey`(`segment`),
    INDEX `snow_updates_status_fkey`(`status`),
    INDEX `snow_updates_time_fkey`(`time`),
    INDEX `snow_updates_priority_fkey`(`priority`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snow_conditions` (
    `id` VARCHAR(191) NOT NULL,
    `update_id` VARCHAR(191) NOT NULL,
    `snow_type` VARCHAR(191) NOT NULL,
    `secondary_snow_type` VARCHAR(191) NULL,
    `layer` ENUM('SURFACE', 'MIDDLE', 'BASE') NOT NULL DEFAULT 'SURFACE',
    `depth` DOUBLE NULL,
    `coverage` INTEGER NULL,
    `quality` INTEGER NULL,
    `hardness` INTEGER NULL,
    `moisture` INTEGER NULL,
    `notes` TEXT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `snow_update_conditions_update_fkey`(`update_id`),
    INDEX `snow_update_conditions_snow_type_fkey`(`snow_type`),
    INDEX `snow_update_conditions_secondary_snow_type_fkey`(`secondary_snow_type`),
    INDEX `snow_update_conditions_layer_fkey`(`layer`),
    UNIQUE INDEX `snow_conditions_update_id_layer_snow_type_key`(`update_id`, `layer`, `snow_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snow_review_references` (
    `id` VARCHAR(191) NOT NULL,
    `update_id` VARCHAR(191) NOT NULL,
    `review_id` VARCHAR(191) NOT NULL,
    `relevance` INTEGER NOT NULL DEFAULT 1,
    `notes` TEXT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `snow_update_review_refs_update_fkey`(`update_id`),
    INDEX `snow_update_review_refs_review_fkey`(`review_id`),
    UNIQUE INDEX `snow_review_references_update_id_review_id_key`(`update_id`, `review_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `snow_attachments` (
    `id` VARCHAR(191) NOT NULL,
    `update_id` VARCHAR(191) NOT NULL,
    `filename` VARCHAR(255) NOT NULL,
    `file_type` ENUM('IMAGE', 'VIDEO', 'DOCUMENT', 'AUDIO') NOT NULL,
    `file_size` INTEGER NOT NULL,
    `file_path` VARCHAR(500) NOT NULL,
    `caption` VARCHAR(500) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `snow_update_attachments_update_fkey`(`update_id`),
    INDEX `snow_update_attachments_file_type_fkey`(`file_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `location_data` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `location_data_user_id_timestamp_key`(`user_id`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `help_requests` (
    `id` VARCHAR(191) NOT NULL,
    `user_id` VARCHAR(255) NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `gpscoord` VARCHAR(255) NOT NULL,
    `help_type` VARCHAR(100) NOT NULL,
    `room_id` VARCHAR(255) NOT NULL,
    `status` ENUM('active', 'completed', 'cancelled') NOT NULL DEFAULT 'active',
    `location_accuracy` DOUBLE NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `help_requests_user_id_key`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `help_notifications` (
    `id` VARCHAR(191) NOT NULL,
    `help_giver` VARCHAR(255) NOT NULL,
    `help_requester` VARCHAR(255) NOT NULL,
    `state` INTEGER NOT NULL,
    `accepted_at` DATETIME(3) NULL,
    `accepted_latitude` DOUBLE NULL,
    `accepted_longitude` DOUBLE NULL,
    `accepted_accuracy` DOUBLE NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `nearby_users_help_request_fkey`(`help_requester`),
    UNIQUE INDEX `help_notifications_help_giver_help_requester_key`(`help_giver`, `help_requester`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `weather` (
    `id` VARCHAR(191) NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `temperature` DOUBLE NULL,
    `wind_speed` DOUBLE NULL,
    `wind_direction` DOUBLE NULL,
    `air_pressure` DOUBLE NULL,
    `snow_depth` DOUBLE NULL,
    `relative_humidity` DOUBLE NULL,
    `dew_point` DOUBLE NULL,
    `precipitation` DOUBLE NULL,
    `visibility` DOUBLE NULL,
    `cloud_cover` INTEGER NULL,
    `station_id` VARCHAR(50) NULL,
    `station_name` VARCHAR(100) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `weather_timestamp_idx`(`timestamp`),
    INDEX `weather_station_id_idx`(`station_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `coordinates` ADD CONSTRAINT `coordinates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snowTypes` ADD CONSTRAINT `snowTypes_primary_snow_type_id_fkey` FOREIGN KEY (`primary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_type_secondary` ADD CONSTRAINT `snow_type_secondary_primary_snow_type_id_fkey` FOREIGN KEY (`primary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_type_secondary` ADD CONSTRAINT `snow_type_secondary_secondary_snow_type_id_fkey` FOREIGN KEY (`secondary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_snowType_fkey` FOREIGN KEY (`snowType`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_secondarySnowType_fkey` FOREIGN KEY (`secondarySnowType`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_updates` ADD CONSTRAINT `snow_updates_creator_fkey` FOREIGN KEY (`creator`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_updates` ADD CONSTRAINT `snow_updates_segment_fkey` FOREIGN KEY (`segment`) REFERENCES `segments`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_snow_type_fkey` FOREIGN KEY (`snow_type`) REFERENCES `snowTypes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_secondary_snow_type_fkey` FOREIGN KEY (`secondary_snow_type`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_review_references` ADD CONSTRAINT `snow_review_references_review_id_fkey` FOREIGN KEY (`review_id`) REFERENCES `userReviews`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_review_references` ADD CONSTRAINT `snow_review_references_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_attachments` ADD CONSTRAINT `snow_attachments_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `location_data` ADD CONSTRAINT `location_data_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_requests` ADD CONSTRAINT `help_requests_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_giver_fkey` FOREIGN KEY (`help_giver`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_receiver_fkey` FOREIGN KEY (`help_requester`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_request_fkey` FOREIGN KEY (`help_requester`) REFERENCES `help_requests`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
