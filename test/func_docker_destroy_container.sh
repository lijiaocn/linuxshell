#!/bin/bash
. ../library.sh

NAME="linuxshell-test"
func_docker_destroy_container  $NAME
docker run -idt --name $NAME alpine:latest /bin/sleep 30
func_docker_destroy_container  $NAME
