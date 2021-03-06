 Param
	(
	[Parameter(Mandatory=$True)]
	[string]$Platform
	)

# This script adds accounts required in the farm to the local admins group. simples.

# let's clean the error variable as we are not starting a fresh session
$Error.Clear()

# setup the parameter file
$parameterfile = "r:\powershell\xml\spconfig-"+$Platform+".xml"
[xml]$adminaccountstoadd = Get-Content $parameterfile

# Get the local Administrators
$AdminGroup = ([ADSI]"WinNT://$env:COMPUTERNAME/Administrators,group")
# Get the membets of the local  admins group
$LocalAdmins = $AdminGroup.psbase.invoke("Members") | ForEach-Object {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}
# loop through the parameter file for each of the user accounts that need to be added to the admins group
foreach ($adminaccounttoadd in $adminaccountstoadd.farm.adminaccounts.account) {
		Write-Host "INFO: Adding admin account $($adminaccounttoadd.Name)" -NoNewline -ForegroundColor Yellow
	Try	{
		$ManagedAccountDomain,$ManagedAccountUser = $adminaccounttoadd.Name -Split "\\"
		# Add managed account to local admins by first testing that it is not already an admin and if it is not then we add it via ADSI provider
		If (!($LocalAdmins -contains $ManagedAccountUser)) {
			([ADSI]"WinNT://$env:COMPUTERNAME/Administrators,group").Add("WinNT://$ManagedAccountDomain/$ManagedAccountUser")
			Write-Host " Done!"	-BackgroundColor DarkGreen	
		}
		Else {
			Write-Host ""
			# we use write-warning here as we could request input from the console if we desired
			Write-Warning "$($adminaccounttoadd.Name) is already a local admin!"
			$warning = $true
		}
	}
	Catch {
		$_
		Write-Host "."
		Write-Warning "Could not add $($adminaccounttoadd.Name) to Admins group!"
	}
}
Write-Host ''
# here we are testing to see if we should note to the console that warnings were generated this is not really necessary and is just here to show a multiple condition test
if ((!$warning) -and (!$Error)) {
	Write-Host "Done Adding Admin Accounts!" -BackgroundColor DarkGreen
}
else {
	Write-Warning "Done Adding Admin Accounts, but errors or warnings were generated!"
}

# here we dump a file to the desktop to let us know if the process completed or threw an error
if (!$Error) {
	Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)' completed'.txt
}
else {
	Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)' failed'.txt
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