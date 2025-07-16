#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing required packages..."
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "🔐 Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "📦 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Updating package list..."
sudo apt update -y

echo "🐳 Installing Docker Engine and plugins..."
sudo apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

echo "🚀 Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "👤 Adding Jenkins to Docker group..."
sudo usermod -aG docker jenkins

echo "🔁 Reloading group membership..."
sudo systemctl restart jenkins

echo "✅ Docker installed and Jenkins added to Docker group!"
docker --version

