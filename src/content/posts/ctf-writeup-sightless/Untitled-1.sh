#!/bin/bash

# Go to the project directory
cd /home/runner/CungLoi.API_Devops || { echo "Error: Could not change to project directory."; exit 1; }

# Function to ask for user input with validation
function get_user_input {
  local prompt="$1"
  local timeout_duration=60
  local input=""

  read -t $timeout_duration -r -p "$prompt: " input

  if [ $? -ne 0 ]; then
    echo "No input received within $timeout_duration seconds. Exiting..."
    exit 1
  fi

  echo "$input"
}

git pull || { echo "Error: Could not pull latest changes"; exit 1; }

# Ask for the branch name
branch_name=$(get_user_input "Enter branch name")

# Ask for the deployment target
deployment_target=$(get_user_input "Enter deployment target (prod, dev, test)" "prod dev test")

# Determine the image tag based on the branch
image_tag="cung-loi:$deployment_target"  # Use branch name for the image tag

# Get the current directory (which is now the project root)
project_dir=$(pwd)

# Checkout to the specified branch
git checkout "$branch_name" || { echo "Error: Could not checkout branch $branch_name"; exit 1; }

# Pull the latest changes
git pull || { echo "Error: Could not pull latest changes"; exit 1; }

# Build the Docker image
echo "Building Docker image: $image_tag"
docker build -t "$image_tag" "$project_dir" 2>/dev/null || { echo "Error: Could not build Docker image"; exit 1; }

# Tag the Docker image for DigitalOcean registry
docker tag "$image_tag" registry.digitalocean.com/einslight/"$image_tag" 2>/dev/null || { echo "Error: Could not tag Docker image"; exit 1; }

# Push the Docker image to the registry
docker push registry.digitalocean.com/einslight/"$image_tag" 2>/dev/null || { echo "Error: Could not push Docker image"; exit 1; }

echo "Successfully built, tagged, and pushed image: $image_tag"

# Upgrade the services (single docker-compose command)
docker compose pull 2>/dev/null || { echo "Error: Could not pull Docker Compose services"; exit 1; } 
docker compose up --force-recreate --build -d || { echo "Error: Could not upgrade Docker Compose services"; exit 1; }

# Clean up unused images
docker image prune -f 2>/dev/null || { echo "Warning: Could not clean up unused Docker images"; }