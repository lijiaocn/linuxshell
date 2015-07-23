#!/bin/bash

. ../library.sh

func_git_check_tag  https://github.com/coreos/etcd.git  release-0.4  0.4.1 etcd
echo $?
