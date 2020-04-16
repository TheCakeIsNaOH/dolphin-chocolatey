$ErrorActionPreference = 'Stop'
$toolsDir 			   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pp                    = Get-PackageParameters
$shortcutName          = 'Dolphin Emulator.lnk'
$extractDir            = $(Get-ToolsLocation)
$dolphinDir            = (Join-Path $extractDir Dolphin-x64)
$exepath               = (Join-Path $dolphinDir Dolphin.exe)
$url64                 = 'https://dl.dolphin-emu.org/builds/71/d1/dolphin-master-5.0-11845-x64.7z'
$checksum64            = '63af7aa4c226aa1048cd0625cd4dd8c5244cf3293c6678afd790388474ef71bf'

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
