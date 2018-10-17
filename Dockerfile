FROM alpine:3.8

# Download and install hugo
ARG HUGO_VERSION

# Update, upgrade, install curl
RUN apk add curl tar

# Install latest Hugo version, or Hugo version passed as build arg
RUN HUGO_VERSION=""; \
    if [ -z ${HUGO_VERSION} ]; then \
        HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/tags | grep -m 1 -o "[[:digit:]]\\+.*[[:digit:]]"); \
    else \
        HUGO_VERSION=${HUGO_VERSION}; \
    fi; \
    url=https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_"$HUGO_VERSION"_Linux-64bit.tar.gz; \
    curl -L -s -o hugo.tar.gz $url; \
    tar -xzf hugo.tar.gz && cp hugo /bin/ && rm hugo.tar.gz

ENV HUGO_BASE_URL http://localhost
ENV HUGO_PORT 1313
ENV HUGO_BIND 0.0.0.0
ENV HUGO_APPEND_PORT true

WORKDIR /data

# Serve site
CMD hugo server -w -b ${HUGO_BASE_URL} --port ${HUGO_PORT} --bind ${HUGO_BIND} --appendPort=${HUGO_APPEND_PORT}
