-- Consolidate user tables: merge mobile_users into users table

-- Step 1: Add new columns to users table
ALTER TABLE `users` 
    ADD COLUMN `dev_id` VARCHAR(255) NULL,
    ADD COLUMN `ip_address` VARCHAR(255) NULL,
    ADD COLUMN `lastName` VARCHAR(255) NULL,
    ADD COLUMN `low_battery` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `phone_number` VARCHAR(255) NULL,
    MODIFY `firstName` VARCHAR(255) NOT NULL,
    MODIFY `email` VARCHAR(255) NULL,
    MODIFY `password` VARCHAR(255) NULL,
    MODIFY `surname` VARCHAR(255) NULL;

-- Step 2: Migrate data from mobile_users to users table
INSERT INTO `users` (
    `firstName`, 
    `lastName`, 
    `email`, 
    `password`, 
    `role`, 
    `dev_id`, 
    `ip_address`, 
    `phone_number`, 
    `low_battery`, 
    `created_at`, 
    `updated_at`
)
SELECT 
    `first_name` as `firstName`,
    `last_name` as `lastName`,
    NULL as `email`,
    NULL as `password`,
    'NORMAL' as `role`,
    `dev_id`,
    `ip_address`,
    `phone_number`,
    `low_battery`,
    `created_at`,
    `updated_at`
FROM `mobile_users`;

-- Step 3: Update existing users to copy surname to lastName
UPDATE `users` SET `lastName` = `surname` WHERE `lastName` IS NULL AND `surname` IS NOT NULL;

-- Step 4: Drop foreign key constraints
ALTER TABLE `help_requests` DROP FOREIGN KEY `help_requests_dev_id_fkey`;
ALTER TABLE `location_data` DROP FOREIGN KEY `location_data_dev_id_fkey`;
ALTER TABLE `nearby_users` DROP FOREIGN KEY `nearby_users_help_giver_fkey`;
ALTER TABLE `nearby_users` DROP FOREIGN KEY `nearby_users_help_receiver_fkey`;

-- Step 5: Drop the surname column
ALTER TABLE `users` DROP COLUMN `surname`;

-- Step 6: Drop the mobile_users table
DROP TABLE `mobile_users`;

-- Step 7: Create unique index for dev_id
CREATE UNIQUE INDEX `users_dev_id_key` ON `users`(`dev_id`);

-- Step 8: Recreate foreign key constraints
ALTER TABLE `location_data` ADD CONSTRAINT `location_data_dev_id_fkey` FOREIGN KEY (`dev_id`) REFERENCES `users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `help_requests` ADD CONSTRAINT `help_requests_dev_id_fkey` FOREIGN KEY (`dev_id`) REFERENCES `users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_giver_fkey` FOREIGN KEY (`help_giver`) REFERENCES `users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE `nearby_users` ADD CONSTRAINT `nearby_users_help_receiver_fkey` FOREIGN KEY (`help_requester`) REFERENCES `users`(`dev_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
