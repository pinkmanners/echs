#!/bin/bash


#    installSoftware.sh - installs software for fedora 42 gnome
#    Copyright (C) 2025  pinkmanners


#                    _       __               __  __  _
#    _______________(_)___  / /_   ________  / /_/ /_(_)___  ____ ______
#   / ___/ ___/ ___/ / __ \/ __/  / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
#  (__  ) /__/ /  / / /_/ / /_   (__  )  __/ /_/ /_/ / / / / /_/ (__  )
# /____/\___/_/  /_/ .___/\__/  /____/\___/\__/\__/_/_/ /_/\__, /____/
#                 /_/                                     /____/

# set version string
ver="0.5.0"

# send all output to a log file
LOG=installSoftware.log
exec > >(tee -a "${LOG}") 2>&1


#                                             _____                      __  _
#   __  __________  _____   _________  ____  / __(_)________ ___  ____ _/ /_(_)___  ____
#  / / / / ___/ _ \/ ___/  / ___/ __ \/ __ \/ /_/ / ___/ __ `__ \/ __ `/ __/ / __ \/ __ \
# / /_/ (__  )  __/ /     / /__/ /_/ / / / / __/ / /  / / / / / / /_/ / /_/ / /_/ / / / /
# \__,_/____/\___/_/      \___/\____/_/ /_/_/ /_/_/  /_/ /_/ /_/\__,_/\__/_/\____/_/ /_/

echo
echo ┌──────────────────────────────────┐
echo │ pinkmanners - installSoftware.sh │
echo └────────────────────────────╴v$ver
echo "Welcome to installSoftware.sh by pinkmanners!
This script will perform the following 7 steps to configure your Fedora 42 Workstation system:

1. Configure DNF, 2. Install DNF Repos, 3. Install COPR Repos, 4. Remove Fedora's Flatpak repo and replace it with Flathub
5. Update software from DNF and Flatpak, 6. Install user specificed software, 7. Remove unused software and dependancies

Please make sure you have a backup of your system before proceeding, as this script will make major changes to your system."

echo echo
read -n 1 -p "□ Are you sure you want to continue? (Y/n) " -r REPLY
if [[ ${REPLY} =~ ^[Nn]$ ]]; then
  echo "
  Exiting..."
  exit 1
fi

echo
echo "━━━╸Beginning installation╺━━━"
echo

#        __      ____                         _____
#   ____/ /___  / __/       _________  ____  / __(_)___ _
#  / __  / __ \/ /_        / ___/ __ \/ __ \/ /_/ / __ `/
# / /_/ / / / / __/  _    / /__/ /_/ / / / / __/ / /_/ /
# \__,_/_/ /_/_/    (_)   \___/\____/_/ /_/_/ /_/\__, /
#                                               /____/

echo
echo "■ (1/7) Configuring DNF..."
echo

# speed up dnf by adding these to dnf.conf
sudo echo "defaultyes=True" >> /etc/dnf/dnf.conf
sudo echo "fastestmirror=True" >> /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf


#    ________  ____  ____  _____
#   / ___/ _ \/ __ \/ __ \/ ___/
#  / /  /  __/ /_/ / /_/ (__  )
# /_/   \___/ .___/\____/____/
#          /_/

echo
echo "■ (2/7) Installing DNF repositories..."
echo

# add RPM Fusion free + non-free repos
echo " ...[1/2] RPM Fusion (free + non-free)"
echo
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# add Terra repo
echo
echo " ...[2/2] Terra"
echo
sudo dnf install --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release


#   _________  ____  _____
#  / ___/ __ \/ __ \/ ___/
# / /__/ /_/ / /_/ / /
# \___/\____/ .___/_/
#          /_/

echo
echo "■ (3/7) Installing COPR repositories..."
echo

# add cuda text copr
echo
echo " ...[1/2] Cuda Text from zliced13/YACR"
echo
sudo dnf copr enable zliced13/YACR

# add yumex copr
echo
echo " ...[2/2] Yum Extender (Nobara) from timlau/yumex-ng"
echo
sudo dnf copr enable timlau/yumex-ng


