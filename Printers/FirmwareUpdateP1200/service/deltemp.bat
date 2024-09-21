@echo off
start /min CMD /c PowerShell.exe -Executionpolicy Bypass -Command "%ProgramData%\DN\UtilityTemp\deltemp.ps1" -u
::pause