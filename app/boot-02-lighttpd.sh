#!/bin/sh

# Script de boot do container
# * Preparar ambiente do lighttpd

# Variaveis de ambiente
	[ -f /run/env.conf ] && . /run/env.conf 

# Diretorio de logs
	mkdir -p /run;
	mkdir -p /run/lighttpd;
	mkdir -p /data;
	mkdir -p /data/lighttpd;
	touch /data/lighttpd/error.log;
	touch /data/lighttpd/access.log;
	chown -R lighttpd:lighttpd /data/lighttpd;
	chown -R lighttpd:lighttpd /run/lighttpd;
	

# Pidfile
	touch /run/lighttpd/lighttpd.pid
	chown lighttpd:lighttpd /run/lighttpd/lighttpd.pid

# Servidor lighttpd no supervisord
	# logs do servico
	acslog="/data/services/lighttpd.log";
	errlog="/data/services/lighttpd.err";
	touch $acslog;
	touch $errlog;
	chown lighttpd:lighttpd $acslog;
	chown lighttpd:lighttpd $errlog;

	# unit de servico
	scfg="/etc/supervisor.d/lighttpd.ini";
	(
		echo;
		echo "[program:$name]";
		echo "user           = lighttpd";
		echo "priority       = 90";
		echo "command        = /usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf -D";
		echo "autostart      = true";
		echo "autorestart    = true";
		echo "startsecs      = 0";
		echo "stopwaitsecs   = 2";
		echo "stdout_logfile = $acslog";
		echo "stderr_logfile = $errlog";
		echo;
	) > $scfg

