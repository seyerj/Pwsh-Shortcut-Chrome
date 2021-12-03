#################################
# 2021 PS Icon Deployment script v0.2
# 12/01/2021 Josh Seyer
# Douglas County, OR
################################

# Register log event source for Windows event log
New-EventLog -LogName 'PS-Shortcut-Deploy' -Source 'DC_PS_Script'

# Set target for Shortcut
# Set Chrome to open 
$Apppath = '"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"'
# Set url path
$TargetFile = "https://duckduckgo.com"

# Set location for shortcut.  Public Desktop makes it available for all users
$ShortcutFile = "$env:Public\Desktop\duckduckgo.lnk"

# Create the shortcut
$WScriptShell = New-Object -ComObject WScript.Shell
# icon location
$iconlocation = "c:\temp\icons\duck.ico"
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.IconLocation = $iconlocation # icon index 0
$Shortcut.TargetPath = $Apppath
$Shortcut.arguments = $TargetFile
$Shortcut.Save()

# Set Read Only
Set-ItemProperty -Path $ShortcutFile -Name IsReadOnly -Value $true

# Log Outcome
if (Test-Path $ShortcutFile) 
{
    Write-EventLog -LogName 'PS-Shortcut-Deploy' -Source 'DC_PS_Script' -EntryType 'Information' -EventID 1 -Message 'PS duckduckgo shortcut creation attempt completed'    
}
else 
{
    Write-EventLog -LogName 'PS-Shortcut-Deploy' -Source 'DC_PS_Script' -EntryType 'Information' -EventID 1 -Message 'PS duckduckgo shortcut creation attempt failed, no shortcut created'    
}

# Remove log event source for Windows event log
Remove-EventLog -LogName 'PS-Shortcut-Deploy'
