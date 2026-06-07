#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(realpath "${SCRIPT_DIR}/..")"
DEBUG_BUILD_DIR="$(realpath "${ROOT_DIR}/build-Debug")"
RELEASE_BUILD_DIR="$(realpath "${ROOT_DIR}/build-Release")"
BUILD_SYSTEM="Ninja"


print_usage() {
    echo "Usage:"
    echo "  $0 [-r | for release build]"
    echo
}

debug_build() {

    cmake \
        -S "$ROOT_DIR" \
        -B "$DEBUG_BUILD_DIR" \
        -G "$BUILD_SYSTEM" \
        -DCMAKE_BUILD_TYPE=Debug

    cmake --build "$DEBUG_BUILD_DIR" --parallel "$(nproc)"

}

release_build() {

    cmake \
        -S "$ROOT_DIR" \
        -B "$RELEASE_BUILD_DIR" \
        -G "$BUILD_SYSTEM" \
        -DCMAKE_BUILD_TYPE=Release

    cmake --build "$RELEASE_BUILD_DIR" --parallel "$(nproc)"

}

BUILD_TYPE="DEBUG"

if [[ $# -gt 0 ]]; then
    case "$1" in
        -r|--release)
            BUILD_TYPE="RELEASE"
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
fi

## echo "BUILD_TYPE set to ${BUILD_TYPE}"

if [[ "$BUILD_TYPE" == "RELEASE" ]]; then
    release_build
else
    debug_build
fi
