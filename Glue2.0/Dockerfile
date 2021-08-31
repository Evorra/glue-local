## inspired from https://github.com/webysther/aws-glue-docker
## I followed the instructions at https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html
##
FROM ubuntu

# refresh package list and install a few useful packages
RUN apt-get -q update -y
RUN apt-get -qq install -y git 
RUN apt-get install -q -y zip

# install the reccomended maven distribution
# and reccomended Spark distribution
ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz /tmp/maven.tar.gz
ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-2.0/spark-2.4.3-bin-hadoop2.8.tgz /tmp/spark.tar.gz
RUN tar zxvf /tmp/maven.tar.gz -C /opt && \
    tar zxvf /tmp/spark.tar.gz -C /opt && \
    rm -rf /tmp/*

# install Glue libs (v2.0 on branch glue-2.0)
RUN git clone -b glue-2.0 https://github.com/awslabs/aws-glue-libs.git /opt/aws-glue-libs

# install python (specifically 3.7 as pyspark-2.4.3 requires this version)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get -qq install -y python3.7
RUN ln -s /usr/bin/python3.7 /usr/bin/python

# install pip
RUN apt-get -qq install -y pip
RUN python -m pip install --upgrade pip

# install a few additional python packages
RUN python -m pip install awscli
RUN python -m pip install -U pytest

# copy java 8 from a prebuilt docker image (faster)
COPY --from=openjdk:8-jdk-slim-buster /usr/local/openjdk-8 /usr/local/openjdk-8

# define a bunch of environment variables
ENV JAVA_HOME=/usr/local/openjdk-8
ENV M2_HOME=/opt/apache-maven-3.6.0
ENV SPARK_HOME=/opt/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8
ENV GLUE_HOME=/opt/aws-glue-libs

ENV PATH="${JAVA_HOME}/bin:${PATH}:${M2_HOME}/bin:$SPARK_HOME/bin:${GLUE_HOME}/bin/"

ENV GLUE_PY_FILES=$GLUE_HOME/PyGlue.zip
ENV SPARK_CONF_DIR=$GLUE_HOME/conf
ENV GLUE_JARS_DIR=$GLUE_HOME/jarsv1

ENV PYTHONPATH="${SPARK_HOME}/python/:${PYTHONPATH}"
ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:${PYTHONPATH}"
ENV PYTHONPATH="${GLUE_PY_FILES}:${PYTHONPATH}"

# Generate spark-defaults.conf
RUN mkdir $SPARK_CONF_DIR
RUN echo "spark.driver.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf
RUN echo "spark.executor.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf

# launches gluepyspark so it downloads all dependencies
RUN chmod +x $GLUE_HOME/bin/glue-setup.sh
# this step has to be executed manually and the image updated with docker commit
#RUN $GLUE_HOME/bin/glue-setup.sh

WORKDIR /project
CMD ["bash"]