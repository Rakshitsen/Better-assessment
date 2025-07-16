# Real-Time EC2 Metrics Dashboard with CI/CD to EKS 🚀

A Flask-based web application that displays **real-time EC2 instance metrics** — CPU, Memory, and Disk utilization — in the form of **interactive gauge charts** using Plotly. The dashboard also shows the instance's **private IP address**.

## 🧩 Features

- 📊 **Live Dashboard**: Visualizes resource usage via speedometer-style Plotly gauges.
- 🛰️ **Private IP Display**: Shows the current EC2 instance's private IPv4 address.
- ⚙️ **Lightweight & Portable**: Simple setup; deployable on any Ubuntu-based EC2 instance.

## 📁 Project Structure

.
├── app.py # Flask app logic
├── test_app.py # Unit tests for the Flask app
├── templates/
│ └── dashboard.html # HTML template for the dashboard
└── static/
└── style.css # Custom CSS styling


## 🔁 CI/CD Pipeline Overview (via Jenkins)

The project includes a fully automated **CI/CD pipeline** built with Jenkins:

### 🧪 Pipeline Stages

1. **Checkout SCM** – Pulls latest code from GitHub repository  
2. **Install Dependencies** – Sets up Python virtual environment and installs packages  
3. **Unit Test** – Runs Python test cases  
4. **Linting** – Checks code quality with flake8/pylint  
5. **Build** – Builds Docker image  
6. **Security Scan** – Scans Docker image using Trivy  
7. **Push** – Pushes Docker image to Amazon ECR  
8. **Create EKS Cluster** *(optional)* – Conditionally creates EKS cluster using `eksctl`  
9. **Deploy on Kubernetes** – Deploys app on EKS using `kubectl`

## ⚙️ EC2 Instance Setup (t2.medium)

This project was bootstrapped on a **t2.medium Ubuntu EC2 instance**, with the following tools manually installed:

- ✅ Java & Jenkins (for CI/CD orchestration)
- ✅ Python tools:
  ```bash
  sudo apt install python3-venv
  python3 -m venv $VENV
  . $VENV/bin/activate
  pip install --upgrade pip
  pip install -r requirements.txt


✅ Docker (for containerizing the app)

✅ AWS CLI (for interacting with ECR & EKS)

✅ eksctl (for EKS cluster provisioning)

✅ kubectl (for managing K8s deployments)


Jenkins Plugins Used (For CI/CD to AWS EKS)

| Plugin Name                         | Purpose                                                                 |
| ----------------------------------- | ----------------------------------------------------------------------- |
| **Docker Pipeline**                 | To build and run Docker containers inside Jenkins pipelines             |
| **AWS Credentials**                 | To securely store and access AWS access keys                            |
| **Pipeline: AWS Steps**             | Adds AWS CLI steps like `withAWS()` to Jenkins pipelines                |
| **Pipeline Utility Steps**          | Common helper steps like reading YAML, JSON, file operations, etc.      |
| **Git Plugin**                      | Enables Jenkins to pull code from GitHub                                |
| **Trivy Scanner Plugin (optional)** | For Docker image security scanning (or you can use CLI directly)        |
| **AnsiColor Plugin**                | Makes colored logs readable in Jenkins console                          |
| **Credentials Binding Plugin**      | Helps inject credentials securely into the environment (e.g., AWS keys) |





CI/CD Pipeline Breakdown (Jenkins)

The project uses a Jenkins-based CI/CD pipeline with the following stages:
🔍 1. Checkout SCM

Clones the latest source code from the GitHub repository using stored credentials.
📦 2. Install Dependencies

Sets up a Python virtual environment, upgrades pip, and installs all required dependencies from requirements.txt.
✅ 3. Unit Test

Executes automated unit tests using pytest to ensure the core functionality works as expected.
🧹 4. Linting

Runs static code analysis using flake8 to maintain code quality and detect style violations. Linting issues are logged but do not fail the pipeline.
🛠️ 5. Build

Builds a Docker image using the Dockerfile, tagging it with the Jenkins build number for version control.
🔐 6. Security Scan

Scans the Docker image for known vulnerabilities using Trivy, aligning with DevSecOps best practices.
🚀 7. Push

Authenticates securely with Docker Hub and pushes the Docker image. Credentials are injected securely using Jenkins' withCredentials.
☁️ 8. Create EKS Cluster (Conditional)

If the RECREATE_CLUSTER parameter is set to true, a new EKS cluster is provisioned using eksctl. This stage runs only when needed.
📦 9. Deploy on Kubernetes (EKS)

    Connects to the EKS cluster using kubectl

    Applies Kubernetes manifests (namespace.yml, deployment.yml, and service.yml)

    Dynamically replaces the image tag in the deployment file

    Verifies the service deployment
