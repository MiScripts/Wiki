Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
$StartLocal = Get-Location 
$Variables = $StartLocal.toString() + "\StaffCreationSource.ps1"
#Global Variables - Import from file - Make sure you have the source in the same directory as the GUI
. $Variables

[System.Windows.Forms.Application]::EnableVisualStyles()

$CreateUser                   = New-Object system.Windows.Forms.Form
$CreateUser.ClientSize        = New-Object System.Drawing.Point(500,400)
$CreateUser.text              = "Staff Creation/Disabling Script"
$CreateUser.TopMost           = $false

$FirstNameTextBox                = New-Object system.Windows.Forms.TextBox
$FirstNameTextBox.multiline      = $false
$FirstNameTextBox.width          = 174
$FirstNameTextBox.height         = 25
$FirstNameTextBox.location       = New-Object System.Drawing.Point(14,46)
$FirstNameTextBox.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$FirstName                       = New-Object system.Windows.Forms.Label
$FirstName.text                  = "Enter First Name"
$FirstName.AutoSize              = $true
$FirstName.width                 = 25
$FirstName.height                = 10
$FirstName.location              = New-Object System.Drawing.Point(12,26)
$FirstName.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LastName                        = New-Object system.Windows.Forms.Label
$LastName.text                   = "Enter Last Name"
$LastName.AutoSize               = $true
$LastName.width                  = 25
$LastName.height                 = 10
$LastName.location               = New-Object System.Drawing.Point(14,87)
$LastName.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LastNameTextBox                 = New-Object system.Windows.Forms.TextBox
$LastNameTextBox.multiline       = $false
$LastNameTextBox.width           = 174
$LastNameTextBox.height          = 20
$LastNameTextBox.location        = New-Object System.Drawing.Point(12,109)
$LastNameTextBox.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$EdlioLabel                       = New-Object system.Windows.Forms.Label
$EdlioLabel.text                  = "Edlio"
$EdlioLabel.AutoSize              = $true
$EdlioLabel.width                 = 25
$EdlioLabel.height                = 10
$EdlioLabel.location              = New-Object System.Drawing.Point(27,250)
$EdlioLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$EdlioCheckbox = New-Object System.Windows.Forms.Checkbox 
$EdlioCheckbox.Location = New-Object System.Drawing.Size(10,250) 
$EdlioCheckbox.Size = New-Object System.Drawing.Size(20,20)
$EdlioCheckbox.Text = "Edlio"
$EdlioCheckbox.TabIndex = 4
$objForm.Controls.Add($EdlioCheckbox)

$CCLabel                       = New-Object system.Windows.Forms.Label
$CCLabel.text                  = "Notify Staff"
$CCLabel.AutoSize              = $true
$CCLabel.width                 = 25
$CCLabel.height                = 10
$CCLabel.location              = New-Object System.Drawing.Point(137,250)
$CCLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$CCCheckbox = New-Object System.Windows.Forms.Checkbox 
$CCCheckbox.Location = New-Object System.Drawing.Size(120,250) 
$CCCheckbox.Size = New-Object System.Drawing.Size(20,20)
$CCCheckbox.Text = "Notify Staff"
$CCCheckbox.TabIndex = 4
$objForm.Controls.Add($CCCheckbox)

$GoogleLabel                       = New-Object system.Windows.Forms.Label
$GoogleLabel.text                  = "Google"
$GoogleLabel.AutoSize              = $true
$GoogleLabel.width                 = 25
$GoogleLabel.height                = 10
$GoogleLabel.location              = New-Object System.Drawing.Point(27,280)
$GoogleLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$GoogleCheckbox = New-Object System.Windows.Forms.Checkbox 
$GoogleCheckbox.Location = New-Object System.Drawing.Size(10,280) 
$GoogleCheckbox.Size = New-Object System.Drawing.Size(20,20)
$GoogleCheckbox.Text = "Google"
$GoogleCheckbox.TabIndex = 4
$objForm.Controls.Add($GoogleCheckbox)

