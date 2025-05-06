
# Container para processamento de criptografia por API HTTP

	- Gerar chaves privadas (e respectiva chave publica):
		DH
		RSA
		ECC: secp256k1 (SECP256K1), prime256v1 (SECP256R1), secp384r1 (SECP384R1), secp521r1 (SECP521R1), ed25519 (Ed25519)
		Wireguard

	- Gerar identificadores universais:
		UUID: uuid-v4
		LVM2-UUID: uuid especifico de volumes LVM2 (gestor de volumes especial do Linux)

	- Calcular HASH: 
		md5
		sha1
		md5-sha1
		sha256
		sha384
		sha512
		sha512-224
		sha512-256
		sha3-224
		sha3-256
		sha3-384
		sha3-512
		shake128
		shake256


## Implementacao de servidores HTTP do container

	Serviço para prover endpoints para uso em API

	Servidor HTTP, porta padrão e variável de ambiente para modificar porta:

	/app/api-rsa.py           - porta padrao HTTP 9001 - PORT_API_RSA
	/app/api-wireguard.py     - porta padrao HTTP 9002 - PORT_API_WIREGUARD
	/app/api-uuid.py          - porta padrao HTTP 9011 - PORT_API_UUID
	/app/api-lvm2-uuid.py     - porta padrao HTTP 9012 - PORT_API_LVM2UUID
	/app/api-diffie-helman.py - porta padrao HTTP 9021 - PORT_API_DIFFIEHELMAN
	/app/api-ecc.py           - porta padrao HTTP 9022 - PORT_API_ECC
	/app/api-hash.py          - porta padrao HTTP 9031 - PORT_API_HASH

	Porta HTTP 80 faz proxy para todas as demais portas especificas


## Instalando - Construindo imagem localmente

```

# Baixar fontes:
cd /usr/local/src/
wget https://github.com/patrickbrandao/cryptools/archive/refs/heads/main.zip -O cryptools.zip

# Extrair (requer: apt-get -y install unzip ):
unzip cryptools.zip

# Entrar no diretorio dos fontes:
cd cryptools-main

# Construir imagem do container:
sh build.sh

# Criar rede docker para containers publicos:
docker network create \
    -d bridge \
   \
    -o "com.docker.network.bridge.name"="br-net-public" \
    -o "com.docker.network.bridge.enable_icc"="true" \
    -o "com.docker.network.driver.mtu"="65495" \
   \
    --subnet 10.111.0.0/16 --gateway 10.111.255.254 \
    --ipv6 \
    --subnet=2001:db8:10:111::/64 \
    --gateway=2001:db8:10:111::ffff \
    \
    network_public

# Rodar container (detalhes no script run.sh):
sh run.sh

# Testar APIs:
sh test.sh

```



## Procedimentos para desenvolvimento do zero

```
# Container de base inicial:

	# Criar container limpo:
	docker rm -f api-test
    docker run -d --restart=always \
        --name api-test -h api-test.intranet.br \
        --user=root --cap-add=ALL --privileged \
        \
        alpine:3 sleep 9999999000

	# Entrar no container
	docker exec -it api-test ash

	# Instalar pacotes:
	apk update
	apk upgrade

	apk add bash
	apk add wireguard-tools
	apk add jq
	apk add curl
	apk add python3
	apk add py3-pip
	apk add py3-flask
	apk add py3-asn1crypto
	apk add py3-cffi
	apk add py3-cffi-pyc
	apk add py3-cparser
	apk add py3-cparser-pyc
	apk add py3-cryptography
	apk add py3-cryptography-pyc
	apk add py3-rsa
	apk add py3-openssl
	apk add py3-openssl-pyc
	apk add py3-werkzeug
	apk add py3-pycryptodomex
	apk add supervisor
	apk add lighttpd

	mkdir /app

```



