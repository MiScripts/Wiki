---
title: Update AD User Pager Field from samAccountName
description: This script will update the 'pager' field in Active Directory to their samAccountName. This has been useful for a district or location which utilizes PaperCut.
published: true
date: 2024-02-01T02:48:25.252Z
tags: powershell, active directory, papercut, samaccountname
editor: markdown
dateCreated: 2024-02-01T02:46:25.040Z
---

<!--
title: Update AD User Pager Field from samAccountName
description: This script will update the 'pager' field in Active Directory to their samAccountName. This has been useful for a district or location which utilizes PaperCut. This allows you to configure PaperCut to use the 'pager' field in Active Directory and their student ID for print release. 
published: true
date: 2024-1-31
tags: 
editor: markdown
dateCreated: 2024-1-31
-->

# Update AD User Pager Field from samAccountName
This script will update the 'pager' field in Active Directory to their samAccountName. This has been useful for a district or location which utilizes PaperCut. This allows you to configure PaperCut to use the 'pager' field in Active Directory and their student ID for print release. 

```PowerShell
Import-Module ActiveDirectory

# Define the filter for samAccountName starting with '200'
# This matches the beginning of our student usernames within MISTAR
$filter = "samAccountName -like '200*'"

# Get the users matching the filter
$users = Get-ADUser -Filter $filter -Properties samAccountName

# Iterate through each user and update the pager field
foreach ($user in $users) {
    try {
        # Set the pager field to the user's samAccountName
        Set-ADUser -Identity $user -Replace @{pager=$user.samAccountName}
        Write-Host "Updated pager for user: $($user.samAccountName)"
    } catch {
        Write-Host "Failed to update pager for user: $($user.samAccountName). Error: $_"
    }
}
```