$OnlyGoogleLabel                       = New-Object system.Windows.Forms.Label
$OnlyGoogleLabel.text                  = "Only Google"
$OnlyGoogleLabel.AutoSize              = $true
$OnlyGoogleLabel.width                 = 25
$OnlyGoogleLabel.height                = 10
$OnlyGoogleLabel.location              = New-Object System.Drawing.Point(137,280)
$OnlyGoogleLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$OnlyGoogleCheckbox = New-Object System.Windows.Forms.Checkbox 
$OnlyGoogleCheckbox.Location = New-Object System.Drawing.Size(120,280) 
$OnlyGoogleCheckbox.Size = New-Object System.Drawing.Size(20,20)
$OnlyGoogleCheckbox.Text = "Only Google"
$OnlyGoogleCheckbox.TabIndex = 4
$objForm.Controls.Add($OnlyGoogleCheckbox)

$SpiceworksLabel                       = New-Object system.Windows.Forms.Label
$SpiceworksLabel.text                  = "Spiceworks Ticket Number"
$SpiceworksLabel.AutoSize              = $true
$SpiceworksLabel.width                 = 25
$SpiceworksLabel.height                = 10
$SpiceworksLabel.location              = New-Object System.Drawing.Point(15,310)
$SpiceworksLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$SpiceworksTextbox                = New-Object system.Windows.Forms.TextBox
$SpiceworksTextbox.multiline      = $false
$SpiceworksTextbox.width          = 174
$SpiceworksTextbox.height         = 25
$SpiceworksTextbox.location       = New-Object System.Drawing.Point(14,330)
$SpiceworksTextbox.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$CreateUserButton                   = New-Object system.Windows.Forms.Button
$CreateUserButton.text              = "Create User"
$CreateUserButton.width             = 100
$CreateUserButton.height            = 50
$CreateUserButton.location          = New-Object System.Drawing.Point(275,50)
$CreateUserButton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$CreateUserButton.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#00FF00")
$CreateUserButton.Enabled           = $True

$DisableUserButton                   = New-Object system.Windows.Forms.Button
$DisableUserButton.text              = "Disable User"
$DisableUserButton.width             = 100
$DisableUserButton.height            = 50
$DisableUserButton.location          = New-Object System.Drawing.Point(380,50)
$DisableUserButton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$DisableUserButton.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#FF0000")
$DisableUserButton.Enabled           = $True

$HelpUserButton                   = New-Object system.Windows.Forms.Button
$HelpUserButton.text              = "Help"
$HelpUserButton.size              = New-Object System.Drawing.Size(75,23)
$HelpUserButton.location          = New-Object System.Drawing.Point(40,370)
$HelpUserButton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$HelpUserButton.Enabled           = $True


$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,370)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$BuildingLabel = New-Object System.Windows.Forms.Label
$BuildingLabel.Location = New-Object System.Drawing.Point(140,150)
$BuildingLabel.Size = New-Object System.Drawing.Size(140,20)
$BuildingLabel.Text = 'Additional Buildings'
$BuildingLabel.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$BuildingListbox = New-Object System.Windows.Forms.Listbox
$BuildingListbox.Location = New-Object System.Drawing.Point(140,170)
$BuildingListbox.Size = New-Object System.Drawing.Size(120,20)
$BuildingListbox.SelectionMode = 'MultiExtended'
foreach ($Object in $GlobalBuildings)
{
[void] $BuildingListbox.Items.Add($Object)
}

$BuildingListbox.Height = 70
$form.Controls.Add($BuildingListbox)
$form.Topmost = $true


$FirstBuildingLabel = New-Object System.Windows.Forms.Label
$FirstBuildingLabel.Location = New-Object System.Drawing.Point(14,150)
$FirstBuildingLabel.Size = New-Object System.Drawing.Size(120,20)
$FirstBuildingLabel.Text = 'Home Building'
$FirstBuildingLabel.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$FirstBuildingListbox = New-Object System.Windows.Forms.Listbox
$FirstBuildingListbox.Location = New-Object System.Drawing.Point(12,170)
$FirstBuildingListbox.Size = New-Object System.Drawing.Size(120,20)
foreach ($Object in $GlobalBuildings)
{
[void] $FirstBuildingListbox.Items.Add($Object)
}

$FirstBuildingListbox.Height = 70
$form.Controls.Add($FirstBuildingListbox)
$form.Topmost = $true

