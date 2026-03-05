#!/bin/bash

directoryCreation(){
    set -x
    DESKTOP_DIR=$(xdg-user-dir DESKTOP)
    mkdir -p "$HOME"/Teknoparrot/{GAME,PREFIX,DUMPS,TMP}
    TREE=${HOME}/Teknoparrot
    GAME=${TREE}/GAME
    PREFIX=${TREE}/PREFIX
    RUNNER=${TREE}/RUNNER
    TMP=${TREE}/TMP
    read -p "Press enter to continue"
}

fileExistenceChecker(){
    if [[ -f "$GAME"/TPBootstrapper.exe ]]; then
        rm -rf "$GAME"/TPBootstrapper*
    fi
    if [[ -f "$TREE"/Teknoparrot-Linux ]]; then
        rm -rf "$TREE"/Teknoparrot-Linux
    fi
    if [[ -f "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop ]]; then
        rm -rf "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
    fi
    if [[ -d "$TREE"/RUNNER ]]; then
        rm -rf "$TREE"/RUNNER
    fi
    if [[ -d "$HOME"/.cache/winetricks ]]; then
        rm -rf "$HOME"/.cache/winetricks
    fi
    read -p "Press enter to continue"
}

customRunner(){
    source /etc/os-release
    if [[ $ID == arch ]]; then
    (
    cd "$TMP"
    if [[ ! -f "/usr/bin/yay" ]]; then
        sudo pacman -S --needed base-devel
        wget -c https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
        tar -xvf yay.tar.gz && cd yay
        makepkg -si
    fi
    if [[ ! -d "/opt/wine-ge-custom-opt/" ]]; then
        yay -S wine-ge-custom-bin-opt
    fi
    )
    else
        cd "$TMP"
        wget -c https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton8-26/wine-lutris-GE-Proton8-26-x86_64.tar.xz
        tar -xvf wine-lutris-GE-Proton8-26-x86_64.tar.xz
        sudo mv lutris-GE-Proton8-26-x86_64 /opt/wine-ge-custom-opt
    fi
    ln -s /opt/wine-ge-custom-opt "$TREE"/RUNNER
    set -x
    read -p "Press enter to continue"
}

dependencyInstall(){
    export WINEPREFIX=${PREFIX}
    echo Creating the Wine prefix && wineboot
    echo Downloading .NET Runtime && wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP"
    echo Downloading .NET Desktop Runtime && wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP"
    echo "Installing .NET 4.8 (Legacy Dependency)" && winetricks -q dotnet48
    echo "Installing .NET Runtime" && wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart
    echo "Installing .NET Desktop Runtime" && wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
    echo "Downloading Teknoparrot (Web-Installer)" && wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP"
    (
        echo "Extracting Teknoparrot (Web-Installer)" && unzip "$TMP"/TPBootstrapper.zip -d "$GAME"
        cd "$GAME"
        echo -e "Installing Teknoparrot (Web-Installer)" && wine TPBootstrapper.exe
    )
    rm -rf "$GAME"/TPBootstrapper*
    rm -rf "$TMP"
    read -p "Press enter to continue"
}

executableCreation(){
    cp -r .icon.png "$TREE"
    cd "$TREE"
    HEADER="#!/bin/bash"
    DRIPRIME_FLAG="export DRI_PRIME=0 #If you are using a setup with a hybrid GPU (integrated + dedicated), it is highly recommended that you use DRI_PRIME=1 to utilize your dedicated GPU."
    echo "$HEADER" > Teknoparrot-Linux
    echo "$DRIPRIME_FLAG" >> Teknoparrot-Linux
    echo "export WINEPREFIX=$PREFIX" >> Teknoparrot-Linux
    echo "$RUNNER/bin/wine "$GAME"/TeknoParrotUi.exe" >> Teknoparrot-Linux
    chmod +x Teknoparrot-Linux
    while true; do
        echo -e "Do you want to create a shortcut on your Desktop?\n"
        read -p "[Y/n] " shortcutInput
        if [[ -z "$shortcutInput" ]]; then
            shortcutInput="y"
        fi
        case $shortcutInput in
            [Yy])
                echo "[Desktop Entry]" > "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Exec="$TREE"/Teknoparrot-Linux" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Name=Teknoparrot" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Icon="$TREE"/.icon.png" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Terminal=false" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Type=Application" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                echo "Categories=Game;" >> "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                chmod +x "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop
                cp "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop "$HOME"/.local/share/applications/
                break
            ;;
            [Nn])
                exit
            ;;
            *)
                if [[ -f "$DESKTOP_DIR"/com.sakaki.Teknoparrot.desktop ]]; then
                    break
                fi
                echo -e "\nInvalid value\n"
                sleep 1.5
                clear
            ;;
        esac
    done
    read -p "Press enter to continue"
}

clear
directoryCreation
fileExistenceChecker
customRunner
dependencyInstall
executableCreation
