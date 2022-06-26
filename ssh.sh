#!/bin/bash
## Update Repository

apt update

## Install sudo

apt install sudo

## Install SSH Server

apt install openssh-server

## Erstelle SSH Verzeichnis

mkdir /root/.ssh
## Erlaube den Login als root

echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config

## Importiere SSH Key

echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIUVnpiLRw847wQn1tlJWtyNr6UBJA8zfdOwA3CJw5M+Txd/J68zSwsJs7OrTXPB00JPwWp1b595XuLqzQD3DNn4VUr8I8exjcAKQM5jzwTG4CYoXYmfgruetNbTOMVGt5JuoVYMZdVL7CX93QApokPs0HBiQecbPxGXhJ0RKAOz/bbb3f3wbN5b+PassZwdWO3ZN/oNtPrh8quecrpukXrTMTOx4uoUMo6VNKqE1g+XhpwzIdlrxqRSVtuHpo14JiicpoxzF582Uxrm2N3tYB9OYN910jOFN4J3NugLSwr2/CimlwfTxd/g+65LiNsCQtNyx6ktkzV8hiNz/FPb1D rsa-key-20211127 >> ~/.ssh/authorized_keys

## Starte den SSH Dienst neu

sudo systemctl restart sshd