#     ______      __  __          __
#    / __/ /___ _/ /_/ /_  __  __/ /_
#   / /_/ / __ `/ __/ __ \/ / / / __ \
#  / __/ / /_/ / /_/ / / / /_/ / /_/ /
# /_/ /_/\__,_/\__/_/ /_/\__,_/_.___/

echo
echo "■ (4/7) Installing Flathub repository and removing Fedora's..."
echo

# add the flathub repo and reinstall flatpaks from it, then remove the fedora maintained repo
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )

flatpak remote-delete fedora


#                    __      __
#   __  ______  ____/ /___ _/ /____  _____
#  / / / / __ \/ __  / __ `/ __/ _ \/ ___/
# / /_/ / /_/ / /_/ / /_/ / /_/  __(__  )
# \__,_/ .___/\__,_/\__,_/\__/\___/____/
#     /_/

echo
echo "■ (5/7) Updating packages and flatpaks..."
echo

# update system packages
echo
echo " ...[1/2] DNF Updates"
echo
sudo dnf --refresh
sudo dnf update

# update flatpaks
echo
echo " ...[1/2] Flatpak Updates"
echo
flatpak update


#     _            __        ____              ______
#    (_)___  _____/ /_____ _/ / /  _________  / __/ /__      ______ _________
#   / / __ \/ ___/ __/ __ `/ / /  / ___/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
#  / / / / (__  ) /_/ /_/ / / /  (__  ) /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
# /_/_/ /_/____/\__/\__,_/_/_/  /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/

echo
echo "■ (6/7) Installing software..."
echo

# install system packages
echo
echo " ...[1/3] from DNF"
echo
sudo dnf install git make gcc zsh nvim mc ranger kitty btop htop fastfetch yt-dlp dnf-plugins-core timeshift thunar terminator cudatext yumex gpick gparted gnome-tweaks gnome-extensions-app numix-icon-theme-circle papirus-icon-theme breeze-cursor-theme qt6pas
sudo dnf install p7zip-*
sudo dnf install ffmpeg --allowerasing

# install flatpaks
echo
echo " ...[1/3] from Flatpak"
echo

flatpak install -y brave tenacity xnconvert lightzone nookdesktop plexdesktop raider mousam mullvad evince ptyxis rhythmbox inkscape gearlever onlyoffice logseq bitwarden poweriso soundconverter strawberry tidal-hifi wsjtx eloquent

# install flatpaks (these need their sources picked correctly)
echo
echo " ...[1/3] from Flatpak"
echo
echo " ... * You have to pick the right refs for these so pay attention ^_^"
echo
echo echo

read -n 1 -p "□ Are you ready? (Y/n) " -r REPLY

if [[ ${REPLY} =~ ^[Nn]$ ]]; then
  echo "Exiting..."
  exit 1
fi

flatpak install echo telegram transmission audacity krita shotwell gimp media-downloader handbrake vlc


#                                                       ______
#    ________  ____ ___  ____ _   _____     _________  / __/ /__      ______ _________
#   / ___/ _ \/ __ `__ \/ __ \ | / / _ \   / ___/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
#  / /  /  __/ / / / / / /_/ / |/ /  __/  (__  ) /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
# /_/   \___/_/ /_/ /_/\____/|___/\___/  /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/

echo
echo "■ (7/7) Removing unused software and dependancies..."
echo

# remove software
sudo dnf remove gnome-boxes gnome-connections gnome-contacts gnome-maps gnome-tour totem mediawriter nautilus firefox rhythmbox

# remove any unused dependacies
sudo dnf autoremove

echo "
         ____       __                 ______                _                ____         __
  ____ _/ / /  ____/ /___  ____  ___  / / / /  ___  ____    (_)___  __  __   / __/__  ____/ /___  _________ _
 / __  / / /  / __  / __ \/ __ \/ _ \/ / / /  / _ \/ __ \  / / __ \/ / / /  / /_/ _ \/ __  / __ \/ ___/ __  /
/ /_/ / / /  / /_/ / /_/ / / / /  __/_/_/_/  /  __/ / / / / / /_/ / /_/ /  / __/  __/ /_/ / /_/ / /  / /_/ /
\__,_/_/_/   \__,_/\____/_/ /_/\___(_|_|_)   \___/_/ /_/_/ /\____/\__, /  /_/  \___/\__,_/\____/_/   \__,_/
                                                      /___/      /____/
"
