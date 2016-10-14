# constants
$version = "2.1.1"
$driverName = "phantomjs.exe"
$folderName = "phantomjs-$version-windows"
$binaryPath = "bin"
$zipName = "$folderName.zip"

$downloadUrl = "https://bitbucket.org/ariya/phantomjs/downloads/$zipName"

# move current folder to where contains this .ps1 script file.
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
pushd $scriptDir

$currentPath = Convert-Path "."
$zipPath = Join-Path $currentPath $zipName

# download driver .zip file if not exists.
if (-not (Test-Path ".\$zipName")){
    (New-Object Net.WebClient).Downloadfile($downloadurl, $zipPath)
    if (Test-Path ".\$driverName") { del ".\$driverName" }
}

# Decompress .zip file to extract driver .exe file.
if (-not (Test-Path ".\$driverName")) {
    $shell = New-Object -com Shell.Application
    $zipFile = $shell.NameSpace("$zipPath\$folderName\$binaryPath")

    $zipFile.Items() | `
    where {(Split-Path $_.Path -Leaf) -eq $driverName} | `
    foreach {
        $currentDir = $shell.NameSpace((Convert-Path "."))
        $currentDir.copyhere($_.Path)
    }
    sleep(2)
}
