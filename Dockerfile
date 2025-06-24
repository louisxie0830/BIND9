# 基於 Debian 穩定版映像
FROM debian:stable-slim

# 設定環境變數以避免互動式提示
ENV DEBIAN_FRONTEND=noninteractive

# 安裝 BIND9 及相關工具
RUN apt-get update \
    && apt-get install -y --no-install-recommends bind9 bind9utils dnsutils \
    && rm -rf /var/lib/apt/lists/*

# 建立運行時所需目錄並賦予 bind 使用者寫入權限
RUN mkdir -p /run/named /var/run/named /var/cache/bind \
    && chown -R bind:bind /run/named /var/run/named /var/cache/bind

# 把本機 config、zones 資料夾都複製進映像
COPY config/ /etc/bind/
COPY zones/  /etc/bind/zones/

# 標示這些目錄可被掛載（可選）
VOLUME ["/etc/bind", "/etc/bind/zones"]

# 開放 DNS 所需的 TCP/UDP 53 埠口
EXPOSE 53/tcp 53/udp

# 切換到 bind 使用者，提高安全性
USER bind

# 以前景模式啟動 named，並指定主配置檔
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
