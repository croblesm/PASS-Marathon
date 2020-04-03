# Azure file share
# Change these four parameters as needed
ACI_PERS_RESOURCE_GROUP=PASS-Marathon
ACI_PERS_STORAGE_ACCOUNT_NAME=acivolumes
ACI_PERS_LOCATION=westus
ACI_PERS_SHARE_NAME=acishare

# Create the storage account with the parameters
az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS

# Create the file share
az storage share create \
  --name $ACI_PERS_SHARE_NAME \
  --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME

echo $ACI_PERS_STORAGE_ACCOUNT_NAME

STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
echo $STORAGE_KEY

az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name aci-voltest \
    --image mcr.microsoft.com/mssql/server:2017-CU16-ubuntu \
    --environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=SqLr0ck$ \
    --dns-name-label aci-voltest \
    --cpu 2 \
    --memory 2 \
    --port 1433 \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /Shared

az container show --resource-group $ACI_PERS_RESOURCE_GROUP \
--name aci-voltest --query ipAddress.fqdn --output tsv

az container exec --resource-group $ACI_PERS_RESOURCE_GROUP --name aci-voltest --exec-command "/bin/bash"
az container exec --resource-group $ACI_PERS_RESOURCE_GROUP --name aci-voltest --exec-command "ls /Shared"

echo "export PS1=""[dbamaster] """ >> ~/.bashrc

/opt/mssql-tools/bin/sqlcmd -U SA -P $MSSQL_SA_PASSWORD -d master -i /Shared/LeTest/MyScript.sql

ENV SQLCMDPASSWORD=${SA_PASSWORD}