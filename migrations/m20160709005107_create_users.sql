CREATE TABLE users (
    id                  serial PRIMARY KEY,
    username            text NOT NULL,
    password_bcrypt     text NOT NULL,
    email               text NOT NULL
);
