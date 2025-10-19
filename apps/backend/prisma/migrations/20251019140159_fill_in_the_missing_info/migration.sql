-- AlterTable
ALTER TABLE `coordinates` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `location_data` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `nearby_users` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `rescue` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `role` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `snowTypes` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `updates` ALTER COLUMN `updated_at` DROP DEFAULT;

-- AlterTable
ALTER TABLE `userReviews` ALTER COLUMN `updated_at` DROP DEFAULT;
