---
title: GPO Search
description: 
published: true
date: 2024-05-14T20:18:45.175Z
tags: 
editor: markdown
dateCreated: 2024-02-28T21:51:48.147Z
---

# GPO Search
Searching for a specific phrase within Group Policy Objects (GPOs) can be a tedious task. This script simplifies the process by allowing you to input the specific phrase you're looking for and quickly identifies the relevant policy it belongs to. This streamlines updates and ensures policies are accurately maintained.

Assuming you have the proper permission to run this, you can modify the following line to include the word or phrase you're looking for.

```powershell
$string = "\\FILE01\"
```
```powershell
<#
.SYNOPSIS
  Searches for a specific word or phrase within all Group Policy Objects (GPOs) in a domain.

.DESCRIPTION
  This script scans all the GPOs in a specified domain for a given phrase. It is useful for identifying GPOs related to specific file servers or local workstation admin accounts.

.PARAMETER string
    The phrase to search for within the GPOs. Example: "\\FILE01\".

.INPUTS
  None

.OUTPUTS
  None - The results are displayed on the console.

.NOTES
  Version:        1.0
  Author:         Rob Lane
  Creation Date:  unknown
  Purpose/Change: Initial script development
  
.EXAMPLE
  PS> .\Search-GPO.ps1
  Executes the script to search for the specified phrase within all GPOs in the domain.
#>

# Search for a phrase within the GPO that you are looking for. 
# This can be useful for a file server or searching for local workstation admin accounts, i.e., \\FILE01\ or 'Administrator'
$string = "\\FILE01\"

$DomainName = $env:USERDNSDOMAIN

write-host "Finding all the GPOs in $DomainName"

Import-Module GroupPolicy

# Get all the GPOs within the domain
$allGposInDomain = Get-GPO -All -Domain $DomainName

# Define an array of strings and initialize it with an empty array
[string[]] $FoundGPO = @()

Write-Host "Searching"

# Attempt each GPO in $allGposInDomain and do the following for each one:
foreach ($gpo in $allGposInDomain) {
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml

    if ($report -match $string) {
        write-host "Match found in: $($gpo.DisplayName)" -foregroundcolor "red"
        $FoundGPO += "$($gpo.DisplayName)";
    }
    else {
        Write-Host "No match in: $($gpo.DisplayName)"
    }
}

write-host "`r`n"

write-host "Results:" -foregroundcolor "Green"

foreach ($Found in $FoundGPO) {
    write-host "Match found in: $($Found)" -foregroundcolor "Red"
}
