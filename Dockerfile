FROM lsiobase/java:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LIBRESONIC_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs, thelamer"

# environment settings
ENV LIBRE_HOME="/app/libresonic" \
LIBRE_SETTINGS="/config"

# Install War File
RUN \
 echo "**** Get War ****" && \
 if [ -z ${LIBRESONIC_RELEASE+x} ]; then \
        LIBRESONIC_RELEASE=$(curl -sX GET "https://api.github.com/repos/Libresonic/libresonic/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p /app/libresonic && \
 curl -o \
        /app/libresonic/libresonic.war -L \
        "https://github.com/Libresonic/libresonic/releases/download/${LIBRESONIC_RELEASE}/libresonic-${LIBRESONIC_RELEASE}.war"


# add local files
COPY root/ /

# ports and volumes
EXPOSE 4040
VOLUME /config /media /music /playlists /podcasts
