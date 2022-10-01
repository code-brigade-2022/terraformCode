#!/bin/bash

# color output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
#Set Variables for Terraform backend setup
RESOURCE_GROUP_NAME='RG-tfState'
STORAGE_ACCOUNT_NAME="tfstate$RANDOM"
CONTAINER_NAME='tfstate'
STATE_FILE="terraform.state"
REGION=southcentralus

create_blob () {
    echo -e "${GREEN} Validate if storage exist"
    isStorageAccount=$(az storage account list --query '[].name' -o tsv | grep ${STORAGE_ACCOUNT_NAME})
    if [ ! -z "${isStorageAccount}" ]; then
        echo -e "${RED} Storage exist!...continue with creation of container"
        create_container
        get_storage_access_key
        exit 0
    fi
    # Create resource group for Storage account
    echo -e "${GREEN} Creating resource group: ${RESOURCE_GROUP_NAME} in region: ${REGION}"
    az group create --name $RESOURCE_GROUP_NAME --location $REGION
    # Create blob storage account
    echo -e "${GREEN} Creating storage account: ${STORAGE_ACCOUNT_NAME} in resource group: ${RESOURCE_GROUP_NAME}"
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
    # Creacion de blob container y llave de acceso
    create_container
    get_storage_access_key
}

create_container () {
    # Create Blob Container
    echo -e "${GREEN} creando blob container: ${CONTAINER_NAME} in storage: ${STORAGE_ACCOUNT_NAME}"
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
    # Enable blob storage versioning (optional)
    # az storage account blob-service-properties update \
    #     --resource-group $RESOURCE_GROUP_NAME \
    #     --account-name $STORAGE_ACCOUNT_NAME \
    #     --enable-versioning true
}

get_storage_access_key () {
    # Get The Storage Key
    echo -e "${GREEN} recuperando llave de acceso y actualizando env ARM_ACCESS_KEY..."
    ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
    export ARM_ACCESS_KEY=$ACCOUNT_KEY
}

# presentacion
echo -e "${GREEN} ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄ ▄▄▄▄▄▄   ▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄  ▄▄▄▄▄▄▄ "
echo -e "${GREEN}█       █       █      ██       █  █  ▄    █   ▄  █ █   █       █      █      ██       █"
echo -e "${GREEN}█       █   ▄   █  ▄    █    ▄▄▄█  █ █▄█   █  █ █ █ █   █   ▄▄▄▄█  ▄   █  ▄    █    ▄▄▄█"
echo -e "${GREEN}█     ▄▄█  █ █  █ █ █   █   █▄▄▄   █       █   █▄▄█▄█   █  █  ▄▄█ █▄█  █ █ █   █   █▄▄▄ "
echo -e "${GREEN}█    █  █  █▄█  █ █▄█   █    ▄▄▄█  █  ▄   ██    ▄▄  █   █  █ █  █      █ █▄█   █    ▄▄▄█"
echo -e "${GREEN}█    █▄▄█       █       █   █▄▄▄   █ █▄█   █   █  █ █   █  █▄▄█ █  ▄   █       █   █▄▄▄ "
echo -e "${GREEN}█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄██▄▄▄▄▄▄▄█  █▄▄▄▄▄▄▄█▄▄▄█  █▄█▄▄▄█▄▄▄▄▄▄▄█▄█ █▄▄█▄▄▄▄▄▄██▄▄▄▄▄▄▄█"
echo -e "${GREEN}########################################################################################"
echo -e "${GREEN}#                              CREACION DE STORAGE PARA TERRAFORM                      #"
echo -e "${GREEN}########################################################################################"

# magia
create_blob

# Mostrar resumen de cambios
cat << EOF
=================================================
storage_account_name: ${STORAGE_ACCOUNT_NAME}
container_name: ${CONTAINER_NAME}
access_key: ${ACCOUNT_KEY}
state_file_name: ${STATE_FILE}
=================================================
recuerda actualizar las variables de entorno de terraform.
EOF
