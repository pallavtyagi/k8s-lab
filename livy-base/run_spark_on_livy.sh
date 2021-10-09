curl -s -k -H 'Content-Type: application/json' \
    -X POST \
     -d '{
        "name": "test12",
        "className": "org.apache.spark.examples.SparkPi",
        "numExecutors": 2,
        "file": "local:///opt/spark/examples/src/main/python/pi.py",
        "args": ["10"],
        "conf": {
            "spark.kubernetes.driver.pod.name" : "spark-pi-driver-12",
            "spark.kubernetes.container.image": "rootstrap/spark-py:latest",
            "spark.kubernetes.authenticate.driver.serviceAccountName": "spark",
	    "spark.kubernetes.namespace" : "livy"
        }
      }' "http://localhost:8998/batches"
