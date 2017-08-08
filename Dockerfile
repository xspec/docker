FROM openjdk:8-jre

MAINTAINER Sandro Cirulli <sandro@sandrocirulli.net>

ENV XSPEC_VERSION=0.5.0
ENV SAXON_VERSION=9.7.0-18

# install XSpec
ENV XSPEC_DOWNLOAD_SHA256 d568a8b1dbc83dffb96fea477f75863a099a25a3e68c5792aa61a7cf9bfe7d6d
RUN curl -fSL -o xspec-${XSPEC_VERSION}.tar.gz https://github.com/xspec/xspec/archive/v${XSPEC_VERSION}.tar.gz && \
	echo ${XSPEC_DOWNLOAD_SHA256} xspec-${XSPEC_VERSION}.tar.gz | sha256sum -c - && \
	tar xvzf xspec-${XSPEC_VERSION}.tar.gz && \
	mv /xspec-${XSPEC_VERSION} /xspec && \
	rm xspec-${XSPEC_VERSION}.tar.gz
ENV XSPEC_HOME /xspec

WORKDIR /xspec
	
# install Saxon HE
ENV SAXON_DOWNLOAD_SHA256 b8884cff013f4169fba13751a876794952858e9003e0726d4f9cb28d8bb09448
RUN mkdir -p saxon && \
	export SAXON_CP=/xspec/saxon/saxon9he.jar && \
	curl -fSL -o ${SAXON_CP} http://central.maven.org/maven2/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar && \
	echo ${SAXON_DOWNLOAD_SHA256} ${SAXON_CP} | sha256sum -c - && \
	chmod +x ${SAXON_CP}
ENV SAXON_CP /xspec/saxon/saxon9he.jar 

# use non-privileged user to run xspec
RUN groupadd -r xspec && \
    useradd -s /bin/bash -r -g xspec xspec && \
 	chown xspec:xspec -R /xspec
USER xspec

ENTRYPOINT ["/xspec/bin/xspec.sh"]
CMD ["-h"]
