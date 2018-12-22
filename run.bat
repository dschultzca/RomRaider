@echo off 
    setlocal enableextensions disabledelayedexpansion

    rem Where to find java information in registry
    set "javaKey=HKLM\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment"

    rem Get current java version
    set "javaVersion="
    for /f "tokens=3" %%v in ('reg query "%javaKey%" /v "CurrentVersion" 2^>nul') do set "javaVersion=%%v"

    rem Test if a java version has been found
    if not defined javaVersion (
        echo Java version not found
        goto endProcess
    )

    rem Get java home for current java version
    set "javaDir="
    for /f "tokens=2,*" %%d in ('reg query "%javaKey%\%javaVersion%" /v "JavaHome" 2^>nul') do set "javaDir=%%e\bin\javaw.exe"

    if not defined javaDir (
        echo Java directory not found
    ) else (
        echo Found Java %javaVersion% in : "%javaDir%"
    )

    choice /T 3 /D n /M "Start RomRaider Editor"
    if errorlevel 255 goto endProcess
    if errorlevel 2   goto logger
    if errorlevel 1   goto editor
    if errorlevel 0   goto endProcess

:editor
    echo starting **** RomRaider Editor ****
    start "" "%javaDir%" -Djava.library.path=lib/windows -Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dsun.java2d.d3d=true -Xms64M -Xmx512M -jar RomRaider.jar
    goto endProcess
:logger
    echo starting **** RomRaider Logger ****
    start "" "%javaDir%" -Djava.library.path=lib/windows -Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dsun.java2d.d3d=true -Xms64M -Xmx512M -jar RomRaider.jar -logger
    goto endProcess

:endProcess 
    endlocal
