#!/bin/bash
#follow @sakaki91

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
                echo -e "\n$ERROR_LOG\n==> Invalid value"
                sleep 2
                clear
            ;;
        esac
    done
}

variableTree(){
    [ -d "$TREE" ] && rm -rf "$TREE"
    [ -f "$AR_LOG" ] && rm -rf "$AR_LOG"
    PROGRAM=${TREE}/PROGRAM
    PREFIX=${TREE}/PREFIX
    RUNNER=${TREE}/RUNNER
    TMP=${TREE}/TMP
    RUNNER_EXEC="$RUNNER"/umu-run
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
    echo -e "$WAIT_LOG Proton Wineboot." && $RUNNER_EXEC wineboot -u &> $AR_LOG
        [ -d "$PREFIX"/pfx ] && echo -e " $DONE_LOG Structure created!"
        [ ! -d "$PREFIX"/pfx ] && echo -e " $ERROR_LOG Structure not created." && exit
    echo -e "$WAIT_LOG Downloading .NET Runtime.\n$WAIT_LOG Downloading .NET Desktop Runtime."
    wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP" &>> $AR_LOG
    wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP" &>> $AR_LOG
        [ -f "$TMP"/dotnet-runtime-win-x64.exe ] && echo -e " $DONE_LOG .NET Runtime was downloaded!"
        [ ! -f "$TMP"/dotnet-runtime-win-x64.exe ] && echo -e " $ERROR_LOG .NET Runtime was not downloaded." && exit
        [ -f "$TMP"/windowsdesktop-runtime-win-x64.exe ] && echo -e " $DONE_LOG .NET Desktop Runtime was downloaded!"
        [ ! -f "$TMP"/windowsdesktop-runtime-win-x64.exe ] && echo -e " $ERROR_LOG .NET Desktop Runtime was not downloaded." && exit
        "$RUNNER_EXEC" "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &>> $AR_LOG && echo -e " $DONE_LOG .NET Runtime installed!"
        "$RUNNER_EXEC" "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &>> $AR_LOG && echo -e " $DONE_LOG .NET Desktop Runtime installed!"  
    (
        echo -e "$WAIT_LOG Downloading Teknoparrot (Web-Installer)"
        wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &>> $AR_LOG
            [ -f "$TMP"/TPBootstrapper.zip ] && echo -e " $DONE_LOG TPBootstrapper was downloaded!"
            [ ! -f "$TMP"/TPBootstrapper.zip ] && echo -e " $ERROR_LOG TPBootstrapper was not downloaded." && exit
        unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM" &>> $AR_LOG
            [ -f "$PROGRAM"/TPBootstrapper.exe ] && echo -e " $DONE_LOG TPBootstrapper was extracted!"
            [ ! -f "$PROGRAM"/TPBootstrapper.exe ] && echo -e " $ERROR_LOG TPBootstrapper was not extracted." && exit
        cd "$PROGRAM"
        echo -e "$WAIT_LOG Installing Teknoparrot (Web-Installer)"
            [ -f "$PROGRAM"/TPBootstrapper.exe ] && echo -e " $DONE_LOG TPBootstrapper was found!"
            [ ! -f "$PROGRAM"/TPBootstrapper.exe ] && echo -e " $ERROR_LOG TPBootstrapper was not found." && exit
            "$RUNNER_EXEC" TPBootstrapper.exe &>> $AR_LOG
            [ -f "$PROGRAM"/TeknoParrotUi.exe ] && echo -e " $DONE_LOG Teknoparrot installed!"
            [ ! -f "$PROGRAM"/TeknoParrotUi.exe ] && echo -e " $ERROR_LOG Teknoparrot not installed." && exit
    )
    ls $TREE &>> $AR_LOG && ls $TREE/* &>> $AR_LOG
    rm -rf "$PROGRAM"/TPBootstrapper*
    rm -rf "$TMP" && echo -e " $DONE_LOG Temporary files cleared!"
}

executableCreation(){
    HEADER="#!/bin/bash"
    DEBUG_FLAG="#export PROTON_LOG=1"
    DRIPRIME_FLAG="#export DRI_PRIME=1"
    MANGOHUD_FLAG="#export MANGOHUD=1"
    PROTON_LOCATION="export PROTONPATH=$HOME/.local/share/Steam/compatibilitytools.d/UMU-Proton-9.0-4e"
    (
        cd "$TREE"
        echo "$HEADER" > Teknoparrot-Linux
        echo "$DEBUG_FLAG" >> Teknoparrot-Linux
        echo "$DRIPRIME_FLAG" >> Teknoparrot-Linux
        echo "$MANGOHUD_FLAG" >> Teknoparrot-Linux
        echo "export LC_ALL=C" >> Teknoparrot-Linux
        echo "export LC_NUMERIC=C" >> Teknoparrot-Linux
        echo "export LANG=en_US.UTF-8" >> Teknoparrot-Linux
        echo "export GAMEID=0" >> Teknoparrot-Linux
        echo "$PROTON_LOCATION" >> Teknoparrot-Linux
        echo "export WINEPREFIX=$PREFIX" >> Teknoparrot-Linux
        echo "$RUNNER_EXEC" "$PROGRAM"/TeknoParrotUi.exe >> Teknoparrot-Linux
        chmod +x Teknoparrot-Linux
    )
}

ARL_NAME="Arcade Runtime Linux"
ARL_VERSION="3.1-4"
AR_LOG="/dev/null"
DONE_LOG="\e[1;32m* [ DONE ]\033[0m"
WAIT_LOG="\e[1;33m* [ WAIT ]\033[0m"
ERROR_LOG="\e[1;31m* [ ERROR ]\033[0m"

case $1 in
    "--help")
        echo -e "\n$ARL_NAME $ARL_VERSION\n\n--help\t\tShow this message.\n--version\tShow wrapper version.\n--debug \tThis executes the script and generates a log file (AR.LOG) in $HOME.\n--remove\tClears all files created by the script.\n"
        exit
    ;;
    "--debug")
        AR_LOG=$HOME/AR.LOG
    ;;
    "--version")
        echo -e "$ARL_NAME $ARL_VERSION"
        exit
    ;;
    "--remove")
        clear
        creationTree
        [ ! -d $TREE ] && echo -e "\n$ERROR_LOG\n==> Teknoparrot is not installed." && exit
        variableTree
        [ ! -d $TREE ] && echo -e "\n$DONE_LOG\n==> Teknoparrot successfully removed!"
        exit
    ;;
esac

clear
creationTree
variableTree
runner
dependencyInstall
executableCreation