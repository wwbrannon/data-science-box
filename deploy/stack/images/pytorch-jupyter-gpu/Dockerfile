ARG PYTORCH_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}

ARG LOCALE
ARG NB_UID
ARG NB_GID
ARG NB_USER

ENV CONDA_DIR=/opt/conda

USER root

#
# Configure repos, install updates
#

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates apt-transport-https apt-utils lsb-release \
    software-properties-common

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | apt-key add -
RUN apt-add-repository \
    "deb http://apt.postgresql.org/pub/repos/apt/ \
    $(lsb_release -cs)-pgdg main"

RUN apt-get update && apt-get -y dist-upgrade

#
# Install software
#

RUN apt-get install -y --no-install-recommends \
    "$(: Kerberos support for bigdisk fs)" \
    krb5-user kstart \
    \
    "$(: Development tools)" \
    build-essential gfortran binutils \
    autoconf automake m4 bison flex gdb libtool \
    jq pkg-config shellcheck ctags \
    bzip2 gzip zip unzip \
    git subversion \
    curl wget \
    vim nano \
    screen less \
    openssh-client ssh-askpass \
    \
    "$(: Database tools)" \
    sqlite3 unixodbc unixodbc-dev odbc-postgresql pgtop \
    postgresql-client mysql-client libpq-dev \
    \
    "$(: R dependences)" \
    libxml2-dev libcurl4-openssl-dev libssl-dev \
    \
    "$(: Misc Jupyter dependencies including tex)" \
    sudo locales tzdata fonts-liberation fonts-dejavu inkscape ffmpeg \
    libsm6 libxext-dev libxrender1 lmodern netcat pandoc python-dev \
    texlive-fonts-extra texlive-fonts-recommended texlive-xetex \
    texlive-generic-recommended texlive-latex-base texlive-latex-extra

RUN rm -rf /var/lib/apt/lists/*

RUN echo "${LOCALE} UTF-8" > /etc/locale.gen && locale-gen

#
# Update conda and install software
#

RUN conda update -n base -c defaults conda

# Jupyter and friends
RUN conda install -y \
    tini notebook jupyter jupyterhub jupyterlab nbconvert nbformat ipywidgets

# misc non-pytorch data science packages
RUN conda install -y \
    numpy pandas numexpr dask pytables pandasql \
    scipy scikit-learn statsmodels scikit-image patsy networkx nltk spacy \
    torchvision tensorboard graphviz pydot \
    matplotlib seaborn \
    \
    pymc3 pystan rpy2 \
    \
    sqlalchemy sqlite psycopg2 \
    \
    cython jinja2 tqdm hdf5 pyyaml requests unidecode xlrd python-louvain

RUN conda install -y -c pytorch torchtext

RUN pip install torchviz torchsummary

# so we can use widgets in notebooks
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix

# facets, which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets

RUN conda clean --all -y && \
    npm cache clean --force

RUN mkdir -p /etc/jupyter/
COPY jupyterhub_config.py /etc/jupyter/

#
# Finalize
#

ENV SHELL=/bin/bash \
    LC_ALL=$LOCALE \
    LANG=$LOCALE \
    LANGUAGE=$LOCALE \
    PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

RUN groupadd -g 11 wheel && \
    groupadd -g $NB_GID $NB_UID && \
    echo "%wheel         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -m -s /bin/bash -N -g $NB_GID -G wheel -d $HOME \
            -u $NB_UID $NB_USER && \
    mkdir /home/$NB_USER/notebooks

ADD pw /root/pw
RUN echo "$NB_USER:$(cat /root/pw)" | chpasswd && \
    rm -f /root/pw

ADD fix-permissions /usr/local/bin/fix-permissions
RUN chmod ugo+x /usr/local/bin/fix-permissions
RUN fix-permissions $HOME /etc/jupyter/

COPY start.sh /usr/local/bin/

EXPOSE 8000
WORKDIR $HOME

ENTRYPOINT ["tini", "-g", "--"]
CMD ["start.sh"]

