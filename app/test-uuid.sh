# Teste endpoint /home (GET)
curl -X GET http://localhost:9011/home

# Teste endpoint /home (POST)
curl -X POST http://localhost:9011/home

# Teste endpoint /ping
curl -X GET http://localhost:9011/ping

# Teste endpoint /cryptools/ping
curl -X GET http://localhost:9011/cryptools/ping

# Teste endpoint /uuid
curl -X GET http://localhost:9011/uuid

# Teste endpoint /cryptools/uuid
curl -X GET http://localhost:9011/cryptools/uuid

# Teste endpoint /uuid/list sem parâmetro count (padrão: 1)
curl -X GET http://localhost:9011/uuid/list

# Teste endpoint /uuid/list com parâmetro count via GET
curl -X GET "http://localhost:9011/uuid/list?count=5"

# Teste endpoint /cryptools/uuid/list com parâmetro count via GET
curl -X GET "http://localhost:9011/cryptools/uuid/list?count=3"

# Teste endpoint /uuid/list com parâmetro count via POST
curl -X POST http://localhost:9011/uuid/list \
  -H "Content-Type: application/json" \
  -d '{"count": 10}'

# Teste endpoint /cryptools/uuid/list com parâmetro count via POST
curl -X POST http://localhost:9011/cryptools/uuid/list \
  -H "Content-Type: application/json" \
  -d '{"count": 7}'

# Verificar se /home retorna status "online"
curl -s http://localhost:9011/home | grep -q '"status":"online"' && echo "Teste /home: OK" || echo "Teste /home: FALHA"

# Verificar se /ping retorna "pong"
curl -s http://localhost:9011/ping | grep -q "pong" && echo "Teste /ping: OK" || echo "Teste /ping: FALHA"

# Verificar se /uuid retorna um UUID válido (formato padrão UUID)
curl -s http://localhost:9011/uuid | grep -q -E '"uuid":"[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"' && echo "Teste /uuid: OK" || echo "Teste /uuid: FALHA"

# Verificar se /uuid/list retorna a quantidade correta de UUIDs
COUNT=5
RESULT=$(curl -s "http://localhost:9011/uuid/list?count=$COUNT")
RETURNED_COUNT=$(echo $RESULT | jq -r '.count')
if [ "$RETURNED_COUNT" -eq "$COUNT" ]; then
    echo "Teste /uuid/list (quantidade): OK"
else
    echo "Teste /uuid/list (quantidade): FALHA - Esperado: $COUNT, Recebido: $RETURNED_COUNT"
fi

# Verificar se todos os UUIDs na lista têm formato válido
curl -s "http://localhost:9011/uuid/list?count=3" | jq -r '.list[]' | grep -q -v -E '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$' || echo "Todos os UUIDs têm formato válido"


