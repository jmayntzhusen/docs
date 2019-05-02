# If you want to get the API docs from the Umbraco CMS for local testing you can run this script, it is also this script that is used on the buildserver.

# Comment out this command if you already have DocFX installed
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install docfx -y

git clone -q https://github.com/jmayntzhusen/Umbraco-CMS.git src

docfx metadata

docfx build docfx.json