#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing curl and tar..."
sudo apt install -y curl tar

echo "📥 Downloading eksctl binary..."
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp

echo "🚀 Moving eksctl to /usr/local/bin..."
sudo mv /tmp/eksctl /usr/local/bin

echo "✅ Verifying eksctl installation..."
eksctl version

