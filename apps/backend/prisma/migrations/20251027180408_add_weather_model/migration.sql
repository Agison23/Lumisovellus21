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
