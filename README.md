# Teknoparrot.Core-Linux

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, trying to decouple it as much as possible from the Windows NT kernel.  
We also __DO NOT USE illegal dumps__ (always use your *legal dumps!*), and we __DO NOT USE proprietary code__ from the __[Teknoparrot](https://teknoparrot.com/en/)__ project, And this works like a translator, a __Linux-Wrapper__ that translates an __NT-Wrapper__.

__Be patient if something doesn't work (this is quite common), I'm doing this on my own, and I'm really trying.__

#### If you would like to support the development of the project:
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sakaki91)  

### Getting Started: 
- [[ Setup ]](#setup)
- [[ Auto-install ]](#auto-install)
- [[ Wiki ]](https://github.com/sakaki91/Teknoparrot.Core-Linux/wiki)
- [[ Currently supported games ]](https://www.github.com/sakaki91/Teknoparrot.Core-Linux/wiki/Currently-supported-games)

## Setup:

### WARNING!  
 In several games (especially those that use Lua, such as some WMMTs), it is necessary and highly recommended to enable EN_US in locale.gen, because otherwise certain games simply won't work due to localization errors, which can be explained below:

    $ sudo nano /etc/locale.gen

Check if the en_US.UTF-8 UTF-8 doesn't have a "#" in front of it, if it does, just uncomment it and run:

    $ sudo locale-gen

After that, you should see something similar to this:

    [user@host]$ sudo locale-gen
    Generating locales...
    en_US.UTF-8... done
    Generation complete.

And now you can proceed with the automatic/manual installation!

First, we will create a basic folder structure in your user folder:

    $ cd ~
    $ mkdir -p Teknoparrot/{PROGRAM,PREFIX,TMP}
    $ cd Teknoparrot/TMP
    
The guide uses UMU-Proton 100%, and recently discontinued the priority use of WineGE, so first install (UMU-Proton)[https://github.com/Open-Wine-Components/umu-launcher#installing-as-user] as --user-install!

Let's start preparing the prefix and installing the dependencies:

    $ export WINEPREFIX=$HOME/Teknoparrot/PREFIX
    $ ~/.local/bin/umu-run wineboot
    $ wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe
    $ wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe
    $ wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip
    $ ~/.local/bin/umu-run dotnet-runtime-win-x64.exe
    $ ~/.local/bin/umu-run windowsdesktop-runtime-win-x64.exe
    $ unzip TPBootstrapper.zip -d ~/Teknoparrot/PROGRAM
    $ ~/.local/bin/umu-run ~/Teknoparrot/PROGRAM/TPBootstrapper.exe

Following this, you should be able to use Teknoparrot normally. 

Below is an example of how the program would run:

__UMUProton__ (Local Installed):

    $ LC_ALL=C LC_NUMERIC=C LANG=en_US.UTF-8 WINEPREFIX=$HOME/Teknoparrot/PREFIX $HOME/.local/bin/umu-run $HOME/Teknoparrot/PROGRAM/TeknoparrotUi.exe

## Auto Install:

Script dependencies: `git, bash, unzip, make (umu-run needs to be compiled locally.), tar, zenity, wget`

    $ cd ~/
    $ git clone https://github.com/sakaki91/Teknoparrot.Core-Linux/
    $ cd Teknoparrot.Core-Linux/
    $ chmod +x install.sh
    $ ./install.sh
