# WELCOME TO AUTOTRACK! #
this is a VEX V5 3D auto planner with point placement simular to that of Jerrypath. It is made with the open source Godot game engine and programmed with GDScript. It will also be open source so that the VEX community will be able to contribute back to it.

Features of this auto planner:
- Fully 3D VEX Field, like XRC
- A point placment system with the ability to save/load paths
- currently will support EZ-Templete PID, with Odom support to come sometime after realse

Platforms that it will support:
- Windows
- Linux
- MacOS

# Contributing & Setup #
To start contributing to the project, you will have to download the godot engine along with cloning the repo with:
```git clone```.

After you do that, install godot depending on what os you have based on the guides below.

Then, you will be good to go and start making commits
(This will likely change soon once i figure out how to setup commit reviewing)

# Debian/Ubuntu/Linux Mint #
**⚠️ if you are on one of these distros, the packaged version of godot is outdated and the flatpak versions are non-offical wrappers ⚠️.**

It is recomended to install the version from [steam](https://store.steampowered.com/app/404790/Godot_Engine/) or the [godot website](https://godotengine.org/)

Then, after installing godot, install git using:
```sudo apt install git``

# Fedora/OpenSUSE/Nobora
If you are on Fedora, Nobora or OpenSUSE, then you can install godot with the method above or run:
``` sudo dnf install godot```
for fedora/nobora
or ``` 
sudo zypper addrepo https://download.opensuse.org/repositories/games/openSUSE_Tumbleweed/games.repo
sudo zypper refresh
sudo zypper install godot ```
for openSUSE

to install git for fedora/nobora, run:
``` sudo dnf install git```
for OpenSUSE:
``` sudo zypper install```

# Arch Linux #
To install godot for Arch Linux or Arch based distros, you will have to run:
``` pacman -S godot # this will install the godot package and not the godot-mono package since this project uses gdscript and not C#. ```

Then install git using
```sudo pacman -S git```

# Windows #
To install on windows, go to [steam](https://store.steampowered.com/app/404790/Godot_Engine/) or the [godot website](https://godotengine.org/)

On windows you can ethier install git from the [git website](https://git-scm.com/), or use [Github Desktop](https://desktop.github.com/download/) if you like

Note: I recommend the steam version because it allows you to automaticly recieve updates, whereas the stanadlone .exe from the godot site will require you to redownload it when a new version or minor release comes out.



<small> Project created by Zachary D(4303D) and Andrew G(4303B)