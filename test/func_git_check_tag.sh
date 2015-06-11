#!/bin/bash

. ../library.sh

func_git_check_tag  v0.4.0 Xflannel https://github.com/coreos/flannel.git
echo $?
