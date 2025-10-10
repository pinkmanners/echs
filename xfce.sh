#!/bin/sh

#    xfce.sh - installs software for fedora 42
#    Copyright (C) 2025  pinkmanners


#                    _       __               __  __  _
#    _______________(_)___  / /_   ________  / /_/ /_(_)___  ____ ______
#   / ___/ ___/ ___/ / __ \/ __/  / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
#  (__  ) /__/ /  / / /_/ / /_   (__  )  __/ /_/ /_/ / / / / /_/ (__  )
# /____/\___/_/  /_/ .___/\__/  /____/\___/\__/\__/_/_/ /_/\__, /____/
#                 /_/                                     /____/

# set version string
ver="0.5.1x"

# send all output to a log file
LOG=installSoftwareScript.log
exec > >(tee -a "${LOG}") 2>&1


#                                             _____                      __  _
#   __  __________  _____   _________  ____  / __(_)________ ___  ____ _/ /_(_)___  ____
#  / / / / ___/ _ \/ ___/  / ___/ __ \/ __ \/ /_/ / ___/ __ `__ \/ __ `/ __/ / __ \/ __ \
# / /_/ (__  )  __/ /     / /__/ /_/ / / / / __/ / /  / / / / / / /_/ / /_/ / /_/ / / / /
# \__,_/____/\___/_/      \___/\____/_/ /_/_/ /_/_/  /_/ /_/ /_/\__,_/\__/_/\____/_/ /_/

echo
echo ┌──────────────────────────────────┐
echo │ pinkmanners - installSoftware.sh │
echo └────────────────────────────v$ver
echo "Welcome to installSoftware.sh by pinkmanners!

This script will perform the following 7 steps to configure your Fedora system:

1. Configure DNF, 2. Install DNF Repos, 3. Install COPR Repos, 4. Remove Fedora's Flatpak repo and replace it with Flathub
5. Update software from DNF and Flatpak, 6. Install user specificed software, 7. Remove unused software and dependancies

Please make sure you have a backup of your system before proceeding, as this script will make major changes to your system."

echo
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
touch /etc/dnf/dnf.conf
sudo echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
sudo echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf


#    ________  ____  ____  _____
#   / ___/ _ \/ __ \/ __ \/ ___/
#  / /  /  __/ /_/ / /_/ (__  )
# /_/   \___/ .___/\____/____/
#          /_/

echo
echo "■ (2/7) Installing DNF repositories..."
echo

# add RPM Fusion free + non-free repos
echo " ...[1/1] RPM Fusion (free + non-free)"
echo
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


#   _________  ____  _____
#  / ___/ __ \/ __ \/ ___/
# / /__/ /_/ / /_/ / /
# \___/\____/ .___/_/
#          /_/

echo
echo "■ (3/7) Installing COPR repositories..."
echo

# add yumex copr
echo
echo " ...[1/1] Yum Extender (Nobara) from timlau/yumex-ng"
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

# add flatpak if its not installed
sudo dnf install -y flatpak
flatpak update -y

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
sudo dnf install gh git ruby make gcc zsh vim nvim lsd bat fzf mc fd ranger htop btop nvtop fastfetch yt-dlp dnf-plugins-core snapper btrfs-assistant xarchiver thunar terminator kitty yumex parole catfish gpick gparted gnome-disks numix-icon-theme-circle breeze-cursor-theme
sudo dnf install libreoffice*
sudo dnf install p7zip-*
sudo dnf install --allowerasing ffmpeg

# install flatpaks
echo
echo " ...[2/3] from Flatpak"
echo

# web
flatpak install -y com.brave.Browser net.waterfox.waterfox net.mullvad.MullvadBrowser org.telegram.desktop

# audio
flatpak install -y org.tenacityaudio.Tenacity org.gnome.Rhythmbox3 org.soundconverter.SoundConverter org.strawberrymusicplayer.strawberry com.mastermindzh.tidal-hifi io.github.lo2dev.Echo org.audacityteam.Audacity

# video
flatpak install -y tv.plex.PlexDesktop fr.handbrake.ghb io.mpv.Mpv org.videolan.VLC

# images
flatpak install -y org.xfce.ristretto org.darktable.Darktable com.xnview.xnconvert org.inkscape.Inkscape org.kde.krita org.gimp.GIMP

# productivity
flatpak install -y org.onlyoffice.desktopeditors com.logseq.logseq org.gnome.Papers re.sonny.Eloquent dev.zed.Zed

# utilities
flatpak install -y camp.nook.nookdesktop com.github.ADBeveridge.Raider io.github.amit9838.mousam com.bitwarden.desktop it.mijorus.gearlever io.github.flattool.Warehouse io.github.mhogomchungu.media-downloader io.github.PeaZip com.poweriso.PowerISO com.transmissionbt.Transmission


#                                                       ______
#    ________  ____ ___  ____ _   _____     _________  / __/ /__      ______ _________
#   / ___/ _ \/ __ `__ \/ __ \ | / / _ \   / ___/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
#  / /  /  __/ / / / / / /_/ / |/ /  __/  (__  ) /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
# /_/   \___/_/ /_/ /_/\____/|___/\___/  /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/

echo
echo "■ (7/7) Removing unused software and dependancies..."
echo

# remove software
sudo dnf remove dnfdragora gnome-boxes gnome-connections gnome-contacts gnome-maps gnome-tour totem mediawriter firefox rhythmbox claws-mail pidgin transmission asunder pragha atril geany

# remove any unused dependacies
sudo dnf autoremove


clear
echo
echo "
         ____       __                 ______                _                ____         __
  ____ _/ / /  ____/ /___  ____  ___  / / / /  ___  ____    (_)___  __  __   / __/__  ____/ /___  ________ __
 / __  / / /  / __  / __ \/ __ \/ _ \/ / / /  / _ \/ __ \  / / __ \/ / / /  / /_/ _ \/ __  / __ \/ ___/ __  /
/ /_/ / / /  / /_/ / /_/ / / / /  __/_/_/_/  /  __/ / / / / / /_/ / /_/ /  / __/  __/ /_/ / /_/ / /  / /_/ /
\__,_/_/_/   \__,_/\____/_/ /_/\___(_|_|_)   \___/_/ /_/_/ /\____/\__, /  /_/  \___/\__,_/\____/_/   \__,_/
                                                      /___/      /____/
"
