-- AlterTable: Add primary_snow_type_id column
ALTER TABLE `snowTypes` ADD COLUMN `primary_snow_type_id` VARCHAR(191) NULL;

-- Update existing data: Set primary_snow_type_id for secondary types based on SnowTypeSecondary relationships
UPDATE `snowTypes` st
INNER JOIN `snow_type_secondary` sts ON st.id = sts.secondary_snow_type_id
SET st.primary_snow_type_id = sts.primary_snow_type_id
WHERE st.is_primary = false;

-- Update existing data: Set primary_snow_type_id to NULL for primary types
UPDATE `snowTypes` SET `primary_snow_type_id` = NULL WHERE `is_primary` = true;

-- Add index for the foreign key
CREATE INDEX `snow_types_primary_snow_type_id_fkey` ON `snowTypes`(`primary_snow_type_id`);

-- Add foreign key constraint
ALTER TABLE `snowTypes` ADD CONSTRAINT `snow_types_primary_snow_type_id_fkey` FOREIGN KEY (`primary_snow_type_id`) REFERENCES `snowTypes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- DropTable: Remove is_primary column
ALTER TABLE `snowTypes` DROP COLUMN `is_primary`;

