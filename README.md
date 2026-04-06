# Arcade.Wrapper-Linux
#### (formerly Teknoparrot.Core-Linux)
 
<p>

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, trying to decouple it as much as possible from the Windows NT kernel.

</p>

<p>

We also __DO NOT USE illegal dumps (always use your legal dumps!)__ and we __DO NOT USE proprietary code from the [TeknoParrot](https://teknoparrot.com/en/) project, nor from the consoles/arcades__.

</p>
<p>

In short, what is this project? It is basically a __*wrapper* for Linux__ that translates a __*wrapper* for NT__.

</p>

__This project does NOT cover games that depend on *APM3* (for now).__

Please be patient if something doesn't work (this is quite common), I'm doing this alone and trying my best.<br>  

#### If you would like to support the project's development:
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sakaki91)  

Did you encounter problems? *[Read this](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/1.-About-the-Project#how-does-the-error-report-work).*

### Getting Started: 
- [[ Auto-install ]](#auto-install)
- [[ Manual-install ]](#manual-install)
	- [[ Wiki ]](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki)
	- [[ Currently supported games ]](https://www.github.com/sakaki91/Arcade.Runtime-Linux/wiki/2.-Currently-supported-games)

## Auto Install:

__Script Dependencies:__  
*Don't know how to install it on your distribution? [Check this out](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/3.-Dependencies-and-Distros-Hardware-tested.).*

`bash`  
`git`  
`zenity`  
`wget`  
`unzip`  
`tar`  
`wine-staging` [[link]](https://gitlab.winehq.org/wine/wine-staging)  
`winetricks`  

Installation:

    $ cd ~/
    $ git clone https://github.com/sakaki91/Arcade.Wrapper-Linux
    $ cd Arcade.Wrapper-Linux
    $ git pull
    $ chmod +x install.sh
    $ ./install.sh

## Manual Install:

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

	$ touch TeknoParrot-Linux

Then edit the file with [nano](https://www.nano-editor.org/) and place this information inside the file:

	#!/bin/bash
	export LC_ALL=C
	export LC_NUMERIC=C
	export LANG=en_US.UTF-8
	export WINEPREFIX=$HOME/TeknoParrot/PREFIX
	wine $HOME/TeknoParrot/PROGRAM/TeknoParrotUi.exe

And after that:

    $ chmod +x TeknoParrot-Linux
    $ ./TeknoParrot-Linux

