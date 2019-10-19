# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/encrypt-disks#create-a-virtual-machine

$cred = Get-Credential

New-AzVm `
    -ResourceGroupName $rgName `
    -Name "myVM" `
    -Location $location `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -Credential $cred

