-- AlterTable
ALTER TABLE `help_notifications` MODIFY `accepted_at` DATETIME(3) NULL;

-- AlterTable
ALTER TABLE `snow_updates` ADD COLUMN `hazards` JSON NULL;
