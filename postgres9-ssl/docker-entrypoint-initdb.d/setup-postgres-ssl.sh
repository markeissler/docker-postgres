#!/usr/bin/env bash

pushd "${PWD}"

cd /var/lib/postgresql/data \
    && pass="$(openssl rand -hex 8)" \
    && openssl genrsa -des3 -passout pass:${pass} -out server.pass.key 2048 \
    && openssl rsa -passin pass:${pass} -in server.pass.key -out server.key \
    && rm server.pass.key \
    && chmod 400 server.key \
    && openssl req -new -key server.key -out server.csr \
        -subj "/C=US/ST=California/L=San Francisco/O=OrgName/OU=IT Department/CN=example.com" \
    && openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt \
    && [[ -f "postgresql.conf" ]] && sed -i.bak 's/#ssl = off/ssl = on/g' postgresql.conf

popd

# enable verbose logging
if [[ -n "${ENABLE_QUERY_LOG// /}" && "${ENABLE_QUERY_LOG}" -eq 1 ]]
then
    echo "log_statement = 'all'" >> "/var/lib/postgresql/data/postgresql.conf"
fi
