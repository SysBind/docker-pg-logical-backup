#!/bin/bash


psql -c "CREATE DATABASE test;"
psql test -c "CREATE TABLE vals(idx int, val varchar);"

idx=1;
while true; do
    psql test -c "INSERT INTO vals(idx, val) VALUES("$idx", 'VAL-"$idx"');";
    idx=$((idx+1)); sleep 1s;
done

