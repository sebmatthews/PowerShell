
# we've got multiple subscriptions against my account so we want to choose the right one
$subs = Get-AzureSubscription | ?{$_.SubscriptionName -match "Visual"}
Select-AzureSubscription -SubscriptionName $subs.SubscriptionName


#REGION kickassfunctions
Function Start-BackupVirtualMachineDisk {
    Param (
		[Parameter(Mandatory=$True)]
		[string]$vmname,
		[Parameter(Mandatory=$True)]
		[string]$servicename,
		[Parameter(Mandatory=$True)]
		[string]$containername
	)
	
	$disk = Get-AzureVM -Name $vmname -ServiceName $servicename | Get-AzureOSDisk
    # Hey happy reader. In the line above, the cmdlet 'Get-AzureDataDisk' could be used to return a collection of data disks if needed
	# You could use this collection if you needed to restore a bunch of data disks also.
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
Start-BackupVirtualMachineDisk -vmname testvm -servicename service -containername vhdbackups