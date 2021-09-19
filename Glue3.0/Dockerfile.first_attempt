## inspired from https://github.com/webysther/aws-glue-docker
##
FROM ubuntu

# refresh package list and install a few additional packages
RUN apt-get -q update -y
RUN apt-get -qq install -y curl 
RUN apt-get -qq install -y git 
RUN apt-get install -q -y zip

# install the reccomended maven distribution
RUN curl -SsL https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz | tar -C /opt --warning=no-unknown-keyword -xzf -

# install Glue libs (v3.0 on main)
RUN git clone https://github.com/awslabs/aws-glue-libs.git /opt/aws-glue-libs

# install the reccomended Spark distribution
# this distribution does not contain pyspark and python helpers
RUN curl -SsL https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz | tar -C /opt --warning=no-unknown-keyword -xzf -

# install python 
RUN apt-get -qq install -y python3
RUN apt-get -qq install -y python-is-python3
RUN apt-get -qq install -y pip
RUN python -m pip install --upgrade pip

# install a few additional python packages
RUN python -m pip install awscli
RUN python -m pip install -U pytest

# copy java 8 from a prebuilt docker images
COPY --from=openjdk:8-jdk-slim-buster /usr/local/openjdk-8 /usr/local/openjdk-8

# define a bunch of environment variables
ENV JAVA_HOME=/usr/local/openjdk-8
ENV M2_HOME=/opt/apache-maven-3.6.0
ENV SPARK_HOME=/opt/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3
ENV GLUE_HOME=/opt/aws-glue-libs

ENV PATH="${JAVA_HOME}/bin:${PATH}:${M2_HOME}/bin:${GLUE_HOME}/bin/"

ENV GLUE_PY_FILES=$GLUE_HOME/PyGlue.zip
ENV SPARK_CONF_DIR=$GLUE_HOME/conf

ENV PYTHONPATH="${SPARK_HOME}/python/:${PYTHONPATH}"
ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:${PYTHONPATH}"
ENV PYTHONPATH="${GLUE_PY_FILES}:${PYTHONPATH}"

# forces the installation of pyspark on top of spark (to complete spark distribution)
RUN python -m pip install pyspark
RUN ln -s /usr/local/bin/pyspark "${SPARK_HOME}/bin/pyspark"

# launches gluepyspark so it downloads all dependencies
RUN $GLUE_HOME/bin/gluepyspark

WORKDIR /project
CMD ["bash"]