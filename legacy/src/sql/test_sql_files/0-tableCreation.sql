CREATE TABLE segments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    terrain VARCHAR(100),
    avalancheDanger BOOL,
    isLowerSegment BIGINT UNSIGNED,
    FOREIGN KEY(isLowerSegment) REFERENCES segments(id)
);

CREATE TABLE coordinates(
    segment BIGINT UNSIGNED,
    `order` BIGINT UNSIGNED,
    `location` Point,
    FOREIGN KEY(segment) references segments(id) ON DELETE CASCADE,
    CONSTRAINT tag PRIMARY KEY(`order`, segment)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    firstName VARCHAR(20),
    surname VARCHAR(30),
    role VARCHAR(20),
    email VARCHAR(30),
    password VARCHAR(100),
    UNIQUE (email)
);

CREATE TABLE snowTypes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    colour VARCHAR(15),
    skiability INT(10) DEFAULT NULL,
    categoryId BIGINT(20) DEFAULT NULL,
    explanation TEXT
);

CREATE TABLE userReviews (
    id SERIAL PRIMARY KEY,
    time DATETIME,
    segment BIGINT UNSIGNED,
    snowType BIGINT(20) UNSIGNED DEFAULT NULL,
    details INT(10) DEFAULT NULL,
    comment TEXT,
    FOREIGN KEY(segment) REFERENCES segments(id) ON DELETE CASCADE,
    CONSTRAINT snowType FOREIGN KEY (snowType) REFERENCES snowTypes (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE updates (
    creator BIGINT UNSIGNED,
    segment BIGINT UNSIGNED,
    time DATETIME,
    description TEXT,
    snowTypeId1 BIGINT(20) UNSIGNED DEFAULT NULL,
    snowTypeId2 BIGINT(20) UNSIGNED DEFAULT NULL,
    secondaryId1 BIGINT(20) UNSIGNED DEFAULT NULL,
    secondaryId2 BIGINT(20) UNSIGNED DEFAULT NULL,
    reviewId1 BIGINT UNSIGNED DEFAULT NULL,
    reviewId2 BIGINT UNSIGNED DEFAULT NULL,
    reviewId3 BIGINT UNSIGNED DEFAULT NULL,
    FOREIGN KEY(creator) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(segment) REFERENCES segments(id) ON DELETE CASCADE,
    CONSTRAINT snowTypeId1 FOREIGN KEY (snowTypeId1) REFERENCES snowTypes (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT snowTypeId2 FOREIGN KEY (snowTypeId2) REFERENCES snowTypes (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT secondaryId1 FOREIGN KEY (secondaryId1) REFERENCES snowTypes (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT secondaryId2 FOREIGN KEY (secondaryId2) REFERENCES snowTypes (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT reviewId1 FOREIGN KEY (reviewId1) REFERENCES userReviews (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT reviewId2 FOREIGN KEY (reviewId2) REFERENCES userReviews (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT reviewId3 FOREIGN KEY (reviewId3) REFERENCES userReviews (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT tag  PRIMARY KEY (time, segment)
);
