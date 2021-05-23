ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION}

ARG POSTGIS_VERSION
ARG NB_UID
ARG NB_GID

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates krb5-user kstart \
    postgis ${POSTGIS_VERSION} pgtop \
    \
    ogdi-bin gdal-bin geoip-bin proj-bin gdal-data proj-data geoip-database \
    publicsuffix
RUN rm -rf /var/lib/apt/lists/*

RUN groupadd -g $NB_GID $NB_UID && \
    usermod -g $NB_GID -u $NB_UID postgres

ADD pw /home/postgres/pw
RUN chown ${NB_UID} /home/postgres/pw && chmod 600 /home/postgres/pw

