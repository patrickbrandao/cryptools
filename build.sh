#!/bin/sh

find . | grep DS_Store | while read x; do rm $x; done
docker build . -t cryptools

exit 0

