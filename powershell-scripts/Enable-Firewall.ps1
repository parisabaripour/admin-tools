<#
.SYNOPSIS
    This script checks if the firewall is enabled on all profiles and enables it if it is not.

.DESCRIPTION
    The script retrieves the status of the firewall on Domain, Public, and Private profiles. If any profile has the firewall disabled, the script attempts to enable the firewall on all profiles.

.PARAMETER None

.EXAMPLE
    PS> .\Enable-Firewall.ps1
    This command runs the script to check if the firewall is enabled on all profiles and enables it if necessary.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0
#>

# Check if the firewall is enabled
function Check-FirewallStatus {
    $firewallStatus = Get-NetFirewallProfile -Profile Domain,Public,Private | Select-Object -Property Name,Enabled
    return $firewallStatus
}

# Enable the firewall
function Enable-Firewall {
    try {
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction Stop
        Write-Output "Firewall enabled successfully."
    } catch {
        Write-Error "Failed to enable the firewall. Error: $_"
    }
}

# Main script logic
$firewallStatus = Check-FirewallStatus

$allEnabled = $true
foreach ($profile in $firewallStatus) {
    if ($profile.Enabled -eq $false) {
        $allEnabled = $false
        break
    }
}

if ($allEnabled) {
    Write-Output "Firewall is already enabled on all profiles."
} else {
    Write-Output "Firewall is not enabled. Attempting to enable it..."
    Enable-Firewall
}
