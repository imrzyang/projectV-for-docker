FROM nginx:mainline-alpine-slim
MAINTAINER ifeng <https://t.me/HiaiFeng>
EXPOSE 80
USER root

RUN apk update && apk add --no-cache supervisor wget unzip curl

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
ENV UUID 7954b7ec-d328-4035-983f-4ff2191d3b6e
ENV TROJAN_PASSWORD imrzyangtrojanpassword
ENV VMESS_WSPATH /imrzyangpathm
ENV VLESS_WSPATH /imrzyangpathl
ENV TROJAN_WSPATH /imrzyangpatht

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY keepalive_exec /root/keepalive_exec

RUN mkdir /etc/v2ray /usr/local/v2ray && chmod a+x /root/keepalive_exec
COPY config.json /etc/v2ray/
COPY entrypoint.sh /usr/local/v2ray/

# 感谢 fscarmen 大佬提供 Dockerfile 层优化方案
RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip v2ray  && \
    wget -q -O /usr/local/v2ray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && \
    wget -q -O /usr/local/v2ray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && \
    chmod a+x /usr/local/v2ray/entrypoint.sh && \
    apk del wget unzip  && \
    rm -rf /tmp/v2ray-linux-64.zip && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*
    
ENTRYPOINT [ "/usr/local/v2ray/entrypoint.sh" ]
