# List out disks of a storage account continer

$RGName = 'thisRG'
$SAName = 'thiStorageAccount'
$ConName = 'vhds'

$TempObj = New-Object -TypeName PSCustomObject
$TempObj |Add-Member -Name BlobName -MemberType NoteProperty -Value $null
$TempObj |Add-Member -Name LeaseState -MemberType NoteProperty -Value $null
$Keylist = Get-AzureRmStorageAccountKey -ResourceGroupName $RGName -StorageAccountName $SAName
$Key = $Keylist[0].Value
$Ctx = New-AzureStorageContext -StorageAccountName $SAName -StorageAccountKey $Key
$List = Get-AzureStorageBlob -Blob *.vhd -Container $ConName -Context $Ctx
$List | ForEach-Object { $TempObj.BlobName = $_.Name
$TempObj.LeaseState = $_.ICloudBlob.Properties.LeaseState; $TempObj }