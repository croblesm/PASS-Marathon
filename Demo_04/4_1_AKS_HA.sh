# DEMO 6 - Azure Kubernetes services (AKS) - HA
#   1- Get pods
#   2- Get public IP of SQL Server service
#   3- Simulate failure
#   4- Connect to SQL Server
#   5- Show Kubernetes dashboard
# -----------------------------------------------------------------------------

# 0- Environment variables | demo path
resource_group=PASS-Marathon;
aks_cluster=endurance;
namespace_simple=plex-sql;
namespace_complex=tars-sql;
acr_name=dbamastery;
sa_password="_EnDur@nc3_";
cd ~/Documents/$resource_group/Demo_04;

# 1- Connect to Kubernetes cluster in AKS
az aks get-credentials --resource-group $resource_group --name $aks_cluster
kubectl config set-context $aks_cluster
kubectl config set-context --current --namespace=$namespace_simple
kubectl config get-contexts

# 2- Get nodes, pods, services, namespaces
kubectl get namespaces
kubectl get nodes
kubectl get all
kubectl get pods
kubectl get services

# 3- Check PVC - Matching AZ disk with AKS-PVC
kubectl describe pvc pvc-data-plex

# Filter by Volume
kubectl describe pvc pvc-data-plex | grep "Volume:" #  ➡️ Match it with AKS-PVC
# Go to the portal --> All resources --> Look for PVC disk

# 5- Check pod events
MyPod=`kubectl get pods | grep mssql-plex | awk {'print $1'}`
kubectl describe pods $MyPod

# 6- Check pod logs
kubectl logs $MyPod -f

# 7- Show Kubernetes dashboard
az aks browse --resource-group $resource_group --name $aks_cluster

# 8- Get public IP of SQL Server service
kubectl get service mssql-plex
MyService=`kubectl get service mssql-plex | grep mssql-plex | awk {'print $4'}`

# 10- Connect to SQL Server to create new database
clear & sqlcmd -S $MyService -U SA -P $sa_password -i "4_2_CreateDatabase.sql"

# 3- Simulate failure
./4_3_SimulateFailure.sh

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 7- Get SQL Server instance properties
# 8- Explore database objects

# 4- Connect to SQL Server
clear & sqlcmd -S $MyService -U SA -P $sa_password -Q "select @@servername;"
clear & sqlcmd -S $MyService -U SA -P $sa_password -Q "select @@version;"

# 5- Show Kubernetes dashboard
az aks browse --resource-group $resource_group --name $aks_cluster