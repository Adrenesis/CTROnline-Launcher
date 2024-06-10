@::!/dos/rocks
pause
@echo off
goto :init

:header
    echo %__NAME% v%__VERSION%
    echo This is an auto-updater for CTROnline
    echo it is able to download/update any tool/emu to make CTROnline works
    echo.
    goto :eof

:usage
    echo USAGE:
    echo   %__BAT_NAME% [flags] --####-folder "./path-to-folder/"
    echo.
    echo.  -?, /?, --help                         shows this help
    echo.  -v, /v, --version                      shows the version
    echo.  -e, /e, --verbose                      shows detailed output
    echo.  -f, /f, --fps-30                       patch with 30 fps
    echo.  -sx, /sx, --skip-xdelta                skip xDelta check and download
    echo.  -sd, /sd, --skip-duckstation           skip DuckStation check and download
    echo.  -ss, /ss, --skip-duckstation-settings  skip DuckStation settings check and download
    echo.  -sb, /sb, --skip-bios                  skip bios copy in duckstation settings folder
    echo.  -fu, /fu, --force-update               force update of CTROnline
    echo.  -fx, /fx, --force-xdelta               force xDelta check and download
    echo.  -fd, /fd, --force-duckstation          force DuckStation check and download
    echo.  -fs, /fs, --force-duckstation-settings force DuckStation settings check and download
    echo.  -fb, /fb, --force-bios                 force bios copy in duckstation settings folder
    echo.  -i, /i, --input                        Change input for patched iso
    echo.                                         (default .\CTR - Crash Team Racing (USA).bin)
    echo.  -o, /o, --output                       Change output for patched iso
    echo.                                         (default .\ctr-u_Online60.bin)
    echo.  -x, /x, --xdelta-folder                Change xDelta folder 
    echo.                                         (default .\xdelta\)
    echo.  -d, /d, --duckstation-folder           Change DuckStation folder 
    echo.                                         (default .\duckstation\)
    echo.  -s, /s, --duckstation-settings-folder  Change DuckStation Settings folder 
    echo.                                         (default %USERPROFILE\documents\DuckStation\)
    echo.  -b, /b, --bios                         Change the bios given to DuckStation
    echo.                                         (default .\bios.bin)
    goto :eof

:version
    if "%~1"=="full" call :header & goto :eof
    echo %__VERSION%
    goto :eof

:init
    set "__NAME=%~n0"
    set "__VERSION=0.1"
    set "__YEAR=2024"

    set "__BAT_FILE=%~0"
    set "__BAT_PATH=%~dp0"
    set "__BAT_NAME=%~nx0"

    set "OptHelp="
    set "OptVersion="
    set "OptVerbose="

    set "FPS60=true"
    set "SkipXDelta=false"
    set "SkipDuckStation=false"
    set "SkipDuckStationSettings=false"
    set "SkipBios=false"
    set "ForceUpdate=false"
    set "ForceXDelta=false"
    set "ForceDuckStation=false"
    set "ForceDuckStationSettings=false"
    set "ForceBios=false"
    set "FileInput=.\CTR - Crash Team Racing (USA).bin"
    set "FileOutput=.\ctr-u_Online60.bin"
    set "BiosFile=.\bios.bin"
    set "XDeltaFolder=.\xdelta\"
    set "DuckStationFolder=.\duckstation\"
    set "DuckStationSettingsFolder=%USERPROFILE%\documents\DuckStation\"

