# Create subnet
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-vnet#deployment-scenarios

# Multi-container group
# https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/container-instances/container-instances-multi-container-yaml.md
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-multi-container-group
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-reference-yaml
# https://gist.github.com/lizrice/0a05339473a9e3090184daca2f264344
# https://medium.com/@lizrice/azure-container-instances-with-multiple-containers-512c022c04ec

# Listing azure account names
az account list --output table

# Set account to use specific subscription
az account set --subscription "Microsoft Azure Sponsorship"

# # Create VNET
# az network vnet create \
# --name ACI-VNet \
# --location centralus \
# --resource-group PASS-Marathon \
# --address-prefix 10.10.0.0/16

# # Create Sub-Net in VNet
# az network vnet subnet create \
# --address-prefix 10.10.0.0/24 \
# --name ACI-SubNet \
# --resource-group PASS-Marathon \
# --vnet-name ACI-VNet

# # Create ACI SQL container (AG1)
# az container create \
# --resource-group PASS-Marathon \
# --name aci-ag-01 \
# --image mcr.microsoft.com/mssql/server:2017-CU17-ubuntu \
# --environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=SqLr0ck$ \
# --cpu 2 \
# --memory 2 \
# --port 1433 \
# --vnet ACI-VNet \
# --vnet-address-prefix 10.10.0.0/16 \
# --subnet ACI-SubNet \
# --subnet-address-prefix 10.10.0.0/24

# # Create ACI SQL container (AG2 )
# az container create \
# --resource-group PASS-Marathon \
# --name aci-ag-02 \
# --image mcr.microsoft.com/mssql/server:2017-CU17-ubuntu \
# --environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=SqLr0ck$ \
# --cpu 2 \
# --memory 2 \
# --port 1433 \
# --vnet ACI-VNet \
# --vnet-address-prefix 10.10.0.0/16 \
# --subnet ACI-SubNet \
# --subnet-address-prefix 10.10.0.0/24

# Create resource group
az group create --name PASS-Marathon --location westus

# Deploy container group
az container create --resource-group PASS-Marathon --file aci-group-v5.yml

az container create --resource-group MSSQLTips \
--name serverless-sql-01 \
--image mcr.microsoft.com/mssql/server:2017-CU16-ubuntu \
--environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=SqLr0ck$ \
--dns-name-label serverless-sql-01 \
--cpu 2 \
--memory 2 \
--port 1433

# Check status
az container show --resource-group PASS-Marathon --name AG-RedScale --output table

# Check logs
az container logs --resource-group PASS-Marathon --name AG-RedScale --container-name ag-01
az container logs --resource-group PASS-Marathon --name AG-RedScale --container-name ag-02