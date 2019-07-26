FROM openjdk:8u181-jre-stretch

MAINTAINER Roger Mähler <roger dot mahler at umu dot se>

ARG CORENLP_MX=1g
ARG CORENLP_PORT=9000

ENV CORENLP_ARCHIVE_VERSION=2018-10-05
ENV CORENLP_ARCHIVE=stanford-corenlp-full-${CORENLP_ARCHIVE_VERSION}
ENV CORENLP_PATH=/corenlp
ENV CORENLP_MX=${CORENLP_MX}
ENV CORENLP_PORT=${CORENLP_PORT}}

RUN apt-get install -yqq --no-install-recommends -y wget unzip \

WORKDIR $CORENLP_PATH

RUN set -ex; \
    wget http://nlp.stanford.edu/software/$CORENLP_ARCHIVE.zip; \
    unzip $CORENLP_ARCHIVE; \
    rm $CORENLP_ARCHIVE.zip; \
    export CLASSPATH="`find . -name '*.jar'`"

EXPOSE ${CORENLP_PORT}

CMD java -mx${CORENLP_MX} -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port ${CORENLP_PORT}