:parse
    if "%~1"=="" goto :validate

    if /i "%~1"=="/?"                                call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="-?"                                call :header & call :usage "%~2" & goto :end
    if /i "%~1"=="--help"                            call :header & call :usage "%~2" & goto :end

    if /i "%~1"=="/v"                                call :version      & goto :end
    if /i "%~1"=="-v"                                call :version      & goto :end
    if /i "%~1"=="--version"                         call :version full & goto :end

    if /i "%~1"=="/e"                                set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="-e"                                set "OptVerbose=yes"  & shift & goto :parse
    if /i "%~1"=="--verbose"                         set "OptVerbose=yes"  & shift & goto :parse

    if /i "%~1"=="/f"                                set "FPS60=true"  & shift & goto :parse
    if /i "%~1"=="-f"                                set "FPS60=true"  & shift & goto :parse
    if /i "%~1"=="--fps-30"                          set "FPS60=true"  & shift & goto :parse

    if /i "%~1"=="/sx"                               set "SkipXDelta=true"  & shift & goto :parse
    if /i "%~1"=="-sx"                               set "SkipXDelta=true"  & shift & goto :parse
    if /i "%~1"=="--skip-xdelta"                     set "SkipXDelta=true"  & shift & goto :parse

    if /i "%~1"=="/sd"                               set "SkipDuckStation=true"  & shift & goto :parse
    if /i "%~1"=="-sd"                               set "SkipDuckStation=true"  & shift & goto :parse
    if /i "%~1"=="--skip-duckstation"                set "SkipDuckStation=true"  & shift & goto :parse

    if /i "%~1"=="/ss"                               set "SkipDuckStationSettings=true"  & shift & goto :parse
    if /i "%~1"=="-ss"                               set "SkipDuckStationSettings=true"  & shift & goto :parse
    if /i "%~1"=="--skip-duckstation-settings"       set "SkipDuckStationSettings=true"  & shift & goto :parse

    if /i "%~1"=="/sb"                               set "SkipBios=true"  & shift & goto :parse
    if /i "%~1"=="-sb"                               set "SkipBios=true"  & shift & goto :parse
    if /i "%~1"=="--skip-bios"                       set "SkipBios=true"  & shift & goto :parse

    if /i "%~1"=="/fu"                               set "ForceUpdate=true"  & shift & goto :parse
    if /i "%~1"=="-fu"                               set "ForceUpdate=true"  & shift & goto :parse
    if /i "%~1"=="--force-update"                    set "ForceUpdate=true"  & shift & goto :parse

    if /i "%~1"=="/fx"                               set "ForceXDelta=true"  & shift & goto :parse
    if /i "%~1"=="-fx"                               set "ForceXDelta=true"  & shift & goto :parse
    if /i "%~1"=="--force-xdelta"                    set "ForceXDelta=true"  & shift & goto :parse

    if /i "%~1"=="/fd"                               set "ForceDuckStation=true"  & shift & goto :parse
    if /i "%~1"=="-fd"                               set "ForceDuckStation=true"  & shift & goto :parse
    if /i "%~1"=="--force-duckstation"               set "ForceDuckStation=true"  & shift & goto :parse

    if /i "%~1"=="/fs"                               set "ForceDuckStationSettings=true"  & shift & goto :parse
    if /i "%~1"=="-fs"                               set "ForceDuckStationSettings=true"  & shift & goto :parse
    if /i "%~1"=="--force-duckstation-settings"      set "ForceDuckStationSettings=true"  & shift & goto :parse

    if /i "%~1"=="/fb"                               set "ForceBios=true"  & shift & goto :parse
    if /i "%~1"=="-fb"                               set "ForceBios=true"  & shift & goto :parse
    if /i "%~1"=="--force-bios"                      set "ForceBios=true"  & shift & goto :parse

    if /i "%~1"=="/i"                                set "FileInput=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--input"                           set "FileInput=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-i"                                set "FileInput=%~2"   & shift & shift & goto :parse

    if /i "%~1"=="/o"                                set "FileOutput=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--output"                          set "FileOutput=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-o"                                set "FileOutput=%~2"   & shift & shift & goto :parse

    if /i "%~1"=="/b"                                set "BiosFile=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--bios"                            set "BiosFile=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-b"                                set "BiosFile=%~2"   & shift & shift & goto :parse

    if /i "%~1"=="/x"                                set "XDeltaFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--xdelta-folder"                   set "XDeltaFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-x"                                set "XDeltaFolder=%~2"   & shift & shift & goto :parse

    if /i "%~1"=="/d"                                set "DuckStationFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--duckstation-folder"              set "DuckStationFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-d"                                set "DuckStationFolder=%~2"   & shift & shift & goto :parse

    if /i "%~1"=="/s"                                set "DuckStationSettingsFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="--duckstation-settings-folder"     set "DuckStationSettingsFolder=%~2"   & shift & shift & goto :parse
    if /i "%~1"=="-s"                                set "DuckStationSettingsFolder=%~2"   & shift & shift & goto :parse

    if not defined UnNamedArgument     set "UnNamedArgument=%~1"     & shift & goto :parse
    if not defined UnNamedOptionalArg  set "UnNamedOptionalArg=%~1"  & shift & goto :parse

    shift
    goto :parse

