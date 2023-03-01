set -exuo pipefail

RED="\033[31m"      # Error message
GREEN="\033[32m"    # Success message
YELLOW="\033[33m"   # Warning message
BLUE="\033[36m"     # Info message
PLAIN='\033[0m'

CONFIG_FILE="/etc/v2ray/config.json"
SERVICE_FILE="/etc/systemd/system/v2ray.service"
OS=`hostnamectl | grep -i system | cut -d: -f2`

V6_PROXY=""
IP=`curl -sL -4 ip.sb`
if [[ "$?" != "0" ]]; then
    IP=`curl -sL -6 ip.sb`
    V6_PROXY="https://gh.hijk.art/"
fi

colorEcho() {
    echo -e "${1}${@:2}${PLAIN}"
}

archAffix(){
    case "$(uname -m)" in
        i686|i386)
            echo '32'
        ;;
        x86_64|amd64)
            echo '64'
        ;;
        *armv7*)
            echo 'arm32-v7a'
            ;;
        armv6*)
            echo 'arm32-v6a'
        ;;
        *armv8*|aarch64)
            echo 'arm64-v8a'
        ;;
        *mips64le*)
            echo 'mips64le'
        ;;
        *mips64*)
            echo 'mips64'
        ;;
        *mipsle*)
            echo 'mipsle'
        ;;
        *mips*)
            echo 'mips'
        ;;
        *s390x*)
            echo 's390x'
        ;;
        ppc64le)
            echo 'ppc64le'
        ;;
        ppc64)
            echo 'ppc64'
        ;;
        *)
            colorEcho $RED " 不支持的CPU架构！"
            exit 1
        ;;
    esac

	return 0
}

installV2ray() {
    rm -rf /tmp/v2ray
    mkdir -p /tmp/v2ray
    # DOWNLOAD_LINK="${V6_PROXY}https://github.com/v2fly/v2ray-core/releases/download/${NEW_VER}/v2ray-linux-$(archAffix).zip"
    DOWNLOAD_LINK="${V6_PROXY}https://github.com/v2fly/v2ray-core/releases/download/v4.45.2/v2ray-linux-$(archAffix).zip"
    colorEcho $BLUE " 下载V2Ray: ${DOWNLOAD_LINK}"
    curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip ${DOWNLOAD_LINK}
    if [ $? != 0 ];then
        colorEcho $RED " 下载V2ray文件失败，请检查服务器网络设置"
        exit 1
    fi
    mkdir -p '/etc/v2ray' '/var/log/v2ray' && \
    unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
    mkdir -p /usr/bin/v2ray
    cp /tmp/v2ray/v2ctl /usr/bin/v2ray/; cp /tmp/v2ray/v2ray /usr/bin/v2ray/; cp /tmp/v2ray/geo* /usr/bin/v2ray/;
    chmod +x '/usr/bin/v2ray/v2ray' '/usr/bin/v2ray/v2ctl' || {
        colorEcho $RED " V2ray安装失败"
        exit 1
    }

    cat >$SERVICE_FILE<<-EOF
[Unit]
Description=V2ray Service
Documentation=https://hijk.art
After=network.target nss-lookup.target

[Service]
# If the version of systemd is 240 or above, then uncommenting Type=exec and commenting out Type=simple
#Type=exec
Type=simple
# This service runs as root. You may consider to run it as another user for security concerns.
# By uncommenting User=nobody and commenting out User=root, the service will run as user nobody.
# More discussion at https://github.com/v2ray/v2ray-core/issues/1011
User=root
#User=nobody
NoNewPrivileges=true
ExecStart=/usr/bin/v2ray/v2ray -config /etc/v2ray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable v2ray.service
}

installV2ray
