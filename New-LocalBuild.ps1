[CmdletBinding()]
param(
    [string] $wyamExe = '',
    [string] $source = 'src',
    [string] $destination = 'build\site',
    [string] $packages = 'packages',
    [string] $version = '2.2.5',
    [switch] $preview,
    [switch] $watch
)

if ($wyamExe -eq '')
{
    & nuget install Wyam -Version $version -OutputDirectory $packages -PreRelease -Verbosity detailed

    $path = Get-ChildItem -Path $packages -Recurse -Filter wyam.dll | Select-Object -First 1
    $wyamExe = $path.FullName
}

$commandLine = "& dotnet '$wyamExe' --input $source --output $destination --use-local-packages --packages-path $packages"
if ($preview)
{
    $commandLine += ' -p'
}

if ($watch)
{
    $commandLine += ' -w'
}

Invoke-Expression -Command $commandLine
