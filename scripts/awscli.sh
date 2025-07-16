#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing required dependencies..."
sudo apt install -y curl unzip

echo "📥 Downloading AWS CLI v2 installer..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

echo "📂 Unzipping installer..."
unzip awscliv2.zip

echo "🛠️ Installing AWS CLI..."
sudo ./aws/install

echo "🧹 Cleaning up installer files..."
rm -rf aws awscliv2.zip

echo "✅ Verifying installation..."
aws --version

