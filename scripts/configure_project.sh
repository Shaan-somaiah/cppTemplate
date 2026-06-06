#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"

print_usage() {
    echo "Usage:"
    echo "  $0 -p <project_name>"
    echo
    echo "Example:"
    echo "  $0 -p file_transfer_project"
}

PROJECT_NAME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--project-name)
            PROJECT_NAME="$2"
            shift 2
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
    echo "Project name required!"
    exit 1
fi

if [[ ! "${PROJECT_NAME}" =~ ^[a-z][a-z0-9_]*$ ]]; then
    echo "ERROR: project name must be snake_case"
    echo "Example: file_transfer"
    exit 1
fi

########################################
# Generate naming variants
########################################

PROJECT_NAME_SNAKE="${PROJECT_NAME}"

PROJECT_NAME_UPPER=$(echo "${PROJECT_NAME_SNAKE}" | tr '[:lower:]' '[:upper:]')

PROJECT_NAME_CAMEL=$(
    echo "${PROJECT_NAME_SNAKE}" |
    awk -F_ '{
        for (i = 1; i <= NF; i++) {
            if (i == 1) {
                printf "%s", $i
            } else {
                printf toupper(substr($i,1,1)) substr($i,2)
            }
        }
    }'
)

echo "Project Name Variants:"
echo "  SNAKE : ${PROJECT_NAME_SNAKE}"
echo "  UPPER : ${PROJECT_NAME_UPPER}"
echo "  CAMEL : ${PROJECT_NAME_CAMEL}"

########################################
# Replace contents
########################################

echo
echo "Replacing placeholders..."

find "${ROOT_DIR}" \
    -type f \
    ! -path "*/build/*" \
    ! -path "*/.git/*" \
    -exec sed -i \
        -e "s/MY_PROJECT_NAME/${PROJECT_NAME_UPPER}/g" \
        -e "s/myProjectName/${PROJECT_NAME_CAMEL}/g" \
        -e "s/my_project_name/${PROJECT_NAME_SNAKE}/g" \
        {} +

########################################
# Rename files
########################################

echo
echo "Renaming files..."

find "${ROOT_DIR}" \
    -type f \
    ! -path "*/build/*" \
    ! -path "*/.git/*" \
    -name "*my_project_name*" |
while read -r path; do

    dir="$(dirname "$path")"
    file="$(basename "$path")"

    new_file="${file//my_project_name/${PROJECT_NAME_SNAKE}}"

    if [[ "$file" != "$new_file" ]]; then
        echo "  $path"
        echo "    -> $dir/$new_file"
        mv "$path" "$dir/$new_file"
    fi
done

########################################
# Rename directories
########################################

echo
echo "Renaming directories..."

find "${ROOT_DIR}" \
    -depth \
    -type d \
    ! -path "*/build/*" \
    ! -path "*/.git/*" \
    -name "*my_project_name*" |
while read -r path; do

    new_path="${path//my_project_name/${PROJECT_NAME_SNAKE}}"

    if [[ "$path" != "$new_path" ]]; then
        echo "  $path"
        echo "    -> $new_path"
        mv "$path" "$new_path"
    fi
done

echo
echo "Project configured successfully."