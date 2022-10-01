#!/bin/bash

# color output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

destroy_infra_azure () {
    # init teraform
    echo -e "destroying infrastructure in Azure"
    # plan terraform for changes
    terraform plan -destroy -detailed-exitcode -out=tfplan.out
    if [ $? -eq 1 ]; then
        echo -e "${RED} ERROR: tf plan, please check and try again"
        exit 1;
    elif [ $? -eq 0 ]; then
        echo -e "${GREEN} No Changes detected..."
        exit 0;
    fi
    # apply changes
    echo -e "${GREEN} Changes detected... Applying"
    terraform apply "tfplan.out"
    if [ $? -eq 1 ]; then
        echo -e "${RED} ERROR: error aplying changes..."
        exit 1;
    fi
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
echo -e "${GREEN}#                                  DESTROY INFRA EN AZURE                              #"
echo -e "${GREEN}########################################################################################"

destroy_infra_azure
