# we're wrapping this up in a function slightly pointlessly really only to make it demonstrably reusable

Function Add-BulkSPWebs {
	<#
	.SYNOPSIS         
 	Creates a specified number of webs in a site collection. 
	.PARAMETER  scname
	The name of the site collection in which the webs will be created.
	.PARAMETER  startweb
	The starting number of the web name.
	.PARAMETER  endweb
	The number of webs to create.
	.PARAMETER  prefix
	The name prefix of the webs.  This will be added to the startweb value, for instance - "web1"
	.NOTES
	Adapted from a script by bigseb.com
	#>
	[CmdletBinding()]
	Param (
	[Parameter(Mandatory=$True)]
	[string]$scname,
	[Parameter(Mandatory=$True)]
	[int]$startweb,
	[Parameter(Mandatory=$True)]
	[int]$endweb,
	[Parameter(Mandatory=$True)]
	[string]$prefix
	)
	# We're using a Try...Catch so we can (a) show it and (b) benefit from it
	Try {
		# A For loop will repeat for a specified number of times evaluating until the condition is met.
		# Just remember - Initialise; Condition; Repeat - the semi colons are important!
		For (;$startweb -le $endweb;$startweb++) {
			$webname = $prefix+$startweb
			New-SPWeb -Url "$scname/$webname" -Name $webname -Description $webname -Template "STS#0" -ErrorAction Stop | Out-Null
			Write-Host "SUCCESS: Site $webname added at $scname" -ForegroundColor DarkGreen
		}
	}
	Catch {
		Write-Host "ERROR: An error occurred!" -ForegroundColor Red
		$caught = $true
	}
	Finally {
		Write-Host "Function ended " -NoNewline
		If ($caught) {
			Write-Host "with errors!" -ForegroundColor Red
		}
		Else {
			Write-Host "with no errors." -ForegroundColor DarkGreen
		}
	}
}

# actually do the work
Add-BulkSPWebs -scname 'http://powershell/content/functest06' -startweb 1 -endweb 5 -prefix 'silenta'