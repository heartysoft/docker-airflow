FROM frolvlad/alpine-miniconda3

#lxml pip

WORKDIR /app
ADD ["start.sh", "circus.ini", "airflow_scheduler.sh", "airflow_web.sh", "dag-fetcher.sh", "./"]

RUN apk add --update --no-cache gcc g++ libstdc++ coreutils linux-headers bash \
 && pip install --upgrade --ignore-installed setuptools "apache-airflow[s3,postgres]==1.8.2rc1" circus awscli boto boto3 \
 && apk del gcc g++ linux-headers \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/.cache \
 && mkdir -p /app/airflow/dags \
 && chmod a+x *.sh  \
 && sed -i 's/LOGGING_LEVEL =.*$/LOGGING_LEVEL = logging.WARN/g' /opt/conda/lib/python3.6/site-packages/airflow/settings.py \
 && sed -i 's/BASE_LOG_URL =.*$/BASE_LOG_URL = "\/app\/airflow\/logs"/g' /opt/conda/lib/python3.6/site-packages/airflow/settings.py \
 && sed -i '/print(settings.HEADER)/d' /opt/conda/lib/python3.6/site-packages/airflow/bin/cli.py

EXPOSE 8080

ENV AIRFLOW__CORE__EXECUTOR=LocalExecutor \
    AIRFLOW_HOME="/app/airflow"

CMD ["./start.sh"]
