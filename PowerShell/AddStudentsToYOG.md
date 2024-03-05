---
title: Adding Members to YOG Groups
description: 
published: true
date: 2024-03-05T14:56:20.184Z
tags: 
editor: markdown
dateCreated: 2024-03-04T17:10:00.136Z
---

# Adding Students to YOG Groups

```powershell
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