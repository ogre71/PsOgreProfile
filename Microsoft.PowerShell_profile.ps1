Write-Host "Hello, this is from your powershell profile."
$scratchPath = "C:\Users\Ogre\scratch" 
Write-Host "The scratch path is: " -NoNewLine
Write-Host $scratchPath -foregroundColor "green"
$nppPath = "C:\Program Files (x86)\Notepad++\notepad++.exe"
Write-Host "Notepad++ is located here: " -NoNewLine
Write-Host $nppPath -foregroundColor "green"

Write-Host "The profile is located here: " $profile
Write-Host "To edit the profile type `"notepad `$profile`""
Write-Host "The " -NoNewLine
Write-Host "notepad" -NoNewLine -foregroundColor "green"
Write-Host " and " -NoNewLine
Write-Host "note" -NoNewLine -foregroundColor "green"
Write-Host " commands have been overridden to execute Notepad++"

cd $scratchPath 
$today = (Get-Date -Format FileDate)
$todayExists = Test-Path $today

if (!$todayExists) {
	new-item $today -ItemType Directory
}

set-location $today

function prompt {
	Write-Host -NoNewLine (Get-Location)
	return ">"
}

function notepad ($fileName) {
	&("C:\Program Files (x86)\Notepad++\notepad++.exe") $fileName
}

function note($fileName) {
	notepad ($fileName)
}

function captainslog {
	$url = "https://gist.githubusercontent.com/ogre71/4afed194bee1cb63a6b4b580de1cda03/raw/780dcb2960a2cfcd534d6cbf4edd836f49744124/CaptainsLog.html" 
	$contents = Invoke-RestMethod -Uri $url

	$contents = $contents.Replace("`$`$date`$`$", (Get-Date))
	
	$logExists = Test-Path "CaptainsLog.html"
	if (!$logExists) { 
			$contents >> "CaptainsLog.html"
			notepad "CaptainsLog.html"
	}
	
	& ".\CaptainsLog.html"
	
	return $contents
}

function clone ($repository) { 
	if ($repository -like "PsOgreProfile") {
		git clone https://github.com/ogre71/PsOgreProfile.git
		Write-Host "copy-item $Profile . -Force #This is probably what you want to do next."
	} else {
		Write-Host "Unknown repository: " $repository
		Write-Host "Known repositories: PsOgreProfile"
	}
}