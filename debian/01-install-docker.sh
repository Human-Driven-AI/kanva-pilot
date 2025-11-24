#!/bin/bash

# Install Docker using the convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Start and enable Docker service (usually already done by the script)
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group to run docker without sudo
sudo usermod -aG docker $USER

# Verify installation
docker --version

echo "Docker installed successfully. You may need to log out and back in for group changes to take effect."
echo ""
echo "Now logging into Azure Container Registry..."
docker login kanvaimages.azurecr.io -u KanvaPilot