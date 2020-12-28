FROM debian:buster
LABEL maintainer="Asaf Ohayon <asaf@sysbind.co.il>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt update \
    && apt install --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        lsb-release \
        pigz \
        curl \
	gnupg  \
        npm \
        python3-pip \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && cat /etc/apt/sources.list.d/pgdg.list \
	&& curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
	&& echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
	&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
	&& curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
	&& echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ `lsb_release -cs` main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt update \
        && apt install --no-install-recommends -y  \
        postgresql-client-13  \
        postgresql-client-12  \
        postgresql-client-11  \
        postgresql-client-10  \
        postgresql-client-9.6 \
	postgresql-client-9.5 \
	google-cloud-sdk \
	azure-cli \
    && apt-get clean \
    && npm install --global azbak \
    && pip3 install s3cmd \
    && rm -rf /var/lib/apt/lists/*

COPY *.sh ./

ENV PG_DIR=/usr/lib/postgresql

ENTRYPOINT ["/backup.sh"]
