Dockerfile

```dockerfile
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
```

运行：

```
cd docker-Xray
docker build -t xray .
docker logs xray -f
```

Example：

```dockerfile
docker run -it --restart=always --name xray -v {$PWD}/config/tencent-hk-server.json:/root/config.json ---network=host xray
```

