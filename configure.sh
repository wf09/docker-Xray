#!/bin/sh
# Set ARG

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
	echo "Please mount the configuration file to the /root directory!"
}




install_xray
install_config