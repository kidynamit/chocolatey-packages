Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop';

. (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath 'packageData.ps1')

[array] $uninstallKeys = Get-UninstallRegistryKey @packageData
[array] $filteredUninstallKeys = $uninstallKeys | Where-Object { $_ -ne $null -and ($_.PSObject.Properties['SystemComponent'] -eq $null -or $_.SystemComponent -eq 0) }
foreach ($uninstallKey in $filteredUninstallKeys)
{
    if ($uninstallKey -eq $null) { continue }

    if ($uninstallKey.PSObject.Properties['UninstallString'] -ne $null)
    {
        $uninstallData['SilentArgs'] = "$($uninstallKey.PSChildName) $($uninstallData.SilentArgs)"
        $uninstallData['File'] = ''
        $packageArgs = $packageData + $uninstallData
        Uninstall-ChocolateyPackage @packageArgs
    }
    else
    {
        Write-Warning "The UninstallInformation in the registry does not contain the path to the uninstaller application. `
                        Please report this to package maintainers. Registry key path: [$($uninstallKey.PSPath)]"
    }
}
