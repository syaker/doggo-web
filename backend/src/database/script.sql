CREATE TABLE `users` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`name` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`encrypted_password` VARCHAR(255) NOT NULL,
	`role` VARCHAR(255) NOT NULL,
	`created_at` DATETIME NOT NULL,
	PRIMARY KEY(`id`)
);


CREATE TABLE `messages` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`content` VARCHAR(255),
	`sitter_id` INTEGER NOT NULL,
	`client_id` INTEGER NOT NULL,
	`created_at` DATETIME NOT NULL,
	PRIMARY KEY(`id`)
);


CREATE TABLE `services` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`title` VARCHAR(255) NOT NULL,
	`price` FLOAT NOT NULL,
	`sitter_id` INTEGER NOT NULL,
	`created_at` DATETIME NOT NULL,
	PRIMARY KEY(`id`)
);


CREATE TABLE `promotions` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`service_id` INTEGER NOT NULL,
	`discount` TINYINT NOT NULL,
	`valid_until` DATETIME NOT NULL,
	`created_at` DATETIME NOT NULL,
	PRIMARY KEY(`id`)
);


CREATE TABLE `schedulings` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`availability` JSON NOT NULL,
	`sitter_id` INTEGER NOT NULL,
	PRIMARY KEY(`id`)
);


CREATE INDEX `idx_schedulings_sitter`
ON `schedulings` (`sitter_id`, `id`);
CREATE TABLE `appointments` (
	`id` INTEGER NOT NULL AUTO_INCREMENT UNIQUE,
	`sitter_id` INTEGER NOT NULL,
	`client_id` INTEGER NOT NULL,
	`appointment` DATETIME NOT NULL,
	`status` VARCHAR(255) NOT NULL DEFAULT 'pending',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE INDEX `idx_appointments_sitter_date`
ON `appointments` (`sitter_id`, `appointment_from`);
ALTER TABLE `messages`
ADD FOREIGN KEY(`client_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `messages`
ADD FOREIGN KEY(`sitter_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `services`
ADD FOREIGN KEY(`sitter_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `services`
ADD FOREIGN KEY(`id`) REFERENCES `promotions`(`service_id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `schedulings`
ADD FOREIGN KEY(`sitter_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `appointments`
ADD FOREIGN KEY(`sitter_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `appointments`
ADD FOREIGN KEY(`client_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;