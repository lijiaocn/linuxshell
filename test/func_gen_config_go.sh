#!/bin/bash
. ../library.sh
func_gen_config_go /tmp/test.conf  echo -e "Usage:\n--param1=ddd: this is prefix\n--param2[=false]: default set is false\n--param3=dd"
