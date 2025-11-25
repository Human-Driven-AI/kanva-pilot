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
echo "Created .env for docker-compose"

# Create the data directory if it doesn't exist
mkdir -p "$HOST_DATA_PATH"
mkdir -p "$HOST_DATA_PATH/local-cache"
echo "Created data directory: $HOST_DATA_PATH"

# Set ownership to current user and docker group
echo "Setting ownership to $USER:docker..."
sudo chown -R $USER:docker "$HOST_DATA_PATH"

# Set permissions: owner and group can read/write/execute
chmod -R 775 "$HOST_DATA_PATH"

echo "Permissions set (775 with docker group ownership)"

echo ""
echo "Setup complete!"
