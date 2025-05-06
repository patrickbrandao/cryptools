#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import time
import json
import hashlib
import binascii
from flask import Flask, request, jsonify
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes

# Inicialização do Flask
app = Flask(__name__)

# Obtenção da porta da variável de ambiente ou usar 9001 como padrão
PORT = int(os.environ.get('PORT_API_RSA', 9001))

@app.route('/cryptools/rsa', methods=['GET', 'POST'])
@app.route('/rsa', methods=['GET', 'POST'])
def api_rsa():
    """
    Função para gerar par de chaves RSA
    
    Esta endpoint gera um par de chaves RSA (privada e pública) com o tamanho especificado
    e retorna ambas as chaves junto com seus componentes em formato hexadecimal
    
    Métodos:
        GET, POST
        
    Parâmetros:
        keysize (int): Tamanho da chave em bits. Valores válidos: 1024, 2048, 3072, 4096, 7680, 8192, 16384
                      Valor padrão: 4096
                      
    Retorna:
        JSON com chaves privada e pública em formato PEM e hexadecimal, junto com componentes da chave
    """
    # Obter o tamanho da chave do parâmetro na URL ou no corpo da requisição
    keysize = request.args.get('keysize', 
                               request.form.get('keysize', '4096'))
    
    try:
        keysize = int(keysize)
    except ValueError:
        keysize = 4096
    
    # Validar o tamanho da chave
    valid_keysizes = [1024, 2048, 3072, 4096, 7680, 8192, 16384]
    if keysize not in valid_keysizes:
        keysize = 4096
    
    # Gerar o timestamp UTC
    timestamp = int(time.time())
    
    # Gerar a chave privada RSA
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=keysize
    )
    
    # Extrair a chave pública
    public_key = private_key.public_key()
    
    # Serializar chave privada em formato PEM
    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )
    
    # Serializar chave pública em formato PEM
    public_pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    
    # Serializar chave pública em formato DER para calcular fingerprints
    public_der = public_key.public_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )
    
    # Calcular fingerprints
    fingerprint_md5 = hashlib.md5(public_der).hexdigest()
    fingerprint_sha256 = hashlib.sha256(public_der).hexdigest()
    
    # Extrair os números da chave privada
    private_numbers = private_key.private_numbers()
    public_numbers = private_numbers.public_numbers
    
    # Preparar o resultado
    result = {
        "timestamp": timestamp,
        "keysize": keysize,
        "privkey": binascii.hexlify(private_pem).decode('ascii'),
        "privkey_pem": private_pem.decode('ascii'),
        "pubkey": binascii.hexlify(public_pem).decode('ascii'),
        "pubkey_pem": public_pem.decode('ascii'),
        "modulus": format(public_numbers.n, 'x'),
        "public_exponent": format(public_numbers.e, 'x'),
        "public_exponent_int": public_numbers.e,
        "private_exponent": format(private_numbers.d, 'x'),
        "prime1": format(private_numbers.p, 'x'),
        "prime2": format(private_numbers.q, 'x'),
        "exponent1": format(private_numbers.dmp1, 'x'),
        "exponent2": format(private_numbers.dmq1, 'x'),
        "coefficient": format(private_numbers.iqmp, 'x'),
        "fingerprint_md5": fingerprint_md5,
        "fingerprint_sha256": fingerprint_sha256
    }
    
    return jsonify(result)

# Rota padrão para verificar se a API está funcionando
@app.route('/', methods=['GET'])
def home():
    """
    Função para verificar se a API está funcionando
    
    Retorna:
        JSON com status da API
    """
    return jsonify({
        "status": "online",
        "timestamp": int(time.time()),
        "message": "Cryptools API is working properly"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT, threaded=True)
