# https://markheath.net/post/build-container-images-with-acr
# https://adamtheautomator.com/azure-container-instance-windows/

acrName=dbamastery
resourceGroup=PASS-Marathon
password=`az acr credential show -n $acrName --query "passwords[0].value"  -o tsv`

# create a new ACI instance to run this container
az container create \
--resource-group $resourceGroup \
--name mssql-tools-aci2 \
--image $acrName.azurecr.io/mssql-tools:1.4 \
--registry-username $acrName --registry-password $password \
--dns-name-label serverless-sql-02 \
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