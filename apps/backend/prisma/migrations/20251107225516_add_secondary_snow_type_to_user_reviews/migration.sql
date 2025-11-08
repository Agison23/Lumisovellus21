/*
  Warnings:

  - You are about to drop the column `details` on the `userReviews` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE `snow_conditions` ADD COLUMN `secondary_snow_type` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `userReviews` DROP COLUMN `details`,
    ADD COLUMN `hazards` JSON NULL,
    ADD COLUMN `secondarySnowType` VARCHAR(191) NULL;

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

-- CreateIndex
CREATE INDEX `snow_update_conditions_secondary_snow_type_fkey` ON `snow_conditions`(`secondary_snow_type`);

-- CreateIndex
CREATE INDEX `userReviews_secondarySnowType_fkey` ON `userReviews`(`secondarySnowType`);

-- AddForeignKey
ALTER TABLE `snow_type_secondary` ADD CONSTRAINT `snow_type_secondary_primary_snow_type_id_fkey` FOREIGN KEY (`primary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_type_secondary` ADD CONSTRAINT `snow_type_secondary_secondary_snow_type_id_fkey` FOREIGN KEY (`secondary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `userReviews` ADD CONSTRAINT `userReviews_secondarySnowType_fkey` FOREIGN KEY (`secondarySnowType`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `snow_conditions` ADD CONSTRAINT `snow_conditions_secondary_snow_type_fkey` FOREIGN KEY (`secondary_snow_type`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
