# DEMO 2_1 - ACI Container (Azure CLI)
#
#   1- Create ACI
#   2- Check ACI logs
#   3- Check ACI properties
#   4- Connect to ACI console
#   5- Connect to ACI using Azure Data Studio
# -----------------------------------------------------------------------------
# References:
#   Query Azure CLI command output
#   open https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest

# https://markheath.net/post/build-container-images-with-acr
# https://adamtheautomator.com/azure-container-instance-windows/

# 0- Env variables | demo path
resource_group=PASS-Marathon;
cd ~/Documents/$resource_group/Demo_02;

# 1- Create ACI (Azure CLI)
open https://portal.azure.com

az container create \
--resource-group $resource_group \
--name aci-sql-dev01 \
--image mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04 \
--environment-variables ACCEPT_EULA=Y MSSQL_SA_PASSWORD=_SqLr0ck5_ \
--dns-name-label aci-sql-dev01 \
--cpu 4  --memory 4 \
--port 1433

# 2- Check ACI logs
az container logs  --resource-group $resource_group --name aci-sql-dev01 --follow

# 3- Check ACI properties
az container list --resource-group $resource_group -o table
az container list --resource-group $resource_group --query "sort_by([].{Name:name,FQDN:ipAddress.fqdn,IP:ipAddress.ip,Port:ipAddress.ports[].port,Status:provisioningState}, &Name)" -o json

# 4- Connect to ACI console
az container exec --resource-group $resource_group --name aci-sql-dev01 --exec-command "/bin/bash"

# 5- Connect to ACI using Azure Data Studio