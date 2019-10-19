# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/encrypt-disks#encrypt-a-virtual-machine

## Connect-AzAccount

$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $rgName;
$diskEncryptionKeyVaultUrl = $keyVault.VaultUri;
$keyVaultResourceId = $keyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzKeyVaultKey -VaultName $keyVaultName -Name myKey).Key.kid;

$vmName='encrypted'

Set-AzVMDiskEncryptionExtension -ResourceGroupName $rgName `
    -VMName $vmName `
    -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `
    -DiskEncryptionKeyVaultId $keyVaultResourceId `
    -KeyEncryptionKeyUrl $keyEncryptionKeyUrl `
    -KeyEncryptionKeyVaultId $keyVaultResourceId

Set-AzVMDiskEncryptionExtension `
    -ResourceGroupName $rgName `
    -VMName $vmName `
    -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri `
    -DiskEncryptionKeyVaultId $KeyVault.ResourceId


Get-AzVmDiskEncryptionStatus  -ResourceGroupName $rgName -VMName "myVM"

