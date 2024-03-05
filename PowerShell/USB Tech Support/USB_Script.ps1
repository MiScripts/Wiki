Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$ScriptingTools                   = New-Object system.Windows.Forms.Form
$ScriptingTools.ClientSize        = New-Object System.Drawing.Point(600,500)
$ScriptingTools.text              = "Powershell Tools"
$ScriptingTools.TopMost           = $false

$Iam = whoami.exe
# This base64 string holds the bytes that make up the orange 'G' icon (just an example for a 32x32 pixel image)
$Start = Get-Location 
$iconLocation = $Start.ToString() + "\icon64.txt"
$iconImage       = Get-Content $iconLocation
$iconBase64      = $iconImage
$iconBytes       = [Convert]::FromBase64String($iconBase64)
# initialize a Memory stream holding the bytes
$stream          = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$ScriptingTools.Icon       = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))

#Idk how to get the ` character to load from a file :/, whatever one big line here we gooooooooo!
$HelpFile = "APP UPDATES: This uses 'winget' to search for all installed apps, by itself it will show what can be updated along with version information, if the 'Confirm Changes' checkbox is clicked then it will run the updates  `r`n`r`nSYSTEM UPDATES:  Will install/check the 'PSWindowUpdate' module then will show what can be update, if Confirm Changes is checked then will install those update, also if Auto Restart is check then will restart if the updates prompt for it `r`n`r`nERASE LOCAL ADMINS:  Will show the user all local administrators that do not match the preset values, use 'Show Local Administrators' to display all users/groups with admin rights, if confirm changes is checked will remove all accounts not specifically stated in the script  `r`n`r`nERASE LOCAL PROFILES:  Removes all local profiles that are not logged into the device, will only commit if 'Confirm Changes is checked'`r`n`r`nGET COMPUTER INFO:  Shows information useful for diagnostics and auditing `r`n`r`nGET LOCAL ADMINISTRATORS: Will list all users/groups that have local admin privileges`r`n`r`nCLEAR RECYCLE BIN: Clears the recycle bin if the checkbox is checked, otherwise just shows the amount in the recycling bin `r`n`r`nRIP AND TEAR: This will run REGARDLESS of any checkboxes, will first remove local admins, profiles execpt the logged into account, app updates, then finally update the windows machine and restart if needed"

#Shows the computer name of the device automatically
$HostName = Get-WMIObject Win32_ComputerSystem| Select-Object -ExpandProperty Name
$Title = "COMPUTER NAME: " + $HostName
$TitleText                       = New-Object system.Windows.Forms.Label
$TitleText.text                  = $Title.toString()
$TitleText.AutoSize              = $true
$TitleText.width                 = 30
$TitleText.height                = 15
$TitleText.location              = New-Object System.Drawing.Point(10,5)
$TitleText.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',11)

#Automatically queries the device for all active IP address and lists them at the top, most is just self assigned stuff 
$IP = Get-NetIPAddress -AddressFamily IPv4  | Select-Object IPAddress | Format-Table -HideTableHeaders | out-string | ForEach-Object {$_ -replace (' ','')} | ForEach-Object { $_ -replace "`r|`n"," " } | ForEach-Object { $_.Trim(' ') }
$IPText                       = New-Object system.Windows.Forms.Label
$IPText.text                  = "IP(s) Assigned to the computer: " + $IP 
$IPText.AutoSize              = $true
$IPText.width                 = 30
$IPText.height                = 50
$IPText.location              = New-Object System.Drawing.Point(10,35)
$IPText.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$IPText.MaximumSize           = New-Object System.Drawing.Size(590,0)
$IPText.AutoSize              = $true

#Button that DOES NOT NEED CHECKBOXES CHECKED TO RUN, for cleaning the computer in one command and will do the following in order: Removing Local Admins, Removing Local Profiles, Doing App Updates, and then Running Windows Updates then restarting if needed
$RipAndTear                   = New-Object system.Windows.Forms.Button
$RipAndTear.text              = "Rip And Tear"
$RipAndTear.width             = 100
$RipAndTear.height            = 75
$RipAndTear.location          = New-Object System.Drawing.Point(250,420)
$RipAndTear.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',11)
$RipAndTear.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$RipAndTear.Enabled           = $True

#Button that uses "winget" to check the local applications and update them if the checkbox is checked
$AppUpdates                   = New-Object system.Windows.Forms.Button
$AppUpdates.text              = "App Updates"
$AppUpdates.width             = 100
$AppUpdates.height            = 50
$AppUpdates.location          = New-Object System.Drawing.Point(10,70)
$AppUpdates.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$AppUpdates.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$AppUpdates.Enabled           = $True

