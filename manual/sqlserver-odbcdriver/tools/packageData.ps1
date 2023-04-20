$filesDir = "$(Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath 'files')"

$packageData = @{
    Version           = [version]'18.2.1.1'
    PackageName       = 'Microsoft-ODBC-Driver'
    SoftwareName      = 'Microsoft ODBC Driver 18 for SQL Server*'
    FileType          = 'msi'
    ValidExitCodes    = @(0)
}

$uninstallData = @{
    SilentArgs        = '/quiet /passive /qn'
    ValidExitCodes    = @(0)
}

$installData32 = @{
    ChecksumType      = 'sha256'
    Checksum          = 'A3C94EAFF6A7443C26BE7F5B2F2EED9235921251F01A86D998EAA41E905F5BCD'
    SilentArgs        = '/quiet /passive /qn IACCEPTMSODBCSQLLICENSETERMS=YES /l*v C:\Temp\Microsoft-ODBC-Driver.x86_msi_install.log'
    Url               = "$(Join-Path -Path $filesDir -ChildPath 'msodbcsql.x86.msi')"
}

$installData64 = @{
    ChecksumType64    = 'sha256'
    Checksum64        = '3B9C9F8584B1AFA9071E6324E7C8BE66696211C0FF5A3B0670F2F6C8E2424CF8'
    SilentArgs        = '/quiet /passive /qn IACCEPTMSODBCSQLLICENSETERMS=YES /l*v C:\Temp\Microsoft-ODBC-Driver.x64_msi_install.log'
    FileType64        = 'msi'
    Url64             = "$(Join-Path -Path $filesDir -ChildPath 'msodbcsql.x64.msi')"
}


