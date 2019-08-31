FROM python:2.7-slim-stretch

MAINTAINER Roger Mähler <roger dot mahler at umu dot se>

ENV HSFT_SWENER_VERSION=0.9.3
ENV HSFT_SWENER_ARCHIVE=hfst-swener-${HSFT_SWENER_VERSION}.tgz
#ENV HFST_SWENER_URL=http://www.ling.helsinki.fi/users/janiemi/finclarin/ner/${HSFT_SWENER_ARCHIVE}
ENV HFST_SWENER_URL=http://demo.spraakdata.gu.se/svedk/${HSFT_SWENER_ARCHIVE}

ENV SWENER_USER=swener
ENV SWENER_HOME=/home
ENV SWENER_UID="1025"
ENV SWENER_GID="1025"

USER root

# Install build tools (GNU Compiler) and libtool:
RUN set -ex; \
    apt-get update -qq \
    && apt-get -y -qq dist-upgrade \
    && apt-get install -y -qq --no-install-recommends \
        locales \
        build-essential \
        git wget tar gettext autoconf automake libtool bison flex

# Install Java
RUN mkdir -p /usr/share/man/man1 \
    && apt-get install -y -qq   \
        openjdk-8-jre-headless \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

WORKDIR /src

# Optional: Install HFST is to be compiled. See this link and README. Installation packages exist for Debian (deb) and Windows.
# RUN git clone https://github.com/hfst/hfst.git \
#     && cd hfst \
#     && ./configure --with-unicode-handler=glib --enable-proc \
#     && scripts/generate-cc-files.sh \
#     && make \
#     && make install

# Download and unpack HFST-SweNER from Språkbanken. See link in this page.
COPY cache/${HSFT_SWENER_ARCHIVE} .
RUN tar xvzf ${HSFT_SWENER_ARCHIVE}
# RUN wget -qO- ${HFST_SWENER_URL} | tar xvz - -C /tmp

WORKDIR /src/hfst-swener-${HSFT_SWENER_VERSION}

# Configure and install the package. Note that the package includes executable hfst binaries

RUN ls -al /src/ \
    && ./configure \
    && make \
    && make install

WORKDIR /

RUN rm -rf /src \
    && groupadd -r ${SWENER_USER} --gid=${SWENER_GID} \
    && adduser ${SWENER_USER} --uid ${SWENER_UID} --gid ${SWENER_GID} --disabled-password --gecos '' --shell /bin/bash  \
    && adduser ${SWENER_USER} sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers  \
    && mkdir -p ${SWENER_HOME}/data

WORKDIR ${SWENER_HOME}

USER ${SWENER_USER}

EXPOSE 9000

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

ENTRYPOINT ["/usr/local/bin/hfst-swener"]
CMD []
