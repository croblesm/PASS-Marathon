# https://stackoverflow.com/questions/57894603/azure-container-registry-docker-login-does-not-work

# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
ACR_NAME=dbamastery
SERVICE_PRINCIPAL_NAME=acr-dbamastery

# Obtain the full registry ID for subsequent command args
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
SP_PASSWD=$(az ad sp create-for-rbac --name http://$SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role owner --query password --output tsv)
SP_APP_ID=$(az ad sp show --id http://$SERVICE_PRINCIPAL_NAME --query appId --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $SP_APP_ID"
echo "Service principal password: $SP_PASSWD"

az acr login --name $ACR_NAME
docker login $ACR_NAME.azurecr.io -u $SP_APP_ID -p $SP_PASSWD

# az ad sp show --id http://acr-dbamastery --query appId --output tsv
# 397129bc-423b-4b13-8e0d-c01f0f1b893f
# 92a9521c-e641-4fa9-8213-611e14454201