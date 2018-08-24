#!/bin/bash -e

psql -c 'CREATE DATABASE words;'
psql -c 'CREATE EXTENSION pg_trgm;' words
psql -c 'CREATE EXTENSION pgcrypto;' words
psql -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' words

sqitch deploy
