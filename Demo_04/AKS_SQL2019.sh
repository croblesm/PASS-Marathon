kubectl create namespace plex-sql
kubectl config set-context --current --namespace=plex-sql
kubectl config get-contexts
kubectl create secret generic plex-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-plex.yml
kubectl apply -f ./services/srvc-sql-plex.yml
kubectl apply -f ./deployments/depl-sql-plex.yml --record

kubectl get pvc
kubectl get services
kubectl get pods
pod=`kubectl get pods | grep mssql-plex-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 6- Check pod logs
kubectl logs $pod -f

kubectl get service mssql-plex-service
plex_service=`kubectl get service mssql-plex-service | grep mssql-plex | awk {'print $4'}`
sa_password="_EnDur@nc3_"

sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@version;"

kubectl create namespace tars-sql
kubectl config set-context --current --namespace=tars-sql
kubectl create secret generic tars-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-tars.yml
kubectl apply -f ./services/srvc-sql-tars.yml
kubectl apply -f ./deployments/depl-sql-tars.yml --record

kubectl get pvc
kubectl get services
kubectl get pods
pod=`kubectl get pods | grep mssql-tars-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 6- Check pod logs
kubectl logs $pod -f

kubectl get service mssql-tars-service --watch
tars_service=`kubectl get service mssql-tars-service | grep mssql-tars | awk {'print $4'}`

sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@version;"