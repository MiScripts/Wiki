---
title: Generate Password
description:   This script provides a flexible way to generate passwords by allowing the user to specify the length and character set of the password. It can generate passwords using a combination of letters, numbers, and symbols.
published: true
date: 2024-05-13T18:12:15.816Z
tags: 
editor: markdown
dateCreated: 2024-05-13T18:12:15.816Z
---

```powershell
<#
.SYNOPSIS
  Generates a custom password based on user-specified criteria.

.DESCRIPTION
  This script provides a flexible way to generate passwords by allowing the user to specify the length and character set of the password. It can generate passwords using a combination of letters, numbers, and symbols. It also has an option to output the password as a secure string.

.PARAMETER Length
    Specifies the length of the password. Default is 10 characters.

.PARAMETER Secure
    If used, the password is returned as a secure string, suitable for secure storage and handling in PowerShell.

.PARAMETER Alpha
    Generates a password using only alphabetic characters (both upper and lower case).

.PARAMETER AlphaNumeric
    Generates a password using both alphabetic characters and numbers.

.INPUTS
  None

.OUTPUTS
  If the -Secure switch is used, the password is output as a secure string. Otherwise, it returns a plain text password.

.NOTES
  Version:        1.0
  Author:         Nick Cage	
  Creation Date:  Unknown
  Purpose/Change: Initial script development
  
.EXAMPLE
  PS> .\Generate-Password.ps1 -Length 12 -Alpha
  Generates a 12-character password using only letters.

.EXAMPLE
  PS> .\Generate-Password.ps1 -Length 15 -AlphaNumeric -Secure
  Generates a 15-character password using letters and numbers and returns it as a secure string.
#>

Param 
(
	[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [Int]$Length = 10, #Length of password
    [switch]$Secure, # Returns password as a secure string 
    [switch]$Alpha, #Only letters
    [switch]$AlphaNumeric #Only letters / numbers
)
   
Begin
{
    if ($AlphaNumeric -and $Alpha){ Write-Error "You cannot select both Alphanumeric and Alpha."; exit }

    # Function to remove troublesome characters
    Function Scrub-Random ($Ran) {
        Switch ($Ran){
            {34,39,44 -contains $_} {$Ran = Scrub-Random $(Get-Random -Minimum 33 -Maximum 48)} # Characters " ' , 
            {73,79 -contains $_} {$Ran = Scrub-Random $(Get-Random -Minimum 65 -Maximum 91)} # Characters I O
            {105,108,111 -contains $_} {$Ran = Scrub-Random $(Get-Random -Minimum 97 -Maximum 123)} # Characters i l o
        }
        Return $Ran
    } # End Scrub

    # Gets individual characters based on ascii codes
    Function Get-Char ($Num){
        Switch ($Num) {
            0{[char]$Char = Scrub-Random $(Get-Random -Minimum 97 -Maximum 123)} # Lowercase Letter
            1{[char]$Char = Scrub-Random $(Get-Random -Minimum 65 -Maximum 91)}  # Uppercase Letter
            2{[char]$Char = Scrub-Random $(Get-Random -Minimum 50 -Maximum 58)}  # Number
            3{[char]$Char = Scrub-Random $(Get-Random -Minimum 33 -Maximum 48)}  # Symbol
        } #End Switch
        Return $Char
    } #End Get-Char Function
}
Process
{
    
    For($i=0; $i-le$Length-1; $i++){ # Loop based on length of new password. 

        if ($Alpha){ $Password += Get-Char $(Get-Random -Minimum 0 -Maximum 2)} # Letters 
        elseif ($AlphaNumeric){ $Password += Get-Char $(Get-Random -Minimum 0 -Maximum 3)} # Letters and Numbers
        else {$Password += Get-Char $(Get-Random -Minimum 0 -Maximum 4)} # Letters, Numbers, and Symbols

    } # End For Loop

    # Return value
    if ($Secure) { ConvertTo-SecureString $Password -AsPlainText -Force; Write-Verbose "Returned $Password as secure string." }
    else {Return $Password} 
} #End Process