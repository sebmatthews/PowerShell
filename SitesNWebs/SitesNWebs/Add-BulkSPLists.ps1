
Function Add-SPList {
	<#
	.SYNOPSIS         
 	Creates a list for demo purposes. 
	.PARAMETER  url
	The URL of the web in which to create the list.
	.PARAMETER  listname
	The list name.
	.PARAMETER  listdesc
	The list description.
	.PARAMETER  listtype
	The 
	.PARAMETER scname
	The name of the site collection.
	.NOTES
	Adapted from a script by bigseb.com
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True)]
		[string]$url,
		[Parameter(Mandatory=$True)]
		[string]$listname,
		[Parameter(Mandatory=$True)]
		[string]$listdesc,
		[Parameter(Mandatory=$True)]
		[string]$listtype
		)
	$web = Get-SPWeb $url
	# If you are unsure about available list templates, you can enumerate them quickly using the following script-snip
	# $helperweb = Get-SPWeb <your web here>
	# $helperweb.ListTemplates | Select Name, Description
	$template = $web.ListTemplates[$listtype]
	$web.Lists.Add($name, $description, $template) | Out-Null
	$web.Dispose()
}

Function Add-BulkSPLists {
	<#
	.SYNOPSIS         
 	Creates a list for demo purposes. 
	.PARAMETER  url
	The URL of the web in which to create the list.
	.PARAMETER  namestub
	The name prefix.
	.PARAMETER  descstub
	The description prefix.
	.PARAMETER  type
	The list template type.
	.PARAMETER lists
	The number of lists to create per web.
	.NOTES
	Adapted from a script by bigseb.com
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$True)]
		[string]$url,
		[Parameter(Mandatory=$True)]
		[string]$namestub,
		[Parameter(Mandatory=$True)]
		[string]$descstub,
		[Parameter(Mandatory=$True)]
		[string]$type,
		[Parameter(Mandatory=$True)]
		[int]$lists
		)
	$site = Get-SPSite $url
	# As we're assuming you are bulk adding lists that don't already exist in webs
	# we will use a Try...Catch which is slightly lazy - perhaps as a learning experience
	# you could improve the script to ensure the list does not exist before trying to pound
	# a new one in.
	# Learning is fun, no?
	Try {
		ForEach ($web in $site.AllWebs) {
			$loops = 1
			Do {
				$name = $namestub+$loops
				$description = $descstub+$loops
				Write-Host "INFO: Adding $name to $($web.url)..." -NoNewline -ForegroundColor Yellow -BackgroundColor Black
				# Because we have defined the function Add-SPList 'properly' we can use -erroraction to ensure a terminating error to fire the catch
				Add-SPList -url $web.url -listname $name -listdesc $description -listtype $type -erroraction Stop
				Write-Host "Done!"-ForegroundColor DarkGreen
			}
			While (++$loops -le $lists)
		}
	}
	Catch {
		Write-Host "An error occurred!" -ForegroundColor Red
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
Add-BulkSPLists -url "http://powershell/content/functest06" -namestub "Bibbety Bobb" -descstub "Bibbety Bob Demo List" -type "Custom List" -lists 5