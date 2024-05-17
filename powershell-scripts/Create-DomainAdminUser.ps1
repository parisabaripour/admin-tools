<#
.SYNOPSIS
    This script creates a new domain admin user in Active Directory.

.DESCRIPTION
    The script prompts for a username, password, and other details, then creates a new user in Active Directory and adds them to the Domain Admins group.

.PARAMETER None

.EXAMPLE
    PS> .\Create-DomainAdminUser.ps1
    This command runs the script and prompts the user to input the details for the new domain admin account.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt for user details
$Username = Read-Host -Prompt "Enter the username for the new domain admin account"
$FirstName = Read-Host -Prompt "Enter the first name for the new domain admin account"
$LastName = Read-Host -Prompt "Enter the last name for the new domain admin account"
$OU = Read-Host -Prompt "Enter the Organizational Unit (OU) for the new user (e.g., 'OU=Admins,DC=example,DC=com')"

# Prompt for the password securely
$Password = Read-Host -Prompt "Enter the password for the new domain admin account" -AsSecureString

# Create the new user
try {
    New-ADUser -Name "$FirstName $LastName" `
               -GivenName $FirstName `
               -Surname $LastName `
               -SamAccountName $Username `
               -UserPrincipalName "$Username@example.com" `
               -Path $OU `
               -AccountPassword $Password `
               -Enabled $true
    Write-Output "User $Username has been created successfully."
} catch {
    Write-Error "Failed to create user $Username. Error: $_"
    exit 1
}

# Add the new user to the Domain Admins group
try {
    Add-ADGroupMember -Identity "Domain Admins" -Members $Username
    Write-Output "User $Username has been added to the Domain Admins group."
} catch {
    Write-Error "Failed to add user $Username to the Domain Admins group. Error: $_"
    exit 1
}

Write-Output "Domain admin user $Username has been created and added to the Domain Admins group successfully."
