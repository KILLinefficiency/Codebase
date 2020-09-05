#/bin/bash

if [ $(whoami) == "root" ]; then
	printf "\nYou are running Codebase as the \e[01;33mroot\e[00;39m user.\nAll the files will be owned by the \e[01;33mroot\e[00;39m user.\n\n"
fi

if [ "$1" == "help" ]; then
cat << HELP
help here
HELP
fi

if !([ -d .codebase ] && [ -d .codebase/root ] && [ -f .codebase/division ] && [ -f .codebase/root/save_count ] || [ "$1" == "construct" ]); then
	printf "This directory is not a codebase.\nRun:\n\n\t\e[01;32mcbase construct\e[00;39m\n\nto create an empty codebase.\n"
	exit
fi
if [ -e .codebase/division ]; then
	DIVISION=$(cat .codebase/division)
else
	DIVISION="root"
fi

if [ "$1" == "construct" ]; then
	if [ -d .codebase ]; then
		printf "A codebase already exists.\nTo remove it use:\n\n\t\e[01;32mcbase destruct\e[00;39m\n\nAnd then create a new one using:\n\n\t\e[01;32mcbase construct\e[0039m\n\n"
	else
		mkdir .codebase
		mkdir .codebase/root
		echo "1" > .codebase/root/save_count
		echo "root" > .codebase/division
	fi
fi

if [ "$1" == "div" ]; then
	if [ -d .codebase/$2 ]; then
		printf "\nThe division \e[01;36m$2\e[00;39m already exists.\nSwitch to it using:\n\n\t\e[01;32mcbase trigger $2\e[00;39m\n\n"
	else
		mkdir .codebase/$2
		cp .codebase/$DIVISION/* .codebase/$2
	fi
fi

if [ "$1" == "ndiv" ]; then
	for divs in $(ls -F .codebase | grep "/"); do
		if [ "$DIVISION/" == "$divs" ]; then
			echo -e "\e[01;31m-->\e[01;36m $divs\e[00;39m"
		else
			echo -e "    \e[01;39m$divs\e[00;39m"
		fi
	done
fi

if [ "$1" == "trigger" ]; then
	if [ -d .codebase/$2 ]; then
		echo "$2" > .codebase/division
		DIVISION=$(cat .codebase/division)
		total_saves=$(($(cat .codebase/$2/save_count) - 1))
		for switch_div in $(seq $total_saves); do
			cat .codebase/$DIVISION/$switch_div > $(awk '{print $1}' .codebase/$DIVISION/"$switch_div"-info.txt)
		done
	else
		echo -e "The division \e[01;36m$2\e[00;39m does not exist."
	fi
	echo -e "You are on \e[01;36m$(cat .codebase/division)\e[00;39m division now."
fi

if [ "$1" == "cut" ]; then
	if [ "$2" != "root" ]; then
		read -p "Are you sure you want to cut \"$2\" division? [y/N] " cut_div
		if [ -z $cut_div ]; then
			exit
		elif [ "$cut_div" == "y" ] || [ "$cut_div" == "Y" ]; then
			rm -rf .codebase/$2
			echo "root" > .codebase/division
		else
			exit
		fi
	else
		echo -e "Cannot cut the \e[01;36mroot\e[00;39m division."
	fi
fi

if [ "$1" == "smoosh" ]; then
	if [ -d .codebase/$2 ]; then
		cp .codebase/$DIVISION/* .codebase/$2
	else
		printf "The division \e[01;36m$2\e[00;39m does not exist.\nCreate one using:\n\n\t\e[01;32mcbase div $2\e[00;39m\n\n"
	fi
fi

if [ "$1" == "destruct" ]; then
	read -p "Are you sure you want to deconstruct the entire codebase? [y/N] " destruct_codebase
	if [ -z $destruct_codebase ]; then
		exit
	elif [ "$destruct_codebase" == "y" ] || [ "$destruct_codebase" == "Y" ]; then
		rm -rf .codebase
	else
		exit
	fi
fi

if [ "$1" == "save" ]; then
	if [ -e $2 ]; then
		SAVE=$(cat .codebase/$DIVISION/save_count)
		cat $2 > .codebase/$DIVISION/$SAVE
		echo -e "$2 : $3" > .codebase/$DIVISION/$SAVE-info.txt
		echo "$((SAVE + 1))" > .codebase/$DIVISION/save_count
	else
		echo -e "The file \e[01;34m$2\e[00;39m does not exist."
	fi
fi

if [ "$1" == "goto" ]; then
	total_save_files=$(ls .codebase/$DIVISION/*-info.txt | wc -l)
	if [ $2 -le $total_save_files ]; then
		cat .codebase/$DIVISION/$2 > $(awk '{print $1}' .codebase/$DIVISION/$2-info.txt)
	else
		printf "The Save ID: \e[01;35m$2\e[00;39m does not exist yet.\nThere are only \e[01;35m$total_save_files\e[00;39m ID(s) so far.\n"
	fi
fi

if [ "$1" == "history" ]; then
	FILES=$(ls .codebase/$DIVISION/*-info.txt | wc -l)
	printf "\n\e[01;32mSave History:\e[00;39m\n\n"
	for saves in $(seq $FILES); do
		printf "  \e[01;35m$saves\e[01;31m -->\e[00;39m "
		printf "\e[01;39m$(cat .codebase/$DIVISION/$saves-info.txt)\e[00;39m\n\n"
	done
fi