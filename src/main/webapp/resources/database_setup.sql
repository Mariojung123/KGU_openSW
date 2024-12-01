CREATE TABLE user (
    userId BIGINT AUTO_INCREMENT PRIMARY KEY,
    loginId VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    createdDate VARCHAR(255) NOT NULL
);

CREATE TABLE restaurant (
    restaurantId BIGINT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    la DOUBLE NOT NULL,
    lo DOUBLE NOT NULL
);

CREATE TABLE review (
    reviewId BIGINT AUTO_INCREMENT PRIMARY KEY,
    userId BIGINT NOT NULL,
    restaurantId BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    rating DOUBLE NOT NULL,
    createdDate VARCHAR(255) NOT NULL,
    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);