# Bind9 Dockerfile with proper permissions
FROM debian:stable-slim

# 避免互動提示
ENV DEBIAN_FRONTEND=noninteractive

# 安裝 BIND9 及工具
RUN apt-get update \
    && apt-get install -y --no-install-recommends bind9 bind9utils dnsutils \
    && rm -rf /var/lib/apt/lists/*

# 建立運行時目錄並設定權限
RUN mkdir -p /run/named /var/run/named /var/cache/bind \
    && chown -R bind:bind /run/named /var/run/named /var/cache/bind

# 複製 BIND 配置並設定 bind 使用者可讀寫
COPY config/ /etc/bind/
COPY zones/  /etc/bind/zones/
RUN chown -R bind:bind /etc/bind /etc/bind/zones

# 宣告可掛載資料夾
VOLUME ["/etc/bind", "/etc/bind/zones"]

# 開放 DNS 端口
EXPOSE 53/tcp 53/udp

# 切換為 bind 使用者執行
USER bind

# 啟動 named
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
