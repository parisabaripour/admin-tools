<#
.SYNOPSIS
    This script checks if BitLocker is enabled on a specified drive, retrieves the BitLocker key protector ID, and backs up the BitLocker recovery key to Azure Active Directory (Azure AD).

.DESCRIPTION
    The script performs the following actions:
    1. Checks if BitLocker is enabled on a specified drive.
    2. Retrieves the key protector ID of the BitLocker-protected drive.
    3. Backs up the BitLocker recovery key to Azure AD.
    The script ensures that BitLocker protection is in place and securely backs up the recovery key to Azure AD for compliance and recovery purposes.

.PARAMETER TimeZone
    The time zone parameter is reserved for future use and does not affect the current script execution.

.EXAMPLE
    PS> .\Backup-BitLockerRecoveryKeyToAzureAD.ps1
    This command runs the script to check if BitLocker is enabled on the system drive, retrieves the key protector ID, and backs up the BitLocker recovery key to Azure AD.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0
#>

$DriveLetter = $env:SystemDrive

# Function to test if BitLocker is enabled on a drive
function Test-Bitlocker ($BitlockerDrive) {
    # Tests the drive for existing BitLocker key protectors
    try {
        Get-BitLockerVolume -MountPoint $BitlockerDrive -ErrorAction Stop
    } catch {
        Write-Output "BitLocker is not enabled on the $BitlockerDrive drive. Initiating script."
        exit 0
    }
}

# Function to retrieve the key protector ID of a BitLocker-protected drive
function Get-KeyProtectorId ($BitlockerDrive) {
    # Fetches the key protector ID of the drive
    $BitLockerVolume = Get-BitLockerVolume -MountPoint $BitlockerDrive
    $KeyProtector = $BitLockerVolume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }
    return $KeyProtector.KeyProtectorId
}

# Function to backup the BitLocker recovery key to Azure AD
function Invoke-BitlockerBackup ($BitlockerDrive, $BitlockerKey) {
    # Backs up the key to Azure AD
    foreach ($Key in $BitlockerKey) {
        try {
            BackupToAAD-BitLockerKeyProtector -MountPoint $BitlockerDrive -KeyProtectorId $Key #-ErrorAction SilentlyContinue
            Write-Output "Successfully initiated backup of the BitLocker recovery key to Azure AD. Please verify the backup manually."
        } catch {
            Write-Error "An error occurred during the backup process. Please debug and retry."
            exit 1
        }
    }
    exit 0
}

# Test if BitLocker is enabled on the system drive
Test-Bitlocker -BitlockerDrive $DriveLetter

# Retrieve the key protector ID of the system drive
$KeyProtectorId = Get-KeyProtectorId -BitlockerDrive $DriveLetter

# Backup the BitLocker recovery key to Azure Active Directory
Invoke-BitlockerBackup -BitlockerDrive $DriveLetter -BitlockerKey $KeyProtectorId
