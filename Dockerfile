FROM alpine:3.7 as builder

ARG TESTSSL_VERSION=3.0.8
ARG TESTSSL_DOWNLOAD_SHA1=df8531fc56191b4cfb73d012a05bbfb207d6ee7f
ENV TESTSSL_DOWNLOAD_URL https://github.com/drwetter/testssl.sh/archive/v${TESTSSL_VERSION}.tar.gz

RUN wget "$TESTSSL_DOWNLOAD_URL" -O testssl.tar.gz
RUN echo "$TESTSSL_DOWNLOAD_SHA1 *testssl.tar.gz" | sha1sum -c -
RUN mkdir /testssl
RUN tar -xzf testssl.tar.gz -C /testssl --strip-components=1
RUN chmod +x /testssl/testssl.sh

# cleanup to save precious bytes
RUN find /testssl/ -name \*.md -delete
RUN cd /testssl/bin/ && \
	rm openssl.Darwin.x86_64 \
	   openssl.FreeBSD.amd64 \
	   openssl.Linux.i686 


FROM python:3.7-alpine3.7

RUN apk --no-cache add bash drill

ENV PATH /usr/local/bin/testssl:$PATH

COPY --from=builder /testssl /usr/local/bin/testssl

ADD entrypoint.py /

ENTRYPOINT ["python", "/entrypoint.py"]
