# DEMO 5 - Azure Kubernetes services (AKS) - Upgrade
#   0- Pre-requisites
#   1- Connect to Kubernetes cluster in AKS
#   2- Get nodes, pods, services, namespaces
#   3- Check PVC - Matching AK disk with PVC
#   4- Describe deployment
#   5- Check pod events
#   6- Check pod logs
#   7- Show Kubernetes dashboard
#   8- Get public IP of SQL Server service
#   9- Connect to SQL Server
#   10- Connect to SQL Server to create new database
#   12- Upgrade SQL Server (pod image)
#   12- Check rolling upgrade status
#   13- Check rollout history
#   14- Check databases
#
#   Kubernetes cheat sheet:
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
# -----------------------------------------------------------------------------

# 0- Environment variables | demo path
resource_group=PASS-Marathon;
aks_cluster=endurance
acr_name=dbamastery;
sa_password="_EnDur@nc3_"
cd ~/Documents/$resource_group/Demo_04;

# 1- Connect to Kubernetes cluster in AKS
az aks get-credentials --resource-group $resource_group --name $aks_cluster
kubectl config set-context $aks_cluster
kubectl config set-context --current --namespace=plex-sql
kubectl config get-contexts

# 2- Get nodes, pods, services, namespaces
kubectl get nodes
kubectl get namespaces
kubectl get all
kubectl get pods
kubectl get services

# 3- Check PVC - Matching AZ disk with AKS-PVC
kubectl describe pvc pvc-data-plex

# Filter by Volume
kubectl describe pvc pvc-data-plex | grep "Volume:" #  ➡️ Match it with AKS-PVC
# Go to the portal --> All resources --> Look for PVC disk

# 4- Describe deployment
kubectl describe deployment mssql-plex

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

# 9- Connect to SQL Server
clear & sqlcmd -S $MyService -U SA -P $sa_password -Q "select @@servername;"
clear & sqlcmd -S $MyService -U SA -P $sa_password -Q "select @@version;"

# 10- Connect to SQL Server to create new database
clear & sqlcmd -S $MyService -U SA -P $sa_password -i "5_3_CreateDatabase.sql"

# 11- Upgrade SQL Server (pod image)
kubectl --record deployment set image mssql-plex mssql=mcr.microsoft.com/mssql/server:2017-CU16-ubuntu

# 12- Check rolling upgrade status
# In terminal 1
kubectl rollout status -w deployment mssql-plex

# In terminal 2
kubectl get pods
NewPod=`kubectl get pods | grep mssql-plex | awk {'print $1'}`
kubectl describe pods $NewPod
kubectl logs $NewPod -f

# 13- Check rollout history
kubectl rollout history deployment mssql-deployment

# 14- Check databases
clear & sqlcmd -S $MyService -U SA -P $sa_password \
-Q "SET NOCOUNT ON;SELECT name FROM sys.databases; \
PRINT''; \
SELECT CONVERT(CHAR,serverproperty('ProductUpdateLevel')) as "CU";"