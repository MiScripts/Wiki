---
title: Reset AD Presentation Account
description: A service account used by a vendor, or presenter, during professional development days. This account is used frequently enough that we felt resetting the password weekly was a wise idea. 
published: true
date: 2024-05-14T18:59:26.666Z
tags: powershell, active directory, password reset
editor: markdown
dateCreated: 2024-05-14T18:59:26.666Z
---

# Reset AD Presentation Account
This is a modified version of another script, Jim Stalbaum's  [Substitute/Coach reset script](/PowerShell/CoachADPasswordReset), which was lightly modified to fit the use case of one specific user account. The hashtable is unneccesary in this script, however, I kept it included in the event that additional accounts were added. 
```powershell
<#
.SYNOPSIS
  Searches for a specific user (Presenter) in Active Directory and emails a uniquely generated password.

.DESCRIPTION
  This script automates the process of generating and emailing a new password for a specified user account. It can be adapted for other service accounts in the future.

.PARAMETER Username
    Specifies the username for which the password will be reset. Default is set to "Presenter".

.INPUTS
  None

.OUTPUTS
  None - Password changes are performed directly in Active Directory and confirmation emails are sent to specified addresses.

.NOTES
  Version:        1.1
  Original Author: Rob Lane
  Creation Date:  5/5/2023
  Purpose/Change: Sanitized sensitive information for example usage.
  
.EXAMPLE
  PS> .\Reset-Presenter.ps1
  Executes the script to reset the password for the default user "Presenter".

#>
Import-module ActiveDirectory

# Specify the username
$Username = "Presenter"

# Email Notification
$NotifyEmail = "technology@example.org"
$CcEmail = "cc@example.org"

# Create an empty hash table. The username will be the "key" and the password the "value"
$UserPassword = @{}

# Timestamp for email body
$Date = Get-Date -Format MM-dd-yyyy

# Generate a new password for the specific user
# Uses https://wiki.miscripts.org/en/PowerShell/GeneratePassword
$UserPassword.add("$Username", $(C:\Scripts\Generate-Password.ps1 -Length 12 -AlphaNumeric))

# Apply the new password in Active Directory
$UserPassword.GetEnumerator() | % { Set-ADAccountPassword -identity $_.key -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$($_.value)" -Force)}

# Send an email with the hash table values. 
Send-MailMessage `
    -To $NotifyEmail `
    -Cc $CcEmail `
    -From "scripts@example.org" `
    -Subject "Weekly Password for $Username" `
    -Body "The Presentation account information for $Date is below: `n $($UserPassword.GetEnumerator() | Sort name | Out-String)" `
    -SmtpServer "smtprelay.example.org"