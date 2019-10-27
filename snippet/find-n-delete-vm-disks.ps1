<# 
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/find-unattached-disks
#>

# Set deleteUnattachedDisks=1 if you want to delete unattached Managed Disks
# Set deleteUnattachedDisks=0 if you want to see the Id of the unattached Managed Disks
$deleteUnattachedDisks = 0
$managedDisks = Get-AzDisk
foreach ($md in $managedDisks) {
  # ManagedBy property stores the Id of the VM to which Managed Disk is attached to
  # If ManagedBy property is $null then it means that the Managed Disk is not attached to a VM
  if ($md.ManagedBy -eq $null) {
    if ($deleteUnattachedDisks -eq 1) {
      Write-Host "Deleting unattached Managed Disk with Id: $($md.Id)"
      $md | Remove-AzDisk -Force
      Write-Host "Deleted unattached Managed Disk with Id: $($md.Id) "
    }
    else {
      $md.Id
    }
  }
}

# Set deleteUnattachedVHDs=1 if you want to delete unattached VHDs
# Set deleteUnattachedVHDs=0 if you want to see the Uri of the unattached VHDs
$deleteUnattachedVHDs = 0
$storageAccounts = Get-AzStorageAccount
foreach ($storageAccount in $storageAccounts) {
  $storageKey = (Get-AzStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName)[0].Value
  $context = New-AzStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
  $containers = Get-AzStorageContainer -Context $context
  foreach ($container in $containers) {
    $blobs = Get-AzStorageBlob -Container $container.Name -Context $context
    #Fetch all the Page blobs with extension .vhd as only Page blobs can be attached as disk to Azure VMs
    $blobs | Where-Object { $_.BlobType -eq 'PageBlob' -and $_.Name.EndsWith('.vhd') } | ForEach-Object { 
      #If a Page blob is not attached as disk then LeaseStatus will be unlocked
      if ($_.ICloudBlob.Properties.LeaseStatus -eq 'Unlocked') {
        if ($deleteUnattachedVHDs -eq 1) {
          Write-Host "Deleting unattached VHD with Uri: $($_.ICloudBlob.Uri.AbsoluteUri)"
          $_ | Remove-AzStorageBlob -Force
          Write-Host "Deleted unattached VHD with Uri: $($_.ICloudBlob.Uri.AbsoluteUri)"
        }
        else {
          $_.ICloudBlob.Uri.AbsoluteUri
        }
      }
    }
  }
}
