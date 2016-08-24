CREATE TABLE uploads (
    id                  serial PRIMARY KEY,
    user_id             integer REFERENCES users(id),
    filename            text NOT NULL UNIQUE,
    original_filename   text,
    size                bigint,
    created             timestamptz
);