#Button that uses "winget" to check the local applications and update them if the checkbox is checked
$ShowHelp                   = New-Object system.Windows.Forms.Button
$ShowHelp.text              = "Show Help"
$ShowHelp.width             = 100
$ShowHelp.height            = 50
$ShowHelp.location          = New-Object System.Drawing.Point(310,70)
$ShowHelp.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$ShowHelp.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#008000")
$ShowHelp.Enabled           = $True

#Merry Christmas!
$ChristmasColorized                   = New-Object system.Windows.Forms.Button
$ChristmasColorized.text              = "Merry Christmas"
$ChristmasColorized.width             = 100
$ChristmasColorized.height            = 50
$ChristmasColorized.location          = New-Object System.Drawing.Point(410,70)
$ChristmasColorized.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$ChristmasColorized.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#008000")
$ChristmasColorized.Enabled           = $True

#Label for the Auto Restart button
$AutoRestart                       = New-Object system.Windows.Forms.Label
$AutoRestart.text                  = "Auto Restart"
$AutoRestart.AutoSize              = $true
$AutoRestart.width                 = 30
$AutoRestart.height                = 15
$AutoRestart.location              = New-Object System.Drawing.Point(450,130)
$AutoRestart.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',9)

#Used for the updates button to automatically restart without being prompted
$AutoRestartCheckbox = New-Object System.Windows.Forms.Checkbox 
$AutoRestartCheckbox.Location = New-Object System.Drawing.Size(432,130) 
$AutoRestartCheckbox.Size = New-Object System.Drawing.Size(20,20)
$AutoRestartCheckbox.Text = "Auto Restart"
$AutoRestartCheckbox.TabIndex = 4
#$objForm.Controls.Add($AutoRestartCheckbox)

#Label for the Confirm Changes checkbox
$Confirm                       = New-Object system.Windows.Forms.Label
$Confirm.text                  = "Confirm Changes"
$Confirm.AutoSize              = $true
$Confirm.width                 = 30
$Confirm.height                = 15
$Confirm.location              = New-Object System.Drawing.Point(450,150)
$Confirm.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',9)

#Checkbox that MUST BE CHECKED to actually run anything, otherwise the buttons will just show information about what it will update/delete/etc.
$ConfirmCheckbox = New-Object System.Windows.Forms.Checkbox 
$ConfirmCheckbox.Location = New-Object System.Drawing.Size(432,150) 
$ConfirmCheckbox.Size = New-Object System.Drawing.Size(20,20)
$ConfirmCheckbox.Text = "Confirm Changes"
$ConfirmCheckbox.TabIndex = 4
#$objForm.Controls.Add($ConfirmCheckbox)

#Button that installs and uses a powershell module to query updates and then runs then, if Auto Restart is checked will automatically restart and if Confirm Changes is checked will run the updates otherwise just will list them
$InstallUpdates                   = New-Object system.Windows.Forms.Button
$InstallUpdates.text              = "System Updates"
$InstallUpdates.width             = 100
$InstallUpdates.height            = 50
$InstallUpdates.location          = New-Object System.Drawing.Point(10,120)
$InstallUpdates.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$InstallUpdates.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$InstallUpdates.Enabled           = $True

#Queries the system for all users/groups with local administrator permissions - does not work with Azure only devices
$GetLocalAdministrators                   = New-Object system.Windows.Forms.Button
$GetLocalAdministrators.text              = "Get Local Administrators"
$GetLocalAdministrators.width             = 100
$GetLocalAdministrators.height            = 50
$GetLocalAdministrators.location          = New-Object System.Drawing.Point(210,120)
$GetLocalAdministrators.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$GetLocalAdministrators.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffa500")
$GetLocalAdministrators.Enabled           = $True

#Button that removes all other profiles other the Administrator and account that currently logged into the device
$EraseLocalProfiles                   = New-Object system.Windows.Forms.Button
$EraseLocalProfiles.text              = "Erase Local Profiles"
$EraseLocalProfiles.width             = 100
$EraseLocalProfiles.height            = 50
$EraseLocalProfiles.location          = New-Object System.Drawing.Point(110,120)
$EraseLocalProfiles.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$EraseLocalProfiles.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$EraseLocalProfiles.Enabled           = $True

