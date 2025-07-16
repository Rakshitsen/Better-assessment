#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo apt update -y

echo "☕ Installing OpenJDK 21..."
sudo apt install openjdk-21-jdk -y
java -version

echo "🔐 Adding Jenkins GPG key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "📦 Adding Jenkins repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "🔄 Updating package list..."
sudo apt update -y

echo "🛠️ Installing Jenkins (LTS)..."
sudo apt install jenkins -y

echo "🧭 Setting JAVA_HOME for Jenkins..."
echo 'JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' | sudo tee -a /etc/default/jenkins

echo "🚀 Starting and enabling Jenkins service..."
sudo systemctl daemon-reexec
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "🔐 Fetching initial admin password..."
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo "✅ Setup complete! Access Jenkins at: http://<your-ec2-public-ip>:8080"

