-- AlterTable: Add is_primary column
ALTER TABLE `snowTypes` ADD COLUMN `is_primary` BOOLEAN NOT NULL DEFAULT false;

-- Update existing data: Set is_primary = true where categoryId is NULL (primary types)
UPDATE `snowTypes` SET `is_primary` = true WHERE `categoryId` IS NULL;

-- DropTable: Remove categoryId column
ALTER TABLE `snowTypes` DROP COLUMN `categoryId`;




