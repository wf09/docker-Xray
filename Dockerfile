FROM alpine:latest
LABEL maintainer "wf09 <wf09@outlook.de>"

WORKDIR /root
ARG TARGETPLATFORM=linux/amd64

COPY configure.sh fullchain.crt privkey.key /root/

RUN set -ex \
	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
	&& apk update \
	&& apk add --no-cache tzdata openssl ca-certificates \
	&& mkdir -p ./Xray \
	&& chmod +x ./configure.sh \
	&& ./configure.sh "${TARGETPLATFORM}"

CMD /root/Xray/xray -config /root/config.json
