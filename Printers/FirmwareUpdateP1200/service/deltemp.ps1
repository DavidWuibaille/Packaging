Start-Sleep -Second 5
if((Get-ChildItem 'C:\ProgramData\DN'| Measure-Object).Count -eq '1')
{
Remove-Item 'C:\Program Files (x86)\InstallShield Installation Information\{2F3084FE-6E87-4A48-8E12-00A7D492267D}' -Recurse
Remove-Item 'C:\Program Files\InstallShield Installation Information\{2F3084FE-6E87-4A48-8E12-00A7D492267D}' -Recurse
Remove-Item 'C:\ProgramData\DN' -Recurse
}
else
{
Remove-Item 'C:\Program Files (x86)\InstallShield Installation Information\{2F3084FE-6E87-4A48-8E12-00A7D492267D}' -Recurse
Remove-Item 'C:\Program Files\InstallShield Installation Information\{2F3084FE-6E87-4A48-8E12-00A7D492267D}' -Recurse
Remove-Item 'C:\ProgramData\DN\UtilityTemp' -Recurse
}
