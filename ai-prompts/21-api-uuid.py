
## Prompt para gerar a API UUID (porta 9011)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar UUID v4 baseado no gerador do kernel Linux

A porta http padrão deve ser 9011, a variavel de ambiente que informa
a porta personalizada é PORT_API_UUID

Funcao especifica da API UUID:
	Nome da funcao: api_kernel_uuid()
	path: /cryptools/uuid e /uuid
	metodo HTTP: GET ou POST
	content-type de retorno: application/json

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"uuid": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "uuid" deve ser obtido lendo o arquivo: /proc/sys/kernel/random/uuid		


Endpoint para gerar lista de UUID:
	Nome da funcao: api_kernel_uuid_list()
	path: /cryptools/uuid/list e /uuid/list
	metodo HTTP: GET ou POST
	content-type de retorno: application/json

	O parâmetro "count" deve ser enviado via HTTP usando GET (na URL) ou POST (no corpo da requisição)
	e deve informar a quantidade de registros a retornar.
	Se o usuário não informar a quantidade defina o "count" em 1

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"count": 0,
		"list": []
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "list" deve ser uma lista de UUID gerados apartir da leitura do arquivo: /proc/sys/kernel/random/uuid		

	O valor de "count" deve ser o número de registros presentes na lista em "list"

```

