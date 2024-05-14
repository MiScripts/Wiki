---
title: Group AD/O365 Sync with CSV
description: 
published: true
date: 2024-05-14T19:44:00.704Z
tags: powershell, active directory, office 365, sync
editor: markdown
dateCreated: 2024-05-14T19:44:00.704Z
---

# Group AD/O365 Sync with CSV
I used this script for a district that had two classes that had required specific services to be enabled on their A3 license for students. For example, one of the classes was a newspaper/media course which required Teams, whereas the other course did not. We disable Teams by default in most cases for students, so this allowed us to enable it for those specific students.

In order to work, you would have two CSV files that contained student IDs. Those CSVs must live in the directory specified by lines 65 and 68 below. 

```powershell
"C:\Scripts\ADGroupSyncCSV\Students_ClassOne.csv"
"C:\Scripts\ADGroupSyncCSV\Students_ClassTwo.csv"
```

Additionally, you would have to have an AD security group for each "CSV group" which is specified on lines 66 and 69. 

```powershell
$group1 = "EX-ClassOne-O365_A3"
$group2 = "EX-ClassTwo-O365_A3"
```
All changes will be output to the log location, which by default is:
```
C:\Scripts\ADGroupSyncCSV\Logs
```


```powershell
<#
.SYNOPSIS
  Syncs Active Directory groups with user lists from CSV files and logs the operations.

.DESCRIPTION
  This script reads user lists from specified CSV files and synchronizes the membership of corresponding Active Directory groups. It logs all operations, including adding and removing users, and handles errors by writing them to a log file.

.PARAMETER csvPath
    Specifies the path to the CSV file containing the list of users to be synchronized.

.PARAMETER groupName
    Specifies the name of the Active Directory group to be synchronized with the CSV file.

.PARAMETER otherGroupName
    Specifies the name of another group from which users should be removed if they are present.

.PARAMETER logFile
    Specifies the path to the log file where operations and errors will be recorded.

.INPUTS
  None

.OUTPUTS
  None - Operations are logged to a specified log file.

.NOTES
  Version:        1.0
  Author:         Rob Lane
  Creation Date:  12/10/2023
  Purpose/Change: Initial script development
  
.EXAMPLE
  PS> .\Sync-ADGroupWithCSV.ps1
  Executes the script to sync Active Directory groups with the user lists from the CSV files.
#>

# Log file directory and file name
$logDir = "C:\Scripts\ADGroupSyncCSV\Logs"
$logFile = Join-Path -Path $logDir -ChildPath "GroupSyncLog_$(Get-Date -Format 'MM-dd-yyyy').log"

# Define file names and group names
$csvFile1 = "C:\Scripts\ADGroupSyncCSV\Students_ClassOne.csv"
$group1 = "EX-ClassOne-O365_A3"

$csvFile2 = "C:\Scripts\ADGroupSyncCSV\Students_ClassTwo.csv"
$group2 = "EX-ClassTwo-O365_A3"

$otherGroup = "EX-Student_O365_A3"

function Remove-FromOtherGroup {
    param (
        [string]$user,
        [string]$otherGroupName,
        [string]$logFile
    )

    try {
        $isMember = Get-ADGroupMember -Identity $otherGroupName -ErrorAction SilentlyContinue | Where-Object { $_.SamAccountName -eq $user }
        if ($isMember) {
            Remove-ADGroupMember -Identity $otherGroupName -Members $user -Confirm:$false
            $logMessage = "$(Get-Date) - User $user removed from $otherGroupName."
            Write-Host $logMessage
            Add-Content -Path $logFile -Value $logMessage
        }
    } catch {
        $errorMessage = "$(Get-Date) - Error removing user $user from $otherGroupName $_"
        Write-Host $errorMessage -ForegroundColor Red
        Add-Content -Path $logFile -Value $errorMessage
    }
}

function Sync-GroupWithCSV {
    param (
        [string]$csvPath,
        [string]$groupName,
        [string]$otherGroupName,
        [string]$logFile
    )
    
    # Check if the CSV file exists
    if (Test-Path $csvPath) {
        # Get current group members
        $currentMembers = Get-ADGroupMember -Identity $groupName | Select-Object -ExpandProperty SamAccountName

        # Read each line in the CSV as samAccountName
        $csvUsers = Get-Content $csvPath

        # Process each user in the CSV
        foreach ($user in $csvUsers) {
            # Remove user from other group if they are a member
            Remove-FromOtherGroup -user $user -otherGroupName $otherGroupName -logFile $logFile

            # Add or remove users based on CSV
            if ($user -notin $currentMembers) {
                try {
                    Add-ADGroupMember -Identity $groupName -Members $user
                    $logMessage = "$(Get-Date) - User $user added to $groupName."
                    Write-Host $logMessage
                    Add-Content -Path $logFile -Value $logMessage
                } catch {
                    $errorMessage = "$(Get-Date) - Error adding user $user to $groupName $_"
                    Write-Host $errorMessage -ForegroundColor Red
                    Add-Content -Path $logFile -Value $errorMessage
                }
            } elseif ($user -in $currentMembers) {
                $logMessage = "$(Get-Date) - User $user already in $groupName."
                Write-Host $logMessage
                Add-Content -Path $logFile -Value $logMessage
            }
        }

        # Remove students who are no longer in the CSV
        foreach ($user in $currentMembers | Where-Object { $_ -notin $csvUsers }) {
            try {
                Remove-ADGroupMember -Identity $groupName -Members $user -Confirm:$false
                $logMessage = "$(Get-Date) - User $user removed from $groupName."
                Write-Host $logMessage
                Add-Content -Path $logFile -Value $logMessage
            } catch {
                $errorMessage = "$(Get-Date) - Error removing user $user from $groupName $_"
                Write-Host $errorMessage -ForegroundColor Red
                Add-Content -Path $logFile -Value $errorMessage
            }
        }
    } else {
        $errorMessage = "$(Get-Date) - CSV file $csvPath not found."
        Write-Host $errorMessage -ForegroundColor Red
        Add-Content -Path $logFile -Value $errorMessage
    }
}

# Sync groups with CSV files
Sync-GroupWithCSV -csvPath $csvFile1 -groupName $group1 -otherGroupName $otherGroup -logFile $logFile
Sync-GroupWithCSV -csvPath $csvFile2 -groupName $group2 -otherGroupName $otherGroup -logFile $logFile
