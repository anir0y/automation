# print banner 
Write-Host "Installing basic tools for Windows..." -ForegroundColor Green
write-host "by: @anir0y" -ForegroundColor Green
write-host "----------------------------------------"
# Check if the script is running with administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as an administrator."
    Exit 1
}

# Install Chocolatey if not already installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install packages using Chocolatey
$packages = @('vscode', 'googlechrome', 'burp-suite-free-edition')

foreach ($package in $packages) {
    if (-Not (Get-Command $package -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $package..."
        choco install $package -y
    } else {
        Write-Host "$package is already installed."
    }
}

# Check if Python 3.11.4 is installed, and if not, install it directly
$pythonVersion = '3.11.4'
$pythonPath = "C:\Python$pythonVersion"

if (-Not (Test-Path $pythonPath -PathType Container)) {
    Write-Host "Installing Python $pythonVersion..."
    $pythonInstallerUrl = "https://www.python.org/ftp/python/$pythonVersion/python-$pythonVersion-amd64.exe"
    $pythonInstaller = "$env:TEMP\python-$pythonVersion-amd64.exe"

    (New-Object System.Net.WebClient).DownloadFile($pythonInstallerUrl, $pythonInstaller)
    Start-Process -Wait -FilePath $pythonInstaller -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1"
    Remove-Item $pythonInstaller
} else {
    Write-Host "Python $pythonVersion is already installed."
}
