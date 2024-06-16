# CTROnline Launcher

CTROnline Launcher allow to CTROnline and to configure the behavior of how the game is patched and the emu and tools handled.

It is provided in 2 parts:
- The autoUpdater itself is a batch file handling all file management and downloads
- The launcher which wrap the autoupdater commandline and save your settings

The launcher isbuilt and made with Godot v3.5.3 for the maximum compatibility with legacy hardware and technologies 

<ins>___DISCLAIMER: This has been made for personal use with additional level of checks so (almost) anybody can use it, I'm not responsible if anything goes wrong, I can update it, if you find anything handy, but understand that it does things with files, which can always go wrong, please be careful, read carefully, I've tried to describe as much, in any doubt, read the code, edit it___</ins>

## How to use it:

Start the launcher following the folder setup

## Folder Setup:

```
/CTROnline/
 >CTR - Crash Team Racing (USA).bin (iso of the USA version of the game)
 >CTR - Crash Team Racing (USA).cue (iso of the USA version of the game)
 >autoupdater.bat (tutorial on how to make it just below)
 >CTROnline-Launcher.exe
 >bios.bin (a region free or USA psx bios)
```

## What it does:

```
It checks if you have a username.ini file, if not it asks you username
It checks if you have a xdelta folder next to the autoupdater, if not, it download the right version for CTROnline
It checks if you have a duckstation folder next to the autoupdater, if not, it will download duckstation, decompress it right next to the auto updater, it will try and create directory settings for duckstation, copy the bios.bin in the duckstation setting folder.
It checks if your ctr-u_Online60.cue exists, if not it creates it
It checks if the settings for the game is installed in duckstation's setting folder, if not, it downloads and installs it
It download the last client, and compare it to a potential existing client, if the client either does not exist or is not updated, it updates it, and then will only download the xdelta patch for 60 fps and repatch the iso (to avoid consuming the bandwidth of whoever is nice enough to host ctrOnline website)
Then it cleans up everything, launch the game (sometimes launch the old ctr especially when running the first time), then wait 10 sec, then launches the client and auto enter you nickname
```

## Screenshots

![screenshot of the gui](https://github.com/Adrenesis/CTROnline-Launcher/blob/main/screenshots/CTROnline-v0_1_0.PNG?raw=true)

![screenshot of the gui](https://github.com/Adrenesis/CTROnline-Launcher/blob/main/screenshots/CTROnline-v0_1_1.PNG?raw=true)

![screenshot of the gui](https://github.com/Adrenesis/CTROnline-Launcher/blob/main/screenshots/CTROnline-v0_1_2.PNG?raw=true)

## CLI Example:

`.\autoupdater.bat /x .\xdelta0\ /d .\duckstation0\ /b .\SCPH1001.bin /s .\duckstationSettings\ /o CTROnline30.bin /sx /sd /ss /sb /fu /fs /fx /fd /fb --fps-30`

which launches the updater with a custom folder for xdelta, duckstation, a custom bios fed to duckstation, a custom duckstation settings directory, a custom rom name for the patched iso while skipping bios, gamesettings, xdelta and duckstation update and generating the 30 fps version, then launches the game and and the client. All of that while forcing also all those update + forcing the iso update. Force always take over skip.

## Requirements

- A CPU faster than a potato. But it needs to be x86_64.
- For the hardware renderers, a GPU capable of OpenGL 3.1/OpenGL ES 3.1/Direct3D 11 Feature Level 10.0 (or Vulkan 1.0) and above. So, basically anything made in the last 10 years or so.

## Thanks

- Matt & Niko from the dev team of CTROnline
- Mods nicely answering my questions
- Carisa_Rhythm_Demon and ReMate15T (ARG) who had the idea of scripting this
- Sanik [🇦🇷], penta3 for beta testing and ideas
- Leormas [ 🇦🇷 ] for graphics and UIs
- [DuckStation](https://github.com/stenzek/duckstation) team (don't bother them please)
- [XDelta](https://github.com/jmacd/xdelta-gpl) team (don't bother them please)
- [Godot](https://github.com/godotengine/godot) team

## License

Under MIT License