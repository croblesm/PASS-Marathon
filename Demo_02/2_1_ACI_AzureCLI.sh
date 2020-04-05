# DEMO 2_1 - ACI Container (Azure CLI)
#
#   1- Create ACI
#   2- Check ACI logs
#   3- Check ACI properties
# -----------------------------------------------------------------------------
# References:
#   Query Azure CLI command output
#   open https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest
#
#   Azure CLI - ACR commands reference
#   open https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest

# 0- Env variables | demo path
resource_group=PASS-Marathon;
aci_name=aci-sql-dev01;
cd ~/Documents/$resource_group/Demo_02;

# 1- Create ACI
az container create \
    --resource-group $resource_group \
    --name $aci_name \
    --image mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04 \
    --environment-variables ACCEPT_EULA=Y SA_PASSWORD=_SqLr0ck5_ \
    --dns-name-label $aci_name \
    --cpu 4  --memory 4 \
    --port 1433

# 2- Check ACI logs
az container logs  --resource-group $resource_group --name $aci_name --follow

# 3- Check ACI properties
az container list --resource-group $resource_group -o table
az container list --resource-group $resource_group --query "sort_by([].{Name:name,FQDN:ipAddress.fqdn,IP:ipAddress.ip,Port:ipAddress.ports[].port,Status:provisioningState}, &Name)" -o json