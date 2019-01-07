#!/bin/bash

export PGSERVICE="words"

./drop-database.sh

./create-database.sh

psql -f create-schema-ddl.sql
