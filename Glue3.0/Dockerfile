FROM python:3.7.12-bullseye

# JDK 1.8 installation
RUN wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public -O public.key && \
	gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import ./public.key && \
	gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg && \
	rm public.key && \
	rm adoptopenjdk-keyring.gpg && \
	mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings && \
	echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main" | tee /etc/apt/sources.list.d/adoptopenjdk.list && \
	apt-get update && \
	apt-get install -y adoptopenjdk-8-hotspot zip vim
	
# Spark / maven (still required?) / Amazon Glue3 packages (captured from live running job : /opt/amazon folder) and Zeppelin
RUN curl -SsL https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz | tar -C /opt --warning=no-unknown-keyword -xzf -
RUN curl -SsL https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz | tar -C /opt --warning=no-unknown-keyword -xvf -
#RUN curl -SsL https://mirror.checkdomain.de/apache/zeppelin/zeppelin-0.10.0/zeppelin-0.10.0-bin-all.tgz | tar -C /opt --warning=no-unknown-keyword -xzf -

# copy the zip we saved from a Glue worker
ADD ./zip/glue3-opt-amazon.tgz /

# here is the env dump we collected from a Glue worker
# AWS_DEFAULT_REGION : us-east-1
# AWS_METADATA_SERVICE_NUM_ATTEMPTS : 50
# CONTAINER_HOST_PRIVATE_IP : 172.35.33.46
# ERROR_FILE_NAME_LOCATION : /reporting/error.txt
# GLUE_COMMAND_CRITERIA : glueetl
# GLUE_TASK_GROUP_ID : 6c1d9835-6254-4f4b-9030-7bbcbf40331a
# HOSTNAME : ip-172-35-33-46.ec2.internal
# OMP_NUM_THREADS : 4
# PYSPARK_GATEWAY_PORT : 46819
# PYSPARK_GATEWAY_SECRET : 23d350ca7757fa06ccd2ffde650c0ef1ef63b1a45a1c79a28a918934e309cb94
# SHLVL : 0
# SPARK_AUTH_SOCKET_TIMEOUT : 15
# SPARK_BUFFER_SIZE : 65536
# PYTHONUNBUFFERED : YES
# USE_PROXY : false
# WORKER_TYPE : G.1X
# HOME : /home/spark
# GLUE_PYTHON_VERSION : 3
# GLUE_VERSION : 3.0
# LANG : en_US.UTF-8
# LD_LIBRARY_PATH : /opt/amazon/lib/hadoop-lzo-native:/opt/amazon/lib/hadoop-native/:/opt/amazon/lib/glue-native
# PATH : /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/amazon/bin
# PWD : /tmp
# PYSPARK_PYTHON : /usr/bin/python3
# PYTHONPATH : /opt/amazon/spark/jars/spark-core_2.12-3.1.1-amzn-0.jar:/opt/amazon/spark/python/lib/pyspark.zip:/opt/amazon/spark/python/lib/py4j-0.10.9-src.zip:/opt/amazon/lib/python3.6/site-packages
# SPARK_CONF_DIR : /opt/amazon/conf

# Env variables
ENV M2_HOME=/opt/apache-maven-3.6.0
ENV JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64
ENV SPARK_HOME=/opt/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3
ENV GLUE_HOME=/opt/amazon
ENV PATH=${M2_HOME}/bin:${GLUE_HOME}/bin:$PATH
ENV PYTHONPATH=${GLUE_HOME}/spark/jars/spark-core_2.12-3.1.1-amzn-0.jar:${GLUE_HOME}/spark/python/lib/pyspark.zip:${GLUE_HOME}/spark/python/lib/py4j-0.10.9-src.zip:${GLUE_HOME}/lib/python3.6/site-packages
ENV LD_LIBRARY_PATH=${GLUE_HOME}/lib/hadoop-lzo-native:${GLUE_HOME}/lib/hadoop-native/:${GLUE_HOME}/lib/glue-native
ENV SPARK_CONF_DIR=${GLUE_HOME}/conf
#ENV ZEPPELIN_PORT 9001
#ENV ZEPPELIN_ADDR 0.0.0.0

ENV PYTHONPATH="${PYTHONPATH}:/project/"

# additional python lib/bin
RUN pip install awscli pyspark==3.1.1 pytest boto3 delta-spark==1.0.0
RUN pip install pandas
RUN pip install pytest-profiling

RUN ln -sf /usr/local/bin/pyspark ${SPARK_HOME}/bin/pyspark

# to run spark in local mode, and enable s3a filesystem instead of EMR
RUN sed -i 's/spark.master jes/spark.master local/g' /opt/amazon/conf/spark-defaults.conf
RUN sed -i 's/spark.hadoop.fs.s3.impl com.amazon.ws.emr.hadoop.fs.EmrFileSystem/# spark.hadoop.fs.s3.impl com.amazon.ws.emr.hadoop.fs.EmrFileSystem/g' /opt/amazon/conf/spark-defaults.conf
RUN sed -i 's/# spark.hadoop.fs.s3.impl org.apache.hadoop.fs.s3a.S3AFileSystem/spark.hadoop.fs.s3.impl org.apache.hadoop.fs.s3a.S3AFileSystem/g' /opt/amazon/conf/spark-defaults.conf

# Apply Spark interpreter config
#ADD ./interpreter-0.10.0.json /opt/zeppelin-0.10.0-bin-all/conf/interpreter.json

# run scripts
RUN echo '#!/usr/bin/env bash \n\n ${SPARK_HOME}/bin/spark-submit --packages io.delta:delta-core_2.12:1.0.0 --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" $@' > $GLUE_HOME/bin/gluesparksubmit
RUN echo '#!/usr/bin/env bash \n\n ${SPARK_HOME}/bin/pyspark --packages io.delta:delta-core_2.12:1.0.0 --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" $@' > $GLUE_HOME/bin/gluepyspark
RUN echo '#!/usr/bin/env bash \n\n exec pytest "$@"' > $GLUE_HOME/bin/gluepytest
RUN chmod +x $GLUE_HOME/bin/gluesparksubmit && \
	chmod +x $GLUE_HOME/bin/gluepyspark && \
	chmod +x $GLUE_HOME/bin/gluepytest && \
	mkdir -p /opt/work

# Clean-up some tmp files
RUN find /opt -name "._*" -type f -delete

RUN echo "alias ll='ls -al'" >> /root/.bashrc

# removed info logs and updated the driver size
RUN sed -i 's/log4j.rootLogger=.*/log4j.rootLogger=ERROR, console/' /opt/amazon/conf/log4j.properties
RUN echo 'spark.driver.memory 3g' >> /opt/amazon/conf/spark-defaults.conf

# install jupyter
RUN pip install jupyter jupyterthemes jupyter_contrib_nbextensions jupyter_contrib_nbextensions
RUN pip install jupyterlab
RUN mkdir -p /root/.local/share/jupyter/kernels/spark && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user && \
    jupyter notebook --generate-config

# launch
# jupyter-lab --allow-root --no-browser --ip=0.0.0.0

# install pytest-xdist to run tests in //
RUN pip install pytest-xdist

RUN pip install pyjwt

WORKDIR /project

CMD ["bash"]
