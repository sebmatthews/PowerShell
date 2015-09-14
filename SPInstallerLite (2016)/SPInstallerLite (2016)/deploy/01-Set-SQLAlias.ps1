 Param
	(
	[Parameter(Mandatory=$True)]
	[string]$Platform
	)

# this script sets the sql server alias from the config file by adding registry keys. simples.

# let's clean the error variable as we are not starting a fresh session
$Error.Clear()

# setup the parameter file
$parameterfile = "r:\powershell\xml\spconfig-"+$Platform+".xml"

# Be aware that this method is a little clunky as it does not check for existing alias and simply adds new entries!
[xml]$aliastoadd = Get-Content $parameterfile
Write-Host ""
# check and create the registry stubs
Try {
	$checkx86registrystub = Get-Item HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo -ErrorAction silentlycontinue
		if ($checkx86registrystub -eq $NULL) {
		    write-host "INFO: Creating x86 stub in registry..." -ForegroundColor Yellow
		    New-Item HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo
	    }
	    else {
		    write-host "INFO: x86 stub already exists, continuing..." -ForegroundColor Yellow
			Write-Host ""
	    }
	$checkx64registrystub = Get-Item HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo -ErrorAction silentlycontinue
	if ($checkx64registrystub -eq $NULL) {
		write-host "INFO: Creating x64 stub in registry..." -ForegroundColor Yellow
		New-Item HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo
	}
	else {
		write-host "INFO: x64 stub already exists, continuing..." -ForegroundColor Yellow
		Write-Host ""
	    }
	if ($checkx86registrystub -ne $null -and $checkx64registrystub -ne $NULL) {
		write-host "INFO: Both registry stubs exist, this may indicate the presence of existing alias, launching CLICNFG so you can take a peek..." -ForegroundColor Yellow
		Start-Process cliconfg
		$keepcalmcarryon = read-host "Do you wish to continue? Y/N"
		Write-Host ""
		if ($keepcalmcarryon -notlike "Y") {
			break
		}
	}
	Write-Host ""
	foreach ($newalias in $aliastoadd.farm.sqlalias.alias) {
	    write-host "INFO: Creating entries for:"$newalias.name"on instance"$newalias.instance -ForegroundColor Yellow
		$aliasvalue=$newalias.instance
		# set the x86 alias
	    New-ItemProperty HKLM:\SOFTWARE\Microsoft\MSSQLServer\Client\ConnectTo -name $newalias.name -PropertyType String -Value "DBMSSOCN,$aliasvalue" -ErrorAction SilentlyContinue
	    # set the x64 alias
	    New-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\MSSQLServer\Client\ConnectTo -name $newalias.name -PropertyType String -Value "DBMSSOCN,$aliasvalue" -ErrorAction SilentlyContinue
	}
	Write-Host ""
	Write-Host "SUCCESS: All SQL Alias created!" -BackgroundColor DarkGreen
	# uncomment the line below if you want the script to invoke cliconfg to mark-1 eyeball the alias that have been set
	# start-process cliconfg
	# we have to clear the error variable as a non-terminating error was generated at both lines 20 & 29 but because we use a 'silentlycontinue' we don't trigger the catch - don't do this for real!
	# without this clearing of the variable, the finally block will generate a file suffixed 'failed'
	$Error.Clear()
}
Catch {
	Write-Host "Something bad happened!"
	Write-Host "The error was: $error"
}
Finally {
	
	# here we dump a file to the desktop to let us know if the process completed or threw an error
	if (!$Error) {
		Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)' completed'.txt
	}
	else {
		Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)' failed'.txt
	}
}

#    The PowerShell Tutorial for SharePoint 2010
#    Copyright (C) 2014 Seb Matthews
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.