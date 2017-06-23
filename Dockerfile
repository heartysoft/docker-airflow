FROM python:3.6-alpine


RUN apk add --update --no-cache gcc g++ python3-dev musl-dev postgresql-dev libxml2-dev linux-headers libxslt-dev coreutils\
  && python3 -m ensurepip \
  && ln -s /usr/bin/pip3 /usr/bin/pip \
  && rm -r /usr/lib/python*/ensurepip \
  && pip3 install --upgrade lxml pip apache-airflow[s3,postgres] circus awscli boto boto3 \
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.cache \
  && mkdir -p /app/airflow/dags

WORKDIR /app

ADD start.sh .
ADD circus.ini .
ADD airflow_scheduler.sh .
ADD airflow_web.sh .
ADD dag-fetcher.sh .

RUN chmod a+x *.sh 

EXPOSE 8080

#RUN airflow initdb

#CMD ["circusd", "circus.ini"]


ENV AIRFLOW__CORE__EXECUTOR LocalExecutor
ENV AIRFLOW__CORE__LOGGING_LEVEL ERROR
ENV AIRFLOW_HOME "/app/airflow"

CMD ["./start.sh"]
