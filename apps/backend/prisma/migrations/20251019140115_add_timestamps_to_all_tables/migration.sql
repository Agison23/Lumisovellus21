-- Add timestamps to all tables with proper handling of existing data

-- AlterTable: coordinates - add updated_at column with default value
ALTER TABLE `coordinates` ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: location_data - add updated_at column with default value  
ALTER TABLE `location_data` ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: nearby_users - add both created_at and updated_at columns with default values
ALTER TABLE `nearby_users` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: rescue - add both created_at and updated_at columns with default values
ALTER TABLE `rescue` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: role - add both created_at and updated_at columns with default values
ALTER TABLE `role` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: snowTypes - add both created_at and updated_at columns with default values
ALTER TABLE `snowTypes` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: updates - add both created_at and updated_at columns with default values
ALTER TABLE `updates` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- AlterTable: userReviews - add both created_at and updated_at columns with default values
ALTER TABLE `userReviews` ADD COLUMN `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    ADD COLUMN `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);

-- Update existing records to set updated_at to match created_at for tables that already have created_at
UPDATE `coordinates` SET `updated_at` = `created_at` WHERE `updated_at` IS NOT NULL;
UPDATE `location_data` SET `updated_at` = `created_at` WHERE `updated_at` IS NOT NULL;
