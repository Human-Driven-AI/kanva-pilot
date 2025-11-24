#!/bin/bash

# Check if pilot.env exists
if [ ! -f pilot.env ]; then
    echo "Error: pilot.env not found in current directory"
    exit 1
fi

# Copy pilot.env to .env (this will be the working copy)
cp pilot.env .env

# Extract RootDataPath value (handling both quoted and unquoted values)
ROOT_DATA_PATH=$(grep "^RootDataPath=" .env | cut -d'=' -f2 | tr -d '"')

# Expand ~ to absolute path
ROOT_DATA_PATH="${ROOT_DATA_PATH/#\~/$HOME}"

# Update .env to replace ~/kanva-data with the absolute RootDataPath
sed -i "s|~/kanva-data|${ROOT_DATA_PATH}|g" .env

# Create the data directory if it doesn't exist
mkdir -p "$ROOT_DATA_PATH"

# Fix ownership if directory is owned by root
if [ -d "$ROOT_DATA_PATH" ] && [ "$(stat -c '%U' "$ROOT_DATA_PATH" 2>/dev/null || stat -f '%Su' "$ROOT_DATA_PATH" 2>/dev/null)" = "root" ]; then
    echo "Directory is owned by root, fixing ownership..."
    sudo chown -R $USER:$USER "$ROOT_DATA_PATH"
fi

echo "Created .env from pilot.env"
echo "Created data directory: $ROOT_DATA_PATH"
echo "Updated .env with absolute path: $ROOT_DATA_PATH"
echo ""
echo "Setup complete!"
