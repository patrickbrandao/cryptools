#!/bin/sh

# Variaveis
    NAME="cryptools"
    DOMAIN="$(hostname -f)"
    FQDN="$NAME.$DOMAIN"
    LOCAL="$NAME.intranet.br"

# Remover atual:
    (
        docker stop cryptools
        docker rm cryptools
        docker rm -f cryptools
    ) 2>/dev/null

# Rodar
    docker run \
        -d --restart=always \
        --name cryptools -h $LOCAL \
        --tmpfs /run:rw,noexec,nosuid,size=1m \
        \
        --network network_public \
        --ip=10.111.217.101 \
        --ip6=2001:db8:10:111::217:101 \
        \
        --label "traefik.enable=true" \
        --label "traefik.http.routers.$NAME.rule=Host(\`$FQDN\`)" \
        --label "traefik.http.routers.$NAME.entrypoints=web,websecure" \
        --label "traefik.http.routers.$NAME.tls=true" \
        --label "traefik.http.routers.$NAME.tls.certresolver=letsencrypt" \
        --label "traefik.http.services.$NAME.loadbalancer.server.port=80" \
        \
        -e TZ=America/Sao_Paulo \
        \
        cryptools

exit 0

