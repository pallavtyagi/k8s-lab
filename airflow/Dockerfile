FROM apache/airflow:2.1.1
COPY requirements.txt .
RUN pip install --no-cache-dir apache-airflow-providers-apache-spark
RUN pip install --no-cache-dir apache-airflow-providers-apache-livy[http]

