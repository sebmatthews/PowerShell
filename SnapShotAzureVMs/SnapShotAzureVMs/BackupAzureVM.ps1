$subs = Get-AzureSubscription | ?{$_.SubscriptionName -match "Visual"}
Select-AzureSubscription -SubscriptionName $subs.SubscriptionName

$disk = Get-AzureVM -Name ldnsp01 -ServiceName ldndc01 | Get-AzureOSDisk
$StorageAccountName = $disk.MediaLink.Host.Split(‘.’)[0]

$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey ((Get-AzureStorageKey -StorageAccountName bigsebdemos).Primary)

$containername = "vhdtest"

if (!(Get-AzureStorageContainer -context $context -Name $containername -ErrorAction SilentlyContinue)) {
	New-AzureStorageContainer -Context $context -Name $containername -Permission off
}

$storeditems = $disk.MediaLink.LocalPath.Split('/')
$container = $storeditems[1]
$blobname = $storeditems[2]

Start-AzureStorageBlobCopy -SrcContainer $container -SrcBlob $blobname -DestContainer $containername -Context $context
Get-AzureStorageBlobCopyState -Container $container -Blob $blobname -Context $context -WaitForComplete