DOT_LOCATION=~/dot-jeeva

gitclone() {
	echo "Clone dot files into ~/dot-jeeva"
	if [ -d "$DOT_LOCATION" ]; then
		read -n 1 -p "Remove all contents in $DOT_LOCATION [Y/N] [DEFAULT Y]: " confirm
		echo
		confirm=${confirm:-Y}
		if [[ "$confirm" =~ [yY] ]]; then
			echo "Cleaning $DOT_LOCATION"
			cd "$DOT_LOCATION"
			rm -rf *
		else
			exit 1
		fi
	else
		mkdir "$DOT_LOCATION"
	fi
	git clone https://github.com/jeevithakannan2/my-dwm.git --depth 1 "$DOT_LOCATION/my-dwm"
	git clone https://github.com/jeevithakannan2/my-dwmstatus.git --depth 1 "$DOT_LOCATION/my-dwmstatus"
}

install() {
	cd "$DOT_LOCATION/my-dwm"
	sudo make install
	cd "$DOT_LOCATION/my-dwmstatus"
	sudo make install
}

if command -v pacman &>/dev/null; then
	echo "Arch System !!!"
	if command -v git &>/dev/null; then
		echo "Git found in system"
		gitclone
		if [ $? -ne 0 ]; then
			echo "Cloning failed !!"
		fi
	else
		echo "Git not found in system installing git"
		sudo pacman -Syu git
		gitclone
		if [ $? -ne 0 ]; then
			echo "Cloning failed !!"
		fi
	fi
	echo "Installing dwm and dwmstatus"
	install
else
	echo "Arch system not found"
	exit 1
fi
