
# we've got multiple subscriptions against my account so we want to choose the right one
$subs = Get-AzureSubscription | ?{$_.SubscriptionName -match "Visual"}
Select-AzureSubscription -SubscriptionName $subs.SubscriptionName


#REGION kickassfunctions
Function Start-RestoreVirtualMachineDisk {
    Param (
		[Parameter(Mandatory=$True)]
		[string]$vmname,
		[Parameter(Mandatory=$True)]
		[string]$servicename,
		[Parameter(Mandatory=$True)]
		[string]$containername,
		[Parameter(Mandatory=$True)]
		[string]$exportlocation
	)
	
	# note that this function assumes Windows OS

	# do some pre-flight checks
	If ((Get-AzureVM -Name $vmname -ServiceName $servicename).Status -ne "StoppedVM") {
		Write-Output "The VM $vmname is not in a stopped state, please change it's state.  Exiting."
		Break;
	}
	
	If (!(Test-Path -Path $exportlocation)) {
		New-Item -Path $exportlocation -ItemType Directory
	}

	# we need to capture the vm object data to use in the future
	$vmachine = Get-AzureVM -Name $vmname -ServiceName $servicename
	# we need to capture the disk object to use in the future
	$disk = Get-AzureVM -Name $vmname -ServiceName $servicename | Get-AzureOSDisk
	# Hey happy reader. In the line above, the cmdlet 'Get-AzureDataDisk' could be used to return a collection of data disks if needed
	# You could use this collection if you needed to restore a bunch of data disks also
	# But guess what?  I'll let you figure that out or you'll never learn nuffink...
    
	$StorageAccountName = $disk.MediaLink.Host.Split(‘.’)[0]
	$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey ((Get-AzureStorageKey -StorageAccountName $StorageAccountName).Primary)
	$storeditems = $disk.MediaLink.LocalPath.Split('/')
    $container = $storeditems[1]
    $blobname = $storeditems[2]
	$exportfile = $exportlocation+"\"+$vmachine.Name+".xml"

	# dump the VM config to disk, we'll put this in a Try...Catch as we NEED it to work
	Try {
		Export-AzureVM -Name $vmname -ServiceName $servicename -Path $exportfile -ErrorAction Stop
		$vmexported = $True
	}
	Catch {
		Write-Output "Config export of $vmname failed.  Exiting."
		Break;
	}

	# Now we can remove the VM and wait for the disk to be deallocated
	Write-Output "Removing Virtual Machine $vmname"
	Remove-AzureVM -Name $vmname -ServiceName $servicename
	Write-Host "Deallocating disk..." -NoNewline
	While ((Get-AzureDisk -DiskName ($disk.DiskName)).AttachedTo) {
		Start-Sleep 3
		Write-Host "." -NoNewline
	}
	Write-Host
	Write-Output "Removing deallocated disk"
	Remove-AzureDisk -DiskName $disk.DiskName -DeleteVHD
	
	# Now we can restore the OS disk
	Write-Output "Restoring OS disk to VHD container"
	Start-AzureStorageBlobCopy -SrcContainer $containername -SrcBlob $blobname -DestContainer $container -Context $context -Force
	Get-AzureStorageBlobCopyState -Container $container -Blob $blobname -Context $context -WaitForComplete
	Add-AzureDisk -DiskName $disk.DiskName -MediaLocation $disk.MediaLink.AbsoluteUri -OS Windows

	# Now lets re-provision the VM
	Import-AzureVM -Path $exportfile | New-AzureVM -ServiceName $vmachine.ServiceName -VNetName $vmachine.VirtualNetworkName

}
#ENDREGION

# do the work
Start-RestoreVirtualMachineDisk -vmname testvm -servicename ldndc01 -containername vhdbackups -exportlocation "d:\azure\vmconfigs"