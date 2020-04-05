# DEMO 2_2 - ACI Management (Portal experience)
#
#   1- Monitor ACI
#   2- Check ACI logs
#   3- Stop ACI
#   4- Start ACI
#   5- Delete ACI
# -----------------------------------------------------------------------------

# 0- Env variables | demo path
resource_group=PASS-Marathon;
aci_name=aci-sql-dev01;
cd ~/Documents/$resource_group/Demo_02;
open https://portal.azure.com/#home

# 1- Monitor ACI
Go to Resource group --> aci-sql-dev-01 --> Overview
# Azure CLI reference
az container show --resource-group $resource_group --name $aci_name --query "{Status:instanceView.state}" --out table

# 2- Check ACI logs
Go to Resource group --> aci-sql-dev-01 --> Containers --> Logs
# Azure CLI reference
az container logs  --resource-group $resource_group --name $aci_name --follow

# 3- Stop ACI
Go to Resource group --> aci-sql-dev-01 --> Overview --> Stop
# Azure CLI reference
az container stop --name $aci_name --resource-group $resource_group

# 4- Start ACI
Go to Resource group --> aci-sql-dev-01 --> Overview --> Start
# Azure CLI reference
az container start --name $aci_name --resource-group $resource_group

# 5- Delete ACI
Go to Resource group --> aci-sql-dev-01 --> Overview --> Delete
# Azure CLI reference
az container delete --name $aci_name --resource-group $resource_group