
## Prompt para gerar a API WIREGUARD (porta 9002)

```

Crie um codigo para prover uma API HTTP com uma endpoint para gerar chaves WIREGUARD (VPN Wireguard)

A porta http padrão deve ser 9002, a variavel de ambiente que informa
a porta personalizada é PORT_API_WIREGUARD

Funcao especifica da API WIREGUARD:
	Nome da funcao: api_wireguard()
	path: /cryptools/wireguard e /wireguard
	metodo HTTP: GET
	content-type de retorno: application/json

 	Gerar chave privada, chave publica e chave compartilhada para o Wireguard

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"privkey": "",
		"pubkey": "",
		"psk": "",
		"fingerprint_md5": "",
		"fingerprint_sha256": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "privkey" deve ser obtido pelo comando: wg genkey

	O valor de "pubkey" deve ser obtido enviando a chave privada de "privkey" via STDIN para o comando: wg pubkey

	O valor de "psk" deve ser obtido pelo comando: wg genpsk

	Calcule o hash MD5 da chave publica do valor "pubkey" e coloque em formato ascii hexadecimal
	no valor "fingerprint_md5" do json de saida.

	Calcule o hash SHA256 da chave publica do valor "pubkey" e coloque em formato ascii hexadecimal
	no valor "fingerprint_sha256" do json de saida.


Funcao especifica da API WIREGUARD PSK:
	Nome da funcao: api_wireguard_psk()
	path: /cryptools/wireguard/psk e /wireguard/psk
	metodo HTTP: GET
	content-type de retorno: application/json

 	Gerar chave compartilhada PSK para o Wireguard

	Resposta JSON no formado:
	{
		"timestamp": 0,
		"psk": ""
	}

	O valor "timestamp" deve conter o unix timestamp UTC do momento de geração da chave.

	O valor de "psk" deve ser obtido pelo comando: wg genpsk

```

## Prompt para construir testador

Nao fiz ainda, requer criacao de interface wireguard para
validar a chave privada pois nao ha codigo de alto nivel para isso por enquanto

```
# Falta fazer
```



