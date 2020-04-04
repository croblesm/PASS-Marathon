# DEMO 2 - ACI Container
#
#   1- Create Azure resource group
#   2- Create Azure Container Registry
#   3- List ACR registry
#   4- Build a local image
#   5- Tag and push image to ACR
#   6- Build and push from Azure Cloud shell
#   7- List images in ACR repository
# -----------------------------------------------------------------------------
# References:
#   Azure Container Registry authentication with service principals
#   open https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal

# https://markheath.net/post/build-container-images-with-acr
# https://adamtheautomator.com/azure-container-instance-windows/

resource_group=PASS-Marathon;
acr_name=dbamastery;
acr_repo=mssqltools-alpine;
password=`az acr credential show -n $acr_name --query "passwords[0].value"  -o tsv`;
cd ~/Documents/$resource_group/Demo_02;
#az acr login --name $acr_name;

# create a new ACI instance to run this container
az container create \
--resource-group $resource_group \
--name mssql-tools-aci \
--image $acr_name.azurecr.io/$acr_repo:2.1 \
--registry-username $acr_name --registry-password $password \
--dns-name-label mssql-tools-aci \
--cpu 2 --memory 2 \
--port 1433

az container show --resource-group PASS-Marathon --name mssql-tools-aci2

az container exec -resource-group PASS-Marathon \
--name mssql-tools-aci2 \
--container-name mssql-tools-aci2 \
--exec-command "/bin/bash"

az container exec --resource-group PASS-Marathon --name mssql-tools-aci1 --exec-command "/bin/bash"

az container logs --name mssql-tools-aci2 --resource-group PASS-Marathon --follow

az container create \
--resource-group PASS-Marathon \
--name aci-dev-01
--image mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04 \
--environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=SqLr0ck$ \
--dns-name-label serverless-sql-01 \
--cpu 4  --memory 4 \
--port 1433