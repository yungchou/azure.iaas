$rgName = '??'
$rgNameVault = '??'
$vmName = '??'
$aadClientID = '??'
$aadClientSecret = '??'
$KeyVaultName = '??'

$KeyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $rgNameVault $diskEncryptionKeyVaultUrl = $KeyVault.VaultUri
$KeyVaultResourceId = $KeyVault.ResourceId

Set-AzureRmKeyVaultAccessPolicy `
  -VaultName $KeyVaultName `
  -ServicePrincipalName $aadClientID `
  -PermissionsToKeys all `
  -PermissionsToSecrets all `
  -ResourceGroupName $rgnamevault

Set-AzureRmKeyVaultAccessPolicy `
  -VaultName $KeyVaultName `
  -ResourceGroupName $rgnamevault `
  –EnabledForDiskEncryption 
  
# Create a KEK 
Add-Azurekeyvaultkey -VaultName $KeyVaultName -Name 'KEK' -Destination Software 

# To get the KEKUrl 
Get-AzureKeyVaultKey -VaultName $KeyVaultName -Name "KEK" 

# For Windows VM with KEK 
Set-AzureRmVMDiskEncryptionExtension `
  -ResourceGroupName $rgName `
  -VMName $vmName `
  -AadClientID $aadClientID `
  -AadClientSecret $aadClientSecret `
  -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `
  -DiskEncryptionKeyVaultId $KeyVaultResourceId `
  -KeyEncryptionKeyVaultId $KeyVaultResourceId `
  -KeyEncryptionKeyUrl 'https://keyvaultname.vault.azure.net/keys/KEK/1xxxx' 

#For Windows VM Without KEK 
Set-AzureRmVMDiskEncryptionExtension `
  -ResourceGroupName $rgName `
  -VMName $vmName `
  -AadClientID $aadClientID `
  -AadClientSecret $aadClientSecret `
  -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl `
  -DiskEncryptionKeyVaultId $KeyVaultResourceId `
  -VolumeType All 
  
<# 
  Azure Disk Encryption – Convert BEK Disk Encryption to KEK for Azure Recovery Services
  https://blogs.msdn.microsoft.com/mast/2016/11/28/azure-disk-encryption-how-to-encrypt-azure-resource-manager-iaas-vm-using-kek/

  Azure Disk Encryption – How to recover BEK file from Azure Key Vault
  https://blogs.msdn.microsoft.com/mast/2016/11/27/azure-disk-encryption-how-to-recover-bek-file-from-azure-key-vault/ 
  
  Restore Key Vault key and secret for encrypted VMs using Azure Backup
  https://docs.microsoft.com/en-us/azure/backup/backup-azure-restore-key-secret
#>