#Button that removes local administrators unless stated in the script, will have to update the powershell lines - does not do anything to azure only devices
$EraseLocalAdministrators                   = New-Object system.Windows.Forms.Button
$EraseLocalAdministrators.text              = "Erase Local Admins"
$EraseLocalAdministrators.width             = 100
$EraseLocalAdministrators.height            = 50
$EraseLocalAdministrators.location          = New-Object System.Drawing.Point(110,70)
$EraseLocalAdministrators.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$EraseLocalAdministrators.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$EraseLocalAdministrators.Enabled           = $True

#Button that removes local administrators unless stated in the script, will have to update the powershell lines - does not do anything to azure only devices
$ClearRecycleBin                   = New-Object system.Windows.Forms.Button
$ClearRecycleBin.text              = "Clear Recycle Bin"
$ClearRecycleBin.width             = 100
$ClearRecycleBin.height            = 50
$ClearRecycleBin.location          = New-Object System.Drawing.Point(210,70)
$ClearRecycleBin.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$ClearRecycleBin.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ed2939")
$ClearRecycleBin.Enabled           = $True

#Button that displays the local computer info most useful to techs
$GetLocalData                   = New-Object system.Windows.Forms.Button
$GetLocalData.text              = "Get Computer Info"
$GetLocalData.width             = 100
$GetLocalData.height            = 50
$GetLocalData.location          = New-Object System.Drawing.Point(310,120)
$GetLocalData.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$GetLocalData.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffa500")
$GetLocalData.Enabled           = $True

#Text box that displays the information - does not do anything with the input
$FormTextBox                 = New-Object system.Windows.Forms.TextBox
$FormTextBox.multiline       = $true
$FormTextBox.width           = 550
$FormTextBox.height          = 220
$FormTextBox.location        = New-Object System.Drawing.Point(25,180)
$FormTextBox.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$FormTextBox.Enabled         = $true
$FormTextBox.Scrollbars      = "Vertical"

$ScriptingTools.controls.AddRange(@($InstallUpdates, $ChristmasColorized, $ShowHelp, $ClearRecycleBin, $FormTextBox, $GetLocalData, $AutoRestartCheckbox, $AutoRestart, $EraseLocalProfiles, $ConfirmCheckbox, $Confirm, $GetLocalAdministrators, $TitleText, $IPText, $RipAndTear, $AppUpdates, $EraseLocalAdministrators))

$InstallUpdates.Add_Click({ InstallUpdates })
$EraseLocalProfiles.Add_Click({ EraseLocalProfiles })
$GetLocalData.Add_Click({ GetLocalData })
$GetLocalAdministrators.Add_Click({ GetLocalAdministrators })
$RipAndTear.Add_Click({ RipAndTear })
$AppUpdates.Add_Click({ AppUpdates })
$EraseLocalAdministrators.Add_Click({ EraseLocalAdministrators })
$ShowHelp.Add_Click({ ShowHelp })
$ClearRecycleBin.Add_Click({ ClearRecyclebin })
$ChristmasColorized.Add_Click({ ChristmasColorized })

