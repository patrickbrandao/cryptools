#!/bin/sh

EXEC_CMD="$@"

# Funcoes
#========================================================================================================

	# Ponto de captura de logs do boot
    initlogfile="/data/services/init.log"
    lastlogfile="/data/services/last.log"
    _log(){ now=$(date "+%Y-%m-%d-%T"); echo "$now|$@"; echo "$now|$@" >> $initlogfile; }
    _eval(){ _log "Running: $@"; out=$(eval "$@" 2>&1); sn="$?"; _log "Output[$sn]: $out"; }

#========================================================================================================

    # Scripts de ponto de entrada
    _init_bootscripts(){
        _log "INIT-BOOTSCRIPTS"
        cd /app || return 9
        for escript in boot-*.sh; do
        	[ -f "$escript" ] || continue
            _log "Entrypoint script: start [$escript]"
            sh "$escript"
            sn="$?"
            _log "Entrypoint script: stdno [$escript] = $sn"
        done
        _log "END-BOOTSCRIPTS"
    }

#========================================================================================================

    # Pasta de logs e dados gerados pelo container
    mkdir -p /data
    mkdir -p /data/services

    # Limpar logs do ultimo boot
    touch $initlogfile
    cp $initlogfile $lastlogfile
    echo -n > $initlogfile


#========================================================================================================

    # INICIAR:
    _log "Start entrypoint [$0 $@] cmd $EXEC_CMD"

    # Variaveis de ambiente para config geral do container

    # - firewall de protecao do container
    [ "x$PORT_API_RSA"          = "x" ] && PORT_API_RSA="9001"
    [ "x$PORT_API_WIREGUARD"    = "x" ] && PORT_API_WIREGUARD="9002"
    [ "x$PORT_API_UUID"         = "x" ] && PORT_API_UUID="9011"
    [ "x$PORT_API_LVM2UUID"     = "x" ] && PORT_API_LVM2UUID="9012"
    [ "x$PORT_API_DIFFIEHELMAN" = "x" ] && PORT_API_DIFFIEHELMAN="9021"
    [ "x$PORT_API_ECC"          = "x" ] && PORT_API_ECC="9022"
    [ "x$PORT_API_HASH"         = "x" ] && PORT_API_HASH="9031"

    # - servicoes desativados por porta zero ou constante 'disabled' ou 'off'
    [ "$PORT_API_RSA"          = "off" -o "$PORT_API_RSA"          = "disabled" ] && PORT_API_RSA="0"
    [ "$PORT_API_WIREGUARD"    = "off" -o "$PORT_API_WIREGUARD"    = "disabled" ] && PORT_API_WIREGUARD="0"
    [ "$PORT_API_UUID"         = "off" -o "$PORT_API_UUID"         = "disabled" ] && PORT_API_UUID="0"
    [ "$PORT_API_LVM2UUID"     = "off" -o "$PORT_API_LVM2UUID"     = "disabled" ] && PORT_API_LVM2UUID="0"
    [ "$PORT_API_DIFFIEHELMAN" = "off" -o "$PORT_API_DIFFIEHELMAN" = "disabled" ] && PORT_API_DIFFIEHELMAN="0"
    [ "$PORT_API_ECC"          = "off" -o "$PORT_API_ECC"          = "disabled" ] && PORT_API_ECC="0"
    [ "$PORT_API_HASH"         = "off" -o "$PORT_API_HASH"         = "disabled" ] && PORT_API_HASH="0"

    # Garantir publicacao no env
    export PORT_API_RSA="$PORT_API_RSA"
    export PORT_API_WIREGUARD="$PORT_API_WIREGUARD"
    export PORT_API_UUID="$PORT_API_UUID"
    export PORT_API_LVM2UUID="$PORT_API_LVM2UUID"
    export PORT_API_DIFFIEHELMAN="$PORT_API_DIFFIEHELMAN"
    export PORT_API_ECC="$PORT_API_ECC"
    export PORT_API_HASH="$PORT_API_HASH"

    # Gerar arquivo de config em execucao
    (
        echo
        echo PORT_API_RSA="$PORT_API_RSA"
        echo PORT_API_WIREGUARD="$PORT_API_WIREGUARD"
        echo PORT_API_UUID="$PORT_API_UUID"
        echo PORT_API_LVM2UUID="$PORT_API_LVM2UUID"
        echo PORT_API_DIFFIEHELMAN="$PORT_API_DIFFIEHELMAN"
        echo PORT_API_ECC="$PORT_API_ECC"
        echo PORT_API_HASH="$PORT_API_HASH"
        echo
    ) > /run/env.conf

    # Logar variaveis detectadas no boot
    _log "env PORT_API_RSA=$PORT_API_RSA"
    _log "env PORT_API_WIREGUARD=$PORT_API_WIREGUARD"
    _log "env PORT_API_UUID=$PORT_API_UUID"
    _log "env PORT_API_LVM2UUID=$PORT_API_LVM2UUID"
    _log "env PORT_API_DIFFIEHELMAN=$PORT_API_DIFFIEHELMAN"
    _log "env PORT_API_ECC=$PORT_API_ECC"
    _log "env PORT_API_HASH=$PORT_API_HASH"


#========================================================================================================

    # Executar scripts de entrypoint
    _log "Start bootscripts"
    _init_bootscripts

    # Rodar CMD
    if [ "x$EXEC_CMD" = "x" ]; then
        _log "Start default CMD: [sleep 252288000]"
        exec "sleep" "252288000"
        stdno="$?"
    else
        FULLCMD="exec $EXEC_CMD"
        _log "Start CMD: [$EXEC_CMD] [$FULLCMD]"
        eval $FULLCMD
        stdno="$?"
    fi
    _log "Entrypoint end, stdno=$stdno"


exit $stdno

