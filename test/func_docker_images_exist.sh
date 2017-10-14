#!/bin/bash
. ../library.sh

NAME=alpine:latest
func_docker_image_exist $NAME
echo $?

NAME=alpine:latestno
func_docker_image_exist $NAME
echo $?
