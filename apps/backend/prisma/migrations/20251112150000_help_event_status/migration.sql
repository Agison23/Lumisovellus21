-- Add status tracking for help events
ALTER TABLE `help_requests`
    ADD COLUMN `status` ENUM('active', 'completed', 'cancelled') NOT NULL DEFAULT 'active',
    ADD COLUMN `location_accuracy` DOUBLE NULL;

-- Store acceptance metadata for rescuers
ALTER TABLE `help_notifications`
    ADD COLUMN `accepted_at` DATETIME NULL,
    ADD COLUMN `accepted_latitude` DOUBLE NULL,
    ADD COLUMN `accepted_longitude` DOUBLE NULL,
    ADD COLUMN `accepted_accuracy` DOUBLE NULL;
