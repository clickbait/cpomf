CREATE TABLE pages (
    id                  serial PRIMARY KEY,
    title               text NOT NULL,
    slug                text NOT NULL,
    content             text
);