:validate
    echo TODO

:main
    if defined OptVerbose (
        echo **** DEBUG IS ON
    )

    goto :username

:end
    call :cleanenv
    exit /B

:cleanenv
    REM The cleanup function is only really necessary if you
    REM are _not_ using SETLOCAL.
    set "__NAME="
    set "__VERSION="
    set "__YEAR="

    set "__BAT_FILE="
    set "__BAT_PATH="
    set "__BAT_NAME="

    set "OptHelp="
    set "OptVersion="
    set "OptVerbose="

    set "FPS60="
    set "SkipXDelta="
    set "SkipDuckStation="
    set "SkipDuckStationSettings="
    set "SkipBios="
    set "ForceUpdate="
    set "ForceXDelta="
    set "ForceDuckStation="
    set "ForceDuckStationSettings="
    set "ForceBios="
    set "FileInput="
    set "FileOutput="
    set "BiosFile="
    set "XDeltaFolder="
    set "DuckStationFolder="
    set "DuckStationSettingsFolder="

    goto :eof


:username
    if exist .\username.ini goto :xdelta
    echo username.ini not detected, please enter your username.
    set /p "username=Username: "
    echo %username% > username.ini

:xdelta
    if %ForceXDelta%==true goto forcexdelta
    if exist %XDeltaFolder% goto :duckstation
    if %SkipXDelta%==true goto :duckstation
:forcexdelta
    echo Downloading xdelta from github...
    if exist %XDeltaFolder% del /Q /S %XDeltaFolder%
    powershell -Command "wget -O xdelta.zip https://github.com/jmacd/xdelta-gpl/releases/download/v3.0.9/xdelta3-3.0.9-x64.exe.zip"
    mkdir %XDeltaFolder%
    powershell Expand-Archive .\xdelta.zip -DestinationPath %XDeltaFolder%
    echo Downloading Done.

:duckstation
    if %ForceDuckStation%==true goto forceduckstation
    if %SkipDuckStation%==true goto duckstationsettings
    if exist %DuckStationFolder% goto duckstationsettings
:forceduckstation
    echo Downloading DuckStation from github...
    powershell -Command "wget -O .\duckstation.zip https://github.com/stenzek/duckstation/releases/download/latest/duckstation-windows-x64-release.zip"
    echo Downloading Done.
    echo Creating duckstation files...
    if exist %DuckStationFolder%\duckstation-qt-x64-ReleaseLTCG.exe del /Q /S %DuckStationFolder%
    powershell Expand-Archive .\duckstation.zip -DestinationPath %DuckStationFolder%
    echo Done.

:duckstationsettings
    echo Creating DuckStation Settings File...
	echo %DuckStationSettingsFolder%
    if exist %DuckStationSettingsFolder% goto duckstationbios
    mkdir %DuckStationSettingsFolder%

:duckstationbios
    if %ForceBios%==true goto forcebios
    if %SkipBios%==true goto duckstationgamesettings
    if exist %DuckStationSettingsFolder%\bios goto duckstationbioscopy
:forcebios
    mkdir %DuckStationSettingsFolder%\bios

