---
title: Disable Accidental Deletion for AD OUs
description: One of the first things I'll do in a controlled lab environment, or a sandbox, is to disable accidental deletion of OUs. This can save time in the long run, especially if you're working on scripts that may affect multiple OUs. 
published: true
date: 2024-02-01T02:13:12.665Z
tags: powershell, active directory, ous, sandbox, lab
editor: markdown
dateCreated: 2024-02-01T01:34:27.313Z
---

<!--
title: Disable Accidental Deletion of AD OUs
description: One of the first things I'll do in a controlled lab environment, or a sandbox, is to disable accidental deletion of OUs. This can save time in the long run, especially if you're working on scripts that may affect multiple OUs.
published: true
date: 2024-1-31
tags: 
editor: markdown
dateCreated: 2024-1-31
-->

# Disable Accidental Deletion of AD OUs
One of the first things I'll do in a ***controlled*** lab environment, or a sandbox, is to disable accidental deletion of OUs. This can save time in the long run, especially if you're working on scripts that may affect multiple OUs. This allows you the flexibility to move OUs around as needed, in a lab, when required to do so quickly for testing.

**NOTE:** This is a potentially destructive action. This should never be used in a production environment. This is to only be used in a controlled testing (or sandbox/lab) environment.

```PowerShell
# Import the Active Directory module
Import-Module ActiveDirectory

# Get a list of all OUs in Active Directory
$ous = Get-ADOrganizationalUnit -Filter * -SearchBase "OU=BaseOU,DC=TestLab,DC=local" -SearchScope Subtree

# Loop through each OU and disable accidental deletion protection
foreach ($ou in $ous) {
    Set-ADOrganizationalUnit -Identity $ou.DistinguishedName -ProtectedFromAccidentalDeletion $false
    Write-Host "Accidental deletion protection disabled for $($ou.Name)"
}
```