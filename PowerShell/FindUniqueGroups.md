Import-Module ActiveDirectory

$OU = "OU=Students,OU=District Users,DC=localDomain,DC=net"

# Define excluded groups
$excludedGroups = @("Excluded Group 1", "Excluded Group 2")

$allGroups = @()

$users = Get-ADUser -Filter * -SearchBase $OU -Properties MemberOf

# Loop through each user
foreach ($user in $users) {
    # Get groups that the user is a member of
    $groups = $user.MemberOf | Get-ADGroup | Select-Object -ExpandProperty Name

    $filteredGroups = $groups | Where-Object { $_ -notin $excludedGroups }

    if ($filteredGroups.Count -gt 0) {
        $userName = $user.SamAccountName

        Write-Host "User: $userName is a member of the following groups:"
        foreach ($group in $filteredGroups) {
            Write-Host " - $group"
            # Add the group to the allGroups array
            $allGroups += $group
        }
        Write-Host ""
    }
}

$uniqueGroups = $allGroups | Sort-Object -Unique

Write-Host "Unique groups found (excluding 'Excluded Group 1' and 'Excluded Group 2'):"
$uniqueGroups | ForEach-Object { Write-Host " - $_" }
