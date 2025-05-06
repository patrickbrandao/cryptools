#!/bin/bash
# -*- coding: utf-8 -*-

# Script para testar o funcionamento da API RSA
# Testes:
# 1 - Testar endpoints /ping e / (código 200)
# 2 - Solicitar chave RSA 1024 e salvar em /tmp/test-1024.json
# 3 - Extrair privkey_pem para /tmp/key-1024.pem
# 4 - Verificar sintaxe da chave com OpenSSL

# URL base da API
API_URL="http://localhost:9001"

# Cores para formatação de saída
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Iniciando testes da API RSA${NC}"

# Teste 1: Verificar se as endpoints /ping e / estão funcionando
echo -e "${YELLOW}Teste 1: Verificando endpoints /ping e / (HTTP 200)${NC}"

# Testar endpoint /ping
PING_STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${API_URL}/ping)
if [ "$PING_STATUS" -ne 200 ]; then
    echo -e "${RED}Falha no Teste 1: Endpoint /ping retornou código HTTP $PING_STATUS${NC}"
    exit 1
fi

# Testar endpoint /
HOME_STATUS=$(curl -s -o /dev/null -w "%{http_code}" ${API_URL}/)
if [ "$HOME_STATUS" -ne 200 ]; then
    echo -e "${RED}Falha no Teste 1: Endpoint / retornou código HTTP $HOME_STATUS${NC}"
    exit 1
fi

echo -e "${GREEN}Teste 1: Concluído com sucesso${NC}"

# Teste 2: Solicitar chave RSA 1024 e salvar em arquivo
echo -e "${YELLOW}Teste 2: Solicitando chave RSA 1024 e salvando em /tmp/test-1024.json${NC}"

# Verificar se o arquivo já existe e remover se necessário
if [ -f "/tmp/test-1024.json" ]; then
    rm -f /tmp/test-1024.json
fi

# Executar a solicitação e salvar o resultado
HTTP_CODE=$(curl -s -o /tmp/test-1024.json -w "%{http_code}" "${API_URL}/rsa?keysize=1024")

# Verificar o código de status HTTP
if [ "$HTTP_CODE" -ne 200 ]; then
    echo -e "${RED}Falha no Teste 2: API retornou código HTTP $HTTP_CODE${NC}"
    exit 2
fi

# Verificar se o arquivo foi criado
if [ ! -f "/tmp/test-1024.json" ]; then
    echo -e "${RED}Falha no Teste 2: Arquivo /tmp/test-1024.json não foi criado${NC}"
    exit 2
fi

# Verificar se o arquivo contém dados válidos
if [ ! -s "/tmp/test-1024.json" ]; then
    echo -e "${RED}Falha no Teste 2: Arquivo /tmp/test-1024.json está vazio${NC}"
    exit 2
fi

# Verificar se o JSON é válido e contém o keysize correto
KEYSIZE=$(grep -o '"keysize":1024' /tmp/test-1024.json)
if [ -z "$KEYSIZE" ]; then
    echo -e "${RED}Falha no Teste 2: Arquivo não contém keysize=1024${NC}"
    exit 2
fi

echo -e "${GREEN}Teste 2: Concluído com sucesso${NC}"

# Teste 3: Extrair privkey_pem para /tmp/key-1024.pem
echo -e "${YELLOW}Teste 3: Extraindo privkey_pem para /tmp/key-1024.pem${NC}"

# Verificar se o arquivo já existe e remover se necessário
if [ -f "/tmp/key-1024.pem" ]; then
    rm -f /tmp/key-1024.pem
fi

# Extrair o campo privkey_pem e salvar no arquivo
# Usando jq para extrair o valor do campo (instalação: apk add jq)
if command -v jq &> /dev/null; then
    jq -r '.privkey_pem' /tmp/test-1024.json > /tmp/key-1024.pem
else
    # Fallback usando grep e sed se jq não estiver disponível
    grep -o '"privkey_pem":"[^"]*"' /tmp/test-1024.json | \
    sed 's/"privkey_pem":"//;s/"$//' | \
    sed 's/\\n/\n/g' > /tmp/key-1024.pem
fi

# Verificar se o arquivo foi criado
if [ ! -f "/tmp/key-1024.pem" ]; then
    echo -e "${RED}Falha no Teste 3: Arquivo /tmp/key-1024.pem não foi criado${NC}"
    exit 3
fi

# Verificar se o arquivo contém dados válidos
if [ ! -s "/tmp/key-1024.pem" ]; then
    echo -e "${RED}Falha no Teste 3: Arquivo /tmp/key-1024.pem está vazio${NC}"
    exit 3
fi

# Verificar se o arquivo contém "BEGIN PRIVATE KEY"
if ! grep -q "BEGIN PRIVATE KEY" /tmp/key-1024.pem; then
    echo -e "${RED}Falha no Teste 3: Arquivo não parece ser uma chave privada${NC}"
    exit 3
fi

echo -e "${GREEN}Teste 3: Concluído com sucesso${NC}"

# Teste 4: Verificar sintaxe da chave com OpenSSL
echo -e "${YELLOW}Teste 4: Verificando sintaxe da chave com OpenSSL${NC}"

# Verificar se o OpenSSL está instalado
if ! command -v openssl &> /dev/null; then
    echo -e "${RED}Falha no Teste 4: OpenSSL não está instalado${NC}"
    exit 4
fi

# Verificar a chave privada
OPENSSL_RESULT=$(openssl rsa -in /tmp/key-1024.pem -check -noout 2>&1)
OPENSSL_EXIT_CODE=$?

if [ $OPENSSL_EXIT_CODE -ne 0 ]; then
    echo -e "${RED}Falha no Teste 4: OpenSSL relatou erro na chave:${NC}"
    echo "$OPENSSL_RESULT"
    exit 4
fi

# Verificar se a saída contém "RSA key ok"
if ! echo "$OPENSSL_RESULT" | grep -q "RSA key ok"; then
    echo -e "${RED}Falha no Teste 4: OpenSSL não confirmou que a chave está OK${NC}"
    exit 4
fi

echo -e "${GREEN}Teste 4: Concluído com sucesso${NC}"

# Todos os testes foram bem-sucedidos
echo -e "${GREEN}===============================${NC}"
echo -e "${GREEN}TODOS OS TESTES PASSARAM${NC}"
echo -e "${GREEN}API FUNCIONA${NC}"
echo -e "${GREEN}===============================${NC}"

exit 0
