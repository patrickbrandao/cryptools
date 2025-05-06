#!/bin/bash
# Script para testes da API LVM2 UUID

# Variáveis
API_URL="http://localhost:9012"

echo "Testando endpoint de status..."
# Teste da endpoint de status com GET
curl -s -X GET "${API_URL}/" | jq .
# Teste da endpoint de status com POST
curl -s -X POST "${API_URL}/home" | jq .

echo -e "\nTestando endpoint de ping..."
# Teste da endpoint de ping
curl -s -X GET "${API_URL}/ping"
echo "" # Nova linha após o resultado
curl -s -X GET "${API_URL}/cryptools/ping"
echo "" # Nova linha após o resultado

echo -e "\nTestando geração de único UUID LVM2..."
# Teste de geração de UUID via GET
curl -s -X GET "${API_URL}/lvm2/uuid" | jq .
# Teste de geração de UUID via POST
curl -s -X POST "${API_URL}/cryptools/lvm2/uuid" | jq .

echo -e "\nTestando geração de lista de UUIDs LVM2 (count=3)..."
# Teste de geração de lista de UUIDs via GET
curl -s -X GET "${API_URL}/lvm2/uuid/list?count=3" | jq .
# Teste de geração de lista de UUIDs via POST
curl -s -X POST "${API_URL}/cryptools/lvm2/uuid/list" \
  -H "Content-Type: application/json" \
  -d '{"count": 3}' | jq .

echo -e "\nTestando com valor inválido para count..."
# Teste com valor inválido para count
curl -s -X GET "${API_URL}/lvm2/uuid/list?count=abc" | jq .
# Teste com valor negativo para count
curl -s -X POST "${API_URL}/cryptools/lvm2/uuid/list" \
  -H "Content-Type: application/json" \
  -d '{"count": -5}' | jq .

echo -e "\nVerificação de formato do UUID LVM2..."
# Verificar se o formato está correto usando regex
UUID=$(curl -s -X GET "${API_URL}/lvm2/uuid" | jq -r .uuid)
echo "UUID gerado: $UUID"

# Verificar formato usando expressão regular
if [[ $UUID =~ ^[A-Za-z0-9]{6}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{6}$ ]]; then
    echo "✓ Formato do UUID está correto"
else
    echo "✗ Formato do UUID está incorreto"
fi
