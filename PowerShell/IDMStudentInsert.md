---
title: IDM Student Insert
description:   The script relies on flat files being exported from your student information system (SIS) and would need to have the header values aligned with this list or the script tweaked to account for your header values. 
published: true
date: 2024-05-13T17:40:09.147Z
tags: sis, import script, idm
editor: markdown
dateCreated: 2024-05-13T17:40:09.147Z
---

```powershell
<#
.SYNOPSIS
  This is a sanitized version of the 'insert' script for an identity managment (IDM) project that was used for several years to support the creation of student accounts across 6 different school districts. I will work to sanitize and share the 'update' script and 'disable' script as well.
  
  **FULL DISCLOSURE: My organization has shifted to the Classlink OneSync platform for IDM so these scripts are on their way out the door as I finish implementations for all districts**

.DESCRIPTION
  The script relies on flat files being exported from your student information system (SIS) and would need to have the header values aligned with this list or the script tweaked to account for your header values. My particular implementation had our data team 'massage' the SIS data a little bit before delivering the flat file to me, so your mileage may vary in how you adapt this to your district.

.PARAMETER
    No support at this time for parameters.

.INPUTS
  - idm_action: this was a custom attribute that we never leaned on
  - 	idm_samaccountname: this was a constructed username provided to me from the data team, but you could construct a variable in script below for your district
  - 	idm_first_name	: this was the students first name from the SIS
  - idm_middle_name: this was the students middle name from the SIS --- I was suprised by how many students don't have middle names!
  - idm_last_name: this was the students last name from the SIS
  - idm_start_date	: this was the date the student would start attending the school
  - idm_end_date: this was the date the student would be exited from the school
  - 	idm_upn: this was a userprincipalname that you won't find in your SIS, just edit the script below to construct it for your district
  - idm_title: this was a generic placeholder for when we implemented IDM for staff with actual titles ... for now we used 'student' for students
  - idm_department	: this was a generic placeholder for when we implemented IDM for staff with actual departments ... this is null for students
  - idm_status: this was used to indicate if the user is "A"ctive or "I"nactive based on enrollment status in the SIS
  - 	idm_email: this was an email that you won't find in your SIS, just edit the script below to construct it for your district
  - idm_default_password	: this was used for a unique, grade appropriate, password and provided to me from the data team, but you could construct passwords in the script below for your district
  - idm_employeeid: this was used to define the students UIC code
  - 	idm_employeenumber	: this was used to define the students SIS code
  - idm_student_grade_level: this was used to define the students grade level from the SIS
  - idm_student_graduation_year: this was used to define the students graduation year
  - idm_building01name	: this was used to define the students building assignment name
  - idm_building01code	: this was used to define the students building assigment state code
  - idm_password_date: this was used to define the last time our internal help desk tool was used to reset a users IDM password and we never implemented it's use

.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
  Version:        1.0
  Author:         Chris Thomas
  Creation Date:  04/05/2024
  Purpose/Change: Initial script sanitizing
  
.EXAMPLE
  Scheduled task (running as a service account, not your own!) to run every hour or once a day --- whatever works for your district.
#>

#LOCATION OF FLAT FILE FROM SIS
$insertFilePath = "C:\IDM\<DISTRICT>_students_insert.csv"
$content = get-content -Path $insertFilePath

#ONLY DO STUFF IF THE FILE ACTUALLY CONTAINS USERS
if($content -ne $null)
{
    #THE WORKSTATION/SERVER THIS RUNS ON WILL NEED RSAT TOOLS INSTALLED
    Import-Module ActiveDirectory

    #DEFINE CURRENT DATE AND TIME
    $currentDateTime = (Get-Date).ToString('yyyy-MM-dd@hhmm')
    #DEFINE CURRENT DATE
    $currentDate = (Get-Date).ToString('MMddyy')
    #DEFINE CURRENT YEAR
    $currentYear = (Get-Date).ToString('yyyy')
    #DEFINE CURRENT MONTH
    $currentMonth = (Get-Date).ToString('MM')

    #WHO ARE WE INSERTING TODAY?
    $students = Import-Csv -Path $insertFilePath

    #CREATE EMPTY ARRAY TO STORE NEW USERS DISCOVERED
    $i = 0
    $array = @()

    #LOOP THROUGH ALL THE STUDENTS IN THE INSERT FILE
    foreach ($student in $students)
    {
      #region VARIABLE DEFINITIONS
      #DEFINE ALL THE THINGS FROM INSERT FILE

      #DEFINE STUDENT INITIALS IN CASE NEEDED FOR OTHER CONSTRUCTIONS
      $firstName = $student.idm_first_name
      $firstInitial = $firstName.Substring(0,1)
      $middleName = $student.idm_middle_name
      if($middleName -ne $null -AND $middleName -ne '')
      {
        $middleInitial = $middleName.Substring(0,1)
      }
      $lastName = $student.idm_last
      $lastInitial = $lastName.Substring(0,1)
  
      $fullName = $firstName + ' ' + $lastName
      $displayName = $firstName + ' ' + $lastName
  
      $samAccountName = $student.idm_samaccountname
      $userPrincipalName = $student.idm_upn
      $emailAddress = $student.idm_email
  
      $title = 'Student'
      
      $gradeLevel = $student.idm_student_grade_level
      $yearofGrad = $student.idm_student_graduation_year

      $employeeID = $student.idm_employeeid
      $employeeNumber = $student.idm_employeenumber
      $employeeNumberLength = $employeeNumber.Length
      
      #DEFINE LAST 4 OF STUDENT ID IN CASE USED TO CONSTRUCT SAMACCOUNTNAME OR PASSWORD
      $studentID = $employeeNumber.Substring(3)
      $studentIDLast4 = -join "$studentID"[-4..-1]
  
      #DEFINE HOME DRIVE LETTER AND PATH IF USED IN DISTRICT
      $homeDrive = 'H:'
      $homeDirectory = '\\<SERVER_FQDN>\Student Home Drives\' + $yearOfGrad + '\' + $samAccountName
  
      #DEFINE THE USERS YEAR OF GRAD SECURITY GROUP
      $group_YearofGrad = 'Student_' + $yearofGrad
      #CREATE AN EMPTY ARRAY TO STORE THE SECURITY GROUPS TO ADD THE USER TO
      $groupList = @()
      #ADD THE USER TO THEIR YEAR OF GRAD SECURITY GROUP
      $groupList += $group_YearofGrad  
  
      #SET A TEMPORARY PASSWORD TO SUPPORT FINE-GRAINED PASSWORD POLICIES
      #WHICH REQUIRE GROUP MEMBERSHIP BEFORE A NON-SECURE PASSWORD CAN BE USED
      $passwordTemporary = (ConvertTo-SecureString -AsPlainText 'IWishYouHad8DigitPasswords' -Force)
  
      #DEFINE THE STATE BUILDING CODE FOR THE USER
      $buildingCode = $student.idm_building01code
  
      #DEFINE BUILDING VARIABLES BASED ON STATE BUILDING CODES
      #THIS MIGHT BE OVERKILL FOR YOU, BUT I HATED LOOKING UP PHONE NUMBER FOR DISTRICT BUILDINGS WHEN WORKING WITH USER OBJECTS
      switch ($buildingCode)
      {
          '<BUILDING_CODE_1>' {
                              $buildingShortName = '<SHORTNAME>'
                              $office = '<ELEMENTARY_BUILDING_NAME>'
                              $streetAddress = '<BUILDING_ADDRESS'
                              $city = '<DISTRICT>'
                              $postalCode = '<ZIP_CODE>'
                              $officePhone = '<PHONE_NUMBER>'
                              $passwordInsecure = '<ELEM_SIMPLE_PASSWORD>'
                              $passwordSecure = (ConvertTo-SecureString -AsPlainText $passwordInsecure -Force)
                              $ouPath_append = ',<OU_PATH_TO_ELEM_STUDENTS>'
          }
          '<BUILDING_CODE_2>' {
                              $buildingShortName = '<SHORTNAME>'
                              $office = '<HIGHSCHOOL_BUILDING_NAME>'
                              $streetAddress = '<BUILDING_ADDRESS'
                              $city = '<DISTRICT>'
                              $postalCode = '<ZIP_CODE>'
                              $officePhone = '<PHONE_NUMBER>'
                              $passwordInsecure = '<HIGHSCHOOL_PASSWORD_ALGORITHM>'
                              $passwordSecure = (ConvertTo-SecureString -AsPlainText $passwordInsecure -Force)
                              $ouPath_append = ',<OU_PATH_TO_HIGHSCHOOL_STUDENTS>'
          }
      }
  
      #DEFINE OU PATH FOR THE DISTRICT
      $ouPath = 'OU=' + $yearOfGrad + $ouPath_append
      $ouPath_disabled = 'OU=Disabled Users,<OU_PATH>'
  
      #DEFINE THE USER DESCRIPTION
      $description = $buildingShortName + ' - Class of ' + $yearOfGrad
  
      #DEFINE DISTRICT SPECIFIC VARIABLES
      $organization = '<ORG>'
      $state = 'MI'
      $company = '<DISTRICT>'
      $domainName = '<DOMAIN_SHORTNAME>'
      $domainAddress = '<DOMAIN_ADDRESS>'
      $department = $buildingShortName + ' - Class of ' + $yearOfGrad
      #endregion

      #region USER CREATION

      $i = $i + 1
      $array += $student
          
      Write-Host "Creating user: $samAccountName" -ForegroundColor Green
          
      #DEFINE ALL THE NEW USER ATTRIBUTES FOR SPLATTING
      $newUserSplat = @{
        Name = $fullName
        DisplayName = $displayName
        GivenName = $firstName
        Surname = $lastName
        SamAccountNAme = $samAccountName
        UserPrincipalName = $userPrincipalName
        EmailAddress = $emailAddress
        AccountPassword = $passwordTemporary
        ChangePasswordAtLogon = $false
        CannotChangePassword = $true
        PasswordNeverExpires = $true
        Path = $ouPath
        StreetAddress = $streetAddress
        City = $city
        State = $state
        PostalCode = $postalCode
        Organization = $organization
        Company = $company
        Office = $office
        OfficePhone = $officePhone
        Department = $department
        Title = $title
        Description = $description
        EmployeeID = $employeeID
        EmployeeNumber = $employeeNumber
        HomeDirectory = $homeDirectory
        HomeDrive = $homeDrive
        Enabled = $true
      }
          
      #CREATE THE USER BASED ON SPLAT
      New-ADUser @newUserSplat
          
      #SET THE MIDDLE NAME AND INITIALS IF THE USER HAS THEM
      if($middleName -ne $null -AND $middleName -ne '')
      {
        Set-ADUser -Identity $samAccountName -OtherName $middleName -Initials $middleInitial
      }
      else
      {
        Set-ADUser -Identity $samAccountName -Clear MiddleName,Initials
      }
          
      #ADD THE USER TO THEIR GROUPS
      if($groupList -ne $null)
      {
        $groupList = $groupList | ForEach-Object {Get-ADGroup -Identity $_}
        $groupList | ForEach-Object {Add-ADGroupMember -Identity $_ -Members $samAccountName}
      }
          
      #SET THE USERS PASSWORD
      #IF FINE-GRAINED PASSWORD POLICIES ARE INE FFECT THEY WILL BE HONORED
      #IF THE USER IS IN THE APPROPRIATE SECURITY GROUP BEFORE THIS COMMAND
      Set-ADAccountPassword -Identity $samAccountName -Reset -NewPassword $passwordSecure
          
      #CREATE HOME DIRECTORY
      New-Item -Path $homeDirectory -ItemType Directory -Force
          
      #APPLY PERMISSIONS TO HOME FOLDER
      $identityReference = $domainName + '\' + $samAccountName
      $fileSystemAccessRights = [System.Security.AccessControl.FileSystemRights]::Modify
      $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
      $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None
      $accessControl = [System.Security.AccessControl.AccessControlType]::Allow
      $accessRuleSplat = $identityReference, $fileSystemAccessRights, $inheritanceFlags, $propagationFlags, $accessControl
      $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $accessRuleSplat
      $homeDirectoryACL = Get-Acl $homeDirectory
      $homeDirectoryACL.AddAccessRule($accessRule)
      Set-Acl -Path $homeDirectory -AclObject $homeDirectoryACL
      #endregion
    }
    #IF RUN MANUALLY, WILL PRINT ALL NEW STUDENTS ON SCREEN AND EXPORT THEM TO A CSV FOR LOGGING
    $array
    $array | Export-Csv -Path C:\IDM\<DISTRICT>_NEW_$currentDateTime.csv -NoTypeInformation
    #ITERATE $I UP IF WE CREATED ANY NEW STUDENTS
    $i

    #GRAB THAT ARRAY FOR USE IN AN EMAIL TO HELP DESK/BUILDING SECRETARY/DISTRIBUTION LIST
    $body = $array | Out-String

    #IF WE DID CREATE STUDENTS, THEN SEND THE EMAIL
    if($i -gt 0)
    {
      #DEFINE CURRENT DATE
      $emailCurrentDate = (Get-Date).ToString('MM/dd/yy')
      #I DONT KNOW HOW TO DO THIS SECURELY ... SOMEONE WANT TO TEACH ME?
      $emailPassword = ConvertTo-SecureString "<SMTPPASSWORD>" -AsPlainText -Force
      $emailCred = New-Object System.Management.Automation.PSCredential ("<USERNAME>",$emailPassword)
      $emailToAddresses = @('<user1_email>','<user2_email>')
      Send-MailMessage -SmtpServer <SMTP_SERVER> -Subject "$emailCurrentDate - $company Student Account Creation" -Body "$body" -From idm_insert@$domainAddress -To $emailToAddresses -Credential $emailCred
    }
}
