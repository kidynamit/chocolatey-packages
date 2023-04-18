$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation   = Join-Path $toolsDir 'msodbcsql-x86.msi'
$file64Location = Join-Path $toolsDir 'msodbcsql-x64.msi'

#Based on Msi
$packageArgs = @{
  packageName       = 'Microsoft-ODBC-Driver'
  silentArgs        = '/quiet /passive /qn /uninstall'
  validExitCodes    = @(0,1641,3010)
  file              = $fileLocation
  fileType          = 'msi'
}

Uninstall-ChocolateyPackage @packageArgs
