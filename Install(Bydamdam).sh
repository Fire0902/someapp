#!/bin/bash


if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

echo "Début de l'installation..."


echo "Installation de Visual Studio Code..."
sudo pacman -Sy code --noconfirm

echo "Installation de Steam et de Discord"
sudo pacman -Syu steam discord --noconfirm

echo "Installation WineHQ"
sudo pacman -Syu wine --noconfirm

echo "Installation de QEMU et des dépendances..."
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat --noconfirm


echo "Installation de libvirt et des utilitaires réseau..."
sudo pacman -S libvirt ebtables iptables --noconfirm


echo "Démarrage et activation de libvirt..."
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service


echo "Ajout de l'utilisateur au groupe libvirt..."
sudo usermod -aG libvirt $(whoami)

echo "installation et activation au démarage snapd"

git clone https://aur.archlinux.org/snapd.git
cd snapd
makepkg -si

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap

echo "Voulez-vous installer Hyprland ? (o/n)"
read reponse
reponse=$(echo "$reponse" | tr '[:upper:]' '[:lower:]')
if [[ $reponse = "o" ]]; then
    echo "Installation de Hyprland..."
    git clone https://github.com/JaKooLit/Arch-Hyprland
    cd Arch-Hyprland || exit
    chmod +x install.sh
    ./install.sh
    
    echo "Installation Hyprland terminée."
elif [[ $reponse = "n" ]]; then
    echo "Installation annulée."
else
    echo "Réponse non valide. Veuillez répondre par 'o' ou 'n'."
fi



echo "Voulez-vous installer Gnome ? (o/n)"
read reponse
reponse=$(echo "$reponse" | tr '[:upper:]' '[:lower:]')
if [[ $reponse = "o" ]]; then
   echo "Installation du Desktop Gnome"
   echo -n "Installation : ["
   for i in {1..10}; do
      sudo pacman -Syu gnome
      echo -n "#" 
   done
   echo "] terminée."
   echo "Installation Gnome terminée."
elif [[ $reponse = "n" ]]; then
    echo "Installation annulée."
else
    echo "Réponse non valide. Veuillez répondre par 'o' ou 'n'."
fi

 

echo "Reconnexion nécéssaire"

