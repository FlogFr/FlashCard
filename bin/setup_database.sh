#!/bin/bash -e

psql -c 'CREATE DATABASE words;'
psql -c 'CREATE EXTENSION pg_trgm;' words
psql -c 'CREATE EXTENSION pgcrypto;' words
psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' words

sqitch deploy

# test user username: testusername
# test user password: testpassword
# test user languages: testpassword

INSERT INTO users (email, username, passpass, languages) VALUES ('donald.duck@brazaville.com', 'passpass', 'donald.duck', '{}');
INSERT INTO users (email, username, passpass, languages) VALUES ('daisy.duck@brazaville.com', 'passpass', 'daisy.duck', '{"FR"}');
INSERT INTO users (email, username, passpass, languages) VALUES ('huey.duck@brazaville.com', 'passpass', 'huey.duck', '{}');
INSERT INTO users (email, username, passpass, languages) VALUES ('dewey.duck@brazaville.com', 'passpass', 'dewey.duck', '{}');
INSERT INTO users (email, username, passpass, languages) VALUES ('louie.duck@brazaville.com', 'passpass', 'louie.duck', '{}');
INSERT INTO users (email, username, passpass, languages) VALUES ('scrooge.mcduck@brazaville.com', 'passpass', 'scrooge.mcduck', '{"PL", "EN"}');


    insertUser dbconnection "donald.duck@brazaville.com" "passpass"
    insertUser dbconnection "daisy.duck@brazaville.com" "passpass"
    insertUser dbconnection "huey.duck@brazaville.com" "passpass"
    insertUser dbconnection "dewey.duck@brazaville.com" "passpass"
    insertUser dbconnection "louie.duck@brazaville.com" "passpass"
    insertUser dbconnection "scrooge.mcduck@brazaville.com" "passpass"
