pipeline {
    agent any

    parameters {
        booleanParam(name: 'RECREATE_CLUSTER', defaultValue: false, description: 'Recreate EKS cluster on each run')
    }

    environment {
        VENV = "myenv"
        USER_NAME = "rakshitsen"
        IMAGE_NAME = "better-assess-image"
        AWS_REGION = "ap-south-1"
        CLUSTER_NAME = "demo-cluster"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                git(
                    branch: 'main',
                    credentialsId: 'Git_cred',
                    url: 'https://github.com/Rakshitsen/demo-test-repo-flask.git'
                )
            }
        }

        stage('Install dependencies') {
            steps {
                sh '''
                    set -e
                    python3 -m venv $VENV
                    . $VENV/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Unit test') {
            steps {
                sh '''
                    set -e
                    . $VENV/bin/activate
                    pytest
                '''
            }
        }

        stage('Linting') {
            steps {
                script {
                    try {
                        sh '''
                            set -e
                            . $VENV/bin/activate
                            flake8 .
                        '''
                    } catch (err) {
                        echo "Linting issues found: ${err}"
                    }
                }
            }
        }

        stage("Build") {
            steps {
                sh '''
                    docker build -t $USER_NAME/$IMAGE_NAME:$BUILD_NUMBER .
                '''
            }
        }

      stage('Security Scan') {
            steps {
                sh '''
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image $USER_NAME/$IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

        stage("Push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker_cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push $USER_NAME/$IMAGE_NAME:$BUILD_NUMBER
                        docker logout
                    '''
                }
            }
        }

        stage('Create EKS Cluster (Conditioned)') {
            when {
                expression { params.RECREATE_CLUSTER }
            }
            steps {
                withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                    sh '''
                        eksctl create cluster \
                          --name $CLUSTER_NAME \
                          --region $AWS_REGION \
                          --nodegroup-name ng1 \
                          --node-type t3.medium \
                          --nodes 2

                    '''
                }
            }
        }

        stage('Check Cluster Nodes') {
            steps {
                withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                    sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                        kubectl apply -f namespace.yml
                        sed -i "s|image:latest|$USER_NAME/$IMAGE_NAME:$BUILD_NUMBER|g" deployment.yml
                        kubectl apply -f deployment.yml
                        kubectl apply -f service.yml
                        kubectl get service -n project

                    '''
                }
            }
        }
    }
}
