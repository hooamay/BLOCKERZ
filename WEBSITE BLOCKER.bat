@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Check for admin privileges
call :BANNER
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo This script requires administrator privileges.
    echo Please run as administrator.
    echo.
    pause
    exit /b 1
)

:: Set hosts file path
set "hostspath=%SystemRoot%\System32\drivers\etc\hosts"

:MENU
cls
call :BANNER
echo.
echo 1. Block a website
echo 2. Unblock a website  
echo 3. Show blocked websites
echo 4. Backup hosts file
echo 5. Restore hosts file
echo 6. Clear all blocks
echo 7. Exit
echo.
echo Type '--help' for usage guide and tips
echo.
set /p choice=Select option (1-7 or --help): 
if /i "%choice%"=="1" goto BLOCK
if /i "%choice%"=="2" goto UNBLOCK
if /i "%choice%"=="3" goto SHOW
if /i "%choice%"=="4" goto BACKUP
if /i "%choice%"=="5" goto RESTORE
if /i "%choice%"=="6" goto CLEARALL
if /i "%choice%"=="7" exit
if /i "%choice%"=="e" exit
if /i "%choice%"=="exit" exit
if /i "%choice%"=="--help" goto HELP
if /i "%choice%"=="help" goto HELP
if /i "%choice%"=="-h" goto HELP
if /i "%choice%"=="h" goto HELP
echo [!] Invalid option. Please try again.
timeout /t 2 >nul
goto MENU

:BANNER
echo.
echo ██╗  ██╗██╗██████╗ ███████╗██████╗ ███████╗
echo ██║  ██║██║██╔══██╗██╔════╝██╔══██╗╚══███╔╝
echo ███████║██║██║  ██║█████╗  ██████╔╝  ███╔╝
echo ██╔══██║██║██║  ██║██╔══╝  ██╔══██╗ ███╔╝
echo ██║  ██║██║██████╔╝███████╗██║  ██║███████╗
echo ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝
echo            WEBSITE BLOCKER v2.0
echo            DEVELOPED BY: whoami
echo.
exit /b

:ISVALID
:: INPUT: %1 = domain
set "input=%~1"
set "valid=true"

:: Check if empty
if "%input%"=="" (
    set "valid=false"
    goto :ISVALID_END
)

:: Must contain at least one dot - that's the only requirement
echo %input% | find "." >nul || set "valid=false"

:ISVALID_END
set "validated=!valid!"
exit /b

:BLOCK
cls
call :BANNER
echo [*] Block Website
echo.
echo Examples: 
echo   - facebook.com (blocks facebook.com only)
echo   - www.facebook.com (blocks www.facebook.com only)
echo   - *.facebook.com (blocks both facebook.com and www.facebook.com)
echo.
set /p website=Enter a website to BLOCK (or 'e' to exit): 
if /i "%website%"=="exit" goto MENU
if /i "%website%"=="e" goto MENU
if "%website%"=="" goto BLOCK

:: Check for wildcard blocking
set "wildcard=false"
if "%website:~0,2%"=="*." (
    set "wildcard=true"
    set "website=%website:~2%"
)

:: Validate domain
call :ISVALID "%website%"
if /i "!validated!"=="false" (
    echo.
    echo [!] Invalid domain format. Please enter a valid website.
    echo.
    pause
    goto BLOCK
)

if "!wildcard!"=="true" (
    :: Block both www and non-www versions
    call :BLOCK_DOMAIN "%website%"
    call :BLOCK_DOMAIN "www.%website%"
    echo.
    echo [+] Successfully blocked: %website% and www.%website%
) else (
    :: Block only the specified version
    call :BLOCK_DOMAIN "%website%"
    echo.
    echo [+] Successfully blocked: %website%
)

call :FLUSH_DNS
echo.
pause
goto MENU

:BLOCK_DOMAIN
set "domain=%~1"
findstr /i /c:"127.0.0.1 %domain%" "!hostspath!" >nul 2>&1
if !errorlevel! neq 0 (
    echo 127.0.0.1 %domain%>>"!hostspath!"
    echo [✓] Added: %domain%
) else (
    echo [!] Already blocked: %domain%
)
exit /b

:UNBLOCK
cls
call :BANNER
echo [*] Unblock Website
echo.
echo Examples: 
echo   - facebook.com (unblocks facebook.com only)
echo   - www.facebook.com (unblocks www.facebook.com only)
echo   - *.facebook.com (unblocks both facebook.com and www.facebook.com)
echo.
set /p website=Enter a website to UNBLOCK (or 'e' to exit): 
if /i "%website%"=="exit" goto MENU
if /i "%website%"=="e" goto MENU
if "%website%"=="" goto UNBLOCK

:: Check for wildcard unblocking
set "wildcard=false"
if "%website:~0,2%"=="*." (
    set "wildcard=true"
    set "website=%website:~2%"
)

:: Validate domain
call :ISVALID "%website%"
if /i "!validated!"=="false" (
    echo.
    echo [!] Invalid domain format.
    echo.
    pause
    goto UNBLOCK
)

if "!wildcard!"=="true" (
    :: Unblock both www and non-www versions
    call :UNBLOCK_DOMAIN "%website%"
    call :UNBLOCK_DOMAIN "www.%website%"
    echo.
    echo [+] Successfully unblocked: %website% and www.%website%
) else (
    :: Unblock only the specified version
    call :UNBLOCK_DOMAIN "%website%"
    echo.
    echo [+] Successfully unblocked: %website%
)

call :FLUSH_DNS
echo.
pause
goto MENU

