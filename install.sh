#!/bin/bash

customDirectoryFunction(){
    clear
    while true; do
        echo -e "Deseja usar um diretorio customizado?\n"
        read -p "[S/n] " customDirectoryInput
        case "$customDirectoryInput" in
        [Ss])
            customDirectory=$(zenity --title "Selecione um diretorio customizado (fallback: $HOME)" --file-selection --directory)
            clear
            case "$customDirectory" in
                "/" | "/boot"* | "/dev"* | "/etc"* | "/sys"* | "/proc"*)
                    echo -e "\e[31mDIRETORIO PROIBIDO, SELECIONE OUTRO.\e[0m"
                    sleep 2.5
                    clear
                ;;
                *)
                    echo -e "\e[32mDIRETORIO VALIDO!\e[0m"
                    #Caso nao seja selecionado nenhum diretorio, o script usara a /home/$USER/ como fallback!
                    sleep 2.5
                    clear
                    break
                ;;
            esac
        ;;
        [Nn])
            customDirectory=$HOME
            clear
            break
        ;;
        *)
            echo -e "\nOpcao Invalida\n"
            sleep 1.5
            clear
        ;;
        esac
    done
}

directoryCreation(){
    cd $customDirectory
    mkdir -p Teknoparrot && cd Teknoparrot
    mkdir -p GAME PREFIX DUMPS TMP
    GAME=${customDirectory}/Teknoparrot/GAME
    PREFIX=${customDirectory}/Teknoparrot/PREFIX
    TMP=${customDirectory}/Teknoparrot/TMP
    cd $customDirectory/Teknoparrot && pwd && ls . && echo -e ""
    while true; do
        echo -e "Gostaria de usar o WineGE? (recomendado para distros nao-rollingrelease)\n"
        read -p "[S/n] " wineGEInstall
        if [[ $wineGEInstall == [Ss] ]]; then
            wget https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz
            tar -xvf wine-lutris-GE-Proton8-26-x86_64.tar.xz
            mv lutris-GE-Proton8-26-x86_64 RUNNER && rm -rf *.tar.xz
            break
        elif [[ $wineGEInstall == [Nn] ]]; then
            break
        else
            echo -e "\nOpcao Invalida\n"
            sleep 1.5
            clear
        fi
    done
}

dependencyInstall(){
    export WINEPREFIX=${PREFIX}
    wineboot
    cd $TMP
    wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe
    wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe
    winetricks -q dotnet48
    wine dotnet-runtime-win-x64.exe /install /quiet /norestart
    wine windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
    wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip && cd $GAME && unzip $TMP/TPBootstrapper.zip
    wine TPBootstrapper.exe
    rm -f $GAME/TPBootstrapper*
    rm -rf $TMP
}

customDirectoryFunction
directoryCreation
dependencyInstall