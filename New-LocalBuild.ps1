[CmdletBinding()]
param(
    [string] $wyamExe = '',
    [string] $source = 'src',
    [string] $destination = 'build\site',
    [string] $packages = 'packages',
    [switch] $preview,
    [switch] $watch
)

if ($wyamExe -eq '')
{
    & nuget install Wyam -OutputDirectory $packages -PreRelease -Verbosity detailed

    $path = Get-ChildItem -Path $packages -Recurse -Filter wyam.exe | Select-Object -First 1
    $wyamExe = $path.FullName
}

$commandLine = "& '$wyamExe' --input $source --output $destination --use-local-packages --packages-path $packages"
if ($preview)
{
    $commandLine += ' -p'
}

if ($watch)
{
    $commandLine += ' -w'
}

Invoke-Expression -Command $commandLine
