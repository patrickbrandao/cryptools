
## Prompt para gerar a API Diffie-Helman (porta 9021)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar numeração Diffie-Helman

A porta http padrão deve ser 9021, a variavel de ambiente que informa
a porta personalizada é PORT_API_DIFFIEHELMAN

Funcao especifica da API DIFFIEHELMAN:
	Nome da funcao: api_diffiehelman()
	path: /cryptools/diffiehelman, /diffiehelman, /cryptools/dh, /dh
	metodo HTTP: GET ou POST
	content-type de retorno: application/json

 	Gerar numero diffie-helman para uso em criptografia compativel com OpenSSL

 	A requisição deve receber via GET ou POST o parametro "keysize" com o tamanho da
 	chave DH.

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"dh_pem": "",
		"dh": "",
		"pi": "",
		"ph": "",
		"gi": "",
		"gh": "",
		"keysize": 0
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "dh" deve ser a chave DH gerada.
	O valor de "dh_pem" deve ser a representação PEM para uso no OpenSSL (base64, "BEGIN DH PARAMETERS" a "END DH PARAMETERS")
	O valor de "pi" deve ser o número DH (Prime) em formato inteiro.
	O valor de "ph" deve ser o número DH (Prime) em formato hexadecimal ascii (2 dígitos por byte, minúsculo).

	O valor de "gi" deve ser o número generator (G) em formato inteiro.
	O valor de "gh" deve ser o número generator (G) em formato hexadecimal ascii (2 dígitos por byte, minúsculo).

	O valor de "keysize" deve conter o numero de bits do tamanho da chave.

```

## Prompt para construir testador

Nao fiz ainda

```
# Falta fazer
```

