---
title: Remove Users from All AD Groups
description: 
published: true
date: 2024-06-23T19:35:55.824Z
tags: active directory, groups, power, users, user management, group management
editor: markdown
dateCreated: 2024-06-23T19:35:55.824Z
---

# Remove Users from AD Groups 
All users in the OU you specify for the OU variable will be looped through and have all group memberships removed, except for the group specified in the excludedGroup variable. The excluded group is set to the default primary group Domain Users by default. 
 
This can be useful to run on an OU of disabled student or staff accounts you don't want to have group memberships instead of manually removing groups.

```powershell
<#
.SYNOPSIS
  This script removes users in the target OU from all groups they are a member of, except for the excluded group.

.DESCRIPTION
  All users in the OU you specify for the ou variable will be looped through and have all group memberships removed, except for the group specified in the excludedGroup variable. The excluded group is set to the default primary group Domain Users by default. This can be useful to run on an OU of disabled student or staff accounts you don't want to have group memberships instead of manually removing groups.

.PARAMETER ou, excludedGroup
  $ou is the path to the OU to target. Default is "OU=DisabledStaff,DC=example,DC=com"

  $excludedGroup is the name of the group to skip when removing group memberships. Default is "Domain Users"

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Erik Spisak
  Creation Date:  5/16/2024
  Purpose/Change: Initial script development
  
.EXAMPLE
  PS> .\RemoveUsersFromAllGroups.ps1
  Removes the group memberships of all users in the "DisabledStaff" OU.

#>

Import-Module ActiveDirectory

# Set the OU to target and a group name you want to exclude
$ou = Read-Host "OU=DisabledStaff,DC=example,DC=com"
$excludedGroup = "Domain Users"


# Get all users in the OU
$users = Get-ADUser -SearchBase $ou -Filter *

# Loop through each user
foreach($user in $users)
{
    # Get all groups the user is a member of
    $groups = Get-ADPrincipalGroupMembership $user | Select-Object -ExpandProperty Name

    # Loop through each group
    foreach($group in $groups)
    {
        # Skip the excluded group
        if($group -eq $excludedGroup)
        {
            continue
        }

        # Remove the user from the group
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    }
}