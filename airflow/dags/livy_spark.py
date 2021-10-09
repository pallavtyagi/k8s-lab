# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

"""
This is an example DAG which uses the LivyOperator.
The tasks below trigger the computation of pi on the Spark instance
using the Java and Python executables provided in the example library.
"""

from airflow import DAG
from airflow.providers.apache.livy.operators.livy import LivyOperator
from airflow.utils.dates import days_ago

args = {'owner': 'admin1', 'email': ['pallav.k8s.lab@gmail.com'], 'depends_on_past': False}

with DAG(
    dag_id='spark_livy_operator',
    default_args=args,
    schedule_interval='@daily',
    start_date=days_ago(5),
) as dag:

    livy_python_task = LivyOperator(
        task_id='pi_python_task',
        dag=dag,
        livy_conn_id='apache_livy',
        file='local:///opt/spark/examples/src/main/python/pi.py',
        args=[10],
        num_executors=2
        conf={
            "spark.kubernetes.driver.pod.name" : "spark-pi-driver-12",
            "spark.kubernetes.container.image": "rootstrap/spark-py:latest",
            "spark.kubernetes.authenticate.driver.serviceAccountName": "spark",
            "spark.kubernetes.namespace" : "livy"
        }
        class_name='org.apache.spark.examples.SparkPi'
    )

    livy_python_task

