@echo off
mkdir "%ProgramData%\DN\UtilityTemp"
xcopy /Y /s "%~dp0deltemp.bat" "%ProgramData%\DN\UtilityTemp"
xcopy /Y /s "%~dp0deltemp.ps1" "%ProgramData%\DN\UtilityTemp"