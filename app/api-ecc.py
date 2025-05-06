#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
API para geração de chaves criptográficas usando curvas elípticas.
"""

import os
import time
import json
import binascii
from flask import Flask, request, jsonify, make_response

# Importações para criptografia
from cryptography.hazmat.primitives.asymmetric import ec as crypto_ec
from cryptography.hazmat.primitives.asymmetric import ed25519 as crypto_ed25519
from cryptography.hazmat.primitives import serialization as crypto_serialization

# Configuração do aplicativo Flask
app = Flask(__name__)

# Obtém a porta da variável de ambiente ou usa o padrão 9022
PORT = int(os.environ.get('PORT_API_ECC', 9022))

# Mapeamento de tipos de curvas para suas respectivas classes e tamanhos
ECC_TYPES = {
    'secp256k1': (crypto_ec.SECP256K1, 256),
    'prime256v1': (crypto_ec.SECP256R1, 256),  # SECP256R1 é o mesmo que prime256v1
    'secp384r1': (crypto_ec.SECP384R1, 384),
    'secp521r1': (crypto_ec.SECP521R1, 521),
    'ed25519': (None, 255)  # Tratamento especial para Ed25519
}

@app.route('/', methods=['GET', 'POST'])
@app.route('/home', methods=['GET', 'POST'])
def api_home():
    """
    Endpoint para verificar se a API está funcionando.
    
    Returns:
        JSON: Status da API com timestamp atual.
    """
    response = {
        "status": "online",
        "timestamp": int(time.time()),
        "message": "Elliptic Curve Cryptography Key Generator API"
    }
    return jsonify(response)

@app.route('/ping', methods=['GET'])
@app.route('/cryptools/ping', methods=['GET'])
def api_ping():
    """
    Endpoint para responder a um ping.
    
    Returns:
        str: Resposta "pong" em texto plano.
    """
    response = make_response("pong")
    response.headers['Content-Type'] = 'text/plain'
    return response

@app.route('/ecc', methods=['GET', 'POST'])
@app.route('/cryptools/ecc', methods=['GET', 'POST'])
def api_ecc():
    """
    Endpoint para gerar chaves de curvas elípticas.
    
    Parameters:
        type (str): Tipo de curva elíptica (via GET ou POST).
                    Valores aceitos: secp256k1, prime256v1, secp384r1, secp521r1, ed25519.
    
    Returns:
        JSON: Informações das chaves geradas incluindo chaves privada e pública em formatos
              hexadecimal e PEM.
    """
    # Verifica o método da requisição e obtém o parâmetro 'type'
    if request.method == 'POST':
        curve_type = request.form.get('type')
    else:  # GET
        curve_type = request.args.get('type')
    
    # Valida o tipo de curva
    if curve_type not in ECC_TYPES:
        return jsonify({"error": "Invalid curve type"}), 400
    
    # Timestamp da geração
    timestamp = int(time.time())
    
    # Obter o tipo de curva e tamanho da chave
    curve_class, key_size = ECC_TYPES[curve_type]
    
    # Gerar chaves baseado no tipo de curva
    if curve_type == 'ed25519':
        # Gerar chave Ed25519
        private_key = crypto_ed25519.Ed25519PrivateKey.generate()
        public_key = private_key.public_key()
        
        # Serializar a chave privada em formato hexadecimal
        private_bytes = private_key.private_bytes(
            encoding=crypto_serialization.Encoding.Raw,
            format=crypto_serialization.PrivateFormat.Raw,
            encryption_algorithm=crypto_serialization.NoEncryption()
        )
        private_hex = binascii.hexlify(private_bytes).decode('ascii')
        
        # Serializar a chave pública em formato hexadecimal
        public_bytes = public_key.public_bytes(
            encoding=crypto_serialization.Encoding.Raw,
            format=crypto_serialization.PublicFormat.Raw
        )
        public_hex = binascii.hexlify(public_bytes).decode('ascii')
        
        # Serializar a chave privada em formato PEM
        private_pem = private_key.private_bytes(
            encoding=crypto_serialization.Encoding.PEM,
            format=crypto_serialization.PrivateFormat.PKCS8,
            encryption_algorithm=crypto_serialization.NoEncryption()
        ).decode('utf-8')
        
        # Serializar a chave pública em formato PEM
        public_pem = public_key.public_bytes(
            encoding=crypto_serialization.Encoding.PEM,
            format=crypto_serialization.PublicFormat.SubjectPublicKeyInfo
        ).decode('utf-8')
    else:
        # Gerar chave para curvas NIST/SEC
        private_key = crypto_ec.generate_private_key(curve_class())
        public_key = private_key.public_key()
        
        # Serializar a chave privada em formato hexadecimal
        private_bytes = private_key.private_numbers().private_value.to_bytes(
            (key_size + 7) // 8, byteorder='big'
        )
        private_hex = binascii.hexlify(private_bytes).decode('ascii')
        
        # Obter pontos da chave pública (curvas elípticas são pontos x,y)
        public_numbers = public_key.public_numbers()
        x_bytes = public_numbers.x.to_bytes((key_size + 7) // 8, byteorder='big')
        y_bytes = public_numbers.y.to_bytes((key_size + 7) // 8, byteorder='big')
        
        # Formato não comprimido para chave pública: 04 + x + y
        public_bytes = b'\x04' + x_bytes + y_bytes
        public_hex = binascii.hexlify(public_bytes).decode('ascii')
        
        # Serializar a chave privada em formato PEM
        private_pem = private_key.private_bytes(
            encoding=crypto_serialization.Encoding.PEM,
            format=crypto_serialization.PrivateFormat.PKCS8,
            encryption_algorithm=crypto_serialization.NoEncryption()
        ).decode('utf-8')
        
        # Serializar a chave pública em formato PEM
        public_pem = public_key.public_bytes(
            encoding=crypto_serialization.Encoding.PEM,
            format=crypto_serialization.PublicFormat.SubjectPublicKeyInfo
        ).decode('utf-8')
    
    # Montar a resposta
    response = {
        "timestamp": timestamp,
        "type": curve_type,
        "keysize": key_size,
        "privkey": private_hex,
        "privkey_pem": private_pem,
        "pubkey": public_hex,
        "pubkey_pem": public_pem
    }
    
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT, threaded=True)
