#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
API para geração de identificadores LVM2 UUID
"""

import os
import time
import random
import string
import json
from flask import Flask, jsonify, request

# Criação da aplicação Flask
app = Flask(__name__)

def generate_lvm2_uuid():
    """
    Gera um identificador UUID no formato LVM2.
    
    O LVM2 utiliza identificadores no formato 6-4-4-4-4-4-6 (cada número é a quantidade 
    de caracteres em cada grupo).
    Cada caractere utiliza bytes no conjunto: A-Z a-z 0-9.
    
    Returns:
        str: Identificador LVM2 no formato Tvqncy-7hr8-S0Fs-x2tZ-pqzP-hPhn-isLcxG
    """
    # Conjunto de caracteres válidos para LVM2 UUID
    chars = string.ascii_letters + string.digits
    
    # Definição dos tamanhos dos grupos
    group_sizes = [6, 4, 4, 4, 4, 4, 6]
    
    # Gera cada grupo de caracteres aleatórios
    groups = []
    for size in group_sizes:
        group = ''.join(random.choice(chars) for _ in range(size))
        groups.append(group)
    
    # Junta os grupos com hífen
    return '-'.join(groups)

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home():
    """
    Endpoint para verificar se a API está funcionando.
    
    Métodos HTTP:
        GET, POST
    
    Returns:
        JSON: Status da API com timestamp atual
    """
    response = {
        "status": "online",
        "timestamp": int(time.time()),
        "message": "LVM2 UUID Generator API"
    }
    return jsonify(response), 200

@app.route('/cryptools/ping', methods=['GET'])
@app.route('/ping', methods=['GET'])
def api_ping():
    """
    Endpoint para gerar PING.
    
    Métodos HTTP:
        GET
    
    Returns:
        text/plain: Resposta "pong"
    """
    return "pong", 200, {'Content-Type': 'text/plain'}

@app.route('/cryptools/lvm2/uuid', methods=['GET', 'POST'])
@app.route('/lvm2/uuid', methods=['GET', 'POST'])
def api_lvm2_uuid():
    """
    Endpoint para gerar identificadores LVM2 UUID.
    
    Métodos HTTP:
        GET, POST
    
    Returns:
        JSON: Timestamp e UUID gerado
    """
    current_timestamp = int(time.time())
    uuid = generate_lvm2_uuid()
    
    response = {
        "timestamp": current_timestamp,
        "uuid": uuid
    }
    
    return jsonify(response), 200

@app.route('/cryptools/lvm2/uuid/list', methods=['GET', 'POST'])
@app.route('/lvm2/uuid/list', methods=['GET', 'POST'])
def api_lvm2_uuid_list():
    """
    Endpoint para gerar lista de identificadores LVM2 UUID.
    
    Parâmetros:
        count (int): Quantidade de identificadores a serem gerados. 
                     Pode ser enviado via GET ou POST. Padrão: 1.
    
    Métodos HTTP:
        GET, POST
    
    Returns:
        JSON: Timestamp, contagem e lista de UUIDs gerados
    """
    # Obter o parâmetro count da requisição (GET ou POST)
    if request.method == 'GET':
        count = request.args.get('count', 1, type=int)
    else:  # POST
        data = request.get_json(silent=True) or {}
        count = data.get('count', 1)
    
    # Garantir que count seja um inteiro e tenha um valor mínimo de 1
    try:
        count = int(count)
        if count < 1:
            count = 1
    except (ValueError, TypeError):
        count = 1
    
    current_timestamp = int(time.time())
    uuid_list = [generate_lvm2_uuid() for _ in range(count)]
    
    response = {
        "timestamp": current_timestamp,
        "count": len(uuid_list),
        "list": uuid_list
    }
    
    return jsonify(response), 200

if __name__ == '__main__':
    # Configuração da porta HTTP
    # Utiliza a variável de ambiente PORT_API_LVM2UUID ou o valor padrão 9012
    port = int(os.environ.get('PORT_API_LVM2UUID', 9012))
    
    # Inicialização do servidor Flask
    app.run(host='0.0.0.0', port=port, threaded=True)
