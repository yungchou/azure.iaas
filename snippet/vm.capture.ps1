$vmName = '??'
$rgName = '??'
$location = 'southcentralus'
$imageName = "IMG-$vmName"

$method = 1 # capturing using 1: vm, 2: managed disk, 3: non-managed disk
# For method 3 only
$osVhdUri = "https://<storageaccount>.blob.core.windows.net/<container>/<vhdfilename>.vhd"

switch ($method) {
  1 {
    # vm    
    Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force
    Set-AzVm -ResourceGroupName $rgName -Name $vmName -Generalized
    
    $vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName
    $image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.Id

    New-AzImage -Image $image -ImageName $imageName -ResourceGroupName $rgName
  }
  2 {
    # managed disk
    $diskID = $vm.StorageProfile.OsDisk.ManagedDisk.Id

    $imageConfig = New-AzImageConfig -Location $location
    $imageConfig = Set-AzImageOsDisk -Image $imageConfig -OsState Generalized -OsType Windows -ManagedDiskId $diskID

    New-AzImage -ImageName $imageName -ResourceGroupName $rgName -Image $imageConfig
  }
  3 {
    # non-managed disk
    Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force
    Set-AzVm -ResourceGroupName $rgName -Name $vmName -Generalized

    $imageConfig = New-AzImageConfig -Location $location
    $imageConfig = Set-AzImageOsDisk -Image $imageConfig -OsType Windows -OsState Generalized -BlobUri $osVhdUri
    
    $image = New-AzImage -ImageName $imageName -ResourceGroupName $rgName -Image $imageConfig
  }
  Default {
    write-output 'Invalid method'
  }
}

