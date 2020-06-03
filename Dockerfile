FROM lsiobase/alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LIMNORIA_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="nemchik"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    g++ \
    gcc \
    libffi-dev \
    openssl-dev \
    python3-dev && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    gnupg \
    py3-pip \
    python3 && \
  echo "**** install app ****" && \
  if [ -z ${LIMNORIA_VERSION+x} ]; then \
    LIMNORIA="limnoria"; \
  else \
    LIMNORIA="limnoria==${LIMNORIA_VERSION}"; \
  fi && \
  pip3 install -U --no-cache-dir \
    pip && \
  pip3 install -U --no-cache-dir -r \
    https://raw.githubusercontent.com/ProgVal/Limnoria/master/requirements.txt && \
  pip3 install -U --no-cache-dir \
    ${LIMNORIA} && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config
