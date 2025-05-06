
## Prompt para gerar a API RSA (porta 9001)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar chave RSA

A porta http padrão deve ser 9001, a variavel de ambiente que informa
a porta personalizada é PORT_API_RSA

Funcao especifica da API RSA:
	Nome da funcao: api_rsa()
 	Gerar chave privada e chave publica
	path: /cryptools/rsa e /rsa
	metodos HTTP: GET ou POST
	content-type de retorno: application/json

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"keysize": 0,
		"privkey": "",
		"privkey_pem": "",
		"pubkey": "",
		"pubkey_pem": "",
		"modulus": "",
		"public_exponent": "",
		"public_exponent_int": 0,
		"private_exponent": "",
		"prime1": "",
		"prime2": "",
		"exponent1": "",
		"exponent2": "",
		"coefficient": "",
		"fingerprint_md5": "",
		"fingerprint_sha256": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O endpoint deve receber o parametro keysize na requisicao da URL ou no corpo.

	O valor de keysize deve ser retornado no valor "keysize" do JSON, tipo inteiro.
	Os valores válidos para keysize sao: 1024, 2048, 3072, 4096, 7680, 8192, 16384.
	Caso nenhum valor valido seja informado, keysize deve assumir por padrão o valor 4096

	Os valores "privkey_pem" e "pubkey_pem" devem ser as chaves
	representadas em base64 no formato PEM de forma
	que possam ser salvas pelo usuário final em arquivos com a finalidade
	de gerar CSR para solicitação de certificados.

	O valor "public_exponent_int" deve ser o valor em decimal inteiro de "public_exponent"

	Os demais valores devem conter o valor hexadecimal continuo de cada
	parte da chave privada.

	Calcule o hash MD5 da chave publica no formato DER e coloque em formato ascii hexadecimal
	na chave "fingerprint_md5" do json de saida.

	Calcule o hash SHA256 da chave publica no formato DER e coloque em formato ascii hexadecimal
	na chave "fingerprint_sha256" do json de saida.

```

## Prompt para construir testador

Apos produzir o codigo funcional, solicite:

```
Crie um codigo em shell-script para testar o funcionamento da API RSA

Os testes serão numerados e testados sequencialmente, os testes são:

1 - testar se as endpoints /ping e / esta funcionando corretamente com retorno http 200

2 - solicitar uma chave RSA 1024 e salvar o json no arquivo /tmp/test-1024.json

3 - extraia do arquivo /tmp/test-1024.json o valor privkey_pem e salve no arquivo /tmp/key-1024.pem

4 - usando o comando openssl, verifique se a chave privada RSA no arquivo /tmp/key-1024.pem
	está sintaticamente correta

Faça os testes acima na sequencia, se algum teste falhar interrompa o script e informe
o numero do teste que falhou, o script deve produzir codigo de erro (STDNO) no mesmo numero
do teste que falhou.

Se todos os testes funcionarem, informe a mensagem "API FUNCIONA" e retorne sem erro

```

