Function Export-VisioShapesFromStencils {
	Param (
		[Parameter(Mandatory=$True)]
		[string]$stencilsource,
		[Parameter(Mandatory=$True)]
		[string]$outputpath
	)
	# fire up the visio com object and hide it from the UI
	$visio = New-Object -ComObject Visio.Application
	$visio.Visible = $false
	# of course, use a try-catch-finally, especially as we have a com object that we want to ensure is disposed regardless of function outcome
	Try {
		$stencil = $visio.Documents.Add($stencilsource)
		# loop through the stencil shapes
		foreach ($icon in $stencil.Masters) {
			# loop through the shape collection
			foreach ($shape in $icon.Shapes) {
				# the mucking about below is to remove CR and LF characters that are sometimes in the names plus to add an index to shapes that may contain 
				# more than one vector per shape in the stencil (such as those with vectored images and text stored separately)
				$filename = $outputfolder + (($icon.Name).Trim().Replace("`r","").Replace("`n","")) + ($($shape.Index).ToString()) + ".svg"
				# we're using write-host so we can format it simply as this script is UI interactive
				Write-Host "INFO: Exporting $($icon.name)..." -NoNewline -ForegroundColor Yellow
				$shape.Export($filename)
				Write-Host "SUCCESS!" -ForegroundColor DarkGreen
			}
		}
	}
	Catch {
		# handle the exception (well, sort of...)
		Write-Output "Something unexpected has interrupted the script!"
	}
	Finally {
		# dispose of that leaky com object
		$visio.Quit()
	}
}

# plumb in relevant values
$outputfolder = "D:\visio\exports\"
$inputstencil = "D:\visio\stencils\export this stencil.vss"

# call the function
Export-VisioShapesFromStencils -stencilsource $inputstencil -outputpath $outputfolder