<#
.SYNOPSIS
    Maps common time zone names to Windows time zone names and sets the system time zone based on geolocation.

.DESCRIPTION
    This script contains a mapping of common time zone names to Windows time zone names. 
    It includes functions to map a time zone, set the system time zone, and fetch geolocation data 
    to determine the appropriate time zone for the device.

.PARAMETER TimeZone
    The time zone name to be mapped to a Windows time zone name.

.EXAMPLE
    PS> .\Set-TimeZoneByLocation.ps1
    Fetches the geolocation data and sets the system time zone accordingly.

.NOTES
    Author: Parisa Baripour
    Date: 2024-05-17
    Version: 1.0

#>

$global:TimeZoneMappings = @{
    "Pacific/Midway" = "Dateline Standard Time"
    "Pacific/Samoa" = "Samoa Standard Time"
    "US/Hawaii" = "Hawaiian Standard Time"
    "America/Anchorage" = "Alaskan Standard Time"
    "America/Los_Angeles" = "Pacific Standard Time"
    "America/Tijuana" = "Pacific Standard Time (Mexico)"
    "US/Arizona" = "Mountain Standard Time (no DST)"
    "America/Chihuahua" = "Mountain Standard Time (Mexico)"
    "America/Denver" = "Mountain Standard Time"
    "America/Guatemala" = "Central America Standard Time"
    "America/Chicago" = "Central Standard Time"
    "America/Mexico_City" = "Central Standard Time (Mexico)"
    "America/Regina" = "Canada Central Standard Time"
    "America/Bogota" = "SA Pacific Standard Time"
    "America/Panama" = "SA Pacific Standard Time (Mexico)"
    "America/Caracas" = "Venezuela Standard Time"
    "America/Asuncion" = "Paraguay Standard Time"
    "America/La_Paz" = "SA Western Standard Time"
    "America/Cuiaba" = "Central Brazilian Standard Time"
    "America/Santiago" = "Pacific SA Standard Time"
    "America/Sao_Paulo" = "E. South America Standard Time"
    "America/Godthab" = "Greenland Standard Time"
    "America/Montevideo" = "Montevideo Standard Time"
    "America/Buenos_Aires" = "Argentina Standard Time"
    "Atlantic/South_Georgia" = "UTC-02"
    "Atlantic/Azores" = "Azores Standard Time"
    "Atlantic/Cape_Verde" = "Cape Verde Standard Time"
    "Europe/Dublin" = "GMT Standard Time"
    "Europe/London" = "GMT Standard Time"
    "Europe/Lisbon" = "GMT Standard Time"
    "Europe/Casablanca" = "Morocco Standard Time"
    "Africa/Monrovia" = "Greenwich Standard Time"
    "Africa/Casablanca" = "Greenwich Standard Time"
    "Europe/Belgrade" = "Central Europe Standard Time"
    "Europe/Bratislava" = "Central Europe Standard Time"
    "Europe/Budapest" = "Central Europe Standard Time"
    "Europe/Ljubljana" = "Central Europe Standard Time"
    "Europe/Prague" = "Central Europe Standard Time"
    "Europe/Sarajevo" = "Central Europe Standard Time"
    "Europe/Skopje" = "Central Europe Standard Time"
    "Europe/Warsaw" = "Central Europe Standard Time"
    "Europe/Zagreb" = "Central Europe Standard Time"
    "Europe/Brussels" = "Romance Standard Time"
    "Europe/Copenhagen" = "Romance Standard Time"
    "Europe/Madrid" = "Romance Standard Time"
    "Europe/Paris" = "Romance Standard Time"
    "Europe/Amsterdam" = "W. Europe Standard Time"
    "Europe/Berlin" = "W. Europe Standard Time"
    "Europe/Rome" = "W. Europe Standard Time"
    "Europe/Stockholm" = "W. Europe Standard Time"
    "Europe/Vienna" = "W. Europe Standard Time"
    "Africa/Algiers" = "W. Central Africa Standard Time"
    "Europe/Bucharest" = "E. Europe Standard Time"
    "Africa/Cairo" = "Egypt Standard Time"
    "Europe/Helsinki" = "FLE Standard Time"
    "Europe/Kiev" = "FLE Standard Time"
    "Europe/Riga" = "FLE Standard Time"
    "Europe/Sofia" = "FLE Standard Time"
    "Europe/Tallinn" = "FLE Standard Time"
    "Europe/Vilnius" = "FLE Standard Time"
    "Europe/Athens" = "GTB Standard Time"
    "Europe/Istanbul" = "GTB Standard Time"
    "Europe/Minsk" = "GTB Standard Time"
    "Asia/Jerusalem" = "Israel Standard Time"
    "Africa/Harare" = "South Africa Standard Time"
    "Europe/Moscow" = "Russian Standard Time"
    "Europe/Volgograd" = "Russian Standard Time"
    "Asia/Kuwait" = "Arab Standard Time"
    "Asia/Riyadh" = "Arab Standard Time"
    "Africa/Nairobi" = "E. Africa Standard Time"
    "Asia/Baghdad" = "Arabic Standard Time"
    "Asia/Tehran" = "Iran Standard Time"
    "Asia/Dubai" = "Arabian Standard Time"
    "Asia/Baku" = "Azerbaijan Standard Time"
    "Europe/Samara" = "Russian Standard Time"
    "Asia/Tbilisi" = "Georgian Standard Time"
    "Asia/Yerevan" = "Caucasus Standard Time"
    "Asia/Kabul" = "Afghanistan Standard Time"
    "Asia/Tashkent" = "West Asia Standard Time"
    "Asia/Yekaterinburg" = "Ekaterinburg Standard Time"
    "Asia/Karachi" = "Pakistan Standard Time"
    "Asia/Qyzylorda" = "West Asia Standard Time"
    "Asia/Calcutta" = "India Standard Time"
    "Asia/Colombo" = "Sri Lanka Standard Time"
    "Asia/Katmandu" = "Nepal Standard Time"
    "Asia/Almaty" = "Central Asia Standard Time"
    "Asia/Dhaka" = "Bangladesh Standard Time"
    "Asia/Urumqi" = "Central Asia Standard Time"
    "Asia/Rangoon" = "Myanmar Standard Time"
    "Asia/Bangkok" = "SE Asia Standard Time"
    "Asia/Jakarta" = "SE Asia Standard Time"
    "Asia/Novosibirsk" = "N. Central Asia Standard Time"
    "Asia/Hong_Kong" = "China Standard Time"
    "Asia/Krasnoyarsk" = "North Asia Standard Time"
    "Asia/Singapore" = "Singapore Standard Time"
    "Asia/Taipei" = "Taipei Standard Time"
    "Asia/Ulaanbaatar" = "Ulaanbaatar Standard Time"
    "Asia/Irkutsk" = "North Asia East Standard Time"
    "Asia/Tokyo" = "Tokyo Standard Time"
    "Asia/Seoul" = "Korea Standard Time"
    "Asia/Yakutsk" = "Yakutsk Standard Time"
    "Australia/Adelaide" = "Cen. Australia Standard Time"
    "Australia/Darwin" = "AUS Central Standard Time"
    "Australia/Brisbane" = "E. Australia Standard Time"
    "Australia/Sydney" = "AUS Eastern Standard Time"
    "Pacific/Guam" = "West Pacific Standard Time"
    "Australia/Hobart" = "Tasmania Standard Time"
    "Asia/Vladivostok" = "Vladivostok Standard Time"
    "Asia/Magadan" = "Magadan Standard Time"
    "Pacific/Auckland" = "New Zealand Standard Time"
    "Pacific/Fiji" = "Fiji Standard Time"
    "America/Glace_Bay" = "Atlantic Standard Time"
    "America/Moncton" = "Atlantic Standard Time"
    "America/Goose_Bay" = "Atlantic Standard Time"
    "America/Blanc-Sablon" = "Atlantic Standard Time"
    "America/Toronto" = "Eastern Standard Time"
    "America/Nipigon" = "Eastern Standard Time"
    "America/Thunder_Bay" = "Eastern Standard Time"
    "America/Iqaluit" = "Eastern Standard Time"
    "America/Pangnirtung" = "Eastern Standard Time"
    "America/Atikokan" = "Eastern Standard Time"
    "America/Detroit" = "Eastern Standard Time"
    "America/Montreal" = "Eastern Standard Time"
    "America/Nassau" = "Eastern Standard Time"
    "America/Puerto_Rico" = "SA Western Standard Time"
    "America/Port-au-Prince" = "SA Western Standard Time"
    "America/Jamaica" = "SA Western Standard Time"
    "America/Grand_Turk" = "SA Western Standard Time"
}

# Function to map common time zone names to Windows time zone names
function Map-TimeZone {
    param([string]$TimeZone)
    
    if ($global:TimeZoneMappings.ContainsKey($TimeZone)) {
        return $global:TimeZoneMappings[$TimeZone]
    } else {
        Write-Host "Invalid time zone: $TimeZone"
        return $null
    }
}

# Function to set time zone based on location
function Set-TimeZone {
    param([string]$TimeZone)
    
    # Map time zone to Windows time zone
    $windowsTimeZone = Map-TimeZone -TimeZone $TimeZone
    if ($windowsTimeZone) {
        Write-Host "Setting time zone to $windowsTimeZone"
        tzutil /s $windowsTimeZone
    }
}

# Fetch geolocation data from the website
$url = "https://ipapi.co/json/"
$response = Invoke-RestMethod -Uri $url
$locationData = @{
    "Time Zone" = $response.timezone
}

# Extract time zone from location data
$timeZone = $locationData["Time Zone"]

# Set the time zone on the device
if ($timeZone) {
    Set-TimeZone -TimeZone $timeZone
} else {
    Write-Host "Unable to determine time zone from the provided geolocation data."
}
