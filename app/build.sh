#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# TODO(Alex): perhaps better to use an env variable instead? 
#  note: sed command replaces '+' with '_' as '+' is not allowed for docker tag
version=$(grep "version:" $script_dir/pubspec.yaml | tail -n1 | cut -c 10- | sed 's/+/_/g')

tag=testing-flutter/app:$version
dockerfile=$script_dir/Dockerfile

echo "Building docker images: $tag from $dockerfile"

docker build -t $tag -f $dockerfile .