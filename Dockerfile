FROM lsiobase/alpine
MAINTAINER sparklyballs

# environment settings
ENV CATALINA_HOME="/var/lib/tomcat8"
ARG TOMCAT_VERSION_MAJOR="8"
ARG TOMCAT_VERSION_FULL="8.5.3"

# install runtime packages
RUN \
 apk add --no-cache \
	ffmpeg \
	flac \
	openjdk8

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	tar && \

# install tomcat
 mkdir -p \
	/var/lib/tomcat8 && \
 curl -o \
 /tmp/tomcat.tar.gz -L \
	https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz &&\
 tar xf /tmp/tomcat.tar.gz -C \
	/var/lib/tomcat8 --strip-components=1 && \
 ln -s \
	/app/apache-tomcat-${TOMCAT_VERSION_FULL} /var/lib/tomcat8 && \

# install libresonic
 mkdir -p \
	/var/subsonic/transcode && \
 ln -s \
	/usr/bin/ffmpeg /var/subsonic/transcode/ && \
 ln -s \
	/usr/bin/flac /var/subsonic/transcode/ && \
 ln -s \
	/usr/bin/lame /var/subsonic/transcode/ && \
 curl -o \
 /var/lib/tomcat8/webapps/libresonic.war -L \
	https://github.com/Libresonic/libresonic/releases/download/v6.0.1/libresonic-v6.0.1.war && \

# cleanup
 apk del \
	build-dependencies && \
 rm -rf \
	/tmp/*

# Configuration
ADD tomcat-users.xml /var/lib/tomcat8/conf/
RUN sed -i 's/52428800/5242880000/g' /var/lib/tomcat8/webapps/manager/WEB-INF/web.xml

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080
VOLUME /config /music
