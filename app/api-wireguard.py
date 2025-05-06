#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
API para geração de chaves WireGuard
"""

import os
import time
import subprocess
import hashlib
import json
from flask import Flask, jsonify, request

# Cria instância da aplicação Flask
app = Flask(__name__)

# Obtém a porta da API da variável de ambiente ou usa o valor padrão
PORT = int(os.environ.get('PORT_API_WIREGUARD', 9002))

def execute_command(command, input_data=None):
    """
    Executa um comando no sistema operacional e retorna a saída.
    
    Args:
        command (list): Lista com o comando e seus argumentos
        input_data (bytes, optional): Dados a serem enviados para o stdin do comando
        
    Returns:
        str: Saída do comando, com espaços em branco removidos
    """
    process = subprocess.Popen(
        command,
        stdin=subprocess.PIPE if input_data else None,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    stdout, stderr = process.communicate(input=input_data)
    
    if process.returncode != 0:
        error_message = stderr.decode('utf-8').strip()
        raise Exception(f"Erro ao executar comando {command}: {error_message}")
    
    return stdout.decode('utf-8').strip()

def calculate_hash(data, algorithm='md5'):
    """
    Calcula o hash de uma string.
    
    Args:
        data (str): String a ser hashada
        algorithm (str): Algoritmo de hash a ser utilizado (md5 ou sha256)
        
    Returns:
        str: String hexadecimal representando o hash
    """
    if algorithm.lower() == 'md5':
        hash_obj = hashlib.md5()
    elif algorithm.lower() == 'sha256':
        hash_obj = hashlib.sha256()
    else:
        raise ValueError("Algoritmo não suportado. Use 'md5' ou 'sha256'.")
    
    hash_obj.update(data.encode('utf-8'))
    return hash_obj.hexdigest()

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home():
    """
    Endpoint para verificar se a API está funcionando.
    
    Returns:
        Response: JSON com status da API
    """
    response = {
        "status": "online",
        "timestamp": int(time.time()),
        "message": "WireGuard Key Generation API"
    }
    return jsonify(response)

@app.route('/ping', methods=['GET'])
@app.route('/cryptools/ping', methods=['GET'])
def api_ping():
    """
    Endpoint para verificar se a API está respondendo.
    
    Returns:
        str: Texto "pong"
    """
    return "pong", 200, {'Content-Type': 'text/plain'}

@app.route('/wireguard', methods=['GET'])
@app.route('/cryptools/wireguard', methods=['GET'])
def api_wireguard():
    """
    Endpoint para gerar chaves WireGuard.
    Gera chave privada, chave pública e chave compartilhada (PSK).
    
    Returns:
        Response: JSON com as chaves geradas e fingerprints
    """
    current_timestamp = int(time.time())
    
    # Gerar chave privada
    privkey = execute_command(['wg', 'genkey'])
    
    # Gerar chave pública a partir da chave privada
    pubkey = execute_command(['wg', 'pubkey'], privkey.encode('utf-8'))
    
    # Gerar chave compartilhada (PSK)
    psk = execute_command(['wg', 'genpsk'])
    
    # Calcular fingerprints
    fingerprint_md5 = calculate_hash(pubkey, 'md5')
    fingerprint_sha256 = calculate_hash(pubkey, 'sha256')
    
    response = {
        "timestamp": current_timestamp,
        "privkey": privkey,
        "pubkey": pubkey,
        "psk": psk,
        "fingerprint_md5": fingerprint_md5,
        "fingerprint_sha256": fingerprint_sha256
    }
    
    return jsonify(response)

@app.route('/wireguard/psk', methods=['GET'])
@app.route('/cryptools/wireguard/psk', methods=['GET'])
def api_wireguard_psk():
    """
    Endpoint para gerar apenas a chave compartilhada PSK do WireGuard.
    
    Returns:
        Response: JSON com a chave PSK gerada
    """
    current_timestamp = int(time.time())
    
    # Gerar chave compartilhada (PSK)
    psk = execute_command(['wg', 'genpsk'])
    
    response = {
        "timestamp": current_timestamp,
        "psk": psk
    }
    
    return jsonify(response)

if __name__ == '__main__':
    print(f"Iniciando API WireGuard na porta {PORT}")
    app.run(host='0.0.0.0', port=PORT, threaded=True)

