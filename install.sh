#!/bin/bash

UMU_VERSION="10.0-4"
UMU_MONO_VERSION="10.0.0"

INSTALLER_DIR=$(pwd)
TREE="$HOME/.local/share/awl"
PROGRAM="$TREE/bin"
TMP="$TREE/tmp"
RUNNER="$TREE/proton-umu"
PREFIX_UMU="$TREE/pfx_umu"

primaryDepCheck(){
    dependencies=(umu-run bash wget unzip tar)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            printf "\e[0;91mERROR:\033[0m $cmd is not installed, install it and try again.\nFor more information, see: \e[1mhttps://github.com/sakaki91/Arcade.Wrapper-Linux/wiki/3.-Dependencies-and-Distros-Hardware-tested\e[0m\n" && exit
        fi
    done
}

firstLock(){
    while true; do
        clear
        printf "\e[0;33mWARNING:\033[0m This will delete everything contained in \e[1m$TREE\e[0m\nWould you like to continue with a clean installation?\n"
        read -p "[Y/n]: " cleanInstallSelection
        [[ -z $cleanInstallSelection ]] && cleanInstallSelection="y"
        if [[ $cleanInstallSelection == "Y" || $cleanInstallSelection == "y" ]]; then
            [[ -d "$TREE" ]] && rm -rf "$TREE"
            mkdir -p "$TREE"/{bin,pfx_umu,tmp}
            break
        elif [[ $cleanInstallSelection == "N" || $cleanInstallSelection == "n" ]]; then
            exit
        else
            printf "\e[0;91mERROR:\033[0m Invalid option.\n"
            sleep 1.5
        fi
    done
}

downGlobalDeps(){
    STATUS="\e[0;33m*\e[0m"
    while true; do
        clear
        guestDependencies=(dotnet-runtime-win-x64.exe windowsdesktop-runtime-win-x64.exe directx_Jun2010_redist.exe UMU-Proton-$UMU_VERSION.tar.gz wine-mono-$UMU_MONO_VERSION-x86.msi TPBootstrapper.zip)
        printf "[ $STATUS ] Downloading .NET 8 Runtime.\n"
        [[ ! -f "$TMP"/${guestDependencies[0]} ]] && wget -c https://aka.ms/dotnet/8.0/${guestDependencies[0]} --directory-prefix="$TMP" &> "$TREE"/.awl-log
        printf "[ $STATUS ] Downloading .NET 8 Desktop Runtime.\n"
        [[ ! -f "$TMP"/${guestDependencies[1]} ]] && wget -c https://aka.ms/dotnet/8.0/${guestDependencies[1]} --directory-prefix="$TMP" &>> "$TREE"/.awl-log
        printf "[ $STATUS ] Downloading DirectX Standalone Installer.\n"
        [[ ! -f "$TMP"/${guestDependencies[2]} ]] && wget -c https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/${guestDependencies[2]} --directory-prefix="$TMP" &>> "$TREE"/.awl-log
        printf "[ $STATUS ] Downloading UMU-Proton.\n"
        [[ ! -f "$TMP"/${guestDependencies[3]} ]] && wget -c https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-$UMU_VERSION/${guestDependencies[3]} --directory-prefix="$TMP" &>> "$TREE"/.awl-log
        printf "[ $STATUS ] Downloading Wine-Mono for UMU-Proton.\n"
        [[ ! -f "$TMP"/${guestDependencies[4]} ]] && wget -c https://github.com/wine-mono/wine-mono/releases/download/wine-mono-$UMU_MONO_VERSION/${guestDependencies[4]} --directory-prefix="$TMP" &>> "$TREE"/.awl-log
        printf "[ $STATUS ] Downloading TPBootstrapper.\n"
        [[ ! -f "$TMP"/${guestDependencies[5]} ]] && wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &>> "$TREE"/.awl-log
        [[ "$STATUS" == "\e[0;32m*\e[0m" ]] && break
        for deps in "${guestDependencies[@]}"; do
            if [[ ! -f "$TMP"/"$deps" ]]; then
                printf "\e[0;91mERROR:\033[0m There was an error downloading the dependencies, see the log file at: $TREE/.awl-log\n" && exit
            else
                STATUS="\e[0;32m*\e[0m"
            fi
        done
    done
}

