#!/bin/bash

hostDependencyChecker(){
    dependencies=(wine winetricks bash wget unzip tar zenity)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo -e "$ERROR_LOG $cmd not found" && exit 1
        fi
    done
}

atomicTree(){
    TMP=${TREE}/TMP
    PROGRAM=${TREE}/PROGRAM
    PREFIX=${TREE}/PREFIX
    [ -f "$TREE"/TeknoParrot ] && rm -rf "$TREE"/TeknoParrot
    [ -d "$PROGRAM" ] && rm -rf "$PROGRAM"
    [ -d "$PREFIX" ] && rm -rf "$PREFIX"
    [ -d "$TMP" ] && rm -rf "$TMP"
    mv "$TREE" "$TREE".old
    mkdir -p "$TREE"/{TMP,PROGRAM}
}

dependencyInstall(){
    clear
    export WINEPREFIX=${PREFIX}
    echo -e "$WAIT_LOG Wineboot." && wineboot -u &> $ARL_LOG
        if [ -d "$PREFIX"/drive_c ]; then
            echo -e " $DONE_LOG Structure created!"
            echo -e "$WAIT_LOG Downloading dependencies."
            wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP" &>> $ARL_LOG
            wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP" &>> $ARL_LOG
            winetricks dxvk &>> $ARL_LOG
            echo -e "$WAIT_LOG Installing dependencies."
            wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &>> $ARL_LOG
            wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &>> $ARL_LOG
            echo -e "$WAIT_LOG Downloading TeknoParrot (Web-Installer)."
            wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &>> $ARL_LOG
            [ ! -f "$TMP"/TPBootstrapper.zip ] && echo -e " $ERROR_LOG TPBootstrapper was not downloaded." && exit
            unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM" &>> $ARL_LOG
            [ ! -f "$PROGRAM"/TPBootstrapper.exe ] && echo -e " $ERROR_LOG TPBootstrapper was not extracted." && echo -e " $ERROR_LOG TPBootstrapper was not found." && exit
            (
            cd "$PROGRAM"
            wine TPBootstrapper.exe &>> $ARL_LOG
            [ -f "$PROGRAM"/TeknoParrotUi.exe ] && echo -e " $DONE_LOG TeknoParrot installed!"
            [ ! -f "$PROGRAM"/TeknoParrotUi.exe ] && echo -e " $ERROR_LOG TeknoParrot not installed." && exit
            )
            ls $TREE &>> $ARL_LOG && ls $TREE/* &>> $ARL_LOG
            rm -rf "$PROGRAM"/TPBootstrapper*
            rm -rf "$TMP" && echo -e " $DONE_LOG Temporary files cleared!"
       else
            echo -e " $ERROR_LOG Structure not created." && exit
       fi
}

executableCreation(){
    (
        cd "$TREE"
        HEADER="#!/bin/bash"
        FLAGS="LC_ALL=C LC_NUMERIC=C LANG=en_US.UTF-8 WINEPREFIX=$PREFIX wine $PROGRAM/TeknoParrotUi.exe"
        echo $HEADER > TeknoParrot
        echo $FLAGS >> TeknoParrot
        chmod +x TeknoParrot
    )
}

ARL_NAME="Arcade Wrapper Linux/Unix-like"
ARL_VERSION="3.1-7"
ARL_LOG="/dev/null"
DONE_LOG="\e[1;32m==>\033[0m"
WAIT_LOG="\e[1;33m==>\033[0m"
ERROR_LOG="\e[1;31m==>\033[0m"
TREE=${HOME}/TeknoParrot

case $1 in
    "--help")
        echo -e "\n$ARL_NAME $ARL_VERSION\n\n--help\t\tShow this message.\n--version\tShow wrapper version.\n--custom-dir\tWith this flag you can choose a custom installation directory.\n--debug \tThis executes the script and generates a log file (ARL.LOG) in $HOME.\n"
        exit
    ;;
    "--custom-dir")
        TREE=$(zenity --file-selection --directory --title "Select your desired directory:")/TeknoParrot
    ;;
    "--debug")
        ARL_LOG=$HOME/AR.LOG
    ;;
    "--version")
        echo -e "$ARL_NAME $ARL_VERSION"
        exit
    ;;
esac

hostDependencyChecker
clear
atomicTree
dependencyInstall
executableCreation
