FROM debian:stable-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends bind9 bind9utils dnsutils \
 && rm -rf /var/lib/apt/lists/*

# 把本機 config、zones 資料夾都複製進映像裡
COPY config/ /etc/bind/
COPY zones/  /etc/bind/zones/

# 標示這些目錄未來可以當 Volume 掛載（可選）
VOLUME ["/etc/bind", "/etc/bind/zones"]

EXPOSE 53/tcp 53/udp
USER bind

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
