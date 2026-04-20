#!/bin/bash

AWL_NAME="Arcade Wrapper Linux" && AWL_VERSION="3.2-3" && AWL_LOG="/dev/null"
DEFAULT_COLOR="\033[0m" BOLD_COLOR="\033[1m" && DONE_LOG="\e[1;32mOK\033[0m" && NORMAL_LOG="\e[1;34m*\033[0m" && ERROR_LOG="\e[1;31mERROR\033[0m"
TREE=${HOME}/TeknoParrot
DXVK_VERSION="2.7.1"

primaryDependencyChecker(){
    dependencies=(umu-run wine bash wget unzip tar zenity)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            printf "$NORMAL_LOG $cmd not found. $ERROR_LOG\n" && exit 1
        fi
    done
}

atomicTree(){
    PROGRAM=${TREE}/bin
    PREFIX=${TREE}/pfx
    TMP=${PREFIX}/drive_c/tmp
    [ -f "$TREE"/awl ] && rm -r "$TREE"/awl
    [ -d "$PROGRAM" ] && rm -r "$PROGRAM"
    [ -d "$PREFIX" ] && rm -r "$PREFIX"
    mv "$TREE" -T "$TREE".old
    mkdir -p "$TREE"/{bin,pfx} && mkdir -p "$PREFIX/drive_c/tmp"
}

dependencyInstall(){
    clear
    export WINEPREFIX=${PREFIX}
    printf "$NORMAL_LOG Wineboot. ($PREFIX)" && wineboot -u &> $AWL_LOG
    if [ -d "$PREFIX"/drive_c ]; then
        printf " $DONE_LOG\n$NORMAL_LOG Downloading dependencies."
        wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP" &>> $AWL_LOG
        wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP" &>> $AWL_LOG
        wget -c https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe --directory-prefix="$TMP" &>> $AWL_LOG
        wget -c https://github.com/doitsujin/dxvk/releases/download/v$DXVK_VERSION/dxvk-$DXVK_VERSION.tar.gz --directory-prefix="$TMP" &>> $AWL_LOG
        [ ! -f "$TMP"/dotnet-runtime-win-x64.exe ] && printf " $ERROR_LOG\n" && exit
        [ ! -f "$TMP"/windowsdesktop-runtime-win-x64.exe ] && printf " $ERROR_LOG\n" && exit
        [ ! -f "$TMP"/directx_Jun2010_redist.exe ] && printf " $ERROR_LOG\n" && exit
        [ ! -f "$TMP"/dxvk-$DXVK_VERSION.tar.gz ] && printf " $ERROR_LOG\n" && exit
        printf " $DONE_LOG\n$NORMAL_LOG Installing dependencies."
        wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &>> $AWL_LOG
        wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &>> $AWL_LOG
        wine "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\TMP" &>> $AWL_LOG
        wine "$TMP"/DXSETUP.exe /silent &>> $AWL_LOG
        tar -xvf "$TMP"/dxvk-$DXVK_VERSION.tar.gz --directory "$TMP" &>> $AWL_LOG
        mv "$TMP"/dxvk-$DXVK_VERSION/x32/*.dll "$PREFIX"/drive_c/windows/syswow64
        mv "$TMP"/dxvk-$DXVK_VERSION/x64/*.dll "$PREFIX"/drive_c/windows/system32
        wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d10core /d native,builtin /f &>> $AWL_LOG
        wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d11 /d native,builtin /f &>> $AWL_LOG
        wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d8 /d native,builtin /f &>> $AWL_LOG
        wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d9 /d native,builtin /f &>> $AWL_LOG
        wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v dxgi /d native,builtin /f &>> $AWL_LOG
        printf " $DONE_LOG\n$NORMAL_LOG Downloading TeknoParrot (Web-Installer)."
        wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &>> $AWL_LOG
        [ ! -f "$TMP"/TPBootstrapper.zip ] && printf " $ERROR_LOG\n" && exit
        (
        unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM" &>> $AWL_LOG
        cd "$PROGRAM"
        wine TPBootstrapper.exe &>> $AWL_LOG
        [ -f "$PROGRAM"/TeknoParrotUi.exe ] && printf " $DONE_LOG\n"
        [ ! -f "$PROGRAM"/TeknoParrotUi.exe ] && printf " $ERROR_LOG\n" && exit
        )
        ls $TREE &>> $AWL_LOG && ls $TREE/* &>> $AWL_LOG
        rm -f "$PROGRAM"/TPBootstrapper*
        rm -r "$TMP" && printf "$NORMAL_LOG Temporary files cleared. $DONE_LOG\n"
        cp -rT "$PREFIX" "$TREE"/pfx_umu
    else
        printf " $ERROR_LOG\n" && exit
    fi
}

executableCreation(){
    sed -i "s|^\s*AWL_LOCATION=.*|AWL_LOCATION=\"$TREE\"|" awl.sh
    sed -i "s|^\s*TEKNO_LOCATION=.*|TEKNO_LOCATION=\"$PROGRAM\"|" awl.sh
    sed -i "s|^\s*PREFIX_LOCATION=.*|PREFIX_LOCATION=\"$PREFIX\"|" awl.sh
    chmod +x awl.sh
    mv awl.sh "$TREE"/awl
}

case $1 in
    "--help")
        echo -e "$AWL_NAME $AWL_VERSION\n$BOLD_COLOR--help$DEFAULT_COLOR\t\tShow this message.\n$BOLD_COLOR--version$DEFAULT_COLOR\tShow wrapper version.\n\n\e[0;40m./install @args$DEFAULT_COLOR\n\n@args:\n $BOLD_COLOR--debug$DEFAULT_COLOR\tThis executes the script and generates a log file (awl.log) in $HOME.\n $BOLD_COLOR--custom-dir$DEFAULT_COLOR\tWith this flag you can choose a custom installation directory."
        exit
    ;;
    "--custom-dir")
        TREE=$(zenity --file-selection --directory --title "Select your desired directory:")/TeknoParrot
        [[ $2 == "-debug" ]] && AWL_LOG=$HOME/awl.log
    ;;
    "--debug")
        AWL_LOG=$HOME/AWL.LOG
    ;;
    "--version")
        echo -e "$AWL_NAME $AWL_VERSION"
        exit
    ;;
esac

primaryDependencyChecker
git pull
atomicTree
dependencyInstall
executableCreation