# Criar config para proxy aos servicos internos

	# produzir arquivos das partes
	# - principal
	rm -f /etc/lighttpd/_* 2>/dev/null;
	(
		echo;
		echo 'server.modules = (';
		echo '    "mod_accesslog",';
		echo '    "mod_proxy"';
		echo ')';
		echo;
		echo 'include "mime-types.conf"';
		echo;
		echo 'server.username      = "lighttpd"';
		echo 'server.groupname     = "lighttpd"';
		echo 'server.document-root = "/var/www/localhost/htdocs"';
		echo 'server.pid-file      = "/run/lighttpd/lighttpd.pid"';
		echo 'server.errorlog      = "/data/lighttpd/error.log"';
		echo 'index-file.names     = ("index.htm")';
		echo 'accesslog.filename   = "/data/lighttpd/access.log"';
		echo;
	) > /etc/lighttpd/_000-main.conf;

	# - proxy - inicio
	(
		echo;
		echo 'proxy.server = (';
		echo;
	) > /etc/lighttpd/_100-proxy-begin.conf;
	
	# - proxy - redirecionamentos

		# API - RSA
		if [ "$PORT_API_RSA" -gt "0" ]; then
			(   echo "    # RSA port $PORT_API_RSA";
			    echo '    "/rsa"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_RSA, STDPROXYCFG ) ),';
			    echo '    "/cryptools/rsa" => ( ( "host" => "127.0.0.1", "port" => PORT_API_RSA, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_101-proxy-rsa.conf
		else
			echo "# RSA diabled, PORT_API_RSA=$PORT_API_RSA" > /etc/lighttpd/_101-proxy-rsa.conf;
		fi

		# API - WIREGUARD
		if [ "$PORT_API_WIREGUARD" -gt "0" ]; then
			(   echo "    # WIREGUARD port $PORT_API_WIREGUARD";
			    echo '    "/wireguard"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_WIREGUARD, STDPROXYCFG ) ),';
			    echo '    "/cryptools/wireguard" => ( ( "host" => "127.0.0.1", "port" => PORT_API_WIREGUARD, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_102-proxy-wireguard.conf;
		else
			echo "# WIREGUARD diabled, PORT_API_WIREGUARD=$PORT_API_WIREGUARD" > /etc/lighttpd/_102-proxy-wireguard.conf;
		fi

		# API - UUID
		if [ "$PORT_API_UUID" -gt "0" ]; then
			(   echo "    # UUID port $PORT_API_UUID";
			    echo '    "/uuid"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_UUID, STDPROXYCFG ) ),';
			    echo '    "/cryptools/uuid" => ( ( "host" => "127.0.0.1", "port" => PORT_API_UUID, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_103-proxy-uuid.conf;
		else
			echo "# UUID diabled, PORT_API_UUID=$PORT_API_UUID" > /etc/lighttpd/_103-proxy-uuid.conf;
		fi

		# API - LVM2UUID
		if [ "$PORT_API_LVM2UUID" -gt "0" ]; then
			(   echo "    # LVM2UUID port $PORT_API_LVM2UUID";
			    echo '    "/lvm2"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_LVM2UUID, STDPROXYCFG ) ),';
			    echo '    "/cryptools/lvm2" => ( ( "host" => "127.0.0.1", "port" => PORT_API_LVM2UUID, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_104-proxy-lvm2uuid.conf;
		else
			echo "# LVM2UUID diabled, PORT_API_LVM2UUID=$PORT_API_LVM2UUID" > /etc/lighttpd/_104-proxy-lvm2uuid.conf;
		fi

		# API - DIFFIEHELMAN
		if [ "$PORT_API_DIFFIEHELMAN" -gt "0" ]; then
			(   echo "    # DIFFIEHELMAN port $PORT_API_DIFFIEHELMAN";
			    echo '    "/diffiehelman"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_DIFFIEHELMAN, STDPROXYCFG ) ),';
			    echo '    "/cryptools/diffiehelman" => ( ( "host" => "127.0.0.1", "port" => PORT_API_DIFFIEHELMAN, STDPROXYCFG ) ),';
			    echo '    "/dh"                     => ( ( "host" => "127.0.0.1", "port" => PORT_API_DIFFIEHELMAN, STDPROXYCFG ) ),';
			    echo '    "/cryptools/dh"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_DIFFIEHELMAN, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_105-proxy-diffie-helman.conf;
		else
			echo "# DIFFIEHELMAN diabled, PORT_API_DIFFIEHELMAN=$PORT_API_DIFFIEHELMAN" > /etc/lighttpd/_105-proxy-diffie-helman.conf;
		fi

		# API - ECC
		if [ "$PORT_API_ECC" -gt "0" ]; then
			(   echo "    # ECC port $PORT_API_ECC";
			    echo '    "/ecc"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_ECC, STDPROXYCFG ) ),';
			    echo '    "/cryptools/ecc" => ( ( "host" => "127.0.0.1", "port" => PORT_API_ECC, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_106-proxy-ecc.conf;
		else
			echo "# ECC diabled, PORT_API_ECC=$PORT_API_ECC" > /etc/lighttpd/_106-proxy-ecc.conf;
		fi

		# API - HASH
		if [ "$PORT_API_HASH" -gt "0" ]; then
			(   echo "    # HASH port $PORT_API_HASH";
			    echo '    "/hash"           => ( ( "host" => "127.0.0.1", "port" => PORT_API_HASH, STDPROXYCFG ) ),';
			    echo '    "/cryptools/hash" => ( ( "host" => "127.0.0.1", "port" => PORT_API_HASH, STDPROXYCFG ) ),';
			    echo;
		    ) > /etc/lighttpd/_107-proxy-hash.conf;
		else
			echo "# HASH diabled, PORT_API_HASH=$PORT_API_HASH" > /etc/lighttpd/_107-proxy-hash.conf;
		fi

	# - proxy - fim
	(
		echo;
		echo ')';
		echo '#proxy.balance = "round-robin"';
		echo 'proxy.buffer-size = 131072';
		echo;
	) > /etc/lighttpd/_199-proxy-end.conf;

	# Juntar tudo, trocar constantes magicas
	# - Constantes:
	STDPROXYCFG='"connect-timeout"=>60,"read-timeout"=>300,"write-timeout"=>60,"max-pool-size"=>128,"pool-idle-timeout"=>120';
	# - Fechar config final:
	cat /etc/lighttpd/_* | \
		sed "s#STDPROXYCFG#$STDPROXYCFG#g" | \
		sed "s#PORT_API_RSA#$PORT_API_RSA#g" | \
		sed "s#PORT_API_WIREGUARD#$PORT_API_WIREGUARD#g" | \
		sed "s#PORT_API_UUID#$PORT_API_UUID#g" | \
		sed "s#PORT_API_LVM2UUID#$PORT_API_LVM2UUID#g" | \
		sed "s#PORT_API_DIFFIEHELMAN#$PORT_API_DIFFIEHELMAN#g" | \
		sed "s#PORT_API_ECC#$PORT_API_ECC#g" | \
		sed "s#PORT_API_HASH#$PORT_API_HASH#g" \
	> /etc/lighttpd/lighttpd.conf;



exit 0



