#!/bin/sh

export LOGGING_LEVEL=${LOGGING_LEVEL:-WARN}
sed -i "s/LOGGING_LEVEL =.*$/LOGGING_LEVEL = logging.$LOGGING_LEVEL/g" /opt/conda/lib/python3.6/site-packages/airflow/settings.py 

if [ -f /app/requirements.txt ]; then
  pip install -r /app/requirements.txt
fi

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

