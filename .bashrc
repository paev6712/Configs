
# set -a
set -b
set -o vi

# Set the prompt style
# http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
myTty="$(tty)";
myTty="${myTty:5}";
currView=" `cleartool pwv -short`"
if [ "$currView" == " ** NONE **" ]; then
	currView="";
fi
myShLvl=""
if [ $SHLVL -gt 1 ]; then
	myShLvl="($SHLVL)";
fi
PS1="[$myTty\[\e[0;33m\]$myShLvl\[\e[m\]\[\e[1;34m\]$currView\[\e[m\]] \[\e[0;32m\]\h:\[\e[m\] \W \[\e[1;38m\]>\[\e[m\] "

export LS_COLORS='no=00:fi=00:di=00;31:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;34:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
alias ls='/bin/ls --color=tty'

# Define CSCOPE_DB environment variable
export FROOT=/vobs/projects/springboard/fabos
export CSCOPE_DB=$FROOT/cscope/cscope.out


# Shortcut functions
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

cleanOldBuilds() {
	t=30;
	if [ $# -ge 1 ]; then
		t=$1;
	fi
	echo "Cleaning builds older than $t days"
	find /scratch/fos-brm/parker/buildOutput/ -mindepth 1 -maxdepth 1 -type d -ctime +${t} -print -exec rm -rf {} \;
}

cleanEmptyBuilds() {
	echo "Removing empty build directories"
	cd /scratch/fos-brm/parker/buildOutput/ 
	for d in `ls`; do
		if [ -d "$d" ]; then
			if [ -z "`ls $d/`" ]; then
				rmdir $d;
			fi
		fi
	done
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

fullPath() {
	echo "`pwd`/$1"
}

getSwitchCore () {
	if [ $# -eq 3 ]; then
		if [ `expr index $3 "core"` -gt 0 ]; then
			eswscp root@${1}:/core_files/${2}/"${3}.*" .
		else
			eswscp root@${1}:/core_files/${2}/"core.${3}.*" .
		fi
	elif [ $# -eq 2 ] ; then
		eswscp root@${1}:/core_files/${2}/"core.*" .
	else
		echo "Error: Invalid usage"
		echo "$0 <IP> <daemon> [<core name | number>]"
	fi
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

launchBuild() {
	varFile="/vobs/projects/springboard/make/exported_vars.txt"
	touch $varFile
	~parker/bin/startBuild "$@" | tee >(grep "export LAST_BUILD" > $varFile) . $varFile
	rm $varFile
}

remSshKnownHost () {
	if [ $# -eq 1 ]; then
		cmd="perl -ni -e'print unless (\$_ =~ \"$1\")' ~/.ssh/known_hosts"
		echo "Command: $cmd"
		eval $cmd
	else
		echo "Expected usage: $FUNCNAME <IP>"
	fi
}

tracedecodeview() {
	if [ -f /vobs/projects/springboard/build/swbd${1}/fabos/src/utils/trace/tracedecode.linux ] ; then
		/vobs/projects/springboard/build/swbd${1}/fabos/src/utils/trace/tracedecode.linux -a ${2}
	else
		/users/home24/swuser/bin/tracedecode -a ${2}
	fi
}

tracedecodecompress_710() {
	while [ $# -gt 1 ]; do
		~swuser/bin/tracedecode.v71 -a $1 | tracecompact.pl | sort | gzip - > `basename $1 .dmp`.txt.gz;
		shift;
	done
}

tracedecodecompress_fos() {
	while [ $# -ge 1 ]; do
		~swuser/bin/tracedecode.FOS -a $1 | tracecompact.pl | sort | gzip - > `basename $1 .dmp`.txt.gz;
		shift;
	done
}


supportdecodedir() {
	if [ -f /vobs/projects/springboard/build/swbd${1}/fabos/src/utils/support/supportDecode.i686 ] ; then
		/vobs/projects/springboard/build/swbd${1}/fabos/src/utils/support/supportDecode.i686 .
	else
		/users/home24/swuser/bin/supportdecode .
	fi
}

ctDiffView() {
	if [ $# -eq 4 ]; then
		if [ -f $1 ]; then
			vim -d ${1}@@${2}/${3} ${1}@@${2}/${4}
		else
			echo "Not a file: ${1}"
		fi
	elif [ `expr index "$1" "@@"` -ne 0 ]; then
		idx=`expr index "$1" "@@"`
		fName=`expr substr "$1" 1 $((idx-1))`
		branch="${1:$((idx+1))}"
		ver=`expr match "$branch" '.*\/\([0-9]*\)$'`
		branch="${branch%\/[0-9]*}"
		vim -d ${fName}@@${branch}/$((ver-1)) ${fName}@@${branch}/${ver}
	else
		echo "Invalid parameter count.  Should be $0 <fileName> <branch> <ver1> <ver2>"
	fi
}

loadDaemon() {
	if [ $# -eq 2 ]; then
		eswssh root@${2} "if [ -f /fabos/libexec/${1}.orig ]; then rm /fabos/libexec/${1}; else mv /fabos/libexec/${1} /fabos/libexec/${1}.orig; fi"
		eswscp $1 root@${2}:/fabos/libexec/
		return 0
	else
		echo "Invalid parameters: $0 <daemon name> <ip>"
		return 1
	fi
}

loadDaemonReboot() {
	if [ $# -eq 2 ]; then
		eswssh root@${2} "if [ -f /fabos/libexec/${1}.orig ]; then rm /fabos/libexec/${1}; else mv /fabos/libexec/${1} /fabos/libexec/${1}.orig; fi"
		eswscp $1 root@${2}:/fabos/libexec/
		eswssh root@${2} "yes | reboot"
		return 0
	else
		echo "Invalid parameters: $0 <daemon name> <ip>"
		return 1
	fi
}

saveOriginals() {
	while [ $# -ge 1 ]; do
		if [ -f "$1" ]; then
			mv $1 ${1}.orig
		else
			echo "$1 is not a file -> skipping"
		fi
		shift;
	done
}

makeFspf () {
	saveFiles=""
	if [ ! -f ../lib/fspf/libfspf.so.1.0.orig ]; then saveFiles="$saveFiles ../lib/fspf/libfspf.so.1.0"; fi
	if [ ! -f fspf.orig ]; then saveFiles="$saveFiles fspf"; fi
	if [ ! -f fspfd.orig ]; then saveFiles="$saveFiles fspfd"; fi
	
	if [ "$saveFiles" != "" ]; then saveOriginals $saveFiles; fi
	
	make -C ../lib/fspf $@ && make $@
	return $?
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
