# Set the output CSV file path
$csvFilePath = "C:\Users\Ugonna\Desktop\Learn\appData.csv"

# Get the applications installed
function Get-Apps {
  
  $uninstallKeys = Get-ChildItem -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" |
                   Where-Object { $_.Property -contains "DisplayName" }

  $installedApps = @()

  foreach ($key in $uninstallKeys) {
    $app = New-Object PSObject

    $app | Add-Member -MemberType NoteProperty -Name "Applications" -Value $key.GetValue("DisplayName")

    $installedApps += $app
  }

  # Concat the installed apps into a string
  $apps = $installedApps | ForEach-Object -MemberName "Name"
  # {
  #   "Name: $($_.Name); \n"
  # }

  return $installedApps
}

# Get information about All Services
function Get-AllServices {
  # $services = Get-WmiObject -Class Win32_Service
  $services = Get-Service

  # $nonSystemServices = $services | Where-Object { $_.StartMode -notmatch 'System' }
  $nonSystemServices = $services | Where-Object { $_.StartMode -match 'System' }

  return $nonSystemServices
}

Get-Apps | Export-Csv -Path $csvFilePath -NoTypeInformation
Get-AllServices
# Import-Csv -Path $csvFilePath