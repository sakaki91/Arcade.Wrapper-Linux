#!/bin/bash

ERROR_LOG="\e[1;31m"
NC="\033[0m"
PROJECT_HEADER="awl 3.2-4"
AWL_LOCATION=""
TEKNO_LOCATION=""
PREFIX_LOCATION=""

playRunWrapper(){
    FLATPAK_DIR=$(flatpak --installations)
    PLAY_ROM_DIR="$HOME/.var/app/org.purei.Play/config/Play Data Files/arcaderoms"
    [[ ! -d "$FLATPAK_DIR"/app/org.purei.Play ]] && printf "$ERROR_LOG * Emulator not found (Play!). $NC\n" && exit
    [[ ! -d "$AWL_LOCATION"/play ]] && ln -s "$PLAY_ROM_DIR" "$AWL_LOCATION"/play
    printf "wait...\n"
    PLAY_ROM_SELECTION=$(zenity --file-selection --directory --title="Select the desired ROM (Folder only):")
    PLAY_ROM=$(basename $PLAY_ROM_SELECTION)
    flatpak run org.purei.Play --arcade "$PLAY_ROM" &> /dev/null
    printf "done!\n"
}

dolphinRunWrapper(){
    FLATPAK_DIR=$(flatpak --installations)
    [[ ! -d "$FLATPAK_DIR"/app/org.DolphinEmu.dolphin-emu ]] && printf "$ERROR_LOG * Emulator not found (Dolphin). $NC\n" && exit
    printf "wait...\n"
    DOLPHIN_ROM=$(zenity --file-selection --title="Select the desired ROM:" )
    flatpak run org.DolphinEmu.dolphin-emu "$DOLPHIN_ROM" &> /dev/null
    printf "done!\n"
}

teknoRunWrapper(){
    printf "wait...\n"
    if [[ $RUNNER == "wine" ]]; then
        LC_ALL=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LANG=en_US.UTF-8 WINEPREFIX=$AWL_LOCATION/pfx wine $AWL_LOCATION/bin/TeknoParrotUi.exe &>> /dev/null
    elif [[ $RUNNER == "umu" ]]; then
        LC_ALL=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LANG=en_US.UTF-8 GAMEID=0 PROTONPATH="$HOME"/.local/share/Steam/compatibilitytools.d/UMU-Proton-10.0-4/ WINEPREFIX=$AWL_LOCATION/pfx umu-run $AWL_LOCATION/bin/TeknoParrotUi.exe &>> /dev/null
    fi
    printf "done!\n"
}

clear
printf "$PROJECT_HEADER (type: help)\n"
while true; do
	read -p "> " mainIO
    case $mainIO in
        "help")
            printf "run play\t\tOpens the emulator compatible with Namco System [147/246]\nrun dolphin\t\tOpens the emulator compatible with Sega Triforce\nrun tekno-wine\t\tOpens the wine-wrapper compatible with TeknoParrot/OpenParrot and their respective platforms.\nrun tekno-umu\t\tOpens the umu-wrapper compatible with TeknoParrot/OpenParrot and their respective platforms.\n"
        ;;
        "clear")
            clear
            printf "$PROJECT_HEADER (type: help)\n"
        ;;
        "run play")
            playRunWrapper
        ;;
        "run dolphin")
            dolphinRunWrapper
        ;;
        "run tekno-wine")
            RUNNER=wine
            teknoRunWrapper
        ;;
        "run tekno-umu")
            RUNNER=umu
            teknoRunWrapper
        ;;
        *)
            printf "$ERROR_LOG invalid option. $NC\n"
        ;;
    esac
done
