
## Prompt para gerar a API HASH (porta 9031)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar hash do conteudo enviado via POST

A porta http padrão deve ser 9031, a variavel de ambiente que informa
a porta personalizada é PORT_API_HASH

Implementação da API:

	Essa API deve gerar hash do conteudo enviado no corpo da requisicao.
	Todos os bytes do corpo da requisicao enviados via HTTP no metodo POST
	devem passar pela funcão de hash sem nenhum tipo de pre-processamento
	e sem nenhum tipo de importacao.

Lista de endpoints que devem ser suportados:

- para hash md5: /cryptools/hash/md5 e /hash/md5
- para hash sha1: /cryptools/hash/sha1 e /hash/sha1
- para hash MD5-SHA1: /cryptools/hash/md5-sha1 e /hash/md5-sha1
- para hash sha256: /cryptools/hash/sha256 e /hash/sha256
- para hash sha384: /cryptools/hash/sha384 e /hash/sha384
- para hash sha512: /cryptools/hash/sha512 e /hash/sha512
- para hash sha512/224: /cryptools/hash/sha512-224 e /hash/sha512-224
- para hash sha512/256: /cryptools/hash/sha512-256 e /hash/sha512-256
- para hash SHA-512/224: /cryptools/hash/sha512-224 e /hash/sha512-224
- para hash SHA-512/256: /cryptools/hash/sha512-256 e /hash/sha512-256
- para hash SHA3-224: /cryptools/hash/sha3-224 e /hash/sha3-224
- para hash SHA3-256: /cryptools/hash/sha3-256 e /hash/sha3-256
- para hash SHA3-384: /cryptools/hash/sha3-384 e /hash/sha3-384
- para hash SHA3-512: /cryptools/hash/sha3-512 e /hash/sha3-512
- para hash SHAKE128: /cryptools/hash/shake128 e /hash/shake128
- para hash SHAKE256: /cryptools/hash/shake256 e /hash/shake256
- para gerar todos os hashs acima: /cryptools/hash/all e /hash/all


Metodos HTTP: apenas POST
Content-type de retorno: application/json

Resposta JSON no formado:
	{
		"timestamp": 0,
		"type": "",
		"size": 0,
		"HASHNAME": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "type" deve ser o tipo de hash solicitado (parte final do path http, em minusculo)

	O valor de "size" deve ser a quantidade de bytes do corpo da requisição HTTP

	A chave JSON "HASHNAME" deve ser substituida pelo tipo de hash do valor de "type", o valor
	dessa chave JSON deve ser o respectivo hash calculado.

	Exemplo de retorno para chamadas em /cryptools/hash/md5 ou /hash/md5 enviando a palavra "tulipa" no corpo
	da requisição:
	{
		"timestamp": 1746469090,
		"type": "md5",
		"size": 6,
		"md5": "52169089a52705298a67f2f8d9895c76"
	}


	Caso seja solicitado o path /cryptools/hash/all ou /hash/all todos os tipos de hash devem
	ser acionados para preencher seus respectivos valores no JSON de retorno

```

## Prompt para construir testador

Apos produzir o codigo funcional, solicite:

```
Crie um codigo em shell-script para testar o funcionamento da API ECC

Os testes serão numerados e testados sequencialmente, os testes são:

1 - testar se as endpoints /ping e / esta funcionando corretamente com retorno http 200

2 - solicitar uma chave de cada tipo e salvar em um arquivo JSON localmente

3 - obtenha uma chave de cada tipo e salve localmente, extraia a chave privada e teste no openssl
	se ela está sintaticamente correta e pronto para uso.

Faça os testes acima na sequencia, se algum teste falhar interrompa o script e informe
o numero do teste que falhou, o script deve produzir codigo de erro (STDNO) no mesmo numero
do teste que falhou.

Se todos os testes funcionarem, informe a mensagem "API FUNCIONA" e retorne sem erro

```


## Problemas

A IA nao gerou codigo satisfatorio para:
- para hash BLAKE2b: /cryptools/hash/blake2b e /hash/blake2b
- para hash BLAKE2b256: /cryptools/hash/blake2b256 e /hash/blake2b256
- para hash BLAKE2b512: /cryptools/hash/blake2b512 e /hash/blake2b512
- para hash BLAKE2s: /cryptools/hash/blake2s e /hash/blake2s



