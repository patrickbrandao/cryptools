#!/bin/sh

IMAGE=cryptools

# Remover containers
	DLIST=$(docker ps -a | grep "$IMAGE" | awk '{print $1}')
	for did in $DLIST; do docker rm -f $did; done 2>/dev/null

# Remover imagem
	(
		docker stop $IMAGE
		docker rm $IMAGE
		docker rmi $IMAGE
	) 2>/dev/null


