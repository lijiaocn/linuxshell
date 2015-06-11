#!/bin/bash

###############################################################################
#                                                                             #
#                                Time Operation                               #
#                                                                             #
###############################################################################
func_cur_date(){
    echo `date +"%Y%m%d"`
}
func_yesterday_date(){
    echo `date -d yesterday +"%Y%m%d"`
}
func_before_yesterday_date(){
    echo `date -d "-2 day" +"%Y%m%d"`
}
func_cur_time(){
    echo `date +"%Y-%m-%d %H:%M:%S"`
}
func_yesterday_time(){
    echo `date -d yesterday +"%Y-%m-%d %H:%M:%S"`
}
###############################################################################
#                                                                             #
#                                Base Convert Operation                       #
#                                                                             #
###############################################################################
#convert 16base into 10base
#
func_16to10(){
	echo "ibase=16;obase=A; $1"|bc
}

###############################################################################
#                                                                             #
#                                Info  Operation                              #
#                                                                             #
###############################################################################
#Get the net interfaces's name
func_nic_names(){
	local names=`ip addr |grep \<.*\>|awk '{print $2}'|sed -e "s/://"`
	echo $names
}

###############################################################################
#                                                                             #
#                                Error Operation                              #
#                                                                             #
###############################################################################
#$1: message
func_fatal(){
	echo  -n -e "\e[31m"
	echo "Fatal Error: $1"
	echo  -n -e "\e[0m"
	exit
}

###############################################################################
#                                                                             #
#                                Color Operation                              #
#                                                                             #
###############################################################################

#Input is the command.
#The command's execute output will use red color
func_red_cmd(){
	echo  -n -e "\e[31m"
	$*
	echo  -n -e "\e[0m"
}

#Input is the command.
#The command's execute output will use yellow color
func_yellow_cmd(){
	echo  -n -e "\e[33m"
	$*
	echo  -n -e "\e[0m"
}

#Input is the command
#If command is error, display the error
func_error_cmd(){
	$*
	local ret=$?
	if [ ! $ret -eq 0 ];then
		echo  -n -e "\e[41;37m"
		echo "Error: [$ret] $*"
		echo  -n -e "\e[0m"
		exit 1
	fi
	return 0
}

#Input is a string.
#The string  will be displayed with green color
func_green_str(){
	echo  -n -e "\e[32m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

func_yellow_str(){
	echo  -n -e "\e[33m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

#Input is a string.
#The string  will be displayed with red color
func_red_str(){
	echo  -n -e "\e[31m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

###############################################################################
#                                                                             #
#                       Systemd Service Operation                             #
#                                                                             #
###############################################################################

#Start a systemd style Service
func_start_sd_service(){
	systemctl start $1
	sleep 1
	local sta=`systemctl status ${1} |grep "Active: failed"`
	if [ -n "$sta" ];then
		func_red_str   "Start[Fail] $1"
		func_red_str   "            $sta"
		ret=1
	else
		local x=`systemctl status ${1} | grep "Active:"`
		func_green_str "Start[OK]   $1"
		func_green_str "            $x"
	fi
	return $ret
}

#Start a systemd style Service
func_stop_sd_service(){
	systemctl stop $1
	ret=$?
	local sta=`systemctl status ${1} |grep "Active:"`
	func_yellow_str "Stopping $1"
	func_yellow_str "         $sta"
}

###############################################################################
#                                                                             #
#                            Directory Operation                              #
#                                                                             #
###############################################################################

#Create Dirs: $1 $2 $3 ...
func_create_dirs(){
	for i in $*
	do
		if [ ! -d $i ];then
			mkdir -p $i
		fi
	done
}

#Force Copy: 
#$1: Destiation Directory
#$2,$3,$4,...: Source File or Directories
func_force_copy(){
	local dest=$1
	shift 1

	if [ ! -d $dest ];then
		func_red_str "Dest Dir doesn't exist: $dest"
		return 1
	fi
	
	for i in $*
	do
		if [ ! -e $i ];then
			func_red_str "Not Found: $i"
			return 1
		fi
	done

	for i in $*
	do
		cp -rf $i $dest/
	done
}

###############################################################################
#                                                                             #
#                                Git operation                                #
#                                                                             #
###############################################################################

#$1: tag
#$2: local directory
#$3: respositry url
func_git_check_tag(){
	if [ ! -e $2 ];then
		func_error_cmd git clone $3 $2
		if [ ! $?  -eq 0 ];then
			func_red_str "Something is wrong in cloning"
			return 1
		fi
	fi

	if [ ! -d $2 ];then
		func_red_str "The local respositry is not a directory"
		return 1
	fi

	local cur=`pwd`
	cd $2
		func_error_cmd git checkout $1
		if [ ! $? -eq 0 ];then
			return 1
		fi
	cd $cur
}
