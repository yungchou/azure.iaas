#NOW=$(date +"%d-%m-%Y")
NOW="%d%m%Y"

rg="da$NOW"
loc='southcentralus'
templateURL='https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/ubuntu-desktop-gnome/azuredeploy.json'

az group create -n "$rg" -l "$loc"

# 
az group deployment create `
--resource-group "$rg" `
--template-uri "templateURL"