---
title: List AD Group Membership of Users in an OU
description: A quick way to find group membership within a specific OU.
published: true
date: 2024-02-21T18:39:23.692Z
tags: powershell, active dire, groups
editor: markdown
dateCreated: 2024-02-21T18:18:24.129Z
---

# List AD Group Membership of Users in an OU
Sometimes you find yourself needing to see which AD groups an OU of individuals belong to. This script assists with that! It will also allow you to include an excluded (or multiple) excluded groups, such as an all staff distribution list.
```powershell
Import-Module ActiveDirectory

$OU = "OU=Students,OU=District Users,DC=local,DC=net"

# Define excluded groups
$excludedGroups = @("Excluded Group 1", "Excluded Group 2")

$allGroups = @()

$users = Get-ADUser -Filter * -SearchBase $OU -Properties MemberOf

# Loop through each user
foreach ($user in $users) {
    # Get groups that the user is a member of
    $groups = $user.MemberOf | Get-ADGroup | Select-Object -ExpandProperty Name

    $filteredGroups = $groups | Where-Object { $_ -notin $excludedGroups }

    if ($filteredGroups.Count -gt 0) {
        $userName = $user.SamAccountName

        Write-Host "User: $userName is a member of the following groups:"
        foreach ($group in $filteredGroups) {
            Write-Host " - $group"
            # Add the group to the allGroups array
            $allGroups += $group
        }
        Write-Host ""
    }
}

$uniqueGroups = $allGroups | Sort-Object -Unique

Write-Host "Unique groups found (excluding 'Excluded Group 1' and 'Excluded Group 2'):"
$uniqueGroups | ForEach-Object { Write-Host " - $_" }