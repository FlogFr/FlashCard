#!/bin/bash -e

. ./env

pg_dump --data-only --format plain -f db_dump.sql words
