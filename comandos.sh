#!/bin/bash

function menu() {
    option=$(zenity \
        --list \
        --column "Opção" \
        --column "Descrição" \
        --width 600 \
        --height 500 \
        --title "Comandos Úteis" \
        --text "Selecione uma opção abaixo" \
        1 "Listar o conteúdo de um diretório" \
        2 "Listar o conteúdo de um diretório com todas as informações" \
        3 "Criar uma cópia de um arquivo" \
        4 "Criar uma cópia de um diretório" \
        5 "Renomear/Mover um arquivo" \
        6 "Renomear/Mover um diretório" \
        7 "Deletar/Apagar um arquivo" \
        8 "Deletar/Apagar um diretório" \
        9 "Visualize o conteúdo de um arquivo" \
        10 "Visualize o conteúdo de um arquivo com pausa" \
        11 "Exiba quantas linhas tem um arquivo" \
        12 "Qual o número da linha de um arquivo que possui determinada palavra"  \
        13 "Exiba as N primeiras linhas de um arquivo" \
        14 "Exiba as N últimas linhas de um arquivo" \
        15 "Exiba o caminho do diretório atual" \
        16 "Exiba o usuário autenticado atualmente no terminal" \
        17 "Exiba os usuários autenticados em todo o sistema" \
        18 "Troque a senha de um usuário do sistema" \
        19 "Adicione um usuário ao sistema" \
        20 "Remover um usuário completamente do sistema")
    case "$option" in
        1) op1 ;;
        2) op2 ;;
        3) op3 ;;
        4) op4 ;;
        5) op5 ;;
        6) op6 ;;
        7) op7 ;;
        8) op8 ;;
        9) op9 ;;
        10) op10 ;;
        11) op11 ;;
        12) op12 ;;
        13) op13 ;;
        14) op14 ;;
        15) op15 ;;
        16) op16 ;;
        17) op17 ;;
        18) op18 ;;
        19) op19 ;;
        20) op20 ;;
        *) break ;; 
    esac
}

function op1() {
    caminho=`zenity --entry --text="Informe o caminho do diretório a ser listado: "`
    echo
    ls $caminho
    sleep 1
}

function op2() {
    caminho=`zenity --entry --text="Informe o caminho do diretório que terá o conteúdo listado: "`
    echo
    ls -la $caminho
    sleep 1
}

function op3() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser copiado: "` 
    caminhonovo=`zenity --entry --text="Digite o caminho do local onde o arquivo será colado: "`
    echo
    cp $caminho $caminhonovo
    sleep 1
}

function op4() {
    caminho=`zenity --entry --text="Digite o caminho do diretório a ser copiado: "`
    caminhonovo=`zenity --entry --text="Digite o caminho do local onde o diretório será colado: "`
    echo
    cp -R $caminho $caminhonovo
    sleep 1
}

function op5() {
    nome=`zenity --entry --text="Digite o nome/caminho do arquivo a ser renomeado/movido: "`
    caminho=`zenity --entry --text="Digite o novo nome/caminho do arquivo: "`
    echo
    mv $nome $caminho
    sleep 1
}

function op6() {
    nome=`zenity --entry --text="Digite o nome/caminho do diretório a ser movido ou renomeado: "`
    caminho=`zenity --entry --text="Digite o novo nome/caminho do diretório a ser movido ou renomeado: "`
    echo
    mv $nome $caminho
    sleep 1
}

function op7() {
    nome=`zenity --entry --text="Digite o nome do arquivo a ser excluído: "`
    echo
    rm $nome
    sleep 1
}

function op8() {
    caminho=`zenity --entry --text="Digite o caminho do diretório a ser excluído: "`
    echo
    rm -r $caminho
    sleep 1
}

function op9() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser visualizado: "`
    echo
    cat $caminho
    sleep 1
}

function op10() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser visualizado com pausa: "`
    echo
    cat $caminho | more
    sleep 1
}

function op11() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ter as linhas contadas: "`
    echo
    wc -l $caminho
    sleep 1
}

function op12() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser visualizado: "`
    palavra=`zenity --entry --text="Digite a palavra a ser filtrada no arquivo: "`
    echo
    cat $caminho | grep -n $palavra
    sleep 1
}

function op13() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser visualizado: "`
    num=`zenity --entry --text="Digite o número de linhas a ser visualizadas: "`
    echo
    head -n $num $caminho
    sleep 1
}

function op14() {
    caminho=`zenity --entry --text="Digite o caminho do arquivo a ser visualizado: "`
    num=`zenity --entry --text="Digite o número de linhas a ser visualizadas: "`
    echo
    tail -n $num $caminho
    sleep 1
}

function op15() {
    echo
    pwd 
    sleep 1
}

function op16() {
    echo
    whoami
    sleep 1
}

function op17() {
    echo
    w
    sleep 1
}

function op18() {
    nome=`zenity --entry --text="Digite o nome do usuário que terá a senha trocada: "`
    echo
    passwd $nome
    sleep 1
}

function op19() {
    nome=`zenity --entry --text="Digite o nome do usuário a ser criado: "`
    echo
    adduser $nome
    sleep 1
}

function op20() {
    nome=`zenity --entry --text="Digite o nome do usuário a ser removido do sistema: "`
    echo
    userdel -r $nome
    sleep 1
}

resp=0

while [ $resp -eq 0 ]
do
    menu
    echo
    zenity --question --text="Deseja continuar?"
    resp=$?
    clear
done

exit
