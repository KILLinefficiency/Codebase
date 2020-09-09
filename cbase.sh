#/bin/bash

# Default colors for text.
DEFAULT="\e[00;39m"
DEFAULT_BOLD="\e[01;39m"

# Colors for displaying special text like, Save ID, Division name, etc.
RED="\e[01;31m"
GREEN="\e[01;32m"
YELLOW="\e[01;33m"
BLUE="\e[01;34m"
MAGENTA="\e[01;35m"
CYAN="\e[01;36m"

# Checks if bash exists or not. If not, then quites the program.
if [ -z $(which bash) ]; then
	echo -e "Codebase requires ${GREEN}/bin/bash${DEFAULT} to run and was not found."
	exit
fi

# Warns the user that Codebase is being run as the root user.
if [ $(whoami) == "root" ]; then
	printf "\nYou are running Codebase as the ${YELLOW}root${DEFAULT} user.\nAll the files will be owned by the ${YELLOW}root${DEFAULT} user.\n\n"
fi

# Gets a list of Codebase Commands.
if [ "$1" == "help" ]; then
cat << GETHELP

Codebase is a Source Control Management tool.
There is no network activity over Codebase.

Codebase commands and usage:

00] help : shows help (this message).

01] construct : makes an empty codebase in the current working directory.
02] destruct : removes the existing codebase from the current working directory.

03] save <file_name> <optional_save_message> : saves the file in the root division with a unique Save ID and a save message if given.
04] history : displays the history of all the saves with Save IDs and save messages.
05] goto <save_id> : goes back to the save specified by the Save ID.

06] div <div_name> : creates a new division.
07] ndiv : displays the list of divisions and the active division.
08] trigger <div_name> : switches to the specified division.
09] smoosh <div_name> : smooshes the active division with the specified divison.
10] cut <div_name> : removes the specified division from the codebase.

A fun and experimental project by Shreyas Sable.
https://www.github.com/KILLinefficiency/Codebase

GETHELP
fi

# Checks if the current working directory is a codebase or not.
if !([ -d .codebase ] && [ -d .codebase/root ] && [ -f .codebase/division ] && [ -f .codebase/root/save_count ] || [ "$1" == "construct" ]); then
	printf "\nThis directory is not a codebase.\nRun:\n\n\t${GREEN}cbase construct${DEFAULT}\n\nto create an empty codebase.\n\n"
	exit
fi

# Assigns the DIVISION variable to the active division.
if [ -e .codebase/division ]; then
	DIVISION=$(cat .codebase/division)
else
	DIVISION="root"
fi

# Creates an empty codebase in the current working directory.
if [ "$1" == "construct" ]; then
	# Warns if a codebase is already present.
	if [ -d .codebase ]; then
		printf "A codebase already exists.\nTo remove it use:\n\n\t${GREEN}cbase destruct${DEFAULT}\n\nAnd then create a new one using:\n\n\t${GREEN}cbase construct\e[0039m\n\n"
	else
		# Creates the entire file structure for an empty codebase.
		mkdir .codebase
		mkdir .codebase/root
		echo "1" > .codebase/root/save_count
		echo "root" > .codebase/division
		echo -e "Constructed an empty codebase at ${GREEN}$(pwd)${DEFAULT}"
	fi
fi

