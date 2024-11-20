<#
.SYNOPSIS
    This script manages mailbox delegation in Exchange Online by allowing users to add or remove delegation permissions.

.DESCRIPTION
    The script performs the following actions:
    1. Installs the Exchange Online Management module if it is not already installed.
    2. Prompts the user to specify whether to add or remove delegation permissions.
    3. Accepts inputs for the mailbox email, delegate email, and type of permission (SendAs, FullAccess, Both).
    4. Adds or removes the specified permissions for the delegate on the target mailbox.
    5. Disconnects the session from Exchange Online after completing the operation.

.PARAMETER mailboxEmail
    The email address of the mailbox for which delegation permissions are being managed.

.PARAMETER delegateEmail
    The email address of the user to whom permissions are being granted or revoked.

.PARAMETER permissionType
    The type of delegation permission to manage. Options include 'SendAs', 'FullAccess', or 'Both'.

.PARAMETER action
    Specifies whether to 'Add' or 'Remove' the delegation permissions.

.EXAMPLE
    PS> .\Manage-MailboxDelegation.ps1
    This command runs the script, installs the Exchange Online Management module if necessary, prompts for inputs, and manages mailbox delegation as specified.

.NOTES
    Author: [Your Name]
    Date: [Insert Date]
    Version: 1.0
    Requires: Exchange Online Management Module
#>

# Connect to Exchange Online (if not already connected)
if (!(Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Ask whether to add or remove delegation
$action = Read-Host "Do you want to add or remove mailbox delegation? (Enter 'Add' or 'Remove')"

# Prompt for common inputs
$mailboxEmail = Read-Host "Enter the email address of the mailbox"
$delegateEmail = Read-Host "Enter the email address of the user"
$permissionType = Read-Host "Enter the type of delegation (SendAs, FullAccess, Both)"

# Perform action based on user's choice to add or remove
switch ($action.ToLower()) {
    "add" {
        # Add delegation
        switch ($permissionType.ToLower()) {
            "sendas" {
                Add-RecipientPermission -Identity $mailboxEmail -Trustee $delegateEmail -AccessRights SendAs
                Write-Host "$delegateEmail has been granted 'Send As' permission to $mailboxEmail"
            }
            "fullaccess" {
                Add-MailboxPermission -Identity $mailboxEmail -User $delegateEmail -AccessRights FullAccess -InheritanceType All
                Write-Host "$delegateEmail has been granted 'Full Access' permission to $mailboxEmail"
            }
            "both" {
                Add-RecipientPermission -Identity $mailboxEmail -Trustee $delegateEmail -AccessRights SendAs
                Add-MailboxPermission -Identity $mailboxEmail -User $delegateEmail -AccessRights FullAccess -InheritanceType All
                Write-Host "$delegateEmail has been granted 'Send As' and 'Full Access' permissions to $mailboxEmail"
            }
            default {
                Write-Host "Invalid permission type. Please choose 'SendAs', 'FullAccess', or 'Both'."
            }
        }
    }
    "remove" {
        # Remove delegation
        switch ($permissionType.ToLower()) {
            "sendas" {
                Remove-RecipientPermission -Identity $mailboxEmail -Trustee $delegateEmail -AccessRights SendAs -Confirm:$false
                Write-Host "'Send As' permission removed from $delegateEmail for $mailboxEmail"
            }
            "fullaccess" {
                Remove-MailboxPermission -Identity $mailboxEmail -User $delegateEmail -AccessRights FullAccess -InheritanceType All -Confirm:$false
                Write-Host "'Full Access' permission removed from $delegateEmail for $mailboxEmail"
            }
            "both" {
                Remove-RecipientPermission -Identity $mailboxEmail -Trustee $delegateEmail -AccessRights SendAs -Confirm:$false
                Remove-MailboxPermission -Identity $mailboxEmail -User $delegateEmail -AccessRights FullAccess -InheritanceType All -Confirm:$false
                Write-Host "'Send As' and 'Full Access' permissions removed from $delegateEmail for $mailboxEmail"
            }
            default {
                Write-Host "Invalid permission type. Please choose 'SendAs', 'FullAccess', or 'Both'."
            }
        }
    }
    default {
        Write-Host "Invalid action. Please enter 'Add' or 'Remove'."
    }
}

# Disconnect the session
Disconnect-ExchangeOnline -Confirm:$false
