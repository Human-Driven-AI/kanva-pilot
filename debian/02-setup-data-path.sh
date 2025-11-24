#!/bin/bash

# Resolve the absolute path for kanva-data
DATA_PATH="${HOME}/kanva-data"

# Create the data directory if it doesn't exist
mkdir -p "$DATA_PATH"

echo "Created data directory: $DATA_PATH"

# Update pilot.env to replace ~/kanva-data with the absolute path
if [ -f pilot.env ]; then
    # Use sed to replace ~/kanva-data with the absolute path
    sed -i "s|~/kanva-data|${DATA_PATH}|g" pilot.env
    echo "Updated pilot.env with absolute path: $DATA_PATH"
else
    echo "Warning: pilot.env not found in current directory"
    exit 1
fi

echo "Setup complete!"