# Creates a new division.
if [ "$1" == "div" ]; then
	# Warns if the specified division is already present.
	if [ -d .codebase/$2 ]; then
		printf "\nThe division ${CYAN}$2${DEFAULT} already exists.\nSwitch to it using:\n\n\t${GREEN}cbase trigger $2${DEFAULT}\n\n"
	else
		# Copies the contents of the active division to the newly created division.
		mkdir .codebase/$2
		cp .codebase/$DIVISION/* .codebase/$2
	fi
fi

# Shows the list of total divisions and highlights the active division.
if [ "$1" == "ndiv" ]; then
	# Gets all the directories.
	for divs in $(ls -F .codebase | grep "/"); do
		if [ "$DIVISION/" == "$divs" ]; then
			# For active divisions.
			echo -e "${RED}-->${CYAN} ${divs//'/'/''}${DEFAULT}"
		else
			# For other divisions.
			echo -e "    ${DEFAULT_BOLD}${divs//'/'/''}${DEFAULT}"
		fi
	done
fi

# Switches to a specified division.
if [ "$1" == "trigger" ]; then
	if [ -d .codebase/$2 ]; then
		# Gets information about the previous division.
		PREVIOUS_DIV=$(cat .codebase/division)
		previous_div_total_saves=$(($(cat .codebase/$PREVIOUS_DIV/save_count) - 1))
		echo "$2" > .codebase/division
		DIVISION=$(cat .codebase/division)
		total_saves=$(($(cat .codebase/$2/save_count) - 1))
		# Removes all the files from the project directory belonging to the previous division.
		for kill_div in $(seq $previous_div_total_saves); do
			rm -f $(awk '{print $1}' .codebase/$PREVIOUS_DIV/"$kill_div"-info.txt)
		done
		# Populates the project directory with files belonging to the triggered division.
		for switch_div in $(seq $total_saves); do
			cat .codebase/$DIVISION/$switch_div > $(awk '{print $1}' .codebase/$DIVISION/"$switch_div"-info.txt)
		done
	else
		# Warns id the specified division is not found.
		echo -e "The division ${CYAN}$2${DEFAULT} does not exist."
	fi
	echo -e "You are on ${CYAN}$(cat .codebase/division)${DEFAULT} division now."
fi

# Deletes an entire division.
if [ "$1" == "cut" ]; then
	# Does not allow the user to cut the root division.
	if [ "$2" != "root" ]; then
		read -p "Are you sure you want to cut \"$2\" division? [y/N] " cut_div
		if [ -z $cut_div ]; then
			exit
		elif [ "$cut_div" == "y" ] || [ "$cut_div" == "Y" ]; then
			# Deletes the specified division.
			rm -rf .codebase/$2
			# Switches to the root division.
			echo "root" > .codebase/division
			echo -e "You are on ${CYAN}root${DEFAULT} division now."
		else
			exit
		fi
	else
		echo -e "Cannot cut the ${CYAN}root${DEFAULT} division."
	fi
fi

# Smooshes two divisions together.
if [ "$1" == "smoosh" ]; then
	if [ -d .codebase/$2 ]; then
		cp .codebase/$DIVISION/* .codebase/$2
	else
		# Warns if the specified division is not found.
		printf "The division ${CYAN}$2${DEFAULT} does not exist.\nCreate one using:\n\n\t${GREEN}cbase div $2${DEFAULT}\n\n"
	fi
fi

# Destructs the entire codebase from the project directory.
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

# Goes back to the version of a file specified by a Save ID.
if [ "$1" == "goto" ]; then
	total_save_files=$(($(cat .codebase/$DIVISION/save_count) - 1))
	if [ $2 -le $total_save_files ]; then
		# Reads the file name using awk and redirects the contents to it after reading it from the file by the name of the Save ID.
		cat .codebase/$DIVISION/$2 > $(awk '{print $1}' .codebase/$DIVISION/${2}-info.txt)
	else
		# Warns if the Save ID does not exist.
		printf "The Save ID: ${MAGENTA}$2${DEFAULT} does not exist yet.\nThere are only ${MAGENTA}$total_save_files${DEFAULT} ID(s) so far.\n"
	fi
fi

# Shows the history of all the saves belonging to the active division.
if [ "$1" == "history" ]; then
	FILES=$(($(cat .codebase/$DIVISION/save_count) - 1))
	printf "\n${GREEN}Save History:${DEFAULT}\n\n"
	# Displays the Save ID, name of the file and the save message.
	for saves in $(seq $FILES); do
		printf "  ${MAGENTA}$saves${RED} --> ${DEFAULT_BOLD}$(cat .codebase/$DIVISION/$saves-info.txt)${DEFAULT}\n\n"
	done
fi
