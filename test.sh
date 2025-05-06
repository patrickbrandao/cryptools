#!/bin/sh

# Testar endpoints

	# Funcao ansi color
	_echo_success(){ /bin/echo -en "\\033[71G"; /bin/echo -en "\033[42m"; /bin/echo -en "\x1B\033[1;38m   OK   \033[0m"; /bin/echo -e "\x1B[97m\033[0m"; }
	_echo_failure(){ /bin/echo -en "\\033[71G"; /bin/echo -en "\033[41m\e[5m"; /bin/echo -en "\033[1;38m\x1B  FAILED \033[0m"; /bin/echo -e "\x1B[97m\033[0m"; }
	_echo_warning(){ /bin/echo -en "\\033[71G"; /bin/echo -en "\033[40m\e[5m"; /bin/echo -en "\033[1;33m\x1B   WARN \033[0m"; /bin/echo -e "\x1B[97m\033[0m"; }

	_echo_lighred(){ /bin/echo -e "\x1B[91m$@\033[0m"; }
	_echo_lighgreen(){ /bin/echo -e "\x1B[92m$@\033[0m"; }
	_echo_lighyellow(){ /bin/echo -e "\x1B[93m$@\033[0m"; }
	_echo_lighpink(){ /bin/echo -e "\x1B[95m$@\033[0m"; }
	_echo_lighcyan(){ /bin/echo -e "\x1B[96m$@\033[0m"; }
	_echo_lighwhite(){ /bin/echo -e "\x1B[97m$@\033[0m"; }

	_echo_lighred_n(){ /bin/echo -ne "\x1B[91m$@\033[0m"; }
	_echo_lighgreen_n(){ /bin/echo -ne "\x1B[92m$@\033[0m"; }
	_echo_lighyellow_n(){ /bin/echo -ne "\x1B[93m$@\033[0m"; }
	_echo_lighcyan_n(){ /bin/echo -ne "\x1B[96m$@\033[0m"; }
	_echo_lighpink_n(){ /bin/echo -ne "\x1B[95m$@\033[0m"; }
	_echo_lighwhite_n(){ /bin/echo -ne "\x1B[97m$@\033[0m"; }

	# Funcao para obter o json
	_curl_json(){
		cj_name="$1";
		cj_url="$2";
		cj_file="$3";
		_echo_lighwhite_n "- Testando "; _echo_lighcyan_n "$cj_name";
		curl -qs "$cj_url" -o "$cj_file" 2>/dev/null 1>/dev/null; cj_stdno="$?";
		if [ "$cj_stdno" = "0" ]; then
			fb=$(cut -b1 "$cj_file")
			if [ "$fb" = "{" ]; then
				_echo_success;
			else
				_echo_warning;
			fi
		else
			_echo_failure;
		fi;
		return "$cj_stdno";
	}
	_curl_json_post(){
		cj_name="$1";
		cj_url="$2";
		cj_word="$3";
		cj_file="$4";
		_echo_lighwhite_n "- Testando "; _echo_lighcyan_n "$cj_name";
		curl -qs "$cj_url" -X POST -d "$cj_word" -o "$cj_file" 2>/dev/null 1>/dev/null; cj_stdno="$?";
		if [ "$cj_stdno" = "0" ]; then
			fb=$(cut -b1 "$cj_file")
			if [ "$fb" = "{" ]; then
				_echo_success;
			else
				_echo_warning;
			fi
		else
			_echo_failure;
		fi;
		return "$cj_stdno";
	}

	# testes RSA
	_curl_json "RSA-1024"         "http://10.111.217.101/rsa?keysize=1024" "/tmp/test-rsa-1024.json";
	_curl_json "RSA-2048"         "http://10.111.217.101/rsa?keysize=2048" "/tmp/test-rsa-2048.json";
	_curl_json "RSA-3072"         "http://10.111.217.101/rsa?keysize=3072" "/tmp/test-rsa-3072.json";
	_curl_json "RSA-4096"         "http://10.111.217.101/rsa?keysize=4096" "/tmp/test-rsa-4096.json";

	# testes Wireguard
	_curl_json "Wireguard"        "http://10.111.217.101/wireguard" "/tmp/test-wireguard.json";

	# testes UUID
	_curl_json "UUIDv4-Unique"    "http://10.111.217.101/uuid"               "/tmp/test-uuid.json";
	_curl_json "UUIDv4-List"      "http://10.111.217.101/uuid/list?count=16" "/tmp/test-uuid-list.json";

	# testes LVM2-UUID
	_curl_json "LVM2-Unique"      "http://10.111.217.101/lvm2/uuid"               "/tmp/test-lvm2-uniq.json";
	_curl_json "LVM2-List"        "http://10.111.217.101/lvm2/uuid/list?count=16" "/tmp/test-lvm2-list.json";

	# teste DIFFIE-HELMAN
	_curl_json "DH-0128"          "http://10.111.217.101/diffiehelman?keysize=128"   "/tmp/test-dh-0128.json";
	_curl_json "DH-0256"          "http://10.111.217.101/diffiehelman?keysize=256"   "/tmp/test-dh-0256.json";
	_curl_json "DH-0512"          "http://10.111.217.101/diffiehelman?keysize=512"   "/tmp/test-dh-0512.json";
	_curl_json "DH-1024"          "http://10.111.217.101/diffiehelman?keysize=1024"  "/tmp/test-dh-1024.json";

	# teste ECC
	_curl_json "ECC-secp256k1"    "http://10.111.217.101/ecc?type=secp256k1"   "/tmp/test-ecc-secp256k1.json";
	_curl_json "ECC-prime256v1"   "http://10.111.217.101/ecc?type=prime256v1"  "/tmp/test-ecc-prime256v1.json";
	_curl_json "ECC-secp384r1"    "http://10.111.217.101/ecc?type=secp384r1"   "/tmp/test-ecc-secp384r1.json";
	_curl_json "ECC-secp521r1"    "http://10.111.217.101/ecc?type=secp521r1"   "/tmp/test-ecc-secp521r1.json";
	_curl_json "ECC-ed25519"      "http://10.111.217.101/ecc?type=ed25519"     "/tmp/test-ecc-ed25519.json";


	# teste HASH
	_curl_json_post "Hash-ALL"         "http://10.111.217.101/hash/all"         "tulipa"   "/tmp/test-hash-all.json";
	_curl_json_post "Hash-md5"         "http://10.111.217.101/hash/md5"         "tulipa"   "/tmp/test-hash-md5.json";
	_curl_json_post "Hash-sha1"        "http://10.111.217.101/hash/sha1"        "tulipa"   "/tmp/test-hash-sha1.json";
	_curl_json_post "Hash-md5-sha1"    "http://10.111.217.101/hash/md5-sha1"    "tulipa"   "/tmp/test-hash-md5-sha1.json";
	_curl_json_post "Hash-sha256"      "http://10.111.217.101/hash/sha256"      "tulipa"   "/tmp/test-hash-sha256.json";
	_curl_json_post "Hash-sha384"      "http://10.111.217.101/hash/sha384"      "tulipa"   "/tmp/test-hash-sha384.json";
	_curl_json_post "Hash-sha512"      "http://10.111.217.101/hash/sha512"      "tulipa"   "/tmp/test-hash-sha512.json";
	_curl_json_post "Hash-sha512-224"  "http://10.111.217.101/hash/sha512-224"  "tulipa"   "/tmp/test-hash-sha512-224.json";
	_curl_json_post "Hash-sha512-256"  "http://10.111.217.101/hash/sha512-256"  "tulipa"   "/tmp/test-hash-sha512-256.json";
	_curl_json_post "Hash-sha3-224"    "http://10.111.217.101/hash/sha3-224"    "tulipa"   "/tmp/test-hash-sha3-224.json";
	_curl_json_post "Hash-sha3-256"    "http://10.111.217.101/hash/sha3-256"    "tulipa"   "/tmp/test-hash-sha3-256.json";
	_curl_json_post "Hash-sha3-384"    "http://10.111.217.101/hash/sha3-384"    "tulipa"   "/tmp/test-hash-sha3-384.json";
	_curl_json_post "Hash-sha3-512"    "http://10.111.217.101/hash/sha3-512"    "tulipa"   "/tmp/test-hash-sha3-512.json";
	_curl_json_post "Hash-shake128"    "http://10.111.217.101/hash/shake128"    "tulipa"   "/tmp/test-hash-shake128.json";
	_curl_json_post "Hash-shake256"    "http://10.111.217.101/hash/shake256"    "tulipa"   "/tmp/test-hash-shake256.json";

exit 0


