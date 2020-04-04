# DEMO 1 - ACR Build
#
#   1- Create Azure resource group
#   2- Create Azure Container Registry
#   3- List ACR registry
#   4- Build a local image
#   5- Tag and push image to ACR
#   6- Build and push from Azure Cloud shell
#   7- List images in ACR repository
# -----------------------------------------------------------------------------
# References:
#   Azure Container Registry authentication with service principals
#   open https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal

# 0- Env variables | demo path
resource_group=PASS-Marathon;
acr_name=dbamastery;
acr_repo=mssqltools-alpine;
cd ~/Documents/$resource_group/Demo_01;
az acr login --name $acr_name;

# 1- Create Azure resource group
az group create --resource-group $resource_group --location westus

# 2- Create Azure Container Registry
az acr create --resource-group $resource_group --name $acr_name --sku Standard --location westus

# 3- List ACR registry
az acr list --resource-group $resource_group -o table

# 4- Build a local image
# Checking Dockerfile -  mssqltools with Alpine
code Dockerfile
docker build . -t mssqltools-alpine -f Dockerfile

# 5- Tag and push image to ACR
docker images mssqltools-alpine

# Getting image id
image_id=`docker images | grep mssqltools-alpine | awk '{ print $3 }' | head -1`

# Tagging image with build number
docker tag $image_id $acr_name.azurecr.io/$acr_repo:2.0

# Pushing imaget to ACR (dbamastery) - mssqltools-alpine repository 
docker push $acr_name.azurecr.io/$acr_repo:2.0
# Check ACR using Docker extension

# 6- Build and push from Azure Cloud shell
# No Docker, no problem 👍👌
open https://portal.azure.com
cd clouddrive/PASS-Marathon/Demo_01
ls -ll
az acr build --image PASS-Marathon:2.1 --registry dbamastery .

# 7- List images in ACR repository
az acr repository show --name $acr_name --repository acr_repo -o table
az acr repository show-manifests -n $acr_name --repository $acr_repo
az acr repository show-tags -n $acr_name --repository $acr_repo --detail