#!/bin/bash

# Load pilot.env to find RootDataPath
if [ ! -f pilot.env ]; then
    echo "Error: pilot.env not found in current directory"
    exit 1
fi

# Extract RootDataPath value (handling both quoted and unquoted values)
ROOT_DATA_PATH=$(grep "^RootDataPath=" pilot.env | cut -d'=' -f2 | tr -d '"')

# Expand ~ to absolute path
ROOT_DATA_PATH="${ROOT_DATA_PATH/#\~/$HOME}"

# Update pilot.env to replace ~/kanva-data with the absolute RootDataPath
sed -i "s|~/kanva-data|${ROOT_DATA_PATH}|g" pilot.env

# Create the data directory if it doesn't exist
mkdir -p "$ROOT_DATA_PATH"

echo "Created data directory: $ROOT_DATA_PATH"
echo "Updated pilot.env with absolute path: $ROOT_DATA_PATH"
echo ""
echo "RootDataPath exported for docker-compose"
echo ""
echo "Setup complete!"
