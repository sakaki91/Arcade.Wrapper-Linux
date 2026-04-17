__Arcade.Wrapper-Linux.  
(formerly Teknoparrot.Core-Linux).__

> [!WARNING]
> __THIS PROJECT HAS BEEN ARCHIVED INDEFINITELY FOR THE FOLLOWING REASONS:__  
> Currently I'm extremely stressed and have no time for anything, while the original foundation continues to do an increasingly worse job and still gets paid for it. Don't get me wrong, but it seems unnecessary.  
> Keeping this running is like a game of cat and mouse; they "update", something on our side breaks, and while we're fixing it, something else breaks, and I DO NOT WORK for TeknoParrot and I DO NOT SUPPORT a business model in a project that is NOT mine.

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, attempting to decouple it as much as possible from the Windows NT kernel, essentially serving as a Linux wrapper that translates the NT wrapper (TeknoParrot).  

This guide does NOT use illegal dumps or proprietary code from the original projects, and does not cover __APM3 games__ or games that run with __ElfLdr2__ *[(see why)](https://github.com/sakaki91/Arcade.Wrapper-Linux/wiki/1.-About-the-Project#why-is-there-no-support-for-apm3-and-elfldr2)*, it is merely an alternative method to make something that already exists work on other kernels (use your legal dumps).

Please be patient if something doesn't work (this is quite common), I'm doing this alone and trying my best.  

#### If you would like to support the project's development (This is entirely optional, but it would make me happy):
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sakaki91)  

Did you encounter problems? *[Read this](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/1.-About-the-Project#how-does-the-error-report-work).*

#### Getting Started: 
First, [check the compatibility list](https://www.github.com/sakaki91/Arcade.Runtime-Linux/wiki/2.-Currently-supported-games) (as some games require different settings and may not work efficiently with my wrapper, since there are better native options).  
* [[ Auto install ]](#auto-install)
* [[ Manual install ]](#manual-install)
* [[ Extra Tweaks]](#extra-tweaks)
* [[ Wiki ]](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki)

#### Auto Install:
__Script Dependencies:__  
*Don't know how to install it on your distribution? [Check this out](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/3.-Dependencies-and-Distros-Hardware-tested.).*

    bash git zenity wget unzip tar wine-staging

Installation:

    $ cd ~/
    $ git clone https://github.com/sakaki91/Arcade.Wrapper-Linux
    $ cd Arcade.Wrapper-Linux
    $ git pull
    $ chmod +x install.sh
    $ ./install.sh

#### Manual Install:
Some games require extra adjustments to the `/etc/locale.gen` file, first, check if `en_US.utf8` is present in your locale file:

	$ locale -a

If the `en_US.UTF-8` is present, simply ignore the steps below that involve locale-gen!

	$ sudo nano /etc/locale.gen

Just remove the "#" from the beginning of `en_US.UTF-8` and save:

	$ sudo locale-gen

After that, you should see something similar to this:

    [user@host]$ sudo locale-gen
    Generating locales...
    en_US.UTF-8... done
    Generation complete.

And now you can proceed with the manual installation!

First, we will create a basic folder structure in your user folder:

    $ cd ~
    $ mkdir -p TeknoParrot/{PROGRAM,PREFIX,TMP}
    $ cd TeknoParrot/TMP

Let's start by defining the Environment Variables:

    $ export WINEPREFIX=$HOME/Teknoparrot/PREFIX
	$ export LC_ALL=C
	$ export LC_NUMERIC=C
	$ export LANG=en_US.UTF-8

Now we will download and install the dependencies in the prefix:

	$ wineboot -u
    $ wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe
    $ wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe
    $ wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip
    $ wine dotnet-runtime-win-x64.exe
    $ wine windowsdesktop-runtime-win-x64.exe
    $ unzip TPBootstrapper.zip -d ~/Teknoparrot/PROGRAM
    $ wine ~/TeknoParrot/PROGRAM/TPBootstrapper.exe

Following this, you should be able to use Teknoparrot normally. 

Below is an example of how the program would run:

    $ LC_ALL=C LC_NUMERIC=C LANG=en_US.UTF-8 WINEPREFIX=$HOME/TeknoParrot/PREFIX wine $HOME/TeknoParrot/PROGRAM/TeknoParrotUi.exe

Inconvenient, isn't it? You can create a small initializer (which the script even does automatically in the [(Auto-install)](#auto-install) to automate this "bible" of code:

	$ touch TeknoParrot

Then edit the file with [nano](https://www.nano-editor.org/) and place this information inside the file:

	#!/bin/bash
	export LC_ALL=C
	export LC_NUMERIC=C
	export LANG=en_US.UTF-8
	export WINEPREFIX=$HOME/TeknoParrot/PREFIX
	wine $HOME/TeknoParrot/PROGRAM/TeknoParrotUi.exe

And after that:

    $ chmod +x TeknoParrot
    $ ./TeknoParrot

#### Extra Tweaks:
We'll use some paths like absolute-paths as examples, don't forget to adapt them to your directories!  
There are some optional tweaks you can make to improve your experience, which are listed below:  
* Does your GPU not support Vulkan or has limited support?
  * If you have partial support, you can try installing an older version of DXVK (eg: dxvk2010) compatible with your GPU.
  * If you have no Vulkan support at all, you can open `winecfg` within the prefix and remove the following dlls: `d3d10core, d3d11, d3d8, d3d9, dxgi`(this will affect performance).  
* Are you experiencing graphical bugs in the TeknoParrot UI? `Disable Hardware Acceleration in the launcher settings.`
* Would you like Discord to detect TeknoParrotUI and games opened through it? [Download this](https://github.com/EnderIce2/rpc-bridge/releases/latest/download/bridge.zip).  

and run it below:  

    $ unzip path-to-archive/bridge.zip
	$ WINEPREFIX=path-to-prefix wine path-to-archive/bridge.exe --install
