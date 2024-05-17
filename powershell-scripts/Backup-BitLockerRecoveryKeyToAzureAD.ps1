<#
.SYNOPSIS
    This script checks if BitLocker is enabled on a specified drive, retrieves the BitLocker key protector ID, and escrows the BitLocker recovery key into Azure Active Directory (Azure AD).

.DESCRIPTION
    The script performs the following actions:
    1. Checks if BitLocker is enabled on a specified drive.
    2. Retrieves the key protector ID of the BitLocker-protected drive.
    3. Escrows the BitLocker recovery key into Azure AD.
    The script ensures that the BitLocker protection is in place and securely backs up the recovery key to Azure AD for compliance and recovery purposes.

.PARAMETER TimeZone
    The time zone parameter is reserved for future use and does not affect the current script execution.

.EXAMPLE
    PS> .\Backup-BitLockerRecoveryKeyToAzureAD.ps1
    This command runs the script to check if BitLocker is enabled on the system drive, retrieves the key protector ID, and escrows the BitLocker recovery key into Azure AD.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0
#>

$DriveLetter = $env:SystemDrive

# Function to test if BitLocker is enabled on a drive
function Test-Bitlocker ($BitlockerDrive) {
    #Tests the drive for existing Bitlocker keyprotectors
    try {
        Get-BitLockerVolume -MountPoint $BitlockerDrive -ErrorAction Stop
    } catch {
        Write-Output "Bitlocker was not found protecting the $BitlockerDrive drive. Terminating script!"
        exit 0
    }
}

# Function to retrieve the key protector ID of a BitLocker-protected drive
function Get-KeyProtectorId ($BitlockerDrive) {
    #fetches the key protector ID of the drive
    $BitLockerVolume = Get-BitLockerVolume -MountPoint $BitlockerDrive
    $KeyProtector = $BitLockerVolume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }
    return $KeyProtector.KeyProtectorId
}

# Function to escrow the BitLocker recovery key into Azure AD
function Invoke-BitlockerEscrow ($BitlockerDrive,$BitlockerKey) {
    #Escrow the key into Azure AD

    foreach ($Key in $BitlockerKey) {

        try {
            BackupToAAD-BitLockerKeyProtector -MountPoint $BitlockerDrive -KeyProtectorId $Key #-ErrorAction SilentlyContinue
            Write-Output "Attempted to escrow key in Azure AD - Please verify manually!"
            
        } catch {
            Write-Error "This should never have happend? Debug me!"
            exit 1
        }

    }
    exit 0
}

# Test if BitLocker is enabled on the system drive
Test-Bitlocker -BitlockerDrive $DriveLetter

# Retrieve the key protector ID of the system drive
$KeyProtectorId = Get-KeyProtectorId -BitlockerDrive $DriveLetter

# Escrow the BitLocker recovery key into Azure Active Directory
Invoke-BitlockerEscrow -BitlockerDrive $DriveLetter -BitlockerKey $KeyProtectorId