:UNBLOCK_DOMAIN
set "domain=%~1"
findstr /i /c:"127.0.0.1 %domain%" "!hostspath!" >nul 2>&1
if !errorlevel! == 0 (
    :: Create temp file without the blocked domain
    findstr /v /i /c:"127.0.0.1 %domain%" "!hostspath!" > "%temp%\hosts.tmp"
    move /y "%temp%\hosts.tmp" "!hostspath!" >nul
    echo [✓] Removed: %domain%
) else (
    echo [!] Not found: %domain%
)
exit /b

:SHOW
cls
call :BANNER
echo [*] Currently blocked websites:
echo.
set "count=0"
for /f "tokens=2 delims= " %%A in ('findstr /i /c:"127.0.0.1" "!hostspath!" 2^>nul') do (
    if /i not "%%A"=="localhost" (
        echo %%A
        set /a count+=1
    )
)
if !count! == 0 echo No websites are currently blocked.
echo.
echo [*] Total blocked: !count! websites
echo.
pause
goto MENU

:BACKUP
cls
call :BANNER
echo [*] Backup Hosts File
echo.
echo Enter a custom filename (without extension) or press Enter for auto-generated name:
set /p customname=Backup filename (or 'exit' to cancel): 
if /i "%customname%"=="exit" goto MENU
if /i "%customname%"=="e" goto MENU

:: Generate filename based on user input or auto-generate
if "%customname%"=="" (
    :: Auto-generate with current date/time
    set "backupfile=%~dp0hosts_backup_%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.bak"
    set "backupfile=!backupfile: =0!"
    echo [*] Using auto-generated filename...
) else (
    :: Use custom filename
    set "backupfile=%~dp0hosts_backup_%customname%.bak"
    echo [*] Using custom filename: hosts_backup_%customname%.bak
)

echo.
echo [*] Creating backup...
copy "!hostspath!" "!backupfile!" >nul
if !errorlevel! == 0 (
    echo [✓] Hosts file backed up successfully to:
    echo !backupfile!
) else (
    echo [!] Backup failed!
)
echo.
pause
goto MENU

:RESTORE
cls
call :BANNER
echo [*] Restore Hosts File
echo.
echo Available backup files:
dir /b "%~dp0hosts_backup_*.bak" 2>nul
echo.
set /p backupfile=Enter backup filename (or 'exit' to cancel): 
if /i "%backupfile%"=="exit" goto MENU
if /i "%backupfile%"=="e" goto MENU
if "%backupfile%"=="" goto RESTORE

if exist "%~dp0%backupfile%" (
    copy "%~dp0%backupfile%" "!hostspath!" >nul
    if !errorlevel! == 0 (
        echo [✓] Hosts file restored successfully!
        call :FLUSH_DNS
    ) else (
        echo [!] Restore failed!
    )
) else (
    echo [!] Backup file not found!
)
echo.
pause
goto MENU

:CLEARALL
cls
call :BANNER
echo [*] Clear All Blocks
echo.
echo [WARNING] This will remove ALL blocked websites from hosts file.
echo This will NOT affect the original Windows hosts entries.
echo.
set /p confirm=Are you sure? (y/N): 
if /i "%confirm%"=="y" goto CLEARALL_CONFIRM
if /i "%confirm%"=="n" goto MENU
if "%confirm%"=="" goto CLEARALL
goto CLEARALL

:CLEARALL_CONFIRM
:: Create new hosts file with only essential entries
(
echo # Copyright ^(c^) 1993-2009 Microsoft Corp.
echo #
echo # This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
echo #
echo # localhost name resolution is handled within DNS itself.
echo #       127.0.0.1       localhost
echo #       ::1             localhost
echo.
echo 127.0.0.1	localhost
echo ::1		localhost
) > "%temp%\hosts_new.tmp"

move /y "%temp%\hosts_new.tmp" "!hostspath!" >nul
if !errorlevel! == 0 (
    echo [✓] All blocks cleared successfully!
    call :FLUSH_DNS
) else (
    echo [!] Failed to clear blocks!
)
echo.
pause
goto MENU

:FLUSH_DNS
echo [*] Flushing DNS cache...
ipconfig /flushdns >nul 2>&1
if !errorlevel! == 0 (
    echo [✓] DNS cache flushed!
) else (
    echo [!] DNS flush may have failed
)
exit /b

:HELP
cls
call :BANNER
echo [ HELP / USAGE GUIDE ]
echo.
echo BLOCKING OPTIONS:
echo   example.com        - Blocks only example.com
echo   www.example.com    - Blocks only www.example.com  
echo   *.example.com      - Blocks both example.com and www.example.com
echo.
echo EXIT SHORTCUTS:
echo   • Type 'e' or 'exit' to cancel any input
echo   • Type 'e' or 'exit' from main menu to quit program
echo   • Use option 7 from main menu to exit
echo   • Press Ctrl+C anytime to force quit
echo.
echo FEATURES:
echo   • Administrator privilege checking
echo   • Backup and restore hosts file
echo   • Clear all blocks at once
echo   • Improved domain validation
echo   • Better error handling
echo   • Custom or auto-generated backup filenames
echo.
echo HELP COMMANDS:
echo   --help, help, -h, h - Show this help screen
echo.
echo NOTES:
echo   • Don't include http:// or https://
echo   • Use wildcards (*.) for blocking both versions
echo   • Changes take effect immediately
echo   • Backups are saved in the same folder as this script
echo.
echo EXAMPLES:
echo   Block: facebook.com, *.youtube.com, www.twitter.com
echo   Backup: my_backup, clean_hosts, before_update
echo.
pause
goto MENU