FROM python:3.7.3-slim

# Notice: part of this code is from jupyter project
MAINTAINER Roger Mähler <roger dot mahler at umu dot se>

ARG PUSER="humlab"
ARG PUID="1001"
ARG PGID="100"

ARG TINI_VERSION=v0.18.0

ENV LAB_PORT=8888 \
    PUSER=$PUSER \
    PUID=$PUID \
    PGID=$PGID \
     \
    SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive

USER root

RUN set -ex; \
    apt-get update -qq && apt-get -y -qq dist-upgrade \
    \
    && mkdir -p /usr/share/man/man1 \
    && apt-get install -y -qq --no-install-recommends \
        locales \
        build-essential checkinstall \
        curl software-properties-common \
        wget zip unzip bzip2 \
        git \
        ca-certificates \
        sudo \
        fonts-liberation \
        openjdk-8-jdk \
        openjdk-8-jre \
    \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y -qq nodejs \
    \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/bin:$PATH

WORKDIR /tmp

RUN npm install npm@latest -g \
    \
    && npm install -g n \
    && npm cache clean -f \
    && npm config set progress false \
    && npm config set registry http://registry.npmjs.org/ \
    && npm i -g zeromq --unsafe-perm \
    && npm install -g node-gyp \
    \
    && n stable

# STEP: Add tini init (see https://github.com/krallin/tini) and entrypoint
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/tini \
    \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# STEP: install global Python packages
COPY requirements.txt .
RUN python --version && pip install -r requirements.txt \
    \
    && python -m nltk.downloader -d /usr/local/share/nltk_data stopwords punkt sentiwordnet

RUN beakerx install \
    && jupyter labextension install \
         @jupyter-widgets/jupyterlab-manager \
         jupyter-matplotlib \
         jupyterlab-jupytext \
         jupyterlab_bokeh \
         beakerx-jupyterlab \
         @jupyterlab/toc \
    \
    && jupyter nbextension enable --py widgetsnbextension \
    \
    && npm install -g ijavascript itypescript --unsafe-perm \
    && ijsinstall --install=global \
    && its --install=global

ENV NLTK_DATA=/usr/local/share/nltk_data
ENV HOME=/home/$PUSER

COPY scripts/* /tmp/

RUN chmod +x /tmp/setup-user.sh /tmp/setup-lab.sh /tmp/fix-it.sh
RUN /tmp/setup-user.sh
RUN /tmp/fix-it.sh

COPY motd /etc/motd

USER $PUSER

WORKDIR $HOME

RUN jupyter lab --generate-config \
    && /tmp/setup-lab.sh \
    && touch /home/humlab/work/HELLO

# RUN pipenv install --python=three --skip-lock

EXPOSE ${LAB_PORT}

# # docker run -p 8888:8888 -v ~/notebooks:/home/humlab jupyter/minimal-notebook
# #  Setting to an empty string disables authentication altogether, which is NOT RECOMMENDEDc.NotebookApp.token = ''

#ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh" ]

ENTRYPOINT ["tini", "-g", "--"]
CMD ["docker-entrypoint.sh"]
