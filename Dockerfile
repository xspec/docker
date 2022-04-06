FROM openjdk:8-jre

MAINTAINER Sandro Cirulli <sandro@sandrocirulli.net>

ENV XSPEC_VERSION=2.2.4
ENV SAXON_VERSION=11.3

# install XSpec
ENV XSPEC_DOWNLOAD_SHA256 8e473a4e889f553936071b28ad583ef477fe5fa711565af99cf48fdc726bc002
RUN curl -fSL -o xspec-${XSPEC_VERSION}.tar.gz https://github.com/xspec/xspec/archive/v${XSPEC_VERSION}.tar.gz && \
	echo ${XSPEC_DOWNLOAD_SHA256} xspec-${XSPEC_VERSION}.tar.gz | sha256sum -c - && \
	tar xvzf xspec-${XSPEC_VERSION}.tar.gz && \
	mv /xspec-${XSPEC_VERSION} /xspec && \
	rm xspec-${XSPEC_VERSION}.tar.gz
ENV XSPEC_HOME /xspec

WORKDIR /xspec
	
# install Saxon HE
ENV SAXON_DOWNLOAD_SHA256 e62e1a283b1aa610605fde18e9368a9ec6f24d878320eb74cfc1c1f2d432e8a6
RUN mkdir -p saxon && \
	export SAXON_CP=/xspec/saxon/saxon11he.jar && \
	curl -fSL -o ${SAXON_CP} https://repo.maven.apache.org/maven2/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar && \
	echo ${SAXON_DOWNLOAD_SHA256} ${SAXON_CP} | sha256sum -c - && \
	chmod +x ${SAXON_CP}
ENV SAXON_CP /xspec/saxon/saxon11he.jar 

# use non-privileged user to run xspec
RUN groupadd -r xspec && \
    useradd -s /bin/bash -r -g xspec xspec && \
 	chown xspec:xspec -R /xspec
USER xspec

ENTRYPOINT ["/xspec/bin/xspec.sh"]
CMD ["-h"]
