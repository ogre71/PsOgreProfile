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

Set-Alias -Name np -Value notepad

# I dislike trusting myself to have typed strings correctly. 
function nameof($functionName) {
	$result = Get-ChildItem function: | Where { $_.name -like $functionName }
	if ($result -ne $null) {
		return $functionName
	} else { 
		Write-Error "$functionName is an unknown function"
	}
}

function Promote($verb, [parameter(Mandatory=$false)]$alias) {
	Write-Host (nameof($verb)) -ForegroundColor "green" -NoNewLine
	if ($alias -ne $null) {
		Write-Host " ($alias)" -ForegroundColor "green" -NoNewLine
	}
	Write-Host " function available"
}

function New-CaptainsLog {
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

Promote("New-CaptainsLog")

#TODO: change this to a different gist than captainslog, create the bootstrap gist
#TODO: abstract most of this and captainslog into it's own (private?) function
function New-Bootstrap { 
	$url = "https://gist.githubusercontent.com/ogre71/4afed194bee1cb63a6b4b580de1cda03/raw/780dcb2960a2cfcd534d6cbf4edd836f49744124/CaptainsLog.html" 
	$contents = Invoke-RestMethod -Uri $url

	$contents = $contents.Replace("`$`$date`$`$", (Get-Date))
	
	$logExists = Test-Path "bootstrapQuickStart.html"
	if (!$logExists) { 
			$contents >> "bootstrapQuickStart.html"
			notepad "bootstrapQuickStart.html"
	}
	
	& ".\bootstrapQuickStart.html"
	
	return $contents
}

Promote "New-Bootstrap" 

function Get-NamedRepository (
	[ValidateSet("PsOgreProfile", "ReadableThings")]
	$repository	){ 
	if ($repository -like "PsOgreProfile") {
		git clone https://github.com/ogre71/PsOgreProfile.git
		Write-Host "copy-item `$Profile . -Force #This is probably what you want to do next." -ForegroundColor "green"
	} elseif ($repository -like "ReadableThings") {
		git clone https://github.com/ogre71/ReadableThings.git
		cd ReadableThings
	} else {
		Write-Host "Unknown repository: "
		Write-Host "$repository" -ForegroundColor "red"
		Write-Host "Known repositories: " -NoNewLine
		Write-Host "PsOgreProfile, ReadableThings" -ForegroundColor "green"
	}
}
Set-Alias -Name clone -Value Get-NamedRepository

Promote "Get-NamedRepository" -alias "clone"

function zork() {
	cd .\ReadableThings\
	
	$binExists = Test-Path .\Ogresoft.Parser\bin

	if (!$binExists) { 
		Write-Host Building Zork
		pwd
		Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\devenv.exe" -ArgumentList ReadableThings.sln, /build -Wait
	}
	cd .\Ogresoft.Parser\

	cd bin
	cd Debug
	[System.Environment]::CurrentDirectory = Get-Location
	add-type -path .\Ogresoft.Parser.dll
	$global:repl = new-object Ogresoft.Parser.Repl
	$global:repl.Execute("look")
	$global:repl.Shell()
}

Promote("zork")

#create note "do some stuff"
#drop note
#take note
#look
#go north
#go door
#load readable things

