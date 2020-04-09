# DEMO 2 - ACI Container (Azure CLI)
# Part 1 - Azure CLI experience
#
#   1- Create SQL container in ACI
#   2- Check SQL Container logs
#   3- Check SQL Container properties
#   4- Connect to SQL Server container in ACI (Azure Data Studio)
#   5- Show SQL instance dashboard (Azure Data Studio - Optional)
#   6- Basic container lifecycle management (Optional)
#       # Stop, start, delete
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

# 1- Create SQL Server container in ACI
az container create \
    --resource-group $resource_group \
    --name $aci_name \
    --image mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04 \
    --environment-variables ACCEPT_EULA=Y SA_PASSWORD=_SqLr0ck5_ \
    --dns-name-label $aci_name \
    --cpu 4  --memory 4 \
    --port 1433

# 2- Check SQL Container logs
az container logs  --resource-group $resource_group --name $aci_name --follow

# 3- Check SQL Container properties
# Listing all containers in my ACI group
az container list --resource-group $resource_group -o table

# Listing specific container properties
az container show --resource-group $resource_group --name $aci_name
az container show --resource-group $resource_group --name $aci_name "{IP_Adress:ipAddress.ip,FQDN:ipAddress.fqdn}" --out table
az container list --resource-group $resource_group --query "sort_by([].{Name:name,FQDN:ipAddress.fqdn,IP:ipAddress.ip,Port:ipAddress.ports[].port,Status:provisioningState}, &Name)" -o json

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 4- Connect to SQL Server container in ACI
# 5- Show SQL instance dashboard

# 6- Basic container lifecycle management (Optional)
# Stop container
az container stop --name $aci_name --resource-group $resource_group

# Start container
az container start --name $aci_name --resource-group $resource_group

# Delete container
az container delete --name $aci_name --resource-group $resource_group