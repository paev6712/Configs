#!/bin/bash
# File: initialize.sh
# Initialize development environment by symlinking configuration files into base directory.


echo "Begin intializing environment:"


# Bash configuration
echo "    Initialize bash configuration"
if [ -f ~/.bashrc ]; then
	echo "        bash configuration already exists. Overwrite?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes )
				# Remove existing config
				rm ~/.bashrc
				# Symlink .bashrc into scope
				ln -s ~/configs/bash/.bashrc ~/
				# Reload bash config
				source ~/.bashrc
				break;;
			No )
				# Leave existing config
				break;;
		esac
	done
else 
	# Symlink .bashrc into scope
	ln -s ~/configs/bash/.bashrc ~/
	# Reload bash config
	source ~/.bashrc
fi


# Tmux configuraiton
echo "    Initialize tmux configuration"
if [ -f ~/.tmux.conf ]; then
	echo "        tmux configuration already exists. Overwrite?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes )
				# Remove existing config
				rm ~/.tmux.conf
				# Symlink .tmux.conf into scope
				ln -s ~/configs/tmux/.tmux.conf ~/
				# Reload bash config
				tmux source-file ~/.tmux.conf
				break;;
			No )
				# Leave existing config
				break;;
		esac
	done
else 
	# Symlink .tmux.conf into scope
	ln -s ~/configs/tmux/.tmux.conf ~/
	# Reload bash config
	tmux source-file ~/.tmux.conf
fi


# Vim configuration
echo "    Initialize vim configuration"
if [ -f ~/.vimrc ]; then
	echo "        vim configuration already exists. Overwrite?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes )
				# Remove existing config
				rm ~/.vimrc
				# Symlink .vimrc into scope
				ln -s ~/configs/vim/.vimrc ~/
				break;;
			No )
				# Leave existing config
				break;;
		esac
	done
else 
	# Symlink .vimrc into scope
	ln -s ~/configs/vim/.vimrc ~/
fi

echo "        Install pathogen"
if [ -d ~/.vim/ ]; then
	if [ -d ~/.vim/autoload/ ]; then
		if [ -f ~/.vim/autoload/pathogen.vim ]; then
			echo "            Pathogen already installed. Overwrite?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes )
						# Remove existing version 
						rm ~/.vim/autoload/pathogen.vim
						# Symlink pathogen.vim into scope
						ln -s ~/configs/vim/autoload/pathogen.vim ~/.vim/autoload/
						break;;
					No )
						# Leave existing version 
						break;;
				esac
			done
		else
			# Symlink pathogen.vim into scope
			ln -s ~/configs/vim/autoload/pathogen.vim ~/.vim/autoload/
		fi
	else
		mkdir ~/.vim/autoload
		# Symlink pathogen.vim into scope
		ln -s ~/configs/vim/autoload/pathogen.vim ~/.vim/autoload/
	fi
else
	mkdir ~/.vim/
	mkdir ~/.vim/autoload
	# Symlink pathogen.vim into scope
	ln -s ~/configs/vim/autoload/pathogen.vim ~/.vim/autoload/
fi


echo "Finished initializing environment"
