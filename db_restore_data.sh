#!/bin/bash -e

. ./env

psql -f db_dump.sql
