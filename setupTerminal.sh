#    setupTerminal.sh - configures zsh, oh my zsh and bash
#    Copyright (C) 2025  pinkmanners
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#!/bin/bash

# copy fastfetch config
#mkdir ~/.config/fastfetch/
#cp -r ./fastfetch/ ~/.config/fastfetch/

# configure .bashrc
echo "" >> ~/.bashrc
echo "#alias' under here ^_^" >> ~/.bashrc
echo "#alias ls='ls -al'" >> ~/.bashrc
echo "alias cd..='cd ..'" >> ~/.bashrc
echo "alias fpi='flatpak install'" >> ~/.bashrc
echo "alias fpu=flatpak uninstall" >> ~/.bashrc
echo "alias e='exit'" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "#things to run under here :3" >> ~/.bashrc
echo "fastfetch" >> ~/.bashrc

# download and install powerline fonts
git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh

# install oh my zsh and plugins, then configure zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.local/share/oh-my-zsh

git clone https://github.com/clavelm/yt-dlp-omz-plugin.git $ZSH_CUSTOM/plugins/yt-dlp
cp -r $ZSH_CUSTOM/plugins/yt-dlp/.yt-dlp ~/. 

git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

	# uncomment these to use the provided oh-my-zsh template config
		#cp -b \
		#~/.local/share/oh-my-zsh/templates/zshrc.zsh-template \
		#~/.zshrc

	# use my peronal config (inclucded)
cp -b ./zshrc ~/.zshrc

# swtich user to zsh
chsh -s $(which zsh)

echo ""
echo "zsh with omz will start and be the default shell upon next terminal start"
echo ""
