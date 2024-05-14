---
title: Coach Password Reset
description: One of the districts that we assist with had a handful of coach accounts that needed the credentials changed per season. This was our solution. 
published: true
date: 2024-05-14T18:45:09.835Z
tags: powershell, password reset, coach
editor: markdown
dateCreated: 2024-05-14T18:45:09.835Z
---

# Coach AD Password Reset
This script automates the process of password resets for users in specified AD groups. It generates new passwords, updates them in Active Directory, and sends a notification email with the updated credentials. 

This is useful where you have a spring/winter/fall sport schedule within a district and have a lot of turnover in coaching roles or have different coaches for different seasonal sports. 
```powershell
<#
.SYNOPSIS
  Resets passwords for coaches' accounts based on group membership in Active Directory.

.DESCRIPTION
  This script automates the process of password resets for users in specified AD groups. It generates new passwords, updates them in Active Directory, and sends a notification email with the updated credentials.

.PARAMETER Groups
    An array specifying the AD groups whose members' passwords will be reset. Default is set to "Dist-Coaches"

.INPUTS
  None

.OUTPUTS
  None - Password changes are performed directly in Active Directory and confirmation emails are sent to specified addresses.

.NOTES
  Version:        1.1
  Original Author: Jim Stalbaum
  Last Modified By: Rob Lane
  Creation Date:  9/1/22
  Purpose/Change: Updated for use with "coaches" instead of substitutes. 
  
.EXAMPLE
  PS> .\Reset-CoachPasswords.ps1
  Executes the script to reset passwords for the default group "Dist-Coaches".

#>
# Import the Active Directory Module 
Import-module ActiveDirectory

[array]$Groups = "Dist-Coaches"

foreach ($Group in  $Groups) {
    # Email Notification group based on Group_Name_Update@domain.org
    $NotifyEmail = "Coaches_Update@domain.org"
    #$NotifyEmail = "Notification@domain.org"
    
    # Create empty hash table for each location. The username will be the "key" and the password the "value"
    $Coaches = @{}

    # Timestamp for email body
    $Date = Get-Date -Format MM-dd-yyyy

    $Users = Get-ADGroupMember -Identity $Group     
    $Users | ForEach-Object {
    # Uses https://wiki.miscripts.org/en/PowerShell/GeneratePassword 
            $Coaches.add("$($_.SamAccountName)",$( C:\Scripts\Generate-Password.ps1 -Length 10 -AlphaNumeric))
            }
            
    # Loop through each hash table entry and apply the new password in Active Directory.
    $Coaches.GetEnumerator() | % { Set-ADAccountPassword -identity $_.key -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$($_.value)" -Force)}

    # Send an email with the hash table values. 
    Send-MailMessage `
    -To $NotifyEmail `
    -From "DistServer@domain.org" `
    -Subject "Coaching Passwords for $Group" `
    -Body "Coaching account information for $Date is below: `n $($Coaches.GetEnumerator() | Sort name | Out-String)" `
    -SmtpServer "smtprelay.domain.org" `
}