#!/bin/sh
# Set ARG
xtls(){
cat << EOF > /root/Xray/server.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "115b399e-9c7d-406e-adf9-172c965a3c54",
                        "flow": "xtls-rprx-direct"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/root/fullchain.crt", 
                            "keyFile": "/root/privkey.key"
                        }
                    ]
                }
            }
        }
    ]
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}

EOF
}
ws(){
cat << EOF > /root/Xray/server.json
{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
			"decryption": "none",
                "clients": [
                    {
                        "id": "115b399e-9c7d-406e-adf9-172c965a3c54"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}

EOF
}


install_xray(){
PLATFORM=$1 
if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi
[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download files
XRAY_FILE="Xray-linux-${ARCH}.zip"
echo "Downloading binary file: ${XRAY_FILE}"

wget -O ${PWD}/Xray.zip https://cdn.jsdelivr.net/gh/wf09/Xray-release/"${XRAY_FILE}"

if [ $? -ne 0 ]; then
    echo "Error: Failed to download binary file: ${XRAY_FILE} " && exit 1
fi
echo "Download binary file: ${XRAY_FILE} completed"

# Prepare
echo "Prepare to use"
unzip -d Xray Xray.zip && chmod +x ./Xray/xray
}

install_config(){
    case "$XTLS_WS" in
        vless/xtls)
            xtls
            ;;
        vless/ws)
            ws
            ;;
        *)
			echo "Default XTLS."
			xtls
            ;;
    esac
	echo "port=$PORT"
	echo "Done."
}




install_xray
install_config