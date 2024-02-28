---
title: GPO Search
description: Searching for a specific GPO (especially if you know the phrase) you're searching for can be very tedious. This script allows you to search for a phrase and find which policy it is apart of.
published: true
date: 2024-02-28T21:51:48.147Z
tags: 
editor: markdown
dateCreated: 2024-02-28T21:51:48.147Z
---



# GPO Search
```powershell
# Search for a phrase within the GPO that you are looking for. This can be useful for file servers or searching for local workstation admin accounts, i.e., \\FILE01\ or 'Administrator'
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