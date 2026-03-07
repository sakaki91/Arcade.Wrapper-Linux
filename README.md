# Teknoparrot.Core-Linux
This project uses Teknoparrot completely adapted for the Linux kernel, using the Wine utilities!  

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, attempting to decouple it as much as possible from the Windows NT kernel.<br>    
This project does NOT provide the download/use of illegal dumps (use your own dumps legally!), and it also does NOT use proprietary code from those responsible for the games or the creators of [Teknoparrot](https://teknoparrot.com/en/).  

Primary dependencies: `git, bash, wget, wine, winetricks`

### Getting Started: 
- [[ Setup ]](#setup)
  - [[ Preparing the structure ]]()
  - [[ Initial prefix maintenance ]]()
  - [[ Tweaks ]]()
- [[ Auto-install ]](#auto-install)
- [[ Currently supported games ]](#currently-supported-games)
- [[About the Project]](#about-the-project)

### Setup:
Soon, go to [Auto install](#auto-install)

### Auto Install:

    $ git clone https://github.com/sakaki91/Teknoparrot.Core-Linux/
    $ cd Teknoparrot.Core-Linux/
    $ chmod +x install.sh
    $ ./install.sh

### Currently supported games:

__Akai Katana Shin__, It's not working right now, and it won't open.
__Angry Birds Arcade__,  It's not working right now, and it won't open.
__DenshaDeGo!!__, Works out of the box! However, installing DXVK in the "Core" prefix is ​​highly recommended for better performance, as WineD3D may not be sufficient.  
__Initial D: Arcade Stage 7AXX__, (You need to install [xact](https://github.com/sakaki91/Teknoparrot.Core-Linux/issues/1) in the prefix).  
__Initial D: Arcade Stage 8 Infinity__, It's not working for now; it gets to the main menu but then crashes.
__Mario Kart Arcade GP__, It's not working right now, and it won't open.  
__Mario Kart Arcade GP 2__, It's not working right now, and it won't open.  
__Mario Kart Arcade DX USA__, It's not working right now, and it won't open.  
__Mario Kart Arcade DX USA (1.06/OF)__, It's not working right now, and it won't open.  
__Point Blank X__, Currently under review.  

#### __WMMT SERIES:__  
☑️ __Wangan Midnight__, It opens, but doesn't offer satisfactory performance results, regardless of the hardware and graphics APIs, because of emulation via Play! translated, however, I believe there's a better native alternative for this model.  
✅ __Wangan Midnight Maximum Tune 3__, Works out of the box!  
⚠️ __Wangan Midnight Maximum Tune 3DX+__, It works but with instability (flickering).  
✅ __Wangan Midnight Maximum Tune 5DX+__, Works out of the box!  
✅ __Wangan Midnight Maximum Tune 6__, Works out of the box!  
✅ __Wangan Midnight Maximum Tune 6R__, Works out of the box!  
✅ __Wangan Midnight Maximum Tune 6RR__, Works out of the box!  


### About the Project:

#### __What is the GPL license and why does the project have it?__  
It is present in the project precisely to protect the wrapperhe is present in the project precisely to try to protect the wrapper from any kind of "destructive" intent on the part of private companies; she is there to protect the code from being turned into a "closed box" or something similar to a paywall, as we have seen happen with some projects in the past. The culture must be FREE and ACCESSIBLE to all, regardless of their financial status or level of support, with security, transparency and, above all, respect for both the user's machine and the person behind the screen.  
