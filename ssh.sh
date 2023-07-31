#!/bin/bash

# Überprüfen, ob das Skript mit Root-Rechten ausgeführt wird
if [ "$EUID" -ne 0 ]; then
    echo "Dieses Skript muss mit Root-Rechten ausgeführt werden. Bitte verwenden Sie sudo."
    exit 1
fi

# Funktion zur Installation des SSH-Servers
install_ssh_server() {
    echo "Der SSH-Server ist nicht installiert. Installation wird gestartet..."
    apt install -y openssh-server
    echo "Der SSH-Server wurde erfolgreich installiert."
}

# Überprüfen, ob der SSH-Server installiert ist
if ! command -v ssh >/dev/null; then
    install_ssh_server
else
    echo "Der SSH-Server ist bereits installiert."
fi

# Überprüfen, ob der Benutzer "linuxadmin" existiert
if id "linuxadmin" &>/dev/null; then
    echo "Der Benutzer linuxadmin existiert bereits."
else
    # Benutzer "linuxadmin" erstellen und ihm sudo-Berechtigungen zuweisen
    echo "Erstelle den Benutzer linuxadmin mit dem Passwort 12345678..."
    useradd -m -s /bin/bash linuxadmin
    echo "linuxadmin:12345678" | chpasswd
    usermod -aG sudo linuxadmin
    echo "Der Benutzer linuxadmin wurde erfolgreich erstellt und hat nun sudo-Berechtigungen."
fi

# SSH-Schlüssel "rsa-key-20211127" zum authorized_keys des linuxadmin-Benutzers hinzufügen
echo "Füge den SSH-Schlüssel rsa-key-20211127 zum authorized_keys des linuxadmin-Benutzers hinzu..."
mkdir -p /home/linuxadmin/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIUVnpiLRw847wQn1tlJWtyNr6UBJA8zfdOwA3CJw5M+Txd/J68zSwsJs7OrTXPB00JPwWp1b595XuLqzQD3DNn4VUr8I8exjcAKQM5jzwTG4CYoXYmfgruetNbTOMVGt5JuoVYMZdVL7CX93QApokPs0HBiQecbPxGXhJ0RKAOz/bbb3f3wbN5b+PassZwdWO3ZN/oNtPrh8quecrpukXrTMTOx4uoUMo6VNKqE1g+XhpwzIdlrxqRSVtuHpo14JiicpoxzF582Uxrm2N3tYB9OYN910jOFN4J3NugLSwr2/CimlwfTxd/g+65LiNsCQtNyx6ktkzV8hiNz/FPb1D rsa-key-20211127" >> /home/linuxadmin/.ssh/authorized_keys
chown -R linuxadmin:linuxadmin /home/linuxadmin/.ssh
echo "Der SSH-Schlüssel ssh-rsafd45d6g wurde erfolgreich zum authorized_keys des linuxadmin-Benutzers hinzugefügt."

# Root-Login über SSH verbieten
echo "Verbiete den Root-Login über SSH..."
sed -i '/^PermitRootLogin/ c\PermitRootLogin no' /etc/ssh/sshd_config
echo "Root-Login über SSH wurde verboten."

# Neustart des SSH-Servers, um die Änderungen zu übernehmen
echo "Starte den SSH-Server neu..."
systemctl restart sshd
echo "Der SSH-Server wurde erfolgreich neu gestartet."

# Installiere die UFW Firewall
echo "Installiere die UFW Firewall..."
apt install -y ufw

# Firewall-Konfiguration
echo "Konfiguriere die Firewall..."
ufw default allow outgoing
ufw default deny incoming
ufw allow 22
ufw --force enable
echo "Die Firewall wurde konfiguriert und aktiviert."

# Aktualisiere die Paketlisten
apt update

# Installiere verfügbare Updates
apt upgrade -y

# Bereinige unnötige Paketabhängigkeiten
apt autoremove -y

# Zeige eine Erfolgsmeldung an
echo "Alle verfügbaren Updates wurden erfolgreich installiert."
