Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop';

. (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) -ChildPath 'packageData.ps1')

$os = Get-WmiObject -Class Win32_OperatingSystem
$version = [Version]$os.Version
$force = $Env:chocolateyPackageParameters -like '*Force*'

$runtimes = @{
    'x64' = @{
        RegistryPresent = $false;
        RegistryVersion = $null;
        InstallData = $installData64;
        Applicable = (Get-OSArchitectureWidth) -eq 64
    }
    'x86' = @{
        RegistryPresent = $false;
        RegistryVersion = $null;
        InstallData = $installData32;
        Applicable = (Get-OSArchitectureWidth) -eq 32
    }
}

Write-Verbose 'Analyzing servicing information in the registry'
$regRoot = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\'
# https://docs.microsoft.com/en-us/cpp/ide/redistributing-visual-cpp-files
$regData = Get-ItemProperty -Path "$regRoot\MSODBCSQL$($packageData.Version.Major)" -Name 'InstalledVersion' -ErrorAction SilentlyContinue
if ($regData -ne $null)
{
    $versionString = $regData.InstalledVersion
    try
    {
        $parsedVersion = [version]$versionString
        Write-Verbose "Version of installed runtime for architecture $arch in the registry: $versionString"
        $normalizedVersion = [version]($parsedVersion.ToString(3)) # future-proofing in case Microsoft starts putting more than 3 parts here
        $runtimes[$(Get-OSArchitectureWidth)].RegistryVersion = $normalizedVersion
        $runtimes[$(Get-OSArchitectureWidth)].RegistryPresent = $true
    }
    catch
    {
        Write-Warning "The servicing information in the registry is in an unknown format. Please report this to package maintainers. Data from the registry: Version = [$versionString]"
    }
}

$packageRuntimeVersion = $packageData.Version
Write-Verbose "Version number of runtime installed by this package: $packageRuntimeVersion"
foreach ($archAndRuntime in $runtimes.GetEnumerator())
{
    $arch = $archAndRuntime.Key
    $runtime = $archAndRuntime.Value
    $shouldInstall = $runtime.RegistryVersion -eq $null -or $runtime.RegistryVersion -lt $packageRuntimeVersion
    Write-Verbose "Runtime for architecture $arch applicable: $($runtime.Applicable); version in registry: [$($runtime.RegistryVersion)]; should install: $shouldInstall"
    if ($runtime.Applicable)
    {
        if (-not $shouldInstall)
        {
            if ($force)
            {
                Write-Warning "Forcing installation of runtime for architecture $arch version $packageRuntimeVersion even though this or later version appears present, because 'Force' was specified in package parameters."
            }
            else
            {
                if ($runtime.RegistryVersion -gt $packageRuntimeVersion)
                {
                    Write-Warning "Skipping installation of runtime for architecture $arch version $packageRuntimeVersion because a newer version ($($runtime.RegistryVersion)) is already installed."
                }
                else { Write-Host "Runtime for architecture $arch version $packageRuntimeVersion is already installed." }
                continue
            }
        }
        Write-Verbose "Installing runtime for architecture $arch"
        $packageArgs = $runtime.InstallData + $packageData
        Install-ChocolateyPackage @packageArgs
    }
}
