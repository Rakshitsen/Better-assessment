#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y software-properties-common

echo "➕ Adding Deadsnakes PPA for latest Python..."
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update -y

echo "🐍 Installing Python 3.12 and dev tools..."
sudo apt install -y python3.12 python3.12-venv python3.12-dev

echo "⚙️ Setting Python 3.12 as default..."
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
sudo update-alternatives --config python3  # Choose Python 3.12 if prompted

echo "📦 Installing pip and upgrading..."
python3 -m ensurepip --default-pip
python3 -m pip install --upgrade pip

echo "🧪 Creating virtual environment..."
python3 -m venv ~/pyenv
source ~/pyenv/bin/activate

echo "✅ Python setup complete!"
python --version
pip --version

