Param
	(
	[Parameter(Mandatory=$True, HelpMessage="You must provide a platform suffix so the script can find the paramter file!")]
	[string]$Platform
	)

#REGION functions

Function Test-SnapIns {
	<#
	   .Synopsis
	    This function tests for and loads (if needed) specified Snap Ins
	   .Description
	    This function tests for and loads (if needed) specified Snap Ins.  Simply add snap in names to the $snapinstocheck array
		This function has only been tested with SharePoint 2016.
		This function will only run from an elevated PowerShell session and requires the running user to
		have permission to the SharePoint configuration database.
	   .Example
	   	Test-SnapIns
	   .Notes
	    NAME: Test-SnapIns
	    AUTHOR: Seb Matthews @sebmatthews #bigseb - This script is based on a script by Ed Wilson
	    DATE: September 2016
	   .Link
	    http://sebmatthews.net
	#>
	$snapinsToCheck = @("Microsoft.SharePoint.PowerShell") # list more as required
	$currentSnapins = Get-PSSnapin
	$snapinsToCheck | ForEach-Object {
		$snapin = $_
        if(($CurrentSnapins | Where-Object {$_.Name -eq "$snapin"}) -eq $null) {
	            Write-Host
				Write-Host "$snapin snapin not found, loading it"
	            Add-PSSnapin $snapin
	            Write-Host "$snapin snapin loaded"
	        }
	    }
	}

#ENDREGION

# let's clean the error variable as we are not starting a fresh session
$Error.Clear()

# setup the parameter file
$parameterfile = "r:\powershell\xml\spconfig-"+$Platform+".xml"
[xml]$configdata = Get-Content $parameterfile

# load the SP snap in if needed
Test-SnapIns

# do all of the work from here
# this time we have not added the comments as verbosely
# perhaps you should?
# Banzai!

# here we add the managed paths from the config file
$managedpaths = $configdata.farm.iaconfig.managedpaths
foreach ($managedpath in $managedpaths.path) {
	if (!(Get-SPManagedPath -WebApplication $($managedpath.webapp) | ?{$_.name -match $managedpath.mpath})) {
	Write-Host "INFO: Creating managed path $($managedpath.mpath)..."  -NoNewline
	New-SPManagedPath $managedpath.mpath -WebApplication $managedpath.webapp | Out-Null
	Write-Host "Done!" -BackgroundColor DarkGreen
	$Error.Clear()
	}
}


# build out site collections from the config file by looping through the XML elements
$sitecollections = $configdata.farm.iaconfig.sitecollections
Write-Host ''
foreach ($sitecollection in $sitecollections.sitecollection) {
	$siteurl = $sitecollection.webapp+$sitecollection.path+$sitecollection.urlstub
	if (!(Get-SPSite $siteurl -ErrorAction SilentlyContinue)) {
		Write-Host "INFO: Creating site $siteurl ..." -NoNewline 
		$silentsitecreation = New-SPSite -url $siteurl -OwnerAlias $sitecollection.primaryowner -SecondaryOwnerAlias $sitecollection.secondaryowner -Template $sitecollection.template -Name $sitecollection.name -ContentDatabase $sitecollection.contentdb
		# the following 3 lines are required because creating a site collection through powershell
		# does not call the createdefaultgroups method correctly resulting in no default security groups
		# in the site.
		# annoying huh?
			#		$website = Get-SPWeb $siteurl
			#		$website.createdefaultassociatedgroups(($sitecollection.primaryowner),($sitecollection.secondaryowner),"")
			#		$website.dispose()
		Write-Host "Done!" -BackgroundColor DarkGreen
		Write-Host ''
	}
}

if (!$Error) {
	Write-Host
	Write-Host "SUCCESS: Site collections created!" -BackgroundColor DarkGreen
	Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)'completed'.txt
	}
else {
	Write-Host
	Write-Host "ERROR: There was an issue with the site collection creation, please review!" -BackgroundColor Red
	start-process "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\BIN\psconfigui.exe" -argumentlist "-cmd showcentraladmin"
	Out-File $env:USERPROFILE\desktop\$(($MyInvocation).mycommand.name)'failed'.txt
	}
	Write-Host

#    The PowerShell Tutorial for SharePoint 2016
#    Copyright (C) 2015 Seb Matthews
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