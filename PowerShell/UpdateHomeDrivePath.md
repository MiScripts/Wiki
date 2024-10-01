---
title: Update Home Drive Path
description: 
published: true
date: 2024-10-01T19:34:43.912Z
tags: powershell
editor: markdown
dateCreated: 2023-11-05T19:56:04.957Z
---

<!--
title: Update AD Home Drive Path
description: This script can be used to update the home path of AD users within a specific OU. It can be used after a file server migration where you are required to update the home path to reflect the new server.
published: true
date: 2023-11-05T17:20:06.721Z
tags: 
editor: markdown
dateCreated: 2023-11-05T17:20:06.721Z
-->

# Update AD Home Path
This script can assist in updating a specific OU's AD user accounts to a server. In the example below, we'll assume $oldServer is the old server name and $newServer is the new server name. It will also create an output log of all of the changes made in the event something unexpected occurs and you need to manually intevere. 

```PowerShell
<#
.SYNOPSIS
  Updates the home drive mapping of Active Directory users from an old server to a new server.
.DESCRIPTION
  This script retrieves all users in a specified Organizational Unit (OU) and checks if their HomeDirectory is mapped to an old server. If the home drive is mapped to the old server, the script replaces the server name with the new one and updates the HomeDirectory attribute. It also logs each change to a log file.
.PARAMETER oldServer
    The name of the old server to be replaced in the HomeDirectory path.
.PARAMETER newServer
    The name of the new server to replace the old server in the HomeDirectory path.
.PARAMETER ouName
    The distinguished name of the Organizational Unit (OU) where the users are located.
.PARAMETER logFile
    The file path where log entries will be written.
.INPUTS
  None. The script retrieves users from Active Directory based on the specified OU.
.OUTPUTS
  Log file entries for each user whose home drive was updated.
.NOTES
  Version:        1.0
  Author:         Rob Lane
  Creation Date:  11/5/23
  Purpose/Change: Initial script development.
.EXAMPLE
  Run the script to update home drives from 'oldserver' to 'newserver':
    ./UpdateHomeDrive.ps1
#>

Import-Module ActiveDirectory

# Set the name of the old server and the new server
$oldServer = "oldserver"
$newServer = "newserver"

# Set the name of the OU where the users are located
$ouName = "OU=Staff,OU=Users,DC=example,DC=com"

# Set the path and filename for the log file
$logFile = "C:\Scripts\UpdateHomeDrive-Building.log"

# Get a list of all users in the specified OU
$users = Get-ADUser -SearchBase $ouName -Filter * -Properties HomeDirectory

# Loop through each user
foreach ($user in $users) {
  # Get the user's current home drive mapping
  $homeDrive = $user.HomeDirectory

  # Check if the home drive is mapped to the old server
  if ($homeDrive -like "*$oldServer*") {
    # Replace the old server name with the new server name
    $newHomeDrive = $homeDrive -replace $oldServer,$newServer

    # Set the user's home drive mapping to the new server
    Set-ADUser -Identity $user.SamAccountName -HomeDirectory $newHomeDrive

    # Write a log entry for the user
    Add-Content -Path $logFile -Value "$(Get-Date -Format G): Updated home drive for user $($user.SamAccountName) from $homeDrive to $newHomeDrive"
  }
}
```
