#!/bin/bash

# Check if pilot.env exists
if [ ! -f pilot.env ]; then
    echo "Error: pilot.env not found in current directory"
    exit 1
fi

# Extract HostDataPath value (handling both quoted and unquoted values)
HOST_DATA_PATH=$(grep "^HostDataPath=" pilot.env | cut -d'=' -f2 | tr -d '"')

# Expand ~ to absolute path
HOST_DATA_PATH="${HOST_DATA_PATH/#\~/$HOME}"

# Create .env file with the absolute host path for docker-compose
echo "HostDataPath=${HOST_DATA_PATH}" > .env

# Create the data directory if it doesn't exist
mkdir -p "$HOST_DATA_PATH"

# Fix ownership if directory is owned by root
if [ -d "$HOST_DATA_PATH" ] && [ "$(stat -c '%U' "$HOST_DATA_PATH" 2>/dev/null || stat -f '%Su' "$HOST_DATA_PATH" 2>/dev/null)" = "root" ]; then
    echo "Directory is owned by root, fixing ownership..."
    sudo chown -R $USER:$USER "$HOST_DATA_PATH"
fi

# Set permissions to allow containers to write (777 needed because containers run as appuser)
chmod -R 777 "$HOST_DATA_PATH"

echo "Created .env for docker-compose"
echo "Created data directory: $HOST_DATA_PATH"
echo ""
echo "Setup complete!"
