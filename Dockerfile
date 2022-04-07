FROM openjdk:8-jre

MAINTAINER Sandro Cirulli <sandro@sandrocirulli.net>

ENV XSPEC_VERSION=2.2.4
ENV SAXON_VERSION=10.8
ENV XML_RESOLVER_VERSION=4.3.0

# install XSpec
ENV XSPEC_DOWNLOAD_SHA256 8e473a4e889f553936071b28ad583ef477fe5fa711565af99cf48fdc726bc002
RUN curl -fSL -o xspec-${XSPEC_VERSION}.tar.gz https://github.com/xspec/xspec/archive/v${XSPEC_VERSION}.tar.gz && \
	echo ${XSPEC_DOWNLOAD_SHA256} xspec-${XSPEC_VERSION}.tar.gz | sha256sum -c - && \
	tar xvzf xspec-${XSPEC_VERSION}.tar.gz && \
	mv /xspec-${XSPEC_VERSION} /xspec && \
	rm xspec-${XSPEC_VERSION}.tar.gz
ENV XSPEC_HOME /xspec

WORKDIR /xspec
	
# install Saxon HE and dependencies
ENV SAXON_DOWNLOAD_SHA256 f63e8fc48b5d00ab237aaca5f794a7a1efd7318380c36fadf9584e86bac4aa9d
ENV SAXON_CP /xspec/saxon/* 
RUN mkdir -p saxon && \
	cd saxon && \
	curl -fSL -o Saxon-HE-${SAXON_VERSION}.jar https://dev.saxonica.com/maven/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar && \
	echo ${SAXON_DOWNLOAD_SHA256} Saxon-HE-${SAXON_VERSION}.jar | sha256sum -c -

# use non-privileged user to run xspec
RUN groupadd -r xspec && \
    useradd -s /bin/bash -r -g xspec xspec && \
 	chown xspec:xspec -R /xspec
USER xspec

ENTRYPOINT ["/xspec/bin/xspec.sh"]
CMD ["-h"]
