# AWS EKS Tier-3 Architecture with Terraform

This repository contains Terraform scripts to deploy a Tier-3 AWS EKS architecture. Tier-3 architecture typically involves an persentation Tier, logic Tier and Database Tier.

## Prerequisites

Ensure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- AWS CLI configured with necessary credentials

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/aws-eks-tier3.git
   cd aws-eks-tier3

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Adjust Configuration:
- Modify the variables.tf file to set appropriate values for your AWS environment.

4. Deploy Infrastructure:

    ```bash
        terraform apply
    ``````
        Confirm the deployment by typing `yes` when prompted.

5. Verify Deployment:

    ```bash
    kubectl get nodes
    # update the Kubernetes context
    aws eks update-kubeconfig --name my-eks-cluster --region ap-northeast-1
    ```

6. verify access:

    ```bash
    kubectl auth can-i "*" "*"
    kubectl get nodes
    ```

7. Verify autoscaler running:
    ```
    kubectl get pods -n kube-system
    ```

8. Check Autoscaler logs
    ```
    kubectl logs -f -n kube-system -l app=cluster-autoscaler
    ```

9. Check load balancer logs
    ```
    kubectl logs -f -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
    ```

10. Update Kubeconfig       
    Syntax: aws eks update-kubeconfig --region region-code --name your-cluster-name
    ```
    aws eks update-kubeconfig --region ap-northeast-1 --name my-eks-cluster
    ```

11. Create Namespace

    ```bash
    kubectl create ns demo-eks

    kubectl config set-context --current --namespace demo-eks
    ```

# MongoDB Database Setup

## To create MongoDB Resources**

    ```bash
    cd Manifests/mongo_v1
    kubectl apply -f secrets.yaml
    kubectl apply -f deploy.yaml
    kubectl apply -f service.yaml
    ```

## Backend API Setup

    Create NodeJs API deployment by running the following command:

    ```bash
    kubectl apply -f backend-deployment.yaml
    kubectl apply -f backend-service.yaml
    ```

## Frontend setup

    Create the Frontend  resource. In the terminal run the following command:

    ```bash
    kubectl apply -f frontend-deployment.yaml
    kubectl apply -f frontend-service.yaml
    ```

    Finally create the final load balancer to allow internet traffic:

    ```bash
    kubectl apply -f full_stack_lb.yaml
    ```

# Grafana setup 
## Verify Services

    ```bash
    kubectl get svc -n prometheus
    ```

## edit the Prometheus-grafana service:
    ```
    kubectl edit svc prometheus-grafana -n prometheus
    ```

## change ‘type: ClusterIP’ to 'LoadBalancer'

    Username: admin
    Password: prom-operator
    Import Dashboard ID: 1860

Exlore more at: https://grafana.com/grafana/dashboards/

## Destroy Kubernetes resources and cluster

    ```
    cd ./Manifests
    kubectl delete -f -f
    ```
## Remove AWS Resources to stop billing

    ```
    cd terraform
    terraform destroy --auto-approve
    ```