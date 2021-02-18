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

Example：

```bash
git clone https://github.com/wf09/docker-Xray.git
cd docker-Xray
```

```bash
docker build -t xray .
```

```dockerfile
docker run -it --restart=always --name xray -v {$PWD}/config/tencent-hk-server.json:/root/config.json --network=host xray
```

