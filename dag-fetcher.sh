#!/bin/sh


mkdir -p "$AIRFLOW_HOME/dags"

if [ "x$FSDAGS" != "x" ]; then
  cat "$FSDAGS" | while read LINE
  do
    if [ "x$LINE" != "x" ]; then
      cp "$LINE" "$AIRFLOW_HOME/dags/" -uR
    fi
  done
fi


if [ "x$S3DAGS" != "x" ]; then
  cat "$S3DAGS" | while read LINE
  do
    if [ "x$LINE" != "x" ]; then
      aws s3 cp --quiet --recursive "$LINE" "$AIRFLOW_HOME/dags/"
    fi
  done
fi

