#!/bin/sh


n=0
until [ $n -ge 3 ]
do
  airflow initdb && break
  n=$((n+1))
  sleep 3
  echo "n is $n ########################"
done

if [ $n -eq 3 ]; then
  echo "Failed to initialise the database."
  exit 1
fi

set -ex

exec circusd /app/circus.ini

