FROM postgres:17

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
    mkdir -p /usr/share/keyrings; \
    curl -fsSL https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor --batch --yes -o /usr/share/keyrings/timescaledb-archive-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/timescaledb-archive-keyring.gpg] https://packagecloud.io/timescale/timescaledb/debian/ $(. /etc/os-release && echo ${VERSION_CODENAME}) main" > /etc/apt/sources.list.d/timescaledb.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends timescaledb-2-postgresql-17; \
    rm -rf /var/lib/apt/lists/*

# Add custom configuration files if needed
COPY ./custom-config/postgresql.conf /etc/postgresql/postgresql.conf
# COPY ./custom-config/pg_hba.conf /etc/postgresql/pg_hba.conf
COPY init.sql /docker-entrypoint-initdb.d/

ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB facial_manament

# Expose the PostgreSQL port
EXPOSE 5432

# Start PostgreSQL
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
