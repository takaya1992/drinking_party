#!/bin/sh
carton install
sqlite3 ./db/answer.db < ./db/sql/create_table.sql
