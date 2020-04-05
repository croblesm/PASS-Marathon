# DEMO 2_1 - ACI Container (Azure CLI)
#
#   1- Connect to ACI bash console
#   2- Check ACI logs
#   3- Check ACI properties
#   4- Connect to ACI console
#   5- Connect to ACI with Azure Data Studio
# -----------------------------------------------------------------------------
# References:
#   Mount an Azure file share in Azure Container Instances
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files

# 0- Env variables | demo path
resource_group=PASS-Marathon
storage_account_name=acivolumes
location=westus
file_share_name=aci-fileshare
aci_name=aci-sql-dev02;
cd ~/Documents/$resource_group/Demo_03;

# Check ACI status
az container show \
    --resource-group $resource_group \
    --name $aci_name -o table

# 2- Connect to ACI bash console
az container exec --resource-group $resource_group --name $aci_name --exec-command "/bin/bash"

# 3- Listing folders and files

# Creating temp bash profile
# echo "export PS1=\"[dba mastery@ACI] $ \"" > /tmp/sql/.bashrc
# echo "export SQLCMDPASSWORD=_SqLr0ck5_" >> /tmp/sql/.bashrc
# echo "export PATH=\$PATH:/opt/mssql-tools/bin" >> /tmp/sql/.bashrc
source /tmp/sql/.bashrc

# Check folders and files
ls -ll /SQLFiles/SQLScripts

# --------------------------------------
# Azure Storage Explorer step
# --------------------------------------
# 5- Explore ACI - file share with Azure Storage Explorer
# 6- Copy SQL scripts

# 7- Deploy SQL script
sqlcmd -U SA -d master -i /SQLFiles/SQLScripts/1-Create_HumanResources_DB.sql

# Listing existing databases
sqlcmd -U SA -d master -Q "select name from sys.databases"

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 7- Get SQL Server instance properties
# 8- Explore database objects