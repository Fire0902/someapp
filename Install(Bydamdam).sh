#!/bin/bash


if [ "$(id -u)" != "0" ]; then
   echo "Ce script doit être exécuté en tant que root" 1>&2
   exit 1
fi

echo "Début de l'installation..."


echo "Installation de Visual Studio Code..."
sudo pacman -Sy code --noconfirm


echo "Installation de QEMU et des dépendances..."
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat --noconfirm


echo "Installation de libvirt et des utilitaires réseau..."
sudo pacman -S libvirt ebtables iptables --noconfirm


echo "Démarrage et activation de libvirt..."
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service


echo "Ajout de l'utilisateur au groupe libvirt..."
sudo usermod -aG libvirt $(whoami)

echo "Reconnexion nécéssaire"

