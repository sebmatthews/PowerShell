
Function New-RandomlyCreatedWordDocuments {
	Param (
		[Parameter(Mandatory=$True)]
		[string]$seedfile,
		[Parameter(Mandatory=$True)]
		[string]$seednames,
		[Parameter(Mandatory=$True)]
		[int]$documentstocreate,
		[Parameter(Mandatory=$True)]
		[string]$outputpath
	)
	
	# let's spin the variables
	$textarray = Get-Content $seedfile -Delimiter "`t"
	$count = New-Object system.Random
	$loops = 0
	$rand = new-object System.Random
	$words = import-csv $seednames
	# i dont like wiring values into variables, but this way is simpler in the context of this script
	$conjunction = "to budget for","to keep","and","with","without","in","for","to remove the"

	# create the Word COM object
	# Microsoft Word must be installed on the machine this script is run upon
	# original inspiration came from http://www.petri.co.il/generate-microsoft-word-document-powershell.htm# #kudos

	$word=new-object -ComObject "Word.Application"

	do {
		# spin up a new document
		$doc = $word.documents.Add()
		$selection = $word.Selection

		# insert some random text
		$paraloop = 1
		$paragraphs = $count.Next(50) 
		do {
			$randomiser = $count.Next($textarray.Count)
			$selection.TypeText($textarray.get_Item($randomiser))
			$paraloop++
		}
		while ($paraloop -lt $paragraphs)
		$selection.TypeParagraph()

		# save the document with a great filename
		# this is from hanselman
		# http://www.hanselman.com/blog/DictionaryPasswordGeneratorInPowershell.aspx
		$word1 = ($words[$count.Next(0,$words.Count)]).Label
		$con = ($conjunction[$rand.Next($conjunction.Count)])
		$word2 = ($words[$count.Next(0,$words.Count)]).Label
		# end of the hanselman bit
		$documentname = $word1+" "+$con+" "+$word2+".docx"
		$doc.SaveAs([ref]($outputpath+$documentname))    
		$doc.Close()
		Write-Host "Generated document number"($loops+1)
		$loops++
	}
	until ($loops -eq $documentstocreate)

	#exit word
	$word.quit()
}

Clear-Host
# clearly you need to change the filepaths!
New-RandomlyCreatedWordDocuments -seedfile "<path>\para.txt" -seednames "<path>\subjects.csv" -documentstocreate 50 -outputpath "<path>\"