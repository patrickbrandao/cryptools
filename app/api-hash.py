#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import time
import hashlib
import json
from flask import Flask, request, jsonify, Response
from typing import Dict, Any, Union

# Obtendo a porta da API a partir da variável de ambiente
PORT = int(os.environ.get('PORT_API_HASH', 9031))

# Inicializando o Flask
app = Flask(__name__)

def get_timestamp() -> int:
    """
    Obtém o timestamp atual em UTC.
    
    Returns:
        int: Timestamp Unix atual
    """
    return int(time.time())

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home() -> Response:
    """
    Endpoint para verificar se a API está funcionando.
    
    Returns:
        Response: JSON com status, timestamp e mensagem
    """
    response_data = {
        "status": "online",
        "timestamp": get_timestamp(),
        "message": "Hash Generation API"
    }
    return jsonify(response_data)

@app.route('/cryptools/ping', methods=['GET'])
@app.route('/ping', methods=['GET'])
def api_ping() -> Response:
    """
    Endpoint para verificar se a API está funcionando com um ping simples.
    
    Returns:
        Response: Texto simples 'pong'
    """
    return Response("pong", content_type="text/plain")

def calculate_md5(data: bytes) -> str:
    """
    Calcula o hash MD5 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash MD5 em formato hexadecimal
    """
    return hashlib.md5(data).hexdigest()

def calculate_sha1(data: bytes) -> str:
    """
    Calcula o hash SHA1 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA1 em formato hexadecimal
    """
    return hashlib.sha1(data).hexdigest()

def calculate_md5_sha1(data: bytes) -> str:
    """
    Calcula o hash combinado MD5-SHA1 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash MD5-SHA1 em formato hexadecimal
    """
    md5_hash = hashlib.md5(data).digest()
    return hashlib.sha1(md5_hash).hexdigest()

def calculate_sha256(data: bytes) -> str:
    """
    Calcula o hash SHA256 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA256 em formato hexadecimal
    """
    return hashlib.sha256(data).hexdigest()

def calculate_sha384(data: bytes) -> str:
    """
    Calcula o hash SHA384 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA384 em formato hexadecimal
    """
    return hashlib.sha384(data).hexdigest()

def calculate_sha512(data: bytes) -> str:
    """
    Calcula o hash SHA512 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA512 em formato hexadecimal
    """
    return hashlib.sha512(data).hexdigest()

def calculate_sha512_224(data: bytes) -> str:
    """
    Calcula o hash SHA512/224 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA512/224 em formato hexadecimal
    """
    return hashlib.new('sha512_224', data).hexdigest()

def calculate_sha512_256(data: bytes) -> str:
    """
    Calcula o hash SHA512/256 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA512/256 em formato hexadecimal
    """
    return hashlib.new('sha512_256', data).hexdigest()

def calculate_sha3_224(data: bytes) -> str:
    """
    Calcula o hash SHA3-224 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA3-224 em formato hexadecimal
    """
    return hashlib.sha3_224(data).hexdigest()

def calculate_sha3_256(data: bytes) -> str:
    """
    Calcula o hash SHA3-256 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA3-256 em formato hexadecimal
    """
    return hashlib.sha3_256(data).hexdigest()

def calculate_sha3_384(data: bytes) -> str:
    """
    Calcula o hash SHA3-384 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA3-384 em formato hexadecimal
    """
    return hashlib.sha3_384(data).hexdigest()

def calculate_sha3_512(data: bytes) -> str:
    """
    Calcula o hash SHA3-512 dos dados fornecidos.
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHA3-512 em formato hexadecimal
    """
    return hashlib.sha3_512(data).hexdigest()

def calculate_shake128(data: bytes) -> str:
    """
    Calcula o hash SHAKE128 dos dados fornecidos.
    Usando um comprimento de saída de 32 bytes (256 bits).
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHAKE128 em formato hexadecimal
    """
    shake = hashlib.shake_128(data)
    return shake.hexdigest(32)  # 32 bytes = 256 bits

def calculate_shake256(data: bytes) -> str:
    """
    Calcula o hash SHAKE256 dos dados fornecidos.
    Usando um comprimento de saída de 64 bytes (512 bits).
    
    Args:
        data (bytes): Dados para calcular o hash
        
    Returns:
        str: Hash SHAKE256 em formato hexadecimal
    """
    shake = hashlib.shake_256(data)
    return shake.hexdigest(64)  # 64 bytes = 512 bits

