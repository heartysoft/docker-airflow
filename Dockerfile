FROM frolvlad/alpine-miniconda3

#lxml pip

WORKDIR /app
ADD ["start.sh", "circus.ini", "airflow_scheduler.sh", "airflow_web.sh", "dag-fetcher.sh", "./"]

RUN apk add --update --no-cache gcc g++ libstdc++ coreutils linux-headers bash \
 && pip install --upgrade --ignore-installed setuptools "apache-airflow[s3,postgres]==1.8.2rc1" circus awscli boto boto3 flask-caching \
 && apk del gcc g++ linux-headers \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/.cache \
 && mkdir -p /app/airflow/dags \
 && chmod a+x *.sh  \
 && sed -i 's/BASE_LOG_URL =.*$/BASE_LOG_URL = "\/app\/airflow\/logs"/g' /opt/conda/lib/python3.6/site-packages/airflow/settings.py \
 # Fixing deprecation warnings the hard way (don't do this at home)
 #
 && sed -i '/print(settings.HEADER)/d' /opt/conda/lib/python3.6/site-packages/airflow/bin/cli.py \
 && sed -i "s/CsrfProtect/CSRFProtect/g" /opt/conda/lib/python3.6/site-packages/airflow/www/app.py \
 # Flask-caching is compatible with Flask-cache so this should fix the warning
 # without breaking the airflow.
 #
 && sed -i 's/from flask_cache/from flask_caching/g' /opt/conda/lib/python3.6/site-packages/airflow/www/app.py\
 # Fixing flask_wtf.Form and cgi.escape warnings might not be needed but they
 # appear in the logs if you use the webapp.
 #
 && sed -i 's/from flask_wtf import Form/from flask_wtf import FlaskForm/g' /opt/conda/lib/python3.6/site-packages/airflow/www/forms.py \
 && sed -i 's/(Form):/(FlaskForm):/g' /opt/conda/lib/python3.6/site-packages/airflow/www/forms.py \
 && sed -i 's/from cgi import escape/from html import escape/g' /opt/conda/lib/python3.6/site-packages/airflow/www/utils.py

EXPOSE 8080

ENV AIRFLOW__CORE__EXECUTOR=LocalExecutor \
    AIRFLOW_HOME="/app/airflow" \
    AIRFLOW__CORE__LOAD_EXAMPLES=False

CMD ["./start.sh"]
