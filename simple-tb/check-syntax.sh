#!/bin/bash

folder_path=$1

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'

if [ -z "$folder_path" ]; then
    echo -e "${RED}Usage: $0 <folder_path>${RESET}"
fi

if [ ! -d "$folder_path" ]; then
    echo -e "${RED}Error: Folder does not exist: $folder_path${RESET}"
fi

for file in "$folder_path"/*.sv; do
    if [ ! -e "$file" ]; then
        echo -e "${RED}No .sv files found in the folder.${RESET}"
    fi

    echo -e "${YELLOW}Checking file: $file${RESET}"
    verilator --lint-only "$file" -y "$folder_path" -y "../rtl/general-purpose" -y "../rtl/top-module-interfaces"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Syntax check passed for $file${RESET}"
    else
        echo -e "${RED}Syntax check failed for $file${RESET}"
    fi
done

echo -e "${GREEN}Batch syntax check completed.${RESET}"
