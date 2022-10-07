#!/bin/bash

# color output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
#Set Variables for Terraform backend setup
SERVICE_NAME=TerraformSP
SUBID=7703a13e-c5e9-4503-88de-6a4892b0b3c7
# login in to azure
az_login (){
    echo -e "${GREEN} login to Azure Account:"
    az login
    # set subcription account
    echo -e "${GREEN} seteando la subcripcion..."
    az account set --subcription ${SUBID}
}

create_service_principal() {
# create service principal for deploy
    echo -e "${GREEN} creando service principal: "
    az ad sp create-for-rbac --name $SERVICE_NAME --role Contributor --scopes /subscriptions/$SUBID
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
echo -e "${GREEN}#                              PREPARANDO ENTORNO PARA AZURE DEV                       #"
echo -e "${GREEN}########################################################################################"

create_service_principal
