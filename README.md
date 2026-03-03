# Teknoparrot.Core-Linux
This project uses Teknoparrot completely adapted for the Linux kernel, using the Wine utilities!  

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with Linux, attempting to decouple as much as possible from the NT Kernel.

> [!WARNING]
> A basic script has been created to speed up the installation process, in case anyone needs it.  
>  It's almost finished; it installs and prepares directories and dependencies, but it does NOT perform the adjustments or injections.  
>  I'm a bit slow on this due to health reasons, please be kind.  

Primary dependencies: `bash, wget, zenity, wine, winetricks, lutris`

### Getting Started: 
- [[ Setup ]](#setup)
  - [[ Preparing the structure ]]()
  - [[ Initial prefix maintenance ]]()
  - [[ Tweaks ]]()
- [[ Auto-install ]](#auto-install)
- [[ Currently supported games ]](#currently-supported-games)

### Setup:
Soon, go to [Auto install](#auto-install)

### Auto Install:

    $ git clone https://github.com/sakaki91/Teknoparrot.Core-Linux/
    $ cd Teknoparrot.Core-Linux/
    $ chmod +x install.sh
    $ ./install.sh

### Currently supported games:

Initial D: Arcade Stage 7AXX, (You need to install [xact](https://github.com/sakaki91/Teknoparrot.Core-Linux/issues/1) in the prefix).  
Wangan Midnight Maximum Tune 6 (6, 6R & 6RR), Works out of the box!  


