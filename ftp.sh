#!/bin/bash

function menu() {
    echo "-------// Gerenciar FTP//-------"
    echo "1) Instalar servidor FTP"
    echo "2) Habilitar acesso anônimo"
    echo "3) Desabilitar acesso anônimo"
    echo "4) Habilitar envio/escrita de arquivos"
    echo "5) Desabilitar envio/escrita de arquivos"
    echo "6) Desinstalar o servidor FTP"
    echo "7) Sair"
    echo "//----------------------------------//"
    read -p "Informe o número da opção desejada: " op
    case "$op" in
        1) op1 ;;
        2) op2 ;;
        3) op3 ;;
        4) op4 ;;
        5) op5 ;;
        6) op6 ;;
        7) op7 ;;
        *) echo "Opção inválida!" ;;
    esac
}

function op1() {
    apt-get update
    apt-get install vsftpd
    menu
    sleep 1
}

function op2() {
    sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
    service vsftpd restart
    menu
    sleep 1
}

function op3() {
    sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd.conf
    service vsftpd restart
    menu
    sleep 1
}

function op4() {
    sed -i 's/#write_enable=NO/write_enable=YES/g' /etc/vsftpd.conf
    service vsftpd restart
    menu
    sleep 1
}

function op5() {
    sed -i 's/write_enable=YES/write_enable=NO/g' /etc/vsftpd.conf
    service vsftpd restart
    menu
    sleep 1
}

function op6() {
    apt-get remove vsftpd
    apt-get purge vsftpd
    menu
    sleep 1
}

function op7() {
    exit
    sleep 1
}

menu
