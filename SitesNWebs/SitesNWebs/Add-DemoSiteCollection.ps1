# we're wrapping this up in a function slightly pointlessly only to make it demonstrably reusable

Function New-SPDemoSiteCollection {
	<#
	.SYNOPSIS         
 	Creates a site collection in an overly complicated way for demo purposes. 
	.PARAMETER  scurl
	The URL of the site collection to create.
	.PARAMETER  powner
	The primary owner.
	.PARAMETER  sowner
	The secondary owner.
	.PARAMETER  template
	The internal code for the template to use for the site collection.  Must be valid.
	.PARAMETER scname
	The name of the site collection.
	.NOTES
	Adapted from a script by bigseb.com
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True)]
		[string]$scurl,
		[Parameter(Mandatory=$True)]
		[string]$powner,
		[Parameter(Mandatory=$True)]
		[string]$sowner,
		[Parameter(Mandatory=$True)]
		[string]$template,
		[Parameter(Mandatory=$True)]
		[string]$scname
		)
	Write-Host "INFO: Creating site $scurl..." -NoNewline -ForegroundColor Yellow -BackgroundColor Black
	New-SPSite -url $scurl -OwnerAlias $powner -SecondaryOwnerAlias $sowner -Template $template -Name $scname | Out-Null
	# the following 3 lines are required because creating a site collection through powershell
	# does not call the createdefaultgroups method correctly resulting in no default security groups
	# in the site.
	# annoying huh?
	$website = Get-SPWeb $scurl
	$website.createdefaultassociatedgroups(($powner),($sowner),"")
	$website.dispose()
	Write-Host "Done!" -ForegroundColor Green -BackgroundColor Black
}

# actually do the work
New-SPDemoSiteCollection -scurl "http://powershell/content/functest06" -scname "functest06" -powner "BIGSEB\Administrator" -sowner "BIGSEB\Administrator" -template "STS#0"