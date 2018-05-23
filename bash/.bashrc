#**************************************************
# ***** Include Additional Files *****
#**************************************************

# Check if include directory exists
if [ -d ~/configs/bash/include ]; then
	# Include files
	source ~/configs/bash/include/git/git-completion.bash
	source ~/configs/bash/include/git/git-prompt.sh
	source ~/configs/bash/include/brocade/.bashrc_brocade
else
	echo "Failed to include additional bashrc files. Please check if
			Git repo has been installed correctly in ~/configs"
fi


#**************************************************
# ***** Command Prompt *****
#**************************************************

# Set interface being used
myTty="$(tty)";
myTty="${myTty:5}";

# Set shell level
myShLvl=""
if [ $SHLVL -gt 1 ]; then
	myShLvl="($SHLVL)";
fi

# Check if clearcase exists on system
if [ command -v foo >/dev/null 2>&1 ]; then
	# Set current view
	currView=" `cleartool pwv -short`"
	if [ "$currView" == " ** NONE **" ]; then
		currView="";
	fi
else
	# Leave currView blank
	currView=""
fi

# Define colors
export LS_COLORS='no=00:fi=00:di=00;31:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;34:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
alias ls='/bin/ls --color=tty'

# Define command prompt
# Reference: http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
export PS1="[\[\e[0;33m\]$myShLvl\[\e[m\]\[\e[1;34m\]$currView\$(__git_ps1)\[\e[m\]] \[\e[0;32m\]\h:\[\e[m\] \W \[\e[1;38m\]>\[\e[m\] "


#**************************************************
# ***** Configuration *****
#**************************************************

# Prevent scroll locking
stty -ixon

# set -a
set -b
set -o vi

# Default permissions (750)
umask 027


#**************************************************
# ***** Paths *****
#**************************************************

# Define base Git folder, if exists
export BASE_GIT_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"

# Define cscope directory based on clearcase or git
if [[ -d /vobs/projects/springboard/fabos/src ]]; then
	echo vobs
	export CSCOPE_DB="/vobs/projects/springboard/fabos/cscope.out"
else
	# Define Git folder based on ~/bin/buildCscope.sh
	export CSCOPE_DB="$BASE_GIT_DIR/cscope/cscope_database.out"
fi


#**************************************************
# ***** Commands *****
#**************************************************

# Function: commands
#
# Description: List available commands. Whenever a command is added or
#		updated, this should be as well.
#
commands() {
	# Print general commands
	echo "General commands:"
	echo

	# Print Brocade-specific commands
	brocade_commands

	echo
	}

#cstyle()	{ perl /vobs/projects/springboard/toolchains/utils/scripts/cstyle "$@"; }