function ShowHelp {
    $FormTextBox.text = $HelpFile
}
function AppUpdates {
    class Software {
        [string]$Name
        [string]$Id
        [string]$Version
        [string]$AvailableVersion
    }
    winget list -s msstore --accept-source-agreements
    $upgradeResult = winget upgrade | Out-String
    
    $lines = $upgradeResult.Split([Environment]::NewLine)
    
    # Find the line that starts with Name, it contains the header
    $fl = 0
    while (-not $lines[$fl].StartsWith("Name"))
    {
        $fl++
    }
    
    # Line $i has the header, we can find char where we find ID and Version
    $idStart = $lines[$fl].IndexOf("Id")
    $versionStart = $lines[$fl].IndexOf("Version")
    $availableStart = $lines[$fl].IndexOf("Available")
    $sourceStart = $lines[$fl].IndexOf("Source")
    
    # Now cycle in real package and split accordingly
    $upgradeList = @()
    For ($i = $fl + 1; $i -le $lines.Length; $i++) 
    {
        $line = $lines[$i]
        if ($line.Length -gt ($availableStart + 1) -and -not $line.StartsWith('-'))
        {
            $name = $line.Substring(0, $idStart).TrimEnd()
            $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
            $version = $line.Substring($versionStart, $availableStart - $versionStart).TrimEnd()
            $available = $line.Substring($availableStart, $sourceStart - $availableStart).TrimEnd()
            $software = [Software]::new()
            $software.Name = $name;
            $software.Id = $id;
            $software.Version = $version
            $software.AvailableVersion = $available;
    
            $upgradeList += $software
        }
    }
    $List = $upgradeList.Name | Out-String
    Start-Sleep -s 3
    if ($ConfirmCheckbox.checked -eq $True){
        $FormTextBox.text = "Updating these Apps: " + $List
        Start-Sleep -s 3
        winget upgrade --all  
        Start-Sleep -s 1 
        $FormTextBox.text = "Done"
        Start-Sleep -s 1
    }
    else {
        $FormTextBox.text = "Listed Apps to be updated, click Confirm Changes to apply: " + $List
        Start-Sleep -s 3
    } 

}
Function RipAndTear {
Start-Sleep -s 1 
$FormTextBox.text = "Will commence to RIP AND TEAR, please exit now or have your system thoroughly cleaned... You have 10 seconds..."
Start-Sleep -s 10
$FormTextBox.text = "Now starting..."
Start-Sleep -s 2
$FormTextBox.text = "Removing Irregular Local Admins..."
Start-Sleep -s 2
$GA = Get-LocalGroupMember -Group "Administrators" | Select-Object Name 
#Write-Host $GATrimed 
ForEach($object in $GA){
    $User = $object.Name
    $Name = $User.ToString()
    #Write-Host $User
    #Change the if statement below to the groups you want to keep active when running RIP AND TEAR
        if (($Name -like '*\Domain Admins') -or ($Name -like '*\Administrator') -or ($Name -like $Iam)){
        }
        Else{
        Remove-LocalGroupMember -Group "Administrators" -Member $Name
        $FormTextBox.text = "Erasing $Name"
        Start-Sleep -s 3
        }
}
$FormTextBox.text = "Removing Local Profiles..."
Start-Sleep -s 2
$LocalProfile = Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.Loaded -eq $False} | Select-Object LocalPath | Out-String
$FormTextBox.text = "Removing These Profiles...`n" + $LocalProfile 
Start-Sleep -s 3
Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.Loaded -eq $False} | Remove-CimInstance 
$FormTextBox.text = "Starting Updates..."
If (Test-Connection 8.8.8.8 -Quiet ) {
    if (Get-Module -ListAvailable -Name PSWindowsUpdate){
    }
    Else{
        Start-Sleep -s 1
        Set-ExecutionPolicy RemoteSigned -Force
        Start-Sleep -s 1
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Start-Sleep -s 1
        Install-Module PSWindowsUpdate -Force
        Start-Sleep -s 1
    }
    $FormTextBox.text = "Starting App Updates..."
    Start-Sleep -s 1
    winget list -s msstore --accept-source-agreements
    Start-Sleep -s 1
    winget upgrade --all
    Start-Sleep -s 1
    $FormTextBox.text = "Showing System Updates then starting..."
    Start-Sleep -s 1
    $Update = (Get-WindowsUpdate).GetEnumerator() |  Select-Object Title | Format-Table | Out-String
    $Update1 = $Update.trim() + "`r`n"
    $FormTextBox.text = $Update1
    Start-Sleep -s 1
    If ($Update1 -eq "" -or $null -eq $Update1){
        $FormTextBox.text = "No Updates Available"
        Start-Sleep -s 1
        return
    }
    $FormTextBox.text = "Starting Updates, might restart any minute"
    Start-Sleep -s 1
    Install-WindowsUpdate -AcceptAll -AutoReboot
}
else {
    $FormTextBox.text = "Please Check Internet Connection and Try Again"
}

}


