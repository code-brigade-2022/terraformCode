<#
    .SYNOPSIS
    Script para configuracion de terraform state en Azure backend.
    .EXAMPLE
    ./ps_remotestate.ps1
#>
$RESOURCE_GROUP_NAME='RG-tfState'
$STORAGE_ACCOUNT_NAME="tfstate$(get-random)"
$CONTAINER_NAME='tfstate'
$STATE_FILE="terraform.state"
$REGION=eastus
# inicio de sesion
az login

# seleccion de subcripcion a utilizar(solo si se tiene multiples subs)
#az account set -s "<subcripcion-name>"

# creacion de resource group
az group create --name $RESOURCE_GROUP_NAME --location $REGION

# creacion de storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# activar version control para blob storage
az storage account blob-service-properties update \
    --resource-group $RESOURCE_GROUP_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --enable-versioning true

# creacion de blob storage
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# creacion de account key
$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
$env:ARM_ACCESS_KEY=$ACCOUNT_KEY

# Show details for the purposes of this code
Write-Host "storage_account_name: $STORAGE_ACCOUNT_NAME"
Write-Host "container_name: $CONTAINER_NAME"
Write-Host "access_key: $ACCOUNT_KEY"
Write-Host "state_file: $STATE_FILE"
