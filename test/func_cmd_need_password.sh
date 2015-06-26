#!/bin/bash
. ../library.sh

machines="root@192.168.202.240  root@192.168.202.241 root@192.168.202.242"
PASSWORD=""
func_secret_input PASSWORD "PASSWORD:"

echo aaaa>1.txt

for i in $machines
do
	cmd="scp 1.txt   $i:/root/"
	func_cmd_need_password "$PASSWORD" "$cmd" 
done

for i in $machines
do
	ip=`echo $i|sed "s/root@//"`
	cmd="scp $i:/root/1.txt   $ip.1.txt"
	func_cmd_need_password "$PASSWORD" "$cmd" 
done
