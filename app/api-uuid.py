#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import time
import json
from flask import Flask, jsonify, request

# Criação da aplicação Flask
app = Flask(__name__)

# Obtenção da porta da variável de ambiente
PORT = int(os.environ.get('PORT_API_UUID', 9011))

def read_kernel_uuid():
    """
    Lê um UUID v4 do arquivo do kernel Linux.
    
    Returns:
        str: UUID v4 gerado pelo kernel Linux
    """
    try:
        with open('/proc/sys/kernel/random/uuid', 'r') as f:
            return f.read().strip()
    except Exception as e:
        app.logger.error(f"Erro ao ler UUID do kernel: {str(e)}")
        return None

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home():
    """
    Endpoint para verificar se a API está funcionando.
    
    Returns:
        JSON: Status da API com timestamp atual
    """
    response = {
        "status": "online",
        "timestamp": int(time.time()),
        "message": "Linux Kernel UUID Generator API"
    }
    return jsonify(response), 200

@app.route('/ping', methods=['GET'])
@app.route('/cryptools/ping', methods=['GET'])
def api_ping():
    """
    Endpoint para responder a um ping.
    
    Returns:
        str: A palavra "pong"
    """
    return "pong", 200, {'Content-Type': 'text/plain'}

@app.route('/uuid', methods=['GET'])
@app.route('/cryptools/uuid', methods=['GET'])
def api_kernel_uuid():
    """
    Endpoint para gerar um UUID v4 único baseado no gerador do kernel Linux.
    
    Returns:
        JSON: Objeto contendo o timestamp da geração e o UUID gerado
    """
    uuid = read_kernel_uuid()
    if uuid is None:
        return jsonify({"error": "Não foi possível gerar UUID"}), 500
    
    response = {
        "timestamp": int(time.time()),
        "uuid": uuid
    }
    return jsonify(response), 200

@app.route('/uuid/list', methods=['GET', 'POST'])
@app.route('/cryptools/uuid/list', methods=['GET', 'POST'])
def api_kernel_uuid_list():
    """
    Endpoint para gerar uma lista de UUIDs v4 baseados no gerador do kernel Linux.
    
    Parâmetros:
        count (int): Quantidade de UUIDs a serem gerados (via GET ou POST)
                    Se não informado, o valor padrão é 1
    
    Returns:
        JSON: Objeto contendo o timestamp da geração, a quantidade de UUIDs gerados
              e a lista de UUIDs
    """
    # Determina o método de requisição e obtém o parâmetro 'count'
    if request.method == 'POST':
        count = request.json.get('count', 1) if request.is_json else 1
    else:  # GET
        count = request.args.get('count', 1, type=int)
    
    # Garante que o count é um inteiro positivo
    try:
        count = int(count)
        if count < 1:
            count = 1
    except (ValueError, TypeError):
        count = 1
    
    # Gera a lista de UUIDs
    uuid_list = []
    for _ in range(count):
        uuid = read_kernel_uuid()
        if uuid is not None:
            uuid_list.append(uuid)
    
    response = {
        "timestamp": int(time.time()),
        "count": len(uuid_list),
        "list": uuid_list
    }
    return jsonify(response), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT, threaded=True)
