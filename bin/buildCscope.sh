#!/bin/bash
# File: buildCscope.sh
# Description: Create Ctags and Cscope database for Vim and put in
# 		the base of the Git repo.


# Get base Git repo directory
base_git_repo="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z $base_git_repo ]; then
	echo "Not in Git repo!"
	exit 1
fi

# Check command line arguments
if [[ $# -gt 0 ]]; then

	case $1 in
		"-h" | "--help" )
			echo "Expected arguments:"
			echo "\tSpace separated list of base project directories to source"
			echo "\t\tNote: Have had some issues with Cscope when directories \
					not fully specified"
			exit 1
			;;
	esac
else
	echo "Expected arguments:"
	echo "\tSpace separated list of base project directories to source"
	echo "\t\tNote: Have had some issues with Cscope when directories \
			not fully specified"
	exit 1
fi

# Add specified directories to list
directories=''
for i in "$@"; do
	directories="$directories \
			$i"
done

# Display variables
echo "Base Git Directory: $base_git_repo"
echo "Base Project Directories: $base_dir"


# Create cscope directory
if [ ! -d $base_git_repo/cscope ]; then
	echo "Cscope directory doesn't exist. Create it."
	mkdir "$base_git_repo/cscope"
fi

# Clear cscope files
null > $base_git_repo/cscope/cscope.files

# Source files
for directory in $directories; do
	echo "Sourcing $directory"
	find $directory -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.py" -o -iname "makefile" -o -path "lost+found" -prune >> $base_git_repo/cscope/cscope.files
done

# Build cscope database
cscope -b -q -i $base_git_repo/cscope/cscope.files -f $base_git_repo/cscope/cscope_database.out

# Set CSCOPE_DB to point to database
CSCOPE_DB=$base_git_repo/cscope_database.out
export CSCOPE_DB