def create_hash_response(hash_type: str, data: bytes) -> Dict[str, Any]:
    """
    Cria a resposta JSON para um hash específico.
    
    Args:
        hash_type (str): Tipo de hash a ser calculado
        data (bytes): Dados para calcular o hash
        
    Returns:
        Dict[str, Any]: Dicionário com a resposta formatada
    """
    current_time = get_timestamp()
    data_size = len(data)
    
    response = {
        "timestamp": current_time,
        "type": hash_type,
        "size": data_size
    }
    
    if hash_type == "md5":
        response["md5"] = calculate_md5(data)
    elif hash_type == "sha1":
        response["sha1"] = calculate_sha1(data)
    elif hash_type == "md5-sha1":
        response["md5-sha1"] = calculate_md5_sha1(data)
    elif hash_type == "sha256":
        response["sha256"] = calculate_sha256(data)
    elif hash_type == "sha384":
        response["sha384"] = calculate_sha384(data)
    elif hash_type == "sha512":
        response["sha512"] = calculate_sha512(data)
    elif hash_type == "sha512-224":
        response["sha512-224"] = calculate_sha512_224(data)
    elif hash_type == "sha512-256":
        response["sha512-256"] = calculate_sha512_256(data)
    elif hash_type == "sha3-224":
        response["sha3-224"] = calculate_sha3_224(data)
    elif hash_type == "sha3-256":
        response["sha3-256"] = calculate_sha3_256(data)
    elif hash_type == "sha3-384":
        response["sha3-384"] = calculate_sha3_384(data)
    elif hash_type == "sha3-512":
        response["sha3-512"] = calculate_sha3_512(data)
    elif hash_type == "shake128":
        response["shake128"] = calculate_shake128(data)
    elif hash_type == "shake256":
        response["shake256"] = calculate_shake256(data)
    elif hash_type == "all":
        response["md5"] = calculate_md5(data)
        response["sha1"] = calculate_sha1(data)
        response["md5-sha1"] = calculate_md5_sha1(data)
        response["sha256"] = calculate_sha256(data)
        response["sha384"] = calculate_sha384(data)
        response["sha512"] = calculate_sha512(data)
        response["sha512-224"] = calculate_sha512_224(data)
        response["sha512-256"] = calculate_sha512_256(data)
        response["sha3-224"] = calculate_sha3_224(data)
        response["sha3-256"] = calculate_sha3_256(data)
        response["sha3-384"] = calculate_sha3_384(data)
        response["sha3-512"] = calculate_sha3_512(data)
        response["shake128"] = calculate_shake128(data)
        response["shake256"] = calculate_shake256(data)
    
    return response

# Criando as rotas para cada tipo de hash
@app.route('/cryptools/hash/md5', methods=['POST'])
@app.route('/hash/md5', methods=['POST'])
def hash_md5() -> Response:
    """
    Endpoint para calcular o hash MD5 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("md5", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha1', methods=['POST'])
@app.route('/hash/sha1', methods=['POST'])
def hash_sha1() -> Response:
    """
    Endpoint para calcular o hash SHA1 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha1", data)
    return jsonify(response)

@app.route('/cryptools/hash/md5-sha1', methods=['POST'])
@app.route('/hash/md5-sha1', methods=['POST'])
def hash_md5_sha1() -> Response:
    """
    Endpoint para calcular o hash MD5-SHA1 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("md5-sha1", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha256', methods=['POST'])
@app.route('/hash/sha256', methods=['POST'])
def hash_sha256() -> Response:
    """
    Endpoint para calcular o hash SHA256 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha256", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha384', methods=['POST'])
@app.route('/hash/sha384', methods=['POST'])
def hash_sha384() -> Response:
    """
    Endpoint para calcular o hash SHA384 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha384", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha512', methods=['POST'])
@app.route('/hash/sha512', methods=['POST'])
def hash_sha512() -> Response:
    """
    Endpoint para calcular o hash SHA512 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha512", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha512-224', methods=['POST'])
@app.route('/hash/sha512-224', methods=['POST'])
def hash_sha512_224() -> Response:
    """
    Endpoint para calcular o hash SHA512/224 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha512-224", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha512-256', methods=['POST'])
@app.route('/hash/sha512-256', methods=['POST'])
def hash_sha512_256() -> Response:
    """
    Endpoint para calcular o hash SHA512/256 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha512-256", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha3-224', methods=['POST'])
@app.route('/hash/sha3-224', methods=['POST'])
def hash_sha3_224() -> Response:
    """
    Endpoint para calcular o hash SHA3-224 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha3-224", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha3-256', methods=['POST'])
@app.route('/hash/sha3-256', methods=['POST'])
def hash_sha3_256() -> Response:
    """
    Endpoint para calcular o hash SHA3-256 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha3-256", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha3-384', methods=['POST'])
@app.route('/hash/sha3-384', methods=['POST'])
def hash_sha3_384() -> Response:
    """
    Endpoint para calcular o hash SHA3-384 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha3-384", data)
    return jsonify(response)

@app.route('/cryptools/hash/sha3-512', methods=['POST'])
@app.route('/hash/sha3-512', methods=['POST'])
def hash_sha3_512() -> Response:
    """
    Endpoint para calcular o hash SHA3-512 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("sha3-512", data)
    return jsonify(response)

@app.route('/cryptools/hash/shake128', methods=['POST'])
@app.route('/hash/shake128', methods=['POST'])
def hash_shake128() -> Response:
    """
    Endpoint para calcular o hash SHAKE128 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("shake128", data)
    return jsonify(response)

@app.route('/cryptools/hash/shake256', methods=['POST'])
@app.route('/hash/shake256', methods=['POST'])
def hash_shake256() -> Response:
    """
    Endpoint para calcular o hash SHAKE256 dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado do hash
    """
    data = request.get_data()
    response = create_hash_response("shake256", data)
    return jsonify(response)

@app.route('/cryptools/hash/all', methods=['POST'])
@app.route('/hash/all', methods=['POST'])
def hash_all() -> Response:
    """
    Endpoint para calcular todos os tipos de hash dos dados recebidos.
    
    Returns:
        Response: JSON com o resultado de todos os hashes
    """
    data = request.get_data()
    response = create_hash_response("all", data)
    return jsonify(response)

if __name__ == '__main__':
    # Inicializando o servidor Flask
    app.run(host='0.0.0.0', port=PORT, threaded=True)
