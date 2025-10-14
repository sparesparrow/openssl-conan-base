param(
  [string]$BuildType = "Release",
  [string]$OutputDir = "full_deploy",
  [switch]$Rebuild
)

$ErrorActionPreference = "Stop"

if ($Rebuild -and (Test-Path $OutputDir)) {
  Remove-Item -Recurse -Force $OutputDir
}

# Ensure Conan extensions are installed (no-op if already configured)
conan config install https://github.com/conan-io/conan-extensions.git | Out-Null

conan install . `
  --output-folder=$OutputDir `
  --build=missing `
  --settings=build_type=$BuildType `
  --deployer=full_deploy

# Zip the deploy folder for distribution
$zipPath = "${OutputDir}.zip"
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($OutputDir, $zipPath)

Write-Host "full_deploy bundle created at: $zipPath"
