## inspired from https://github.com/webysther/aws-glue-docker
## I followed the instructions at https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html
##
FROM ubuntu

# refresh package list and install a few useful packages
RUN apt-get -q update -y && \
    apt-get -qq install -y git && \
    apt-get install -q -y zip

# install the reccomended maven distribution
# and reccomended Spark distribution
ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz /tmp/maven.tar.gz
ADD https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz /tmp/spark.tar.gz
RUN tar zxvf /tmp/maven.tar.gz -C /opt && \
    tar zxvf /tmp/spark.tar.gz -C /opt && \
    rm -rf /tmp/*

# install Glue libs (v3.0 on main)
RUN git clone https://github.com/awslabs/aws-glue-libs.git /opt/aws-glue-libs

# install python 
RUN apt-get -qq install -y python3 && \
    apt-get -qq install -y python-is-python3

# install pip
RUN apt-get -qq install -y pip && \
    python -m pip install --upgrade pip

# install a few additional python packages
RUN python -m pip install awscli && \
    python -m pip install -U pytest

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
ENV GLUE_JARS_DIR=$GLUE_HOME/jarsv1

# Generate spark-defaults.conf
RUN mkdir $SPARK_CONF_DIR && \
    echo "spark.driver.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf && \
    echo "spark.executor.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf

ENV PYTHONPATH="${SPARK_HOME}/python/:${PYTHONPATH}"
ENV PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip:${PYTHONPATH}"
ENV PYTHONPATH="${GLUE_PY_FILES}:${PYTHONPATH}"

# launches gluepyspark so it downloads all dependencies
RUN chmod +x $GLUE_HOME/bin/glue-setup.sh && \
    $GLUE_HOME/bin/glue-setup.sh

# forces the installation of pyspark on top of spark (to complete spark distribution)
RUN pip install pyspark

# for some reason there's a conflict with netty libraries I remove the glue ones
RUN rm $GLUE_HOME/jarsv1/netty-*

# comment 'source $ROOT_DIR/bin/glue-setup.sh' in gluepyspark, gluepytest and gluesparksubmit
RUN cp $GLUE_HOME/bin/gluepyspark $GLUE_HOME/bin/gluepyspark.old && cat $GLUE_HOME/bin/gluepyspark.old | sed 's/.*glue-setup.sh/#removed the setup line/g' > $GLUE_HOME/bin/gluepyspark && \
    cp $GLUE_HOME/bin/gluepytest $GLUE_HOME/bin/gluepytest.old && cat $GLUE_HOME/bin/gluepytest.old | sed 's/.*glue-setup.sh/#removed the setup line/g' > $GLUE_HOME/bin/gluepytest && \
    cp $GLUE_HOME/bin/gluesparksubmit $GLUE_HOME/bin/gluesparksubmit.old && cat $GLUE_HOME/bin/gluesparksubmit.old | sed 's/.*glue-setup.sh/#removed the setup line/g' > $GLUE_HOME/bin/gluesparksubmit

WORKDIR /project
CMD ["bash"]