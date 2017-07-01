# docker-airflow

Airflow hosted in docker. 

* Runs airflow scheduler with circus with -n 1 option, enabling dag reloading.
* Uses circus to fetch dags from s3 locations and / or file system periodically.
