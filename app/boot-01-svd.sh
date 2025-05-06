#!/bin/sh

# Script de boot do container
# * Preparar ambiente para supervisord

# Variaveis de ambiente
	[ -f /run/env.conf ] && . /run/env.conf 

	# Ponto de captura de logs do boot
    initlogfile="/data/services/init.log"
    _log(){ now=$(date "+%Y-%m-%d-%T"); echo "$now|01-svd|$@"; echo "$now|$@" >> $initlogfile; }
    _eval(){ _log "Running: $@"; out=$(eval "$@" 2>&1); sn="$?"; _log "Output[$sn]: $out"; }


# Diretorios
	mkdir -p /etc/supervisor.d
	mkdir -p /data
	mkdir -p /data/services
	chown -R nobody:nobody /data/services

# Mapa de servicos, registro:  PORTA;SCRIPT
	SERVICES="
		$PORT_API_RSA;/app/api-rsa.py
		$PORT_API_WIREGUARD;/app/api-wireguard.py
		$PORT_API_UUID;/app/api-uuid.py
		$PORT_API_LVM2UUID;/app/api-lvm2-uuid.py
		$PORT_API_DIFFIEHELMAN;/app/api-diffie-helman.py
		$PORT_API_ECC;/app/api-ecc.py
		$PORT_API_HASH;/app/api-hash.py	
	"
	for svc in $SERVICES; do
		port=$(echo "$svc" | cut -f1 -d';')
		script=$(echo "$svc" | cut -f2 -d';')
		name=$(basename "$script" | sed 's#\.py##g')
		scfg="/etc/supervisor.d/$name.ini"

		_log "boot service [$name] = port[$port] script[$script]"
		
		# porta desativada, ignorar servico
		[ "$port" = "0" ] && {
			_log "boot service [$name] DISABLED, port=0 ($port)"
			continue;
		}
		# script ausente
		[ -f "$script" ] || {
			_log "boot service [$name] SCRIPT MISSED"
			continue;
		}

		# logs do servico
		acslog="/data/services/$name.log"
		errlog="/data/services/$name.err"
		touch $acslog
		touch $errlog
		chown nobody:nobody $acslog
		chown nobody:nobody $errlog

		# servico ativo
		# - criar manifesto no supervisord
		(
			echo
			echo "[program:$name]"
			echo "user           = nobody"
			echo "priority       = 10"
			echo "command        = /usr/bin/python3 $script"
			echo "autostart      = true"
			echo "autorestart    = true"
			echo "startsecs      = 0"
			echo "stopwaitsecs   = 2"
			echo "stdout_logfile = $acslog"
			echo "stderr_logfile = $errlog"
			echo
		) > $scfg

	done


exit 0




