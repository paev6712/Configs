#**************************************************
# ***** Plugins *****
#**************************************************
source ~/configs/bash/plugins/git/git-completion.bash
source ~/configs/bash/plugins/git/git-prompt.sh


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


#**************************************************
# ***** Paths *****
#**************************************************

# Define CSCOPE_DB environment variable
# export FROOT=/vobs/projects/springboard/fabos
# Static git folder '/zzz/work40/parker/8.2.1'
# export GIT_FOS_DIR=$(/corp/global/tools/bin/gittools/get_my_workspace)/8.2.1

# Define cscope directory based on clearcase or git
if [[ -d /vobs/projects/springboard/fabos/src ]]; then
	echo vobs
	export CSCOPE_DB="/vobs/projects/springboard/fabos/cscope.out"
else
	# Define Git folder based on ~/bin/buildCscope.sh
	export CSCOPE_DB="$(git rev-parse --show-toplevel 2>/dev/null)/cscope/cscope_database.out"
fi

# Shortcut functions *******************************************************************************************************************************************************
src() {
	if [ -z "$1" ] ; then cd /vobs/projects/springboard/fabos/src
	else cd /vobs/projects/springboard/fabos/src/$1
	fi
}

build() {
	if [ -z "$1" ] ; then	cd /vobs/projects/springboard/build
	elif [ -z "$2" ] ; then	cd /vobs/projects/springboard/build/swbd$1
	else					cd /vobs/projects/springboard/build/swbd$1/fabos/src/$2
	fi
}

checkCoverity() {
	while [ $# -ge 1 ]; do
		cleartool describe $1 | grep COVMD5SUM > /dev/null
		if [ $? -eq 0 ]; then
			covHash=`cleartool describe $1 | grep COVMD5SUM | perl -e 'while(<STDIN>) {m/"([a-f0-9]+)"/; print $1}'`
			fileHash=`md5sum $1 | awk '{print $1;}'`
			if [ "$covHash" = "$fileHash" ]; then
				echo "Matching - $1"
			else
				echo "Mismatching - $1"
			fi
		else
			echo "No Coverity - $1"
		fi
		shift
	done
}

checkGkApproval() {
	while [ $# -ge 1 ]; do
		cleartool describe $1 | grep Approve > /dev/null;
		if [ $? -eq 0 ]; then
			echo "1 $1";
		else
			echo "0 $1";
		fi
		shift
	done
}

gkApprove() {
	while [ $# -ge 1 ]; do
		if [ -e $1 ]; then
			echo "Approving: $1"
			gatekeeper -a -f $1
		else
			echo "File does not exist: $1"
		fi
		shift
	done
}


builds()	{ cd /scratch/fos-brm/parker/buildOutput; }
ccmake()	{ cd /vobs/projects/springboard/make; }
cstyle()	{ perl /vobs/projects/springboard/toolchains/utils/scripts/cstyle "$@"; }
ct()		{ cleartool "$@"; }
ctco()		{ cleartool co -unres -nc $@; }
defectDir() { cd /proj/sj_eng/defects/${1:0:3}000/$1/; }
fabos()		{ cd /vobs/projects/springboard/fabos; }
findmerge()	{ cleartool findmerge `cleartool lsco -cview -all -s` -flatest -print; }
gdb_ppc()	{ /vobs/projects/springboard/toolchains/ppc/gcc-3.4.6-glibc-2.3.6/powerpc-linux/bin/powerpc-linux-gdb "$@"; }
killBuild()	{ /bin/bash /vobs/projects/springboard/make/.abort_and_cleanup_emake_lsf_build; }
lsco()		{ cleartool lsco -cview -all -s; }
lscoa()		{ cleartool lsco -cview -avobs -s; }
ppc()		{ /vobs/projects/springboard/toolchains/ppc/gcc-3.4.6-glibc-2.3.6/powerpc-linux/bin/powerpc-linux-"$@"; }
ppc_new()	{ /vobs/projects/springboard/toolchains/ppc/gcc-4.3.74-eglibc-2.8.74-6/powerpc-linux-gnu/bin/powerpc-linux-gnu-"$@"; }
scratch()	{ cd /scratch/fos-brm/parker/$1; }
#setview()	{ ~/bin/setview "$@"; }
swssh()		{ ssh -o UserKnownHostsFile=/dev/null "$@"; }
swscp()		{ scp -o UserKnownHostsFile=/dev/null "$@"; }
vd()		{ ~/bin/vd.sh "$@"; }
vps()		{ cd /vobs/projects/springboard; }
