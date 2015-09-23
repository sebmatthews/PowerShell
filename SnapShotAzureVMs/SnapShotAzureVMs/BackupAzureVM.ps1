
# we've got multiple subscriptions against my account so we want to choose the right one
$subs = Get-AzureSubscription | ?{$_.SubscriptionName -match "Visual"}
Select-AzureSubscription -SubscriptionName $subs.SubscriptionName


#REGION kickassfunctions
Function Start-BackupVirtualMachineDisks {
    Param (
		[Parameter(Mandatory=$True)]
		[string]$vmname,
		[Parameter(Mandatory=$True)]
		[string]$servicename,
		[Parameter(Mandatory=$True)]
		[string]$containername
	)
	
	$disk = Get-AzureVM -Name $vmname -ServiceName $servicename | Get-AzureOSDisk
    $StorageAccountName = $disk.MediaLink.Host.Split(‘.’)[0]

    $context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey ((Get-AzureStorageKey -StorageAccountName $StorageAccountName).Primary)

    if (!(Get-AzureStorageContainer -context $context -Name $containername -ErrorAction SilentlyContinue)) {
	    New-AzureStorageContainer -Context $context -Name $containername -Permission off
    }

    $storeditems = $disk.MediaLink.LocalPath.Split('/')
    $container = $storeditems[1]
    $blobname = $storeditems[2]

    Start-AzureStorageBlobCopy -SrcContainer $container -SrcBlob $blobname -DestContainer $containername -Context $context
    Get-AzureStorageBlobCopyState -Container $container -Blob $blobname -Context $context -WaitForComplete
}
#ENDREGION

# do the work
Start-BackupVirtualMachineDisks -vmname ldnsp02 -servicename ldndc01 -containername vhdbackups