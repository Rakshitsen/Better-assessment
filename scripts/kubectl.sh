#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📥 Downloading latest kubectl binary..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "🔐 Validating binary (optional but recommended)..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

echo "🚀 Installing kubectl..."
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✅ Verifying installation..."
kubectl version --client

