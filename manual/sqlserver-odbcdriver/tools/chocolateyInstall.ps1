$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation   = Join-Path $toolsDir 'msodbcsql-x86.msi'
$file64Location = Join-Path $toolsDir 'msodbcsql-x64.msi'

#Based on Msi
$packageArgs = @{
  packageName       = 'Microsoft-ODBC-Driver'
  softwareName      = 'Microsoft ODBC Driver 18 for SQL Server*'
  silentArgs        = '/quiet /passive /qn IACCEPTMSODBCSQLLICENSETERMS=YES'
  validExitCodes    = @(0,1641,3010)
  url               = ''
  file              = $fileLocation
  fileType          = 'msi'
  checksum          = 'A3C94EAFF6A7443C26BE7F5B2F2EED9235921251F01A86D998EAA41E905F5BCD'
  checksumType      = 'sha256'
  url64bit          = ''
  file64            = $file64Location
  fileType64        = 'msi'
  checksum64        = '3B9C9F8584B1AFA9071E6324E7C8BE66696211C0FF5A3B0670F2F6C8E2424CF8'
  checksumType64    = 'sha256'
  destination       = $toolsDir
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
