FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends bind9 bind9-utils dnsutils \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/named /var/cache/bind \
 && chown -R bind:bind /run/named /var/cache/bind \
 && chmod 775 /var/cache/bind
EXPOSE 53/udp 53/tcp
CMD ["named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]