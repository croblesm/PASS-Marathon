
# Create Azure resource group
az group create --resource-group PASS-Marathon --location westus

# Create Azure Container Registry
az acr create --resource-group PASS-Marathon --name dbamastery --sku Standard --location westus

# List ACR registries
az acr list --resource-group PASS-Marathon -o table

# Build image
docker build . -t mssql-tools

docker images mssql-tools
image_id=`docker images | grep mssql-tools | awk '{ print $3 }' | head -1`
docker tag $image_id dbamastery.azurecr.io/mssql-tools:1.2
docker images | grep mssql-tools
docker push dbamastery.azurecr.io/mssql-tools:1.2

# Go to Azure Cloud shell
az acr build --image mssql-tools:1.4 --registry dbamastery .

# List images for dbamastery repository
az acr repository show --name dbamastery --repository mssql-tools -o table
az acr repository show-manifests -n dbamastery --repository mssql-tools
az acr repository show-tags -n dbamastery --repository mssql-tools --detail

az acr task list-runs --registry dbamastery --image mssql-tools:1.4 -o table
az acr task logs --registry dbamastery --image mssql-tools:1.4 -o table

docker pull dbamastery.azurecr.io/mssql-tools:1.4