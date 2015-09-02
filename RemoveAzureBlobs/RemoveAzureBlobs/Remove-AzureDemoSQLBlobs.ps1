Function Remove-AzureDemoSQLBlobs {
	<#
	   .SYNOPSIS
	    This function takes a collection of Azure storage blob objects and deletes them pemanently
	   .DESCRIPTION
		We're using the pscmdlet.shouldprocess method to give us a confirm dialogue.
		It's totally unecessary but I do like it.
		In order to use the $pscmdlet method on row 23 we need to include the cmdletbinding and a param blocks so we can bring
		these common parameters into play as part of a cmdlet like advanced function.
		It's not lost on me that this is a whole lot of function wrapper for a tiny bit of action, but hey-ho - it's
		all about the sharing, right?
	   .EXAMPLE
	   	Remove-AzureDemoSQLBlobs -confirm
	   .PARAMETER confirm
	   	Using -confirm will envoke the confirmation dialogue
		.PARAMTER whatif
		Using -whatif will inform the operator what will occur without performing any actual activity
	   .NOTES
	    NAME: Remove-AzureDemoSQLBlobs
	    AUTHOR: Seb Matthews @sebmatthews #bigseb
	    DATE: September 2015
	   .LINK
	    http://sebmatthews.net
	#>
	[cmdletbinding(SupportsShouldProcess=$true)]
	Param ()
	If ($pscmdlet.shouldprocess($($activecontainer))) {        
		# piping the $blobs collection direct to the remove cmdlet is a little inelegant but efficient
		$blobs | Remove-AzureStorageBlob                                                                                       
	}
}
# let's setup our azure connection and context
# please don't forget you will need the following:
# 1) a valid and imported Azure Publish Settings file
# 2) valid credentials
# 3) the Azure module imported
# here we define which Azure subscription we want to use
$subscription = "YOUR SUBS NAME"  
Select-AzureSubscription -SubscriptionName $subscription                            
# define our connection to the storage account
$storagename = "YOUR STORAGE ACC NAME"
# this cmdlet means we don't have to pass the key in, we can 'get it out'
$storagekey = Get-AzureStorageKey -StorageAccountName $storagename                                                      
$primarykey = $storagekey.Primary                                                                                   
# now we create our context for the storage account and 'connect' to it
$azcontext = New-AzureStorageContext -StorageAccountName $storagename -StorageAccountKey $primarykey                    
# next we 'connect' to the container we want to empty of blobs
$activecontainer = "YOUR CONTAINER NAME"
$blobs = (Get-AzureStorageContainer -Context $azcontext) | ?{$_.Name -eq $activecontainer}                            

# do the work
# whatif mode
Remove-AzureDemoSQLBlobs -whatif
# live mode
Remove-AzureDemoSQLBlobs -confirm