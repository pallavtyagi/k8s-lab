wget https://www.apache.org/dyn/closer.lua/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
tar -xvzf spark-3.1.2-bin-hadoop3.2.tgz 
./spark-3.1.2-bin-hadoop3.2/bin/docker-image-tool.sh -r pallavtyagi/spark-k8s -t 1.0.0 build
./spark-3.1.2-bin-hadoop3.2/bin/docker-image-tool.sh -r pallavtyagi/spark-k8s-pi -t 1.0.0 -p ./kubernetes/dockerfiles/spark/bindings/python/Dockerfile build
