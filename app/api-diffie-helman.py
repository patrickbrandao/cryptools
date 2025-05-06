#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import time
import json
from flask import Flask, request, jsonify
from cryptography.hazmat.primitives.asymmetric import dh as crypto_dh
from cryptography.hazmat.primitives.serialization import Encoding as crypto_encoding
from cryptography.hazmat.primitives.serialization import ParameterFormat as crypto_format
import binascii

# Configuração do aplicativo Flask
app = Flask(__name__)

# Obtenção da porta da variável de ambiente ou usa o valor padrão
PORT = int(os.environ.get('PORT_API_DIFFIEHELMAN', 9021))

# Título da API para uso na mensagem de boas-vindas
API_TITLE = "Diffie-Hellman Parameters Generation API"

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home():
    """
    Endpoint para verificar se a API está funcionando.
    
    Métodos: GET, POST
    Content-type de retorno: application/json
    
    Retorno:
        dict: Dicionário com status da API, timestamp e mensagem
    """
    response = {
        "status": "online",
        "timestamp": int(time.time()),
        "message": API_TITLE
    }
    return jsonify(response)

@app.route('/cryptools/ping', methods=['GET'])
@app.route('/ping', methods=['GET'])
def api_ping():
    """
    Endpoint para teste de conectividade simples.
    
    Métodos: GET
    Content-type de retorno: text/plain
    
    Retorno:
        str: Texto simples 'pong'
    """
    return "pong", 200, {"Content-Type": "text/plain"}

@app.route('/cryptools/diffiehelman', methods=['GET', 'POST'])
@app.route('/diffiehelman', methods=['GET', 'POST'])
@app.route('/cryptools/dh', methods=['GET', 'POST'])
@app.route('/dh', methods=['GET', 'POST'])
def api_diffiehelman():
    """
    Endpoint para gerar parâmetros Diffie-Hellman para uso em criptografia.
    
    Métodos: GET, POST
    Parâmetros:
        keysize (int): Tamanho da chave DH em bits
    Content-type de retorno: application/json
    
    Retorno:
        dict: Dicionário com os parâmetros DH gerados nos formatos solicitados
    """
    # Obter o parâmetro keysize da requisição GET ou POST
    if request.method == 'GET':
        keysize = request.args.get('keysize', default=2048, type=int)
    else:  # POST
        keysize = request.json.get('keysize', 2048) if request.is_json else request.form.get('keysize', default=2048, type=int)
    
    # Validar keysize para valores aceitáveis (mínimo 512, máximo 8192)
    keysize = min(max(512, keysize), 8192)
    
    # Timestamp da geração
    timestamp = int(time.time())
    
    try:
        # Gerar parâmetros Diffie-Hellman
        parameters = crypto_dh.generate_parameters(generator=2, key_size=keysize)
        
        # Serializar parâmetros para formato PEM
        dh_pem = parameters.parameter_bytes(
            encoding=crypto_encoding.PEM,
            format=crypto_format.PKCS3
        ).decode('utf-8')
        
        # Obter os valores numéricos para p (prime) e g (generator)
        p = parameters.parameter_numbers().p
        g = parameters.parameter_numbers().g
        
        # Converter para hexadecimal
        ph = format(p, 'x')
        gh = format(g, 'x')
        
        # Preparar resposta
        response = {
            "timestamp": timestamp,
            "dh_pem": dh_pem,
            "dh": dh_pem,  # Mantém a mesma informação que dh_pem por compatibilidade
            "pi": p,
            "ph": ph,
            "gi": g,
            "gh": gh,
            "keysize": keysize
        }
        
        return jsonify(response)
    
    except Exception as e:
        # Em caso de erro, retornar uma mensagem de erro
        error_response = {
            "timestamp": timestamp,
            "error": str(e),
            "keysize": keysize
        }
        return jsonify(error_response), 500

if __name__ == '__main__':
    # Iniciar o servidor Flask
    print(f"Iniciando API Diffie-Hellman na porta {PORT}")
    app.run(host='0.0.0.0', port=PORT, threaded=True)
