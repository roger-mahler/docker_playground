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

RUN chmod +x /usr/local/bin/tini

# STEP: install global Python packages
COPY requirements.txt .
RUN python --version \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && exit 0

RUN python -m nltk.downloader -d /usr/local/share/nltk_data stopwords punkt sentiwordnet \
    \
    && python -m spacy download en_core_web_sm \
    && python -m spacy download fr_core_news_sm \
    && python -m spacy download en_core_web_md \
    && exit 0

RUN jupyter labextension install \
         @jupyter-widgets/jupyterlab-manager \
         jupyter-matplotlib \
         jupyterlab-jupytext \
         jupyterlab_bokeh \
         @jupyterlab/toc

    #      \
    # \
    # && jupyter nbextension enable --py widgetsnbextension
cd
# RUN beakerx install \
#     && jupyter labextension install \
#          beakerx-jupyterlab \
#     \
#     && npm install -g ijavascript itypescript --unsafe-perm \
#     && ijsinstall --install=global \
#     && its --install=global

ENV NLTK_DATA=/usr/local/share/nltk_data
ENV HOME=/home/$PUSER

COPY scripts /tmp/

RUN chmod 0555 /tmp/*.sh \
    && /tmp/setup-user.sh \
    && /tmp/fix-it.sh \
    && cp /tmp/start-jupyterlab.sh /usr/local/bin/

COPY motd /etc/motd

# $ pip install ipysheet
# $ jupyter labextension install @jupyter-widgets/jupyterlab-manager
# $ jupyter labextension install ipysheet

USER $PUSER

WORKDIR $HOME

RUN jupyter lab --generate-config \
    && /tmp/setup-jupyterlab.sh \
    && cp -f /tmp/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py

# RUN pipenv install --python=three --skip-lock

EXPOSE ${LAB_PORT}

# # docker run -rm -p 8888:8888 -v ~/notebooks:/home/humlab jupyter_nlp
# #  Setting to an empty string disables authentication altogether, which is NOT RECOMMENDED c.NotebookApp.token = ''

RUN mkdir ~/notebooks

ENTRYPOINT ["tini", "-g", "--"]

CMD ["start-jupyterlab.sh"]
