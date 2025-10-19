-- RenameIndex
ALTER TABLE `rescue` RENAME INDEX `username` TO `rescue_username_key`;

-- RenameIndex
ALTER TABLE `segments` RENAME INDEX `name` TO `segments_name_key`;

-- RenameIndex
ALTER TABLE `snowTypes` RENAME INDEX `name` TO `snowTypes_name_key`;

-- RenameIndex
ALTER TABLE `users` RENAME INDEX `dev_id` TO `users_dev_id_key`;

-- RenameIndex
ALTER TABLE `users` RENAME INDEX `email` TO `users_email_key`;
