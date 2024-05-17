<#
.SYNOPSIS
    This script creates a local administrator user on a Windows machine.

.DESCRIPTION
    The script prompts the user to input a username and password, then creates a local user with those credentials and adds the user to the local Administrators group.

.PARAMETER Username
    The username for the new local admin account.

.PARAMETER Password
    The password for the new local admin account.

.EXAMPLE
    PS> .\Create-LocalAdminUser.ps1
    This command runs the script and prompts the user to input the username and password for the new local admin account.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0
#>

# Prompt for username
$Username = Read-Host -Prompt "Enter the username for the new local admin account"

# Prompt for password
$Password = Read-Host -Prompt "Enter the password for the new local admin account" -AsSecureString

# Create the new local user
try {
    New-LocalUser -Name $Username -Password $Password -FullName $Username -Description "Local Admin User"
    Write-Output "User $Username has been created successfully."
} catch {
    Write-Error "Failed to create user $Username. Error: $_"
    exit 1
}

# Add the new user to the local Administrators group
try {
    Add-LocalGroupMember -Group "Administrators" -Member $Username
    Write-Output "User $Username has been added to the Administrators group."
} catch {
    Write-Error "Failed to add user $Username to the Administrators group. Error: $_"
    exit 1
}

Write-Output "Local admin user $Username has been created and added to the Administrators group successfully."
