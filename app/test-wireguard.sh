#!/bin/sh

curl 'http://localhost:9002/wireguard' -o /tmp/wg01.json; echo; cat /tmp/wg01.json | jq

curl 'http://localhost:9002/wireguard/psk' -o /tmp/wg-psk-01.json; echo; cat /tmp/wg-psk-01.json | jq

echo

