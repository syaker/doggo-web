CREATE TABLE users(
    id integer PRIMARY KEY,
    name varchar(100),
    email varchar(50),
    encrypted_password varchar(255),
    role VARCHAR(255),
    created_at DATETIME
);

CREATE TABLE services(
    id integer PRIMARY KEY,
    title varchar(200),
    price float,
    sitter_id integer,
    created_at DATETIME,
    FOREIGN KEY (sitter_id) REFERENCES users(id)
);

CREATE TABLE promotions(
    id integer PRIMARY KEY,
    service_id integer,
    discount TINYINT,
    valid_until DATETIME,
    created_at DATETIME,
    FOREIGN KEY (service_id) REFERENCES services(id)
);

CREATE TABLE messages(
    id integer PRIMARY KEY,
    content varchar(255),
    sitter_id integer,
    client_id integer,
    created_at DATETIME,
    FOREIGN KEY (sitter_id) REFERENCES users(id),
    FOREIGN KEY (client_id) REFERENCES users(id)
);

