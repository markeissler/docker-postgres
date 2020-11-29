# Dockerfile
#
# This Dockerfile is used to spin up a postgres server that supports SSL.
#
FROM postgres:10.1-alpine
LABEL maintainer="Mark Eissler <moe@markeissler.org>"

ENV BUILD_USER='postgres'

#
# Build:
#   prompt> docker build -t markeissler/postgres10-ssl:latest .
#
# Run locally:
#   prompt> docker run -it --rm -e TERM=$TERM -e COLUMNS=$COLUMNS -e ROWS=$ROWS markeissler/postgres10-ssl /bin/bash
#
# NOTE: You may need or want to pass the --no-cache option to build a completely fresh image.
#

ARG BUILD_TEMP='/build'

# Make temporary build dir
RUN set -x \
    && mkdir -p /build

# Install runtime dependencies
RUN set -x \
    && apk add --no-cache openssl

# Copy bootstrap files into container
# COPY ./docker-*.sh ./build/
COPY ./docker-entrypoint-initdb.d ./build/docker-entrypoint-initdb.d

# Update docker-entrypoint.sh
# RUN set -x \
#     && cp "/build/docker-entrypoint.sh" "/docker-entrypoint.sh" \
#     && chmod 755 "/docker-entrypoint.sh" \
#     && chown "${BUILD_USER}":"${BUILD_USER}" "/docker-entrypoint.sh"

# Update docker-entrypoint-initdb.d
RUN set -x \
    && mkdir -p "/docker-entrypoint-initdb.d" \
    && chmod 700 "/docker-entrypoint-initdb.d" \
    && chown "${BUILD_USER}":"${BUILD_USER}" "/docker-entrypoint-initdb.d" \
    && cp "/build/docker-entrypoint-initdb.d/"*.sh "/docker-entrypoint-initdb.d/" \
    && chmod 700 "/docker-entrypoint-initdb.d/"*.sh \
    && chown "${BUILD_USER}":"${BUILD_USER}" "/docker-entrypoint-initdb.d/"*.sh

# Remove build directory
RUN set -x \
    && rm -rf "${BUILD_TEMP}"
