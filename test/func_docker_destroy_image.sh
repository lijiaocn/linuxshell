#!/bin/bash

. ../library.sh

NAME=alpinex:latest

docker tag alpine:latest $NAME 
docker images $NAME

func_docker_destroy_image abc
func_docker_destroy_image $NAME
