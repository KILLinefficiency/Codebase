#/bin/bash

DEFAULT="\e[00;39m"
DEFAULT_BOLD="\e[01;39m"

RED="\e[01;31m"
GREEN="\e[01;32m"
YELLOW="\e[01;33m"
BLUE="\e[01;34m"
MAGENTA="\e[01;35m"
CYAN="\e[01;36m"

if [ $(whoami) == "root" ]; then
	printf "\nYou are running Codebase as the ${YELLOW}root${DEFAULT} user.\nAll the files will be owned by the ${YELLOW}root${DEFAULT} user.\n\n"
fi

if [ "$1" == "help" ]; then
cat << HELP
help here
HELP
fi

if !([ -d .codebase ] && [ -d .codebase/root ] && [ -f .codebase/division ] && [ -f .codebase/root/save_count ] || [ "$1" == "construct" ]); then
	printf "This directory is not a codebase.\nRun:\n\n\t${GREEN}cbase construct${DEFAULT}\n\nto create an empty codebase.\n"
	exit
fi
if [ -e .codebase/division ]; then
	DIVISION=$(cat .codebase/division)
else
	DIVISION="root"
fi

if [ "$1" == "construct" ]; then
	if [ -d .codebase ]; then
		printf "A codebase already exists.\nTo remove it use:\n\n\t${GREEN}cbase destruct${DEFAULT}\n\nAnd then create a new one using:\n\n\t${GREEN}cbase construct\e[0039m\n\n"
	else
		mkdir .codebase
		mkdir .codebase/root
		echo "1" > .codebase/root/save_count
		echo "root" > .codebase/division
	fi
fi

if [ "$1" == "div" ]; then
	if [ -d .codebase/$2 ]; then
		printf "\nThe division ${CYAN}$2${DEFAULT} already exists.\nSwitch to it using:\n\n\t${GREEN}cbase trigger $2${DEFAULT}\n\n"
	else
		mkdir .codebase/$2
		cp .codebase/$DIVISION/* .codebase/$2
	fi
fi

if [ "$1" == "ndiv" ]; then
	for divs in $(ls -F .codebase | grep "/"); do
		if [ "$DIVISION/" == "$divs" ]; then
			echo -e "${RED}-->${CYAN} $divs${DEFAULT}"
		else
			echo -e "    ${DEFAULT_BOLD}$divs${DEFAULT}"
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
		echo -e "The division ${CYAN}$2${DEFAULT} does not exist."
	fi
	echo -e "You are on ${CYAN}$(cat .codebase/division)${DEFAULT} division now."
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
		echo -e "Cannot cut the ${CYAN}root${DEFAULT} division."
	fi
fi

if [ "$1" == "smoosh" ]; then
	if [ -d .codebase/$2 ]; then
		cp .codebase/$DIVISION/* .codebase/$2
	else
		printf "The division ${CYAN}$2${DEFAULT} does not exist.\nCreate one using:\n\n\t${GREEN}cbase div $2${DEFAULT}\n\n"
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
		echo -e "The file ${BLUE}$2${DEFAULT} does not exist."
	fi
fi

if [ "$1" == "goto" ]; then
	total_save_files=$(ls .codebase/$DIVISION/*-info.txt | wc -l)
	if [ $2 -le $total_save_files ]; then
		cat .codebase/$DIVISION/$2 > $(awk '{print $1}' .codebase/$DIVISION/$2-info.txt)
	else
		printf "The Save ID: ${MAGENTA}$2${DEFAULT} does not exist yet.\nThere are only ${MAGENTA}$total_save_files${DEFAULT} ID(s) so far.\n"
	fi
fi

if [ "$1" == "history" ]; then
	FILES=$(ls .codebase/$DIVISION/*-info.txt | wc -l)
	printf "\n${GREEN}Save History:${DEFAULT}\n\n"
	for saves in $(seq $FILES); do
		printf "  ${MAGENTA}$saves${RED} -->${DEFAULT} "
		printf "${DEFAULT_BOLD}$(cat .codebase/$DIVISION/$saves-info.txt)${DEFAULT}\n\n"
	done
fi