Function GetLocalAdministrators{
$GA = Get-LocalGroupMember -Group "Administrators" | Select-Object Name | Out-String
$GA1 = $GA.trim() 
$FormTextBox.text = $GA1 
}
Function InstallUpdates {
    $FormTextBox.text = "Checking Internet Connection..."
If (Test-Connection 8.8.8.8 -Quiet ) {
    $FormTextBox.text = "Internet Connection is Good"
    Start-Sleep -s 2
    if (Get-Module -ListAvailable -Name PSWindowsUpdate){
        $FormTextBox.text = "Module is installed."
        Start-Sleep -s 1
    }
    Else{
        Start-Sleep -s 1
        $FormTextBox.Text = "Installing Module..."
        Start-Sleep -s 1
        Set-ExecutionPolicy RemoteSigned -Force
        Start-Sleep -s 1
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Start-Sleep -s 1
        Install-Module PSWindowsUpdate -Force
        Start-Sleep -s 1
    }
    $FormTextBox.text = "Showing Updates then starting..."
    Start-Sleep -s 1
    $Update = (Get-WindowsUpdate).GetEnumerator() |  Select-Object Title | Format-Table | Out-String
    $Update1 = $Update.trim() + "`r`n"
    $FormTextBox.text = $Update1
    Start-Sleep -s 1 
    If ($Update1 -eq "" -or $null -eq $Update1){
        $FormTextBox.text = "No Updates Available"

        return
    }
    Else{
        Start-Sleep -s 1
    }
    If ($ConfirmCheckbox.checked -eq $True){
        if ($AutoRestartCheckbox.checked -eq $True){
            $FormTextBox.text = "Installing updates from the Microsoft Center, device might auto reboot after updates..."
            Start-Sleep -s 2
            Install-WindowsUpdate -AcceptAll -AutoReboot
            $FormTextBox.text = "Done"
        }
        Else
        {
            $FormTextBox.text = "Installing updates from the Microsoft Center, device will prompt with restart notifications..."
            Start-Sleep -s 2
            Install-WindowsUpdate -AcceptAll 
            $FormTextBox.text = "Done"
    }
    }
    Else{
        $FormTextBox.text = "Confirm Changes was not clicked, here again are the available updates"
        start-sleep -s 2
        $FormTextBox.text = $Update1
    }
}
else {
    $FormTextBox.text = "Please Check Internet Connection and Try Again"
}

}
function ChristmasColorized {
    $FormTextBox.text = "Merry Christmas"
    start-sleep -s 2
    Start-Process PowerShell.exe -ArgumentList "-noexit", "-command .\merrychristmas.ps1"
    start-sleep -s 2
}

function ClearRecycleBin {
    $BYTES = (Get-ChildItem -LiteralPath 'C:\$Recycle.Bin' -File -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum 
    $MBYTES = $BYTES / 1024
    $MBYTESR = ([Math]::Round($MBYTES, 2))
    $Amount = $MBYTESR.tostring() + "MB of Data in the Recycling Bin" 
    $FormTextBox.text = $Amount
    if (($ConfirmCheckbox.Checked -eq $true) -or ($ConfirmCheckbox.Checked)){
        Start-Sleep -s 2
        $FormTextBox.text = "Cleaning up recycle bin..."
        Start-Sleep -s 2
        Clear-RecycleBin -force -Confirm
    }
    Else{
        Start-Sleep -s 2
        $FormTextBox.text += "`r`nCheckbox not checked to clear, if you want to clear check the box then run again..."
    }



}
function EraseLocalProfiles {

    if (($ConfirmCheckbox.Checked -eq $true) -or ($ConfirmCheckbox.Checked)){
        $FormTextBox.text = "Preparing to wipe profiles, this might take some time! :) "
        Start-Sleep -s 3
        Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.Loaded -eq $False} | Remove-CimInstance 
        Start-Sleep -s 1
        $FormTextBox.text = "Profiles have been cleaned!"
    }
    Else{
	$LocalProfile = Get-CimInstance -Class Win32_UserProfile | Where-Object {$_.Loaded -eq $False} | Select-Object LocalPath | Out-String
	$FormTextBox.text = "Apply the Confirm Changes Button to apply wiping... " + $LocalProfile
    }
}
function EraseLocalAdministrators {
    $GA = Get-LocalGroupMember -Group "Administrators" | Select-Object Name 
    #Write-Host $GATrimed 
    ForEach($object in $GA){
        $User = $object.Name
        $Name = $User.ToString()
        #Write-Host $User
        #Change the 'or' statements to what you want to be left alone for the computer
        if (($Name -like '*\Domain Admins') -or ($Name -like '*\Administrator') -or ($Name -like $Iam)){
        }
        Else{
        Write-Host $Name
        If ($ConfirmCheckbox.checked -eq $True){
            Remove-LocalGroupMember -Group "Administrators" -Member $Name
            $FormTextBox.text = "Erasing $Name"
            Start-Sleep -s 3
            }
        Else{
            $FormTextBox.text = "Check the Confirm Changes Checkbox to Erase Local Profiles that are irregular"
            Start-Sleep -s 1
            }
        }
    }
}
function GetLocalData{
Start-Sleep -s 1
$FormTextBox.text = "Loading..."
Start-Sleep -s 1

$AllArray = Get-ComputerInfo -Property "OSName","OSVersion","OSBuildNumber","CsName","CSModel","CSManufacturer","OsLastBootUpTime","BiosSeralNumber" | Format-List | Out-String
$AllArrayFormat = $AllArray.trim() + "`r`n"

Start-Sleep -s 1
$FormTextBox.text = $AllArrayFormat
Start-Sleep -s 1
}
[void]$ScriptingTools.ShowDialog()