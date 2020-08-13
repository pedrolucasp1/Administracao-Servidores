#!/bin/bash
# -*- coding: utf-8 -*-

#O Script será automaticamente finalizado se encontrar erros
clear
set -euo pipefail
IFS=$'\n\t'

#Redefinir cores
Color_Off='\033[0m'       # Redefinir texto

#Cores regulares
Red='\033[01;31m'           # Red          /     # Vermelho
RedFlash='\033[05;31m'      # RedFlash     /     # Vermelho piscando
Green='\033[01;32m'         # Green        /     # Verde
GreenFlash='\033[05;32m'    # GreenFlash   /     # Verde piscando
Yellow='\033[01;33m'        # Yellow       /     # Amarelo
YellowFlash='\033[05;33m'   # YellowFlash  /     # Amarelo piscando
Purple='\033[01;35m'        # Purple       /     # Roxo
PurpleFlash='\033[05;35m'   # PurpleFlash  /     # Roxo piscando
Cyan='\033[01;36m'          # Cyan         /     # Ciano
CyanFlash='\033[0;36m'      # CyanFlash    /     # Ciano piscando
Blue='\033[01;34m'          # Blue         /     # Azul
BlueFlash='\033[05;34m'     # BlueFlash    /     # Azul piscando
Black='\033[01;30m'         # Black        /     # Preto
BlackFlash='\033[05;30m'    # BlackFlash   /     # Preto piscando
White='\033[01;37m'         # White        /     # Branco
WhiteFlash='\033[05;37m'    # WhiteFlash   /     # Branco piscando

${APACHE_LOG_DIR} = '${APACHE_LOG_DIR}'

#Veriicar a conexão com a internet
clear
echo -e "$Blue #################################################################################### $Color_Off"
echo
echo -e "$Blue [ INTERNET ] $Color_Off $Yellow Testando o acesso a internet $Color_Off $YellowFlash ... $Color_Off"
    if ! ping -c 7 www.google.com > /dev/null ; then
        echo
        echo -e "$Red [ FALHA ] $Color_Off $White Falha na conectividade, verifique o erro, e tente novamente. $Color_Off"
        echo -e "$Green \n Saindo... $Color_Off"
        exit
    else
        echo
        echo -e "$Red [ SUCESSO ] $Color_Off $White Conectividade OK. $Color_Off"
        echo
    fi
echo
echo -e "$Blue #################################################################################### $Color_Off"
clear

clear
#Modificar o arquivo "/etc/apt/sources.list"
echo -e "$Blue  [ ATUALIZANDO ] $Color_Off $WhiteFlash  Atualizando a sources.list .. $Color_Off"
sed -i "1,17d" /etc/apt/sources.list
      echo "####################################################################################" >> /etc/apt/sources.list
      echo "#                               Repositórios Oficiais                              #" >> /etc/apt/sources.list
      echo "####################################################################################" >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo "deb http://deb.debian.org/debian/ stable main contrib non-free" >> /etc/apt/sources.list
      echo "deb-src http://deb.debian.org/debian/ stable main contrib non-free" >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo "deb http://deb.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list
      echo "deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo "deb http://deb.debian.org/debian-security stable/updates main contrib non-free" >> /etc/apt/sources.list
      echo "deb-src http://deb.debian.org/debian-security stable/updates main contrib non-free" >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo "## Debian Stretch Backports" >> /etc/apt/sources.list
      echo "# deb http://ftp.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list
      echo "# deb-src http://ftp.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list
      echo " " >> /etc/apt/sources.list
      echo "####################################################################################" >> /etc/apt/sources.list
clear

#Atualizar os pacotes e o sistema de atualização
echo -e "$Blue  [ ATUALIZANDO ] $Color_Off $WhiteFlash  Atualizando os pacotes e atualizando a distribuição .. $Color_Off"
      apt-get update -y && apt-get upgrade -y 1> /dev/null 2> /dev/stdout
clear

#Instalando firmwares em falta
echo -e "$Blue  [ INSTALANDO ] $Color_Off $WhiteFlash  Instalando firmwares em falta .. $Color_Off"
    apt-get install firmware-linux firmware-linux-nonfree firmware-realtek build-essential -y 1> /dev/null 2> /dev/stdout
clear

#Instalando e configurando autocomplete
echo -e "$Blue  [ INSTALANDO ] $Color_Off $WhiteFlash  Instalando autocomplete .. $Color_Off"
    apt install bash-completion -y 1> /dev/null 2> /dev/stdout
    sed -i '35,41 s/^/#/' /etc/bash.bashrc
clear

#Colorindo o bash
echo -e "$Blue  [ CONFIGURANDO ] $Color_Off $WhiteFlash  Configurando o bash .. $Color_Off"
    sed -i '9,13 s/^/#/' /root/.bashrc
clear

#Instalando ssh server
echo -e "$Blue  [ INSTALANDO ] $Color_Off $WhiteFlash  Instalando o ssh server e configurando .. $Color_Off"
    apt-get install ssh -y 1> /dev/null 2> /dev/stdout
    sed -i 's/#Port 22/Port 54222/g' /etc/ssh/sshd_config
    sed -i 's/#LoginGraceTime 2m/LoginGraceTime 10/g' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
    sed -i 's/#MaxAuthTries 6/MaxAuthTries 4/g' /etc/ssh/sshd_config
    sed -i 's/#MaxSessions 10/MaxSessions 3/g' /etc/ssh/sshd_config
    sed '/MaxSessions 3/a ServerKeyBits 1024' /etc/ssh/sshd_config
    sed '/ServerKeyBits 1024/a AllowUsers globotech' /etc/ssh/sshd_config

    iptables -A INPUT -p tcp --dport 22 -j DROP

    apt-get install fail2ban -y 1> /dev/null 2> /dev/stdout

    /etc/init.d/ssh restart
clear

#Reinicia o servidor
reboot
