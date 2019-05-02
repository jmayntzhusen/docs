```
# Location of Microsoft.SqlServer.Dac.dll
$DacAssembly = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Extensions\Application\Microsoft.SqlServer.Dac.dll"

# Connection details can be found under "Settings" > "Connection details" on Umbraco.io
# If your password contains $ you'll have to escape them with a backtick (`)
$connectionString = "server=example.com;database=julemand;user id=root@example;password=pa`$`$word"

# The name of the database
$databaseName = "julemand"

# Bacpac files will be written to this directory - make sure it already exists
$backupDirectory = "C:\dbbackup\"

# Load DAC assembly
Write-Host "Loading Dac Assembly: $DacAssembly"
Add-Type -Path $DacAssembly
Write-Host "Dac Assembly loaded."

# Initialize Dac
$now = $(Get-Date).ToString("HH:mm:ss")
$services = new-object Microsoft.SqlServer.Dac.DacServices $connectionString
if ($services -eq $null)
{
    exit
}

$dateTime = $(Get-Date).ToString("yyyy-MM-dd-HH.mm.ss")

Write-Host "Starting backup of $databaseName at $now"
$watch = New-Object System.Diagnostics.StopWatch
$watch.Start()
$services.ExportBacpac("$backupDirectory$databaseName-$dateTime.bacpac", $databaseName)
$watch.Stop()
Write-Host "Backup completed in" $watch.Elapsed.ToString()
```