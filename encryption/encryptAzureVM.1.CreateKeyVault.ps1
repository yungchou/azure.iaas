# MS Doc https://docs.microsoft.com/en-us/azure/virtual-machines/windows/encrypt-disks#create-an-azure-key-vault-and-keys

# Connect-AzAccount
# Login-AzAccount

$rgName = "daADE"
$location = "southcentralus"

Register-AzResourceProvider -ProviderNamespace "Microsoft.KeyVault"
New-AzResourceGroup -Location $location -Name $rgName

#$keyVaultName = "myKeyVault$(Get-Random)"
#$keyVaultName = "$($rgName)KeyVault"
$keyVaultName = "$rgName"

New-AzKeyVault `
    -Location $location `
    -ResourceGroupName $rgName `
    -VaultName $keyVaultName `
    -EnabledForDiskEncryption
<#
WARNING: Access policy is not set. No user or application have access permission to use this va
ult. This can happen if the vault was created by a service principal. Please use Set-AzKeyVault
AccessPolicy to set access policies.
#>

# Enable secrets to be retrieved from a key vault 
# by the Microsoft.Compute resource provider
Set-AzKeyVaultAccessPolicy `
    -VaultName $keyVaultName `
    -ResourceGroupName $rgName `
    -EnabledForDiskEncryption

#    -EnabledForTemplateDeployment
#    -EnabledForDeployment


$UserPrincipalName='abc@yc9.onmicrosoft.com'
Set-AzKeyVaultAccessPolicy `
    -VaultName $keyVaultName `
    -UserPrincipalName $UserPrincipalName ` 
    -PermissionsToKeys create,import,delete,list `
    -PermissionsToSecrets set,delete `
    -PassThru

#-ServicePrincipalName 'http://payroll.contoso.com'`
    
Add-AzKeyVaultKey `
    -VaultName $keyVaultName `
    -Name "$($rgName)Key" `
    -Destination "Software"

Add-AzKeyVaultKey `
    -VaultName $keyVaultName `
    -Name "myKey" `
    -Destination "Software"

$KeyOperations = 'decrypt', 'verify'
$Expires = (Get-Date).AddYears(2).ToUniversalTime()
$NotBefore = (Get-Date).ToUniversalTime()
$Tags = @{'Severity' = 'high'; 'Accounting' = "true"}
Add-AzKeyVaultKey `
    -VaultName 'contoso' `
    -Name 'ITHsmNonDefault' `
    -Destination 'HSM' 
    `-Expires $Expires 
    `-NotBefore $NotBefore `
    -KeyOps $KeyOperations `
    -Disable 
    `-Tag $Tags



# Secret https://docs.microsoft.com/en-us/azure/key-vault/quick-create-powershell

$secretvalue = ConvertTo-SecureString 'hVFkk965BuUv' -AsPlainText -Force
$secret = `
Set-AzKeyVaultSecret `
    -VaultName 'ContosoKeyVault' `
    -Name 'ExamplePassword' `
    -SecretValue $secretvalue

(Get-AzKeyVaultSecret `
    -vaultName "Contosokeyvault" `
    -name "ExamplePassword").SecretValueText


Remove-AzResourceGroup -Name $rgName