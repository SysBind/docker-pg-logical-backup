FROM debian:buster
LABEL maintainer="Asaf Ohayon <asaf@sysbind.co.il>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        lsb-release \
        pigz \
        python3-pip \
        python3-setuptools \
        curl \
        gnupg \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && cat /etc/apt/sources.list.d/pgdg.list \
    && curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y  \
        postgresql-client-12  \
        postgresql-client-11  \
        postgresql-client-10  \
        postgresql-client-9.6 \
        postgresql-client-9.5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY backup.sh ./

ENV PG_DIR=/usr/lib/postgresql

ENTRYPOINT ["/backup.sh"]
