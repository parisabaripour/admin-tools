<#
.SYNOPSIS
    This script installs the Exchange Online Management module (if not already installed), prompts the user to enter the name of a Dynamic Distribution List (DDL), connects to Exchange Online, and retrieves the primary SMTP address and display name of the recipients.

.DESCRIPTION
    The script performs the following actions:
    1. Checks if the Exchange Online Management module is installed.
    2. Installs the module if it is not already installed.
    3. Prompts the user to enter the name of a Dynamic Distribution List (DDL).
    4. Connects to Exchange Online.
    5. Retrieves the primary SMTP address and display name of the recipients of the specified Dynamic Distribution List.

.PARAMETER DDLName
    The name of the Dynamic Distribution List for which the recipient details are to be retrieved.

.EXAMPLE
    PS> .\Get-DynamicDistributionGroupRecipients.ps1
    This command runs the script, installs the Exchange Online Management module if necessary, prompts for the DDL name, connects to Exchange Online, and retrieves the recipient details.

.NOTES
    Author: Parisa Baripour
    Date: 2024-06-05
    Version: 1.0
#>

# Prompt user to enter the name of the DDL
$ddlName = Read-Host "Enter name of the DDL (use quotes if there are spaces)"

# Check if the ExchangeOnlineManagement module is installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    # Install the Exchange Online Management module
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Retrieve and display recipient details
Get-Recipient -RecipientPreviewFilter (Get-DynamicDistributionGroup $ddlName).RecipientFilter | Select-Object PrimarySmtpAddress, DisplayName