$FormTextBox                 = New-Object system.Windows.Forms.TextBox
$FormTextBox.multiline       = $true
$FormTextBox.width           = 175
$FormTextBox.height          = 200
$FormTextBox.location        = New-Object System.Drawing.Point(300,120)
$FormTextBox.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$FormTextBox.Enabled         = $false

$CreateUser.controls.AddRange(@($FirstNameTextBox,$FirstName,$LastName,$LastNameTextBox,$CreateUserButton,$CreateUserButton, $BuildingLabel, $BuildingListbox, $GoogleCheckbox, $EdlioCheckbox, $EdlioLabel, $GoogleLabel, $FormTextBox, $cancelButton, $FirstBuildingListbox, $FirstBuildingLabel, $DisableUserButton, $HelpUserButton, $SpiceworksLabel, $SpiceworksTextbox, $CCCheckbox, $CCLabel, $OnlyGoogleCheckbox, $OnlyGoogleLabel))

$CreateUserButton.Add_Click({ CreateUserButton })
$DisableUserButton.Add_Click({ DisableUserButton })
$HelpUserButton.Add_Click({ HelpUserButton })
#Write your logic code here
function CreateUserButton { 
#Checks to see if there is enough information to create a user on their name
If (($FirstNameTextBox.Text.Length -eq 0) -or ($LastNameTextBox.Text.Length -eq 0)) {
    $FormTextBox.text = "Output is not Valid, make sure you have a First Name, Last Name, and a building."
}
Else{
    #Checks to see if a home building is assigned, if not will not run any further 
    If ($FirstBuildingListbox.Text.Length -eq 0){
    $FormTextBox.text = "Output is not Valid, make sure you specify the building(s) you want."
    }
    Else{
    $FName = $FirstNameTextBox.Text
    $LName = $LastNameTextBox.Text
    $name = ($FName[0] + $LName).ToLower()
    $Buildings = $BuildingListbox.SelectedItems
    $HomeBuilding = $FirstBuildingListbox.SelectedItems
    $FormTextBox.text = "Output is Valid. $name $FName $LName $Buildings $HomeBuilding"
    Start-Sleep -s 3 
    $FormTextBox.text = "Preparing to create $name's account(s)"
    Start-Sleep -s 3 
    $User = Get-ADUser -filter {sAMAccountName -eq $name}
If (!$User) {
        #If Only Google is checked will ignore the AD Creation
        If (($OnlyGoogleCheckbox.Checked -eq $false)) {
            $newu = @{
            SamAccountName = $name
            UserPrincipalName = $name + $Domain
            GivenName = $FName 
            SurName = $LName 
            DisplayName = $FName + " " + $LName 
            Name = $name
            Description = $LName + "," + $FName
            Enabled = $true
            Path = "OU=$HomeBuilding,$ADOU" 
            AccountPassword = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
            EmailAddress = $name + $Domain
            ChangePasswordAtLogon = $true  
        }
        $FormTextBox.text = "Creating AD Account for $name"
        Start-Sleep -s 3 
        New-ADUser @newu
        #The next step has a home folder created for the user
        if (Test-Path -Path "$HomeDirectory$name"){
            $FormTextBox.text = "Home Folder Exists"
            Start-Sleep -s 1
            }
        else {
            $FormTextBox.text = "Creating Home Folder"
            Start-Sleep -s 1
            New-Item -Path "$HomeDirectory$name" -ItemType Directory
            #Creates the permissions for the folder    
            $Acl = Get-Acl "$HomeDirectory$name"
            $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("$name", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
            $Acl.SetAccessRule($Ar)
            Set-Acl "$HomeDirectory$name" $Acl
                }
        #Adds groups for the AD User depending on the buildings that were assigned
        Add-ADGroupMember "Staff" "$name";
        $FormTextBox.text = "Adding $Homebuilding Group"
        Start-Sleep -s 1
        Add-ADGroupMember "Area-$HomeBuilding" "$name"
        foreach ($object in $Buildings) {
            $FormTextBox.text = "Adding $object Group"
            Start-Sleep -s 1
            Add-ADGroupMember "Area-$object" "$name"
        }
        #Checks for if Edlio was check and if it was then assigns Edlio Staff and Edlio for all buildings
        if ($EdlioCheckbox.checked ){
            $FormTextBox.text = "Adding $HomeBuilding Group for Edlio"
            Start-Sleep -s 1
            Add-ADGroupMember "Edlio Teacher" "$name"
            Add-ADGroupMember "Edlio $HomeBuilding" "$name"
        foreach ($Object in $Buildings){
            $FormTextBox.text = "Adding $Object Group for Edlio"
            Start-Sleep -s 1
            Add-ADGroupMember "Edlio $Object" "$name"
        }
    }
    #Creates an array from a dictionary of the buildings for an email's CC.
    $EmailBuildings = $HomeBuilding + $Buildings
    if ($CCCheckbox.checked){
    $EmailList  = $EmailBuildings | ForEach-Object { $CCEmails[$_] }
    }
} 
Else{

}
    #Checks if you checked Google and/or OnlyGoogle is checked, also needs GAM to work
    If (($GoogleCheckbox.checked) -or ($OnlyGoogleCheckbox.checked -eq $true)) {
        $GoogleOU = "Staff of $HomeBuilding"
        $FormTextBox.text = "Creating Google Account"
        Start-Sleep -s 3
        $email = $name + $Domain
        gam create user $email firstname $FName lastname $LName org /$GoogleOU password $DefaultPassword changepassword off 
        $FormTextBox.text = "Assigning Groups for Google Account"
        Start-Sleep -s 3
        gam update group classroom_teachers$Domain add member user $email
        gam update group all-staff$Domain add member user $email
        $FormTextBox.text = "Assigning user to $HomeBuilding group"
        Start-Sleep -s 1
        gam update group $HomeBuilding-staff$Domain add member user $email
    foreach ($object in $Buildings) {
        $FormTextBox.text = "Assigning user to $object group"
        Start-Sleep -s 1
        gam update group $object-staff$Domain add member user $email
    }
    
    #If Spiceworks has been checked and a valid ticket number has been inputed will send an email out
    If($SpiceworksTextbox.text -ne ""){
        if ($SpiceworksTextbox.text -notmatch '^[0-9]+$'){
            $FormTextBox.text = "Cannot send email ticket number not in correct format, try something like 54321"
            Start-Sleep -s 3
        }
        else {= 
            $Message = new-object Net.Mail.MailMessage;
            $ofs = ','
            $CC = [string]$EmailList
            $Message.From = $EmailFrom;
            $Message.To.Add($EmailTo); 
            $Message.CC.Add($CC);
            $Message.Subject = "Staff account created for AD and Google for " + $FName + " " + $LName + "[Ticket " + "#" + $SpiceworksTextbox.text + "]"
            $Message.Body = "Staff member " + $FName + " " + $LName + "'s account has been created for AD and Google. Email is " + $email + " and their password should be the default for new accounts"  
            $SMTPClient.Send($Message)
            $FormTextBox.text = "$name has been created in Google and AD and emailed"
            Start-Sleep -s 3 
        }
    } else {
        $FormTextBox.text = "Account has been created and groups assigned"
    }



    }
    Else{
        If($SpiceworksTextbox.text -ne ""){
            if ( $SpiceworksTextbox.text -notmatch '^[0-9]+$'){
                $FormTextBox.text = "Cannot send email ticket number not in correct format, try something like 54321"
                Start-Sleep -s 3
            }
            else {= 
                $Message = new-object Net.Mail.MailMessage;
                $ofs = ','
                $CC = [string]$EmailList
                $Message.From = $EmailFrom;
                $Message.To.Add($EmailTo); 
                $Message.CC.Add($CC);
                $Message.Subject = "Staff account created for AD for " + $FName + " " + $LName + "[Ticket " + "#" + $SpiceworksTextbox.text + "]";
                $Message.Body = "Staff member " + $FName + " " + $LName + "'s account has been created for AD. Email is " + $email + " and their password should be the default for new accounts";
                $SMTPClient.Send($Message);
                $FormTextBox.text = "$name has been created in AD and emailed";
                Start-Sleep -s 3
            }
        } else {
            $FormTextBox.text = "Account has been created and groups assigned"
            Start-Sleep -s 3
        }
    }
} Else {
    $FormTextBox.text = "User exists in AD, needs manually attention."
}
  
 
}

}

}
function DisableUserButton {
    $GroupMember =  Get-Adgroupmember -Identity "Domain Admins" | Select-Object SamAccountName 
If (($FirstNameTextBox.Text.Length -eq 0) -or ($LastNameTextBox.Text.Length -eq 0)) {
    $FormTextBox.text = "Output is not Valid, make sure you have the First Name and Last Name to disable an account"
    }
else {
    $FName = $FirstNameTextBox.Text
    $LName = $LastNameTextBox.Text
    $name = ($FName[0] + $LName).ToLower()
    if ($OnlyGoogleCheckbox.checked){
        $User = $true
    } Else{
        $User = Get-ADUser -filter {sAMAccountName -eq $name}
    }
    If (!$User) { 
        $FormTextBox.text = "User does not exists in AD or is a Google only account, please check you input" 
    } Else {
    if ($GroupMember.SamAccountName -contains $name) {
        $FormTextBox.text = "Cannot disable Domain Admin Account, will now be exiting..."
        Exit
    }
    Else {
        If ($OnlyGoogleCheckbox.Checked -ne $true) {
    $FormTextBox.text = "AD Account for $FName will be disabled in 3 seconds."
        Start-Sleep -s 3
        Disable-ADAccount -Identity $name
        }
        if (($GoogleCheckbox.checked) -or ($OnlyGoogleCheckbox.checked -eq $true)) {
            $GEmail = $name + $Domain
            $FormTextBox.text = "Google Account for $FName will be disabled in 3 seconds."
            Start-Sleep -s 3
            gam update user $GEmail suspended on
            If($SpiceworksTextbox.text -ne ""){
            if ( $SpiceworksTextbox.text -notmatch '^[0-9]+$'){
                $FormTextBox.text = "Cannot send email ticket number not in correct format, try something like 54321"
                Start-Sleep -s 3
            }
            else {= 
                $Subject = "Staff Account Disabled for AD and Google for " + $FName + " " + $LName + "[Ticket " + "#" + $SpiceworksTextbox.text + "]"
                $Body = "Ticket " + $SpiceworksTextbox.text + " Staff member " + $FName + " " + $LName + "'s account has been disabled for AD and Google."
                $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
                $FormTextBox.text = "$name has been disabled in Google and AD and emailed"
                Start-Sleep -s 3
            }
        } else {
            $FormTextBox.text = "Account for $name has been disabled in Google and AD"
            Start-Sleep -s 3
        }
        }
        Else{
            If($SpiceworksTextbox.text -ne ""){
                if ($SpiceworksTextbox.text -notmatch '[^0-9]'){
                    $FormTextBox.text = "Cannot send email ticket number not in correct format, try something like 54321"
                    Start-Sleep -s 3
                }
                else {
                    $Subject = "Staff Account Disabled for AD for " + $FName + " " + $LName + "[#Ticket " + "#" + $SpiceworksTextbox.text + "]"
                    $Body = "Ticket " + $SpiceworksTextbox.text + " Staff member " + $FName + " " + $LName + "'s account has been disabled for AD."
                    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
                    $FormTextBox.text = "$name has been disabled in AD and email sent"
                    Start-Sleep -s 3
                }
            } else {
                $FormTextBox.text = "Account for $name has been disabled in AD"
                Start-Sleep -s 3
            }
        }
    }
}
}
}
function HelpUserButton {
    $FormTextBox.text = "This form is for creating and disable staff members for Coloma Community Schools!  To disable a user you must have their First Name, Last Name, and Home Building.  You can also add more buildings and give them a Google account and Edlio by selecting the checkboxes respectfully."
    Start-Sleep -s 10 

    $FormTextBox.text = "The Spiceworks ticket number is for directly replying to the created ticket for staff creation/disable.  Also the Notify Staff checkbox is for emailing the staff of those buidlings if Spiceworks has a valid number."
    Start-Sleep -s 10

    $FormTextBox.text = "To disable accounts you need just the First Name and Last Name, check the Google box to disable their Google account as well. Click on cancel to end the script anytime.  Made by Nathan Wonderly :)"
    Start-Sleep -s 10

    $FormTextBox.text = ""
}

[void]$CreateUser.ShowDialog()