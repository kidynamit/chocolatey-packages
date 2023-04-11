$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'msodbcsql.msi'

#Based on Msi
$packageArgs = @{
  packageName   = 'Microsoft-ODBC-Driver'
  softwareName  = 'Microsoft ODBC Driver 17 for SQL Server*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = '/quiet IACCEPTMSODBCSQLLICENSETERMS=YES'
  validExitCodes= @(0,1641,3010)
  url           = ""
  checksum      = '23846AF382068D8824FDF93AC3FB4DB2116DEDEEDC08F6F159189CA920CDC69C'
  checksumType  = 'sha256'
  url64bit      = ""
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
  #installDir   = "" # passed when you want to override install directory - requires licensed editions 1.9.0+
}

Install-ChocolateyInstallPackage @packageArgs

<#
== MSI Properties ==
These are the PROPERTIES of the MSI, some of which you can add or change to the silent args or add as package parameters
Note: This only captures what ends up in the MSI Property/AppSearch tables and is not guaranteed to cover all properties.


MEDIAPACKAGEPATH=\1033_ENU_LP\x64\Setup\x64\
PROMPTROLLBACKCOST=P
INSTALLLEVEL=100
ALLUSERS=1
ISENABLEDWUSFINISHDIALOG=1
CA_ERRORCOUNT=0
CA_WARNINGCOUNT=0
CA_SUCCESSCOUNT=0
UI_SHOWCOPYRIGHT=yes
ADALSQLDLL=**Property found in SecureCustomProperties**
ADALSQLFOUND=**Property found in SecureCustomProperties**
NEWERFOUND_64=**Property found in SecureCustomProperties**
OLDERFOUND_64=**Property found in SecureCustomProperties**
OLDERFOUND2_64=**Property found in SecureCustomProperties**
INSTALLSQLSHAREDDIR_32=**Value is determined by MSI function**
INSTALLSQLSHAREDDIR_64=**Value is determined by MSI function**
#>