:duckstationbioscopy
    echo Copying bios...
    echo F|xcopy %BiosFile% %DuckStationSettingsFolder%\bios\bios.bin>nul
    echo Done

:duckstationgamesettings
    if %ForceDuckStationSettings%==true goto forceduckstationsettings
    if %SkipDuckStationSettings%==true goto client
    if exist %DuckStationSettingsFolder%\gamesettings\SCUS-94426.ini goto client
    if exist %DuckStationSettingsFolder%\gamesettings goto downloadgamesettings

:forceduckstationsettings
    mkdir %DuckStationSettingsFolder%\gamesettings

:downloadgamesettings
    powershell -Command "wget -O %DuckStationSettingsFolder%\gamesettings\SCUS-94426.ini https://online-ctr.com/wp-content/uploads/onlinectr_patches/SCUS-94426.ini"
    echo Done.

:client
    echo Downloading last client...
    if exist .\temp\ del /Q /S .\temp\
    mkdir temp
    powershell -Command "wget -O new_client.zip https://online-ctr.com/wp-content/uploads/onlinectr_patches/client.zip"
    powershell Expand-Archive .\new_client.zip -DestinationPath .\temp\
    echo Downloading done.
    if %ForceUpdate%==true goto updateiso
    if exist .\CLIENT.EXE goto compare
	echo CLIENT.EXE not found updating...
    goto updateiso

:compare
    echo client found, comparing...
    fc .\temp\CLIENT.EXE .\CLIENT.EXE
    if errorlevel 1 (
        echo client.exe outdated
        goto updateiso
    )
    echo check done

:checkbin
    if exist %FileOutput% goto checkcue
    echo bin not detected.
    goto updateiso
:checkcue
    if exist %FileOutput:~0,-4%.cue goto alreadyupdated
    echo cue not detected.
    goto cue
:alreadyupdated
    echo Game already updated.
    goto cleanup

:updateiso
    echo Game needs an update
    del .\CLIENT.EXE
    echo F|xcopy .\temp\CLIENT.EXE .\CLIENT.EXE>nul
    echo Downloading last patch...
    if %FPS60%==true (
        powershell -Command "wget -O ctr-u_Online60.xdelta https://online-ctr.com/wp-content/uploads/onlinectr_patches/ctr-u_Online60.xdelta"
        echo Downloading done.
        echo Updating CTR Online...
        %XDeltaFolder%\xdelta3-3.0.9-x64.exe -f -d -s "%FileInput%" ".\ctr-u_Online60.xdelta" "%FileOutput%"
    )
    if %FPS60%==false (
        powershell -Command "wget -O ctr-u_Online30.xdelta https://online-ctr.com/wp-content/uploads/onlinectr_patches/ctr-u_Online30.xdelta"
        echo Downloading done.
        echo Updating CTR Online...
        %XDeltaFolder%\xdelta3-3.0.9-x64.exe -f -d -s "%FileInput%" ".\ctr-u_Online30.xdelta" "%FileOutput%"
    )
    
:cue
    if exist %FileOutput:~0,-4%.cue goto cleanup
    echo FILE "%FileOutput%" BINARY > %FileOutput:~0,-4%.cue
    echo  TRACK 01 MODE2/2352 >> %FileOutput:~0,-4%.cue
    echo    INDEX 01 00:00:00 >> %FileOutput:~0,-4%.cue
    echo Update done.

:cleanup
    echo Cleanup...
    if exist .\temp\ del /Q /S .\temp\
    if exist .\new_client.zip del .\new_client.zip
    if exist .\duckstation.zip del .\duckstation.zip
    if exist .\xdelta.zip del .\xdelta.zip
    echo Done. Starting Game...
    start "" "%DuckStationFolder%\duckstation-qt-x64-ReleaseLTCG.exe" "%FileOutput%"
    @echo off
    ping 127.0.0.1 -n 10>nul
    powershell -Command "cmd /c '.\CLIENT.EXE < .\username.ini'"
:eof
    goto cleanenv
    pause
    exit