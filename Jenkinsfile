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
        AWS_ACCOUNT_ID = credentials('AWS_ACCOUNT_ID') // Store this as "Secret Text" in Jenkins credentials
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git(
                    branch: 'test',
                    credentialsId: 'Git_cred',
                    url: 'https://github.com/Rakshitsen/Better-assessment.git'
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

        stage('Build') {
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

        stage('Push') {
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
                    sh '''
                        eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve --region $AWS_REGION
                    '''
                    sh '''
                        curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
                        aws iam create-policy \
                        --policy-name AWSLoadBalancerControllerIAMPolicy \
                        --policy-document file://iam_policy.json

                        eksctl create iamserviceaccount \
                        --cluster $CLUSTER_NAME \
                        --namespace kube-system \
                        --name aws-load-balancer-controller \
                        --role-name AmazonEKSLoadBalancerControllerRole \
                        --attach-policy-arn arn:aws:iam::$AWS_ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
                        --approve \
                        --region $AWS_REGION
                    '''
                }
            }
        }

        stage('Deploy on K8S using EKS') {
            steps {
                withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                    sh '''
                        aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME
                        kubectl apply -f namespace.yml
                        sed -i "s|image:latest|$USER_NAME/$IMAGE_NAME:$BUILD_NUMBER|g" deployment.yml
                        kubectl apply -f deployment.yml
                        kubectl apply -f service.yml
                    '''
                }
            }
        }

        stage('Ingress and Ingress Controller') {
            steps {
                withAWS(credentials: 'AWS_CRED', region: "${AWS_REGION}") {
                    sh '''
                        VPC_ID=$(aws eks describe-cluster \
                            --name $CLUSTER_NAME \
                            --region $AWS_REGION \
                            --query "cluster.resourcesVpcConfig.vpcId" \
                            --output text)

                        helm repo add eks https://aws.github.io/eks-charts
                        helm repo update
                        helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
                            --set clusterName=$CLUSTER_NAME \
                            --set serviceAccount.create=false \
                            --set serviceAccount.name=aws-load-balancer-controller \
                            --set region=$AWS_REGION \
                            --set vpcId=$VPC_ID
                    '''
                    sh 'sleep 90'
                    sh 'kubectl apply -f ingress.yml'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
