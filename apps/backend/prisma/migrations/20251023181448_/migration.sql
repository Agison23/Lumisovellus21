/*
  Warnings:

  - You are about to drop the `nearby_users` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `rescue` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `role` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `snow_update_attachments` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `snow_update_conditions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `snow_update_review_references` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `nearby_users` DROP FOREIGN KEY `nearby_users_help_giver_fkey`;

-- DropForeignKey
ALTER TABLE `nearby_users` DROP FOREIGN KEY `nearby_users_help_receiver_fkey`;

-- DropForeignKey
ALTER TABLE `nearby_users` DROP FOREIGN KEY `nearby_users_help_request_fkey`;

-- DropForeignKey
ALTER TABLE `snow_update_attachments` DROP FOREIGN KEY `snow_update_attachments_update_id_fkey`;

-- DropForeignKey
ALTER TABLE `snow_update_conditions` DROP FOREIGN KEY `snow_update_conditions_snow_type_fkey`;

-- DropForeignKey
ALTER TABLE `snow_update_conditions` DROP FOREIGN KEY `snow_update_conditions_update_id_fkey`;

-- DropForeignKey
ALTER TABLE `snow_update_review_references` DROP FOREIGN KEY `snow_update_review_references_review_id_fkey`;

-- DropForeignKey
ALTER TABLE `snow_update_review_references` DROP FOREIGN KEY `snow_update_review_references_update_id_fkey`;

-- DropTable
DROP TABLE `nearby_users`;

-- DropTable
DROP TABLE `rescue`;

-- DropTable
DROP TABLE `role`;

-- DropTable
DROP TABLE `snow_update_attachments`;

-- DropTable
DROP TABLE `snow_update_conditions`;

-- DropTable
DROP TABLE `snow_update_review_references`;

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
CREATE TABLE `snow_conditions` (
    `id` VARCHAR(191) NOT NULL,
    `update_id` VARCHAR(191) NOT NULL,
    `snow_type` VARCHAR(191) NOT NULL,
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
CREATE TABLE `help_notifications` (
    `id` VARCHAR(191) NOT NULL,
    `help_giver` VARCHAR(255) NOT NULL,
    `help_requester` VARCHAR(255) NOT NULL,
    `state` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `nearby_users_help_request_fkey`(`help_requester`),
    UNIQUE INDEX `help_notifications_help_giver_help_requester_key`(`help_giver`, `help_requester`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_snow_type_fkey` FOREIGN KEY (`snow_type`) REFERENCES `snowTypes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_review_references` ADD CONSTRAINT `snow_review_references_review_id_fkey` FOREIGN KEY (`review_id`) REFERENCES `userReviews`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_review_references` ADD CONSTRAINT `snow_review_references_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_attachments` ADD CONSTRAINT `snow_attachments_update_id_fkey` FOREIGN KEY (`update_id`) REFERENCES `snow_updates`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_giver_fkey` FOREIGN KEY (`help_giver`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_receiver_fkey` FOREIGN KEY (`help_requester`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `help_notifications` ADD CONSTRAINT `nearby_users_help_request_fkey` FOREIGN KEY (`help_requester`) REFERENCES `help_requests`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
