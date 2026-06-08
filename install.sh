#!/bin/bash

DXVK_VERSION="2.7.1"
UMU_VERSION="10.0-4"
UMU_MONO_VERSION="10.0.0"

INSTALLER_DIR=$(pwd)
TREE=${HOME}/.local/share/awl
PROGRAM=${TREE}/bin
TMP=${TREE}/tmp
PREFIX=${TREE}/pfx
PREFIX_UMU=${TREE}/pfx_umu

primaryDependencyChecker(){
    dependencies=(umu-run wine bash wget unzip tar)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            printf "\e[1;91mERROR:\033[0m $cmd, install it and try again.\n" && exit 1
        fi
    done
}

firstLock(){
    while true; do
        clear
        printf "\e[1;33mWARNING:\033[0m This will delete everything contained in $TREE\nFor more installation methods, type: '\e[1m./install --help\033[0m'\nWould you like to continue with a clean installation?\n"
        read -p "[Y/n]: " cleanInstallSelection
        [[ -z $cleanInstallSelection ]] && cleanInstallSelection="y"
        if [[ $cleanInstallSelection == "Y" || $cleanInstallSelection == "y" ]]; then
	        [[ -d "$TREE" ]] && rm -rf "$TREE"
            [[ -d "$HOME"/.local/bin/awl ]] && rm -rf "$HOME"/.local/bin/awl
            mkdir -p "$TREE"/{bin,pfx,pfx_umu,tmp}
            break
        elif [[ $cleanInstallSelection == "N" || $cleanInstallSelection == "n" ]]; then
            exit
        else
            printf "\e[1;91mERROR:\033[0m Invalid option.\n"
            sleep 1.5
        fi
    done
}

downloadGlobalDependencies(){
    wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP"
    wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP"
    wget -c https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe --directory-prefix="$TMP"
}

prefixBuildWine(){
    export WINEPREFIX=${PREFIX}
    wineboot -u
    wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart
    wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
    wine "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\tmp"
    wine "$PREFIX"/drive_c/tmp/DXSETUP.exe /silent
    wget -c https://github.com/doitsujin/dxvk/releases/download/v$DXVK_VERSION/dxvk-$DXVK_VERSION.tar.gz --directory-prefix="$TMP"
    tar -xvf "$TMP"/dxvk-$DXVK_VERSION.tar.gz --directory "$TMP"
    mv "$TMP"/dxvk-$DXVK_VERSION/x32/*.dll "$PREFIX"/drive_c/windows/syswow64
    mv "$TMP"/dxvk-$DXVK_VERSION/x64/*.dll "$PREFIX"/drive_c/windows/system32
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d10core /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d11 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d8 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d9 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v dxgi /d native,builtin /f
}

prefixBuildUMU(){
    wget -c https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-$UMU_VERSION/UMU-Proton-$UMU_VERSION.tar.gz --directory-prefix="$TMP"
    wget -c https://github.com/wine-mono/wine-mono/releases/download/wine-mono-$UMU_MONO_VERSION/wine-mono-$UMU_MONO_VERSION-x86.msi --directory-prefix="$TMP"
    tar -xvf "$TMP"/UMU-Proton-$UMU_VERSION.tar.gz --directory "$TMP"
    mv "$TMP"/UMU-Proton-$UMU_VERSION -T "$TREE"/umu
    export GAMEID=0
    export PROTONPATH="$TREE"/umu
    export WINEPREFIX=${PREFIX_UMU}
    umu-run wineboot -u
    umu-run msiexec /i "$TMP"/wine-mono-$UMU_MONO_VERSION-x86.msi
    umu-run "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart
    umu-run "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
    umu-run "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\tmp"
    umu-run "$PREFIX_UMU"/drive_c/tmp/DXSETUP.exe /silent
}

binaryInstall(){
    wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP"
    unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM"
    (cd "$PROGRAM" && wine TPBootstrapper.exe)
    cp -r "$INSTALLER_DIR"/src/{awl,game-list} "$TREE"/
    [[ ! -d "$HOME"/.local/bin ]] && mkdir -p "$HOME"/.local/bin
    ln -sf "$TREE"/awl "$HOME"/.local/bin/awl
}

case $1 in
    "--help")
        printf "\n\e[1minfo:\033[0m\n"
        printf "%-35s%-5s\n" "--help" "show this message."
        printf "%-35s%-5s\n\n" "--version" "show wrapper version."
        printf "\e[1minstallation methods:\033[0m\n"
        printf "%-35s%-5s\n" "./install.sh" "clean installation (default)." 
        printf "%-35s%-5s\n\n" "./install.sh --custom" "runs the installer in custom mode." 
        printf "\e[1mcustom additional flags:\033[0m\n"
        printf "%-35s%-5s\n" "--custom --prefix-only" "creates only the Wine prefix." 
        printf "%-35s%-5s\n" "--custom --prefix-umu-only" "creates only the UMU prefix." 
        printf "%-35s%-5s\n" "--custom --umu-proton-only" "installs only the UMU Proton files." 
        printf "%-35s%-5s\n\n" "--custom --binary-only" "installs only the binary files."
        exit
    ;;
    "--custom")
        mkdir -p "$TREE"/tmp
        if [[ -z $2 ]]; then
            printf "\e[1;91mERROR:\033[0m Empty option.\n\e[1mTry './install.sh --help' for more information.\033[0m\n" && exit 1
        elif [[ $2 == "--prefix-only" ]]; then
                mkdir -p "$TREE"/pfx
                downloadGlobalDependencies
                prefixBuildWine
            elif [[ $2 == "--prefix-umu-only" ]]; then
                mkdir -p "$TREE"/pfx_umu
                downloadGlobalDependencies
                prefixBuildUMU
        elif [[ $2 == "--umu-proton-only" ]]; then
                mkdir -p "$TREE"/umu
                wget -c https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-$UMU_VERSION/UMU-Proton-$UMU_VERSION.tar.gz --directory-prefix="$TMP"
                tar -xvf "$TMP"/UMU-Proton-$UMU_VERSION.tar.gz --directory "$TMP"
                mv "$TMP"/UMU-Proton-$UMU_VERSION -T "$TREE"/umu
        elif [[ $2 == "--binary-only" ]]; then
                export WINEPREFIX=${PREFIX}
                binaryInstall
            else
            printf "\e[1;91mERROR:\e[0m Invalid Option.\n"
        fi
        exit
    ;;
    "--version")
        printf "awl-installer $SCRIPT_VERSION\n"
        exit
    ;;
esac

primaryDependencyChecker
firstLock
downloadGlobalDependencies
prefixBuildWine
prefixBuildUMU
binaryInstall

rm -rf "$PREFIX"/drive_c/tmp "$PREFIX_UMU"/drive_c/tmp
rm -rf "$PROGRAM"/TPBootstrapper*
rm -rf "$TMP"

wineserver -w
printf "\e[1;92mDone!\n\e[0m"
