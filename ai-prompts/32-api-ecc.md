
## Prompt para gerar a API ECC (porta 9022)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar chaves de curvas elipticas

A porta http padrão deve ser 9022, a variavel de ambiente que informa
a porta personalizada é PORT_API_ECC

Funcao especifica da API RSA:
	Nome da funcao: api_ecc()
 	Gerar chave privada e chave publica
	path: /cryptools/ecc e /ecc
	metodos HTTP: GET ou POST
	content-type de retorno: application/json

	Essa API deve gerar uma chave privada usando curvas elípticas de acordo com o tipo
	solicitado.

	O parametro "type" deve ser enviado na requisicão via GET ou POST

	O "type" pode ser: secp256k1, prime256v1, secp384r1, secp521r1 ou ed25519

	Na ausencia do parametro "type" ou valor que não conste na lista, encerre com erro http 400 (bad request)

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"type": "",
		"keysize": 0,
		"privkey": "",
		"privkey_pem": "",
		"pubkey": "",
		"pubkey_pem": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "keysize" deve obtido de acordo com o tipo e retornado em decimal (inteiro).

	O valor "privkey" deve ser preenchido com a chave privada em formato ascii hexadecimal.
	O valor "privkey_pem" deve ser preenchido com a chave privada em formato PEM para uso no OpenSSL.

	O valor "pubkey" deve ser preenchido com a chave publica em formato ascii hexadecimal.
	O valor "pubkey_pem" deve ser preenchido com a chave publica em formato PEM para uso no OpenSSL.

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


