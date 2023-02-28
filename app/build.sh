#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

help_message () {
    echo "Usage:"
    echo "build.sh VERSION"
    echo "Example: "
    echo "build.sh 1.0.0"
}

if [[ $# != 1 ]]; then
    echo "Error: one argument expected"
    help_message
    exit
fi

version=$1

tag=testing-flutter/app:$version
dockerfile=$script_dir/Dockerfile.local

echo "Building $tag - from $dockerfile"

docker build -t $tag -f $dockerfile .