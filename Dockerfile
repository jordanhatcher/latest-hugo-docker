FROM debian:jessie

# Download and install hugo
ARG HUGO_VERSION

# Update, upgrade, install curl
RUN apt-get update && apt-get upgrade -y && apt-get install -y curl

# Install latest Hugo version, or Hugo version passed as build arg
RUN HUGO_VERSION=""; \
    if [ -z ${HUGO_VERSION} ]; then \
        HUGO_VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/tags | grep -m 1 -o "[[:digit:]]\\+.*[[:digit:]]"); \
    else \
        HUGO_VERSION=${HUGO_VERSION}; \
    fi; \
    url=https://github.com/gohugoio/hugo/releases/download/v$HUGO_VERSION/hugo_"$HUGO_VERSION"_Linux-64bit.deb; \
    curl -L -s -o /hugo.deb $url; \
    dpkg -i /hugo.deb && rm /hugo.deb

ENV HUGO_BASE_URL http://localhost
ENV HUGO_PORT 1313
ENV HUGO_BIND 0.0.0.0

WORKDIR /data

# Serve site
CMD hugo server -b ${HUGO_BASE_URL} --port ${HUGO_PORT} --bind ${HUGO_BIND}
