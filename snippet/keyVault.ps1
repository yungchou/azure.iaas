$rgName = 'dnd-vm'
$location = 'southcentralus'

#$keyVaultName = "myKeyVault$(Get-Random)"
$keyVaultName = "$rgName-kv"

Register-AzResourceProvider -ProviderNamespace "Microsoft.KeyVault"
New-AzResourceGroup -Location $location -Name $rgName

New-AzKeyVault `
    -Confirm `
    -Verbose `
    -Location $location `
    -ResourceGroupName $rgName `
    -VaultName $keyVaultName `
    -EnabledForDeployment `
    -EnabledForTemplateDeployment `
    -EnabledForDiskEncryption `
    -EnableSoftDelete `
    -EnablePurgeProtection `
    -Tag @{key0="value0";key1=$null;key2="value2"}

Add-AzKeyVaultKey -VaultName $keyVaultName `
    -Name "$rgName-Key" `
    -Destination "Software"  # HSM