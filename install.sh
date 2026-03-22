#!/bin/bash

NC="\033[0m"
GREENCOLOR="\e[1;32m"
YELLOWCOLOR="\e[1;33m"
REDCOLOR="\e[1;31m"

creationTree(){
    while true; do
        echo -e "Do you want to use a custom directory? [ default: $HOME ]\n"
        read -p "[ Y/n ] " customDirectoryInput
        case $customDirectoryInput in
            [Yy])
                TREE=$(zenity --file-selection --directory --title "Select your desired directory:")/Teknoparrot
                break
            ;;
            [Nn])
                TREE=${HOME}/Teknoparrot
                break
            ;;
            *)
                echo -e "\n[$REDCOLOR ERROR $NC]\n==> Invalid value"
                sleep 2
                clear
            ;;
        esac
    done
}

variableTree(){
    EXEC_SHORTCUT="$HOME/.local/share/applications/com.sakaki.Teknoparrot.desktop"
    PROGRAM=${TREE}/PROGRAM
    PREFIX=${TREE}/PREFIX
    RUNNER=${TREE}/RUNNER
    TMP=${TREE}/TMP
    RUNNER_EXEC="$RUNNER"/umu-run
}

fileExistenceChecker(){ 
    if [[ -d "$TREE" || -f "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop ]]; then
        rm -rf "$TREE"
        rm -rf "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    fi
    if [[ -f "$HOME"/.icons/teknoparrot-icon.png ]]; then
        rm -r "$HOME"/.icons/teknoparrot-icon.png
    fi
}

runner(){
    mkdir -p "$TREE"/{PROGRAM,PREFIX,RUNNER,TMP}
    if [[ ! -f "$HOME"/.local/bin/umu-run ]]; then
        (
        cd "$TMP"
        git clone https://github.com/Open-Wine-Components/umu-launcher
        cd umu-launcher/
        ./configure.sh --user-install
        make install
        )
    fi
    ln -s "$HOME"/.local/bin/umu-run "$RUNNER"/umu-run
}

dependencyInstall(){
    clear
    export WINEPREFIX=${PREFIX}
    echo -e "[$YELLOWCOLOR WAIT $NC] Proton Wineboot" && $RUNNER_EXEC wineboot -u &> /dev/null
    if [[ -d $PREFIX/pfx ]]; then
        echo -e "==> [$GREENCOLOR DONE $NC] Structure created!"
    else
        echo -e "==> [$REDCOLOR ERROR $NC] Structure not created!"
    fi
    echo -e "[$YELLOWCOLOR WAIT $NC] Downloading .NET Runtime" && wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP" &> /dev/null
    echo -e "[$YELLOWCOLOR WAIT $NC] Downloading .NET Desktop Runtime" && wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP" &> /dev/null
    echo -e "[$YELLOWCOLOR WAIT $NC] Installing .NET Runtime" && "$RUNNER_EXEC" "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &> /dev/null && echo -e "==> [$GREENCOLOR DONE $NC] .NET Runtime installed!"
    echo -e "[$YELLOWCOLOR WAIT $NC] Installing .NET Desktop Runtime" && "$RUNNER_EXEC" "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &> /dev/null && echo -e "==> [$GREENCOLOR DONE $NC] .NET Desktop Runtime installed!"
    echo -e "[$YELLOWCOLOR WAIT $NC] Downloading Teknoparrot (Web-Installer)" && wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &> /dev/null
    (
        echo -e "[$YELLOWCOLOR WAIT $NC] Extracting Teknoparrot (Web-Installer)" && unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM" &> /dev/null
        cd "$PROGRAM"
        echo -e "[$YELLOWCOLOR WAIT $NC] Installing Teknoparrot (Web-Installer)" && "$RUNNER_EXEC" TPBootstrapper.exe &> /dev/null
        if [[ -f $PROGRAM/TeknoParrotUi.exe ]]; then
            echo -e "==> [$GREENCOLOR DONE $NC] Teknoparrot installed!"
        else
            echo -e "==> [$REDCOLOR ERROR $NC] Teknoparrot not installed!"
        fi
    )
    rm -rf "$PROGRAM"/TPBootstrapper*
    rm -rf "$TMP"
}

executableCreation(){
    (
        mkdir -p "$HOME/.icons"
        cp -r icon.png "$HOME/.icons/teknoparrot-icon.png"
        cd "$TREE"
        HEADER="#!/bin/bash"
        DEBUG_FLAG="#PROTON_LOG=1"
        DRIPRIME_FLAG="#export DRI_PRIME=1"
        MANGOHUD_FLAG="#export MANGOHUD=1"
        echo "$HEADER" > Teknoparrot-Linux
        echo "$DEBUG_FLAG" >> Teknoparrot-Linux
        echo "$DRIPRIME_FLAG" >> Teknoparrot-Linux
        echo "$MANGOHUD_FLAG" >> Teknoparrot-Linux
        echo "export LC_ALL=C" >> Teknoparrot-Linux
        echo "export LC_NUMERIC=C" >> Teknoparrot-Linux
        echo "export LANG=en_US.UTF-8" >> Teknoparrot-Linux
        echo "export WINEPREFIX=$PREFIX" >> Teknoparrot-Linux
        echo "$RUNNER_EXEC" "$PROGRAM"/TeknoParrotUi.exe >> Teknoparrot-Linux
        chmod +x Teknoparrot-Linux
    )
    echo "[Desktop Entry]" > "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Exec="$TREE"/Teknoparrot-Linux" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Name=Teknoparrot" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Icon="$HOME"/.icons/teknoparrot-icon.png" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Terminal=false" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Type=Application" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    echo "Categories=Game;" >> "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
    chmod +x "$HOME"/.local/share/applications/com.sakaki.Teknoparrot.desktop
}

case $1 in
    "--help")
        echo -e "\nTeknoparrot-Linux (Runtime): Version 3.1-1\n\n--help\t\tShow this message.\n--debug \tIt executes the debug executable file (this may take some time and usually generates its own log file).\n--remove\tClears all files created by the script.\n"
        exit
    ;;
    "--debug")
        echo -e "\nUNDER DEVELOPMENT\n"
        exit
    ;;
    "--remove")
        clear
        creationTree
        variableTree
        if [[ ! -d $TREE ]]; then
            echo -e "\n[$REDCOLOR ERROR $NC]\n==> Teknoparrot is not installed."
        else
            fileExistenceChecker
            echo -e "\n[$GREENCOLOR DONE $NC]\n==> Teknoparrot successfully removed!"
            sleep 2
        fi
        exit
    ;;
esac

clear
creationTree
variableTree
fileExistenceChecker
runner
dependencyInstall
executableCreation