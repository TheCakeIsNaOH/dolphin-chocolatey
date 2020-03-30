$ErrorActionPreference = 'Stop'
$toolsDir 			   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pp                    = Get-PackageParameters
$shortcutName          = 'Dolphin Emulator.lnk'
$extractDir            = $(Get-ToolsLocation)
$dolphinDir            = (Join-Path $extractDir Dolphin-x64)
$exepath               = (Join-Path $dolphinDir Dolphin.exe)
$url64                 = 'https://dl.dolphin-emu.org/builds/a6/20/dolphin-master-5.0-11824-x64.7z'
$checksum64            = '308b9351ea2803866214a4f7f85364b1230f83cba10f1b942c6d527d6d96d932'

$packageArgs = @{
  Url64bit       = $url64
  Checksum64     = $checksum64
  ChecksumType64 = 'sha256'
  UnzipLocation  = $extractDir 
  PackageName    = 'dolphin'
}

Install-ChocolateyZipPackage @packageArgs

Install-BinFile -Name 'Dolphin' -Path $exepath -UseStart

if ($pp['desktopicon']) {
	$desktopicon = (Join-Path ([Environment]::GetFolderPath("Desktop")) $shortcutName)
	Write-Host -ForegroundColor white 'Adding ' $desktopicon
	Install-ChocolateyShortcut -ShortcutFilePath $desktopicon -TargetPath $exepath  -RunAsAdmin
}

if (!$pp['nostart']) {
	$starticon = (Join-Path ([environment]::GetFolderPath([environment+specialfolder]::Programs)) $shortcutName)
	Write-Host -ForegroundColor white 'Adding ' $starticon
	Install-ChocolateyShortcut -ShortcutFilePath $starticon -TargetPath $exepath  -RunAsAdmin
}
