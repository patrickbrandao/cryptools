
## Prompt para gerar a API LVM2 ID (porta 9012)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar IDs de volumes LVM2

A porta http padrão deve ser 9012, a variavel de ambiente que informa
a porta personalizada é PORT_API_LVM2UUID

Funcao especifica da API LVM2 UUID:
	Nome da funcao: api_lvm2_uuid()
	path: /cryptools/lvm2/uuid e /lvm2/uuid
	metodo HTTP: GET ou POST
	content-type de retorno: application/json

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"uuid": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "uuid" deve ser obtido usando a seguinte lógica:
	O LVM2 utiliza identificadores no formato 6-4-4-4-4-4-6 (cada numero é a quantidade de bytes no grupo)
	Cada caracter utiliza bytes no conjunto: A-Z a-z 0-9
	Exemplo de identificador LVM2: Tvqncy-7hr8-S0Fs-x2tZ-pqzP-hPhn-isLcxG


Endpoint para gerar lista de identificadores LVM2:
	Nome da funcao: api_lvm2_uuid_list()
	path: /cryptools/lvm2/uuid/list e /lvm2/uuid/list
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

	O valor de "list" deve ser uma lista de identificadores LVM2 gerados como a mesma lógica
	da endpoint anterior.

	O valor de "count" deve ser o número de registros presentes na lista em "list"

```

