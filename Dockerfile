
FROM alpine:3

# Variaveis globais de ambiente
ENV \
    MAINTAINER="Patrick Brandao <patrickbrandao@gmail.com>" \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Atualiza os repositórios e pacotes
RUN ( \
    apk update                   || exit 1; \
    apk upgrade                  || exit 2; \
    \
    apk add bash                 || exit 11; \
    apk add wireguard-tools      || exit 12; \
    apk add jq                   || exit 13; \
    apk add curl                 || exit 14; \
    apk add python3              || exit 15; \
    apk add py3-pip              || exit 16; \
    apk add py3-flask            || exit 17; \
    \
    apk add py3-asn1crypto       || exit 21; \
    apk add py3-cffi             || exit 22; \
    apk add py3-cffi-pyc         || exit 23; \
    apk add py3-cparser          || exit 24; \
    apk add py3-cparser-pyc      || exit 25; \
    apk add py3-cryptography     || exit 26; \
    apk add py3-cryptography-pyc || exit 27; \
    apk add py3-rsa              || exit 28; \
    apk add py3-openssl          || exit 29; \
    apk add py3-openssl-pyc      || exit 30; \
    apk add py3-werkzeug         || exit 31; \
    apk add py3-pycryptodomex    || exit 32; \
    \
    apk add supervisor           || exit 41; \
    apk add lighttpd             || exit 42; \
    \
    mkdir -p /app; \
    \
)

# Copiar scripts e programas
COPY app/* /app/

# Finalizar: tornar scripts excutaveis, limpar ambiente
RUN ( \
    chmod +x /app/*.py /app/*.sh; \
    \
    rm -rf /var/cache/apk/* 2>/dev/null; \
    rm -rf /root/.local     2>/dev/null; \
    rm -rf /root/.config    2>/dev/null; \
    rm -rf /root/.cache     2>/dev/null; \
    \
)

# Expor porta do proxy que reune todos
# os servicos internos
EXPOSE 80/tcp

# Script de preparacao do ambiente
ENTRYPOINT ["/app/entrypoint.sh"]

# Supervisor de multi-processos
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf ", "-n", "-u", "root"]

