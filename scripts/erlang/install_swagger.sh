#!/usr/bin/env bash

# Based on http://inaka.net/blog/2015/06/23/erlang-swagger-2015/
#
# Usage:
# ./install_swagger.sh <project_root>

# Unoffical Bash "strict mode"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
#ORIGINAL_IFS=$IFS
IFS=$'\t\n' # Stricter IFS settings

if [ ! $# -gt 0 ]; then
    echo "Must specify project path"
    exit 1;
fi

project_root=$1
dist_destination=$project_root/priv/swagger

# Prepare project
cd "$project_root"
mkdir -p "$dist_destination"
mkdir -p priv/swagger-src

# Clone swagger
(
cd priv/swagger-src
git clone git@github.com:swagger-api/swagger-ui.git

# Copy swagger dist into priv/swagger
cd swagger-ui/dist
cp -r *  $dist_destination
)

# Remove swagger repo
rm -rf priv/swagger-src
