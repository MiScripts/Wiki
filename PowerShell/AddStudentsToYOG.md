---
title: Adding Members to YOG Groups
description: 
published: true
date: 2024-10-01T17:43:04.085Z
tags: 
editor: markdown
dateCreated: 2024-03-04T17:10:00.136Z
---

# Adding Students to YOG Groups
This script reads student information from a CSV file, calculates the Year of Graduation (YOG) based on the current academic year which is specified below, and adds students to the appropriate AD group for their graduating class. The script first clears any existing group members that match the student ID format before adding new members. Each grade has its own group, such as "Class of 2025."

This can be useful for districts or environments that have YOG groups instead of or in addition to building level groups.


```powershell
<#
.SYNOPSIS
  Adds students to AD groups based on their grade level and year of graduation (YOG).
.DESCRIPTION
  This script reads student information from a CSV file, calculates the Year of Graduation (YOG) based on the current academic year, and adds students to the appropriate AD group for their graduating class. The script first clears any existing group members that match the student ID format before adding new members. Each grade has its own group, such as "Class of 2025."
.PARAMETER GroupName
    The name of the AD group to which the student will be added.
.PARAMETER StudentID
    The unique ID of the student being added to the AD group.
.INPUTS
  CSV file with student information, including fields like studentID, lastName, firstName, middleName, grade, building, stateId, and birthDate.
.OUTPUTS
  None. Writes output to the console for group clearing and student processing status.
.NOTES
  Version:        1.0
  Author:         Rob Lane
  Creation Date:  9/22/23
  Purpose/Change: Initial script development
.EXAMPLE
  Add-StudentToGroup -GroupName "Class of 2025" -StudentID "12345"
    Adds the student with ID 12345 to the "Class of 2025" AD group.
  NOTE: Not designed to be used manually - will work best to run automatically.
#>

Function Add-StudentToGroup($GroupName, $StudentID) {
    try { 
        Add-ADGroupMember -Identity $GroupName -Members $StudentID 
    }
    catch { } #Ignore
}

$students = Import-Csv "C:\StudentImport\data\ldapdata_stu_xxxxx.csv" -Header studentID, lastName, firstName, middleName, grade, building, stateId, birthDate

# Determine academic year based on cutoff month 
# Using August as default to ensure time for MISTAR rollover
$cutoffMonth = 8
$currentDate = Get-Date
if ($currentDate.Month -lt $cutoffMonth) {
    $academicYear = $currentDate.Year - 1
} else {
    $academicYear = $currentDate.Year
}

$gradeToYOGMapping = @{
    '0' = $academicYear + 13;
    '1' = $academicYear + 12;
    '2' = $academicYear + 11;
    '3' = $academicYear + 10;
    '4' = $academicYear + 9;
    '5' = $academicYear + 8;
    '6' = $academicYear + 7;
    '7' = $academicYear + 6;
    '8' = $academicYear + 5;
    '9' = $academicYear + 4;
    '10' = $academicYear + 3;
    '11' = $academicYear + 2;
    '12' = $academicYear + 1;
}

# Create a hashtable for grades
$gradeGroups = @{}
$students | ForEach-Object {
    if (-not $gradeGroups.ContainsKey($_.Grade)) {
        $gradeGroups[$_.Grade] = @()
    }
    $gradeGroups[$_.Grade] += $_
}

# Remove all users from the group before adding students that match the student ID format
$gradeToYOGMapping.Keys | ForEach-Object {
    $groupName = "Class of $($gradeToYOGMapping[$_])"
    Write-Output "Clearing Group Members for $groupName."
    Get-ADGroupMember $groupName | Where-Object { $_.SamAccountName -like '200*' } | ForEach-Object { Remove-ADGroupMember $groupName $_ -Confirm:$false }
}

# Wait 2 seconds before proceeding
Write-Output "Done - Waiting 2 seconds"
Start-Sleep -Seconds 2

# Loop through each grade and add students to the correct group.
$gradeToYOGMapping.Keys | ForEach-Object {
    $grade = $_
    $groupName = "Class of $($gradeToYOGMapping[$grade])"
    
    Write-Output "Processing Grade $grade students"
    
    foreach ($user in $gradeGroups[$grade]) {
        Add-StudentToGroup -GroupName $groupName -StudentID $user.studentid
    }
}

Write-Output "Done"