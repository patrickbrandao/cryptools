#!/bin/bash
# api-ecc-test.sh
# Script para testar o funcionamento da API ECC

# Define a URL base da API
API_URL="http://localhost:9022"
TEMP_DIR="./ecc_test_files"

# Cores para formatação da saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para exibir mensagens formatadas
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_test() {
    echo -e "${YELLOW}[TEST $1]${NC} $2"
}

# Função para finalizar o script com erro
fail_test() {
    TEST_NUM=$1
    ERROR_MSG=$2
    log_error "$ERROR_MSG"
    log_error "Teste $TEST_NUM falhou"
    exit $TEST_NUM
}

# Cria diretório temporário para arquivos de teste
mkdir -p $TEMP_DIR

# ===== TESTE 1: Verificar endpoints básicas =====
log_test 1 "Testando endpoints básicas (/ e /ping)"

# Testando a endpoint /
log_info "Testando endpoint /"
HTTP_CODE=$(curl -s -o "$TEMP_DIR/home_response.json" -w "%{http_code}" "$API_URL/")
if [ $HTTP_CODE -ne 200 ]; then
    fail_test 1 "Endpoint / retornou código HTTP $HTTP_CODE, esperado 200"
fi

# Verificando se a resposta contém a estrutura esperada
if ! jq -e '.status == "online"' "$TEMP_DIR/home_response.json" > /dev/null; then
    fail_test 1 "Endpoint / não retornou status 'online'"
fi

# Testando a endpoint /ping
log_info "Testando endpoint /ping"
PING_RESPONSE=$(curl -s "$API_URL/ping")
HTTP_CODE=$?
if [ $HTTP_CODE -ne 0 ]; then
    fail_test 1 "Falha ao conectar com a endpoint /ping"
fi

if [ "$PING_RESPONSE" != "pong" ]; then
    fail_test 1 "Endpoint /ping não retornou 'pong', recebeu: $PING_RESPONSE"
fi

log_success "Teste 1 completado com sucesso"

# ===== TESTE 2: Solicitar chaves de cada tipo e salvar em JSON =====
log_test 2 "Solicitando chaves de cada tipo e salvando em arquivos JSON"

# Lista de tipos de curvas a serem testadas
CURVE_TYPES=("secp256k1" "prime256v1" "secp384r1" "secp521r1" "ed25519")

for curve in "${CURVE_TYPES[@]}"; do
    log_info "Solicitando chave do tipo $curve"
    HTTP_CODE=$(curl -s -o "$TEMP_DIR/${curve}_key.json" -w "%{http_code}" "$API_URL/ecc?type=$curve")
    
    if [ $HTTP_CODE -ne 200 ]; then
        fail_test 2 "Falha ao solicitar chave $curve, código HTTP: $HTTP_CODE"
    fi
    
    # Verificar se o arquivo JSON contém campos obrigatórios
    if ! jq -e '.timestamp and .type and .keysize and .privkey and .privkey_pem and .pubkey and .pubkey_pem' "$TEMP_DIR/${curve}_key.json" > /dev/null; then
        fail_test 2 "Resposta para $curve não contém todos os campos obrigatórios"
    fi
    
    log_success "Chave $curve obtida e validada com sucesso"
done

log_success "Teste 2 completado com sucesso"

# ===== TESTE 3: Verificar chaves com OpenSSL =====
log_test 3 "Extraindo chaves privadas e validando com OpenSSL"

# Verificar se o OpenSSL está instalado
if ! command -v openssl &> /dev/null; then
    log_error "OpenSSL não está instalado. Impossível continuar com o Teste 3."
    log_info "Execute 'apk add openssl' para instalar o OpenSSL e tente novamente."
    exit 3
fi

for curve in "${CURVE_TYPES[@]}"; do
    log_info "Validando chave privada $curve com OpenSSL"
    
    # Extrair a chave privada PEM do JSON
    jq -r '.privkey_pem' "$TEMP_DIR/${curve}_key.json" > "$TEMP_DIR/${curve}_private.pem"
    
    # Verificar a validade da chave com OpenSSL
    if [ "$curve" = "ed25519" ]; then
        # Para Ed25519, usamos o comando específico de chave privada
        OPENSSL_OUTPUT=$(openssl pkey -in "$TEMP_DIR/${curve}_private.pem" -noout -text 2>&1)
    else
        # Para curvas EC padrão
        OPENSSL_OUTPUT=$(openssl ec -in "$TEMP_DIR/${curve}_private.pem" -noout -text 2>&1)
    fi
    
    OPENSSL_EXIT_CODE=$?
    
    if [ $OPENSSL_EXIT_CODE -ne 0 ]; then
        fail_test 3 "OpenSSL não conseguiu ler a chave privada $curve: $OPENSSL_OUTPUT"
    fi
    
    log_success "Chave privada $curve validada com OpenSSL"
    
    # Verificar também se as permissões da chave estão seguras
    chmod 600 "$TEMP_DIR/${curve}_private.pem"
done

log_success "Teste 3 completado com sucesso"

# ===== FIM DOS TESTES =====
echo ""
log_success "TODOS OS TESTES COMPLETADOS COM SUCESSO"
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}         API FUNCIONA          ${NC}"
echo -e "${GREEN}================================${NC}"

# Perguntar se deseja limpar os arquivos de teste
read -p "Deseja remover os arquivos de teste? (s/n): " CLEAN_FILES
rm -rf $TEMP_DIR
log_info "Arquivos de teste removidos"

exit 0

