Import-Module ActiveDirectory

# Define the group name
$GroupName = "Group 1"

$users = Get-ADGroupMember -Identity $GroupName | Where-Object { $_.objectClass -eq 'user' }

# Define your export location
$filePath = "C:\Scripts\Export\Users_$GroupName.txt"

$fileStream = [System.IO.StreamWriter] $filePath

foreach ($user in $users) {
    $fileStream.WriteLine($user.SamAccountName)
}
$fileStream.Close()

Write-Host "Usernames exported to $filePath"
