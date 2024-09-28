#!/bin/bash

function instructions() {
    option=$(zenity \
        --list \
        --ok-label "Confirmar" \
        --extra-button "Membros do Grupo" \
        --column "Opção" \
        --column "Descrição" \
        --width 400 \
        --height 350 \
        --title "Comandos Úteis" \
        --text "Selecione uma opção abaixo" \
        1 "🔒 Criar uma regra" \
        2 "⚙️ Configurar Política Padrão" \
        3 "🗑️ Apagar uma regra" \
        4 "📜 Listar todas as regras" \
        5 "🗑️ Apagar todas as regras" \
        6 "💾 Salvar as regras do firewall" \
        7 "🔄 Restaurar as regras do firewall" \
        8 "🚪Sair")

    returnZenity=$?

    if [ "${option,,}" == "" ]; then 
        if [ $returnZenity -eq 0 ]; then 
            return 10 
        else 
            return 9 
        fi 
    else 
        if [[ $option = "Membros do Grupo" ]]; then 
            return 11
        fi 

        return $option
    fi
}

function redirectUser() {
    case $1 in 
        1) createRule;;
        2) createDefaultPolicy;;
        3) remove;;
        4) showIptables;;
        5) removeAll;;
        6) saveData;;
        7) recoveryData;;
        *) echo "Invalid Option";;
    esac
}

function setDefaultValue() {
    if [ -z $1 ]; then 
        echo -1 
    else 
        echo "$1"
    fi 
}

function createRule() {
    insert="-$(zenity \
        --list \
        --column "Opção" \
        --column "Descrição" \
        --width 300 \
        --height 200 \
        --title "Onde você deseja criar a regra?" \
        --text "Selecione uma opção abaixo" \
        I "Adicionar no início" \
        A "Adicionar no final")"
    
    if [ $insert = "-" ]; then 
       return 1
    fi

    chain=$(zenity \
        --list \
        --width 700 \
        --height 200 \
        --text "Escolha uma Cadeia" \
        --column "Cadeia" \
        --column "Utilização" \
        INPUT "Aplica regras aos pacotes de rede que chegam ao servidor." \
        OUTPUT "Aplica regras aos pacotes de rede originados e que partem do servidor." \
        FORWARD "Aplica regras aos pacotes de rede roteados através do servidor." 
    )

    if [ -z $chain ]; then 
       return 1
    fi

    target=$(zenity \
        --list \
        --width 500 \
        --height 200 \
        --text "Alvo da Regra" \
        --column "Regra" \
        --column "Descrição" \
        ACCEPT "O pacote é permitido" \
        REJECT "Descarta o pacote e envia feedback ao remetente." \
        DROP "Descartar o pacote" \
    )

    if [ -z $target ]; then 
       return 1
    fi

    flags=("-s" "-d" "-p" "--sport" "--dport" "-m mac" "-m state" "-i" "-o")

    catchValues=$(zenity \
        --forms \
        --title "Parâmetros" \
        --text "Escreva um ou vários valores" \
        --add-entry "Endereço de Origem (Ex:.. 111.111.111.111)" \
        --add-entry "Endereço de Destino (Ex:.. 222.222.222.222)" \
        --add-entry "Protocolo (Ex:.. udp, tcp, icmp)" \
        --add-entry "Porta de Origem (Ex:.. 80, 443, 5432)" \
        --add-entry "Porta de Destino (Ex:.. 80, 443, 5432)" \
        --add-entry "Endereço MAC (Ex:.. 00:11:22:33:44:55)" \
        --add-entry "Estado (Ex:.. ESTABLISHED, RELATED, NEW, INVALID)" \
        --add-entry "Interface de Entrada (Ex:.. eth0, eth1)" \
        --add-entry "Interface de Saída (Ex:.. eth0, eth1)" \
    )

    if [ -z $catchValues ]; then 
        return 1
    fi

    IFS='|' read -r endereco_origem endereco_destino protocolo porta_origem porta_destino endereco_mac estado interface_entrada interface_saida <<< "$catchValues"

    values=(
        "$(setDefaultValue "$endereco_origem")" 
        "$(setDefaultValue "$endereco_destino")" 
        "$(setDefaultValue "$protocolo")" 
        "$(setDefaultValue "$porta_origem")" 
        "$(setDefaultValue "$porta_destino")" 
        "$(setDefaultValue "$endereco_mac")" 
        "$(setDefaultValue "$estado")"  
        "$(setDefaultValue "$interface_entrada")" 
        "$(setDefaultValue "$interface_saida")" 
    )

    params=""

    for i in "${!values[@]}"; do 
        value="${values[i]}"
        flag="${flags[i]}"

        if [ "$value" != -1 ]; then 
            params+="$flag $value "
        fi
    done 

    sudo iptables $insert $chain $params -j $target

    zenity --info --text "Regra criada com sucesso!"
}

function createDefaultPolicy() {
    chain=$(zenity \
        --list \
        --width 700 \
        --height 200 \
        --text "Escolha uma Cadeia" \
        --column "Cadeia" \
        --column "Utilização" \
        INPUT "Aplica regras aos pacotes de rede que chegam ao servidor." \
        OUTPUT "Aplica regras aos pacotes de rede originados e que partem do servidor." \
        FORWARD "Aplica regras aos pacotes de rede roteados através do servidor." 
    )

    if [ -z $chain ]; then 
        return 1
    fi
       
    target=$(zenity \
        --list \
        --width 500 \
        --height 200 \
        --text "Alvo da Regra" \
        --column "Regra" \
        --column "Descrição" \
        ACCEPT "O pacote é permitido" \
        DROP "Descartar o pacote" \
    )

    if [ -z $target ]; then 
        return 1
    fi

    sudo iptables -P $chain $target

    zenity --info --text "Política padrão configurada com sucesso!"
}

function remove() {
    chain=$(zenity \
        --list \
        --width 700 \
        --height 200 \
        --text "Escolha uma Cadeia" \
        --column "Cadeia" \
        --column "Utilização" \
        INPUT "Aplica regras aos pacotes de rede que chegam ao servidor." \
        OUTPUT "Aplica regras aos pacotes de rede originados e que partem do servidor." \
        FORWARD "Aplica regras aos pacotes de rede roteados através do servidor." 
    )

    if [ -z $chain ]; then 
        return 1
    fi
    code=$(zenity --entry --text "Qual o número da regra?")

    if [ -z $code ]; then 
        return 1
    fi

    sudo iptables -D "$chain" "$code"

    zenity --info --text "Regra apagada com sucesso!"
}

function removeAll() {
    zenity --question --title "Atenção" --text "Você realmente deseja apagar todas as regras?"

    if [ $? -eq 0 ]; then 
        sudo iptables -F
        sudo iptables -X
        zenity --info --text "Regras apagadas com sucesso!"
    fi
}

function showIptables() {
    sudo iptables -L | zenity --text-info --width 700 --height 500 --title "Listagem das regras" --ok-label "Voltar"
}

function saveData() {
    sudo iptables-save > firewall_rules.txt
    realpath firewall_rules.txt | zenity --text-info --title "Arquivo salvo em"
}

function recoveryData() {
    sudo iptables-restore < firewall_rules.txt 
    zenity --info --text "Regras restauradas com sucesso!"
}

function executeApp() {
    while [ true ]; do
        instructions

        option=$?

        case $option in 
            8) exit;;
            9) exit;;
            11) zenity --info --width 500 --height 50 --text "Livia Guimarães de Jesus | Gabriel Cardoso Girarde | Marcelo Alves dos Santos";;
            *)  redirectUser $option;;
        esac
    done
}

executeApp