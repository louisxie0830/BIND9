 FROM debian:stable-slim
 ENV DEBIAN_FRONTEND=noninteractive

 RUN apt-get update \
  && apt-get install -y --no-install-recommends bind9 bind9utils dnsutils \
  && rm -rf /var/lib/apt/lists/*

+ # 建立 runtime 目錄並給 bind 使用者寫入權限
RUN mkdir -p /run/named /var/run/named && chown -R bind:bind /run/named /var/run/named /var/cache/bind

 # 把設定檔與區域檔 COPY 進映像
 COPY config/ /etc/bind/
 COPY zones/  /etc/bind/zones/

 VOLUME ["/etc/bind", "/etc/bind/zones"]
 EXPOSE 53/tcp 53/udp

- USER bind
+ # 切換到 bind 這個非 root 使用者
 USER bind

 CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