prefixBuildUMU(){
    clear
    printf "[ \e[0;33m*\e[0m ] Extracting UMU-Proton.\n"
    tar -xf "$TMP/${guestDependencies[3]}" --directory "$TMP"
    [[ ! -d "$TMP/UMU-Proton-$UMU_VERSION" ]] && printf "\e[0;91mERROR:\033[0m An error occurred while extracting umu proton. Please refer to the log file at: $TREE/.awl-log\n" && exit
    mv "$TMP"/UMU-Proton-$UMU_VERSION -T "$RUNNER"
    [[ ! -d "$RUNNER" ]] && printf "\e[0;91mERROR:\033[0m An error occurred while moving umu proton. Please refer to the log file at: $TREE/.awl-log\n" && exit
    printf "[ \e[0;33m*\e[0m ] Setting environment variables.\n"
    export GAMEID=0
    export PROTONPATH="$TREE"/proton-umu
    export WINEPREFIX=${PREFIX_UMU}
    printf "[ \e[0;33m*\e[0m ] Creating the structure (prefix).\n"
    umu-run wineboot -u &>> "$TREE"/.awl-log
    [[ ! -d "$PREFIX_UMU"/drive_c ]] && printf "\e[0;91mERROR:\033[0m An error occurred while creating the prefix. Please refer to the log file at: $TREE/.awl-log\n" && exit
    printf "[ \e[0;33m*\e[0m ] Installing Wine-Mono for UMU-Proton.\n"
    umu-run msiexec /i "$TMP"/wine-mono-$UMU_MONO_VERSION-x86.msi &>> "$TREE"/.awl-log
    printf "[ \e[0;33m*\e[0m ] Installing .NET 8 Runtime.\n"
    umu-run "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &>> "$TREE"/.awl-log
    printf "[ \e[0;33m*\e[0m ] Installing .NET 8 Desktop Runtime.\n"
    umu-run "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &>> "$TREE"/.awl-log
    printf "[ \e[0;33m*\e[0m ] Installing DirectX Standalone Installer (#1).\n"
    umu-run "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\tmp" &>> "$TREE"/.awl-log
    printf "[ \e[0;33m*\e[0m ] Installing DirectX Standalone Installer (#2).\n"
    umu-run "$PREFIX_UMU"/drive_c/tmp/DXSETUP.exe /silent &>> "$TREE"/.awl-log
}

binaryInstall(){
    printf "[ \e[0;33m*\e[0m ] Extracting TPBootstrapper.\n"
    unzip "$TMP/${guestDependencies[5]}" -d "$PROGRAM" &>> "$TREE"/.awl-log
    [[ ! -f "$PROGRAM"/TPBootstrapper.exe ]] && printf "\e[0;91mERROR:\033[0m An error occurred while extracting TPBootstrapper. Please refer to the log file at: $TREE/.awl-log\n" && exit
    printf "[ \e[0;33m*\e[0m ] Installing TeknoParrot.\n"
    (cd "$PROGRAM" && wine TPBootstrapper.exe &>> "$TREE"/.awl-log)
    rm -rf "$PREFIX_UMU"/drive_c/tmp
    rm -rf "$PROGRAM"/TPBootstrapper*
    rm -rf "$TMP"
    [[ ! -d "$PREFIX_UMU"/drive_c/tmp || ! -f "$PROGRAM"/TPBootstrapper.exe || ! -d "$TMP" ]] && printf "[ \e[0;32m*\e[0m ] Temporary files cleared.\n"
    cp -r "$INSTALLER_DIR"/src/{awl,game-list} "$TREE"/
    [[ ! -d "$HOME"/.local/bin ]] && mkdir -p "$HOME"/.local/bin
    ln -sf "$TREE"/awl "$HOME"/.local/bin/awl
    [[ -f "$HOME"/.local/bin/awl ]] && printf "[ \e[0;32m*\e[0m ] Shortcut created in \e[1m"$HOME"/.local/bin\e[0m\n"
    if [[ $(cat /etc/passwd | grep "$HOME" | grep bash) ]]; then
        [[ ! $(cat "$HOME"/.bashrc | grep 'PATH="$HOME/.local/bin:$PATH"') ]] && printf "\nThe local binaries directory is NOT added to your shell's path, add it with:\n\e[1mecho 'export PATH="'$HOME/.local/bin:$PATH'"' >> "'$HOME'"/.bashrc\e[0m\n\n"
    elif [[ $(cat /etc/passwd | grep "$HOME" | grep zsh) ]]; then
        [[ ! $(cat "$HOME"/.zshrc | grep 'PATH="$HOME/.local/bin:$PATH"') ]] && printf "\nThe local binaries directory is NOT added to your shell's path, add it with:\n\e[1mecho 'export PATH="'$HOME/.local/bin:$PATH'"' >> "'$HOME'"/.zshrc\e[0m\n\n"
    fi
}

primaryDepCheck
firstLock
downGlobalDeps
prefixBuildUMU
binaryInstall
wineserver -w