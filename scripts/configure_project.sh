#!/usr/bin/env bash

## Script to find and replace every occurance of "MY_PROJECT_NAME" and "my_project_name" from 
## template repository with actual project name

set -e

## Usage
function print_usage(){
    echo "Usage :"
    echo "  $0 [--project-name | -p] my_project"
    echo "  $0 -p my_project [-r|--revert] to revert back from my_project to placeholder MY_PROJECT_NAME" 
}

function revert_change(){
    echo "Reverting from ${PROJECT_NAME} to placeholder MY_PROJECT_NAME"
}

PROJECT_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in

        -p=*|--project-name=*)
            PROJECT_NAME="${1#*=}"
            if [[ -z "${PROJECT_NAME}" ]]; then
                print_usage
                exit 1
            fi
            shift
            ;;

        -r|--revert)
            revert_change
            shift
            ;;

        -h|--help)
            print_usage
            exit 0
            ;;
        
        *)
            echo "Unknown argument: $1"
            print_usage
            exit 1
            ;;

    esac
done

if [[ -z "${PROJECT_NAME}" ]]; then
    echo "ERROR : Project name required"
    print_usage
    exit 1
fi

PROJECT_NAME_UPPER=$(echo "${PROJECT_NAME}" | tr '[:lower:]' '[:upper:]')

echo "Replacing MY_PROJECT_NAME in all CMakeLists.txt with ${PROJECT_NAME_UPPER}"