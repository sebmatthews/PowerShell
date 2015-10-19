Function Start-ListInstalledKBs {
	$updateobject = New-Object -comobject “Microsoft.Update.Searcher”
	$allupdates = $updateobject.QueryHistory(0,$updateobject.GetTotalHistoryCount())
	$KBoutput = @()
	$Regexpattern = “KB\d*”
	Foreach ($update in $allupdates) {
	    $KBname = $update.Title
	    $KBid = $KBname | Select-String -Pattern $Regexpattern
		$KBoutput += New-Object PSObject -Property @{
		   	Title = $KBname
			KB = $KBid.Matches.Value
		}
	}
	($KBoutput | Sort-Object KB) | Export-Csv $ENV:USERPROFILE"\desktop\installedKBs.csv" -NoTypeInformation
}

Start-ListInstalledKBs
