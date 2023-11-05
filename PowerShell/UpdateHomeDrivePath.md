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
