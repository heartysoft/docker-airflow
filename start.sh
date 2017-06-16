#!/bin/sh

set -ex

/usr/local/bin/airflow initdb
exec circusd /app/circus.ini

