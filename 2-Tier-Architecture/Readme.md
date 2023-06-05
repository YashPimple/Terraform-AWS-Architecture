## 2-Tier-Architecture Project with Terraform and AWS

This project showcases the implementation of a scalable and resilient 2-tier architecture using Terraform and AWS. Leveraging the power of infrastructure as code, this setup provides a solid foundation for deploying web applications with high availability and fault tolerance.

## Workflow
<p align="center">
  <img width="642" alt="Tier-2 Architecture" src="https://github.com/YashPimple/Terraform-AWS-Architecture/assets/97302447/a543a4bf-a532-45c8-aba7-88bae9936940">
</p>

### Features
- **Tier 1: Web Tier**

  - EC2 instances provisioned in public subnets
  - Auto Scaling Group for handling dynamic workload
  - Load Balancer for distributing traffic and ensuring high availability
  - Security Groups to control inbound and outbound traffic

- **Tier 2: Database Tier**

  - RDS MySQL instance in a private subnet
  - Secure network access using security groups

## Prerequisites
To use this project, you need to have the following prerequisites:

- AWS account with necessary permissions
- Terraform installed on your local machine

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.

```bash
$ cd 2-Tier-Architecture
```

3. Configure your AWS credentials by setting the environment variables or using the AWS CLI.
4. Update the `variables.tf` file with your desired configuration.
5. Initialize the Terraform project.
```bash
$ terraform init
```
6. Review the execution plan.
```bash
$ terraform plan
```
7. Deploy the architecture.
```bash
$ terraform apply
```

8.Confirm the deployment by typing `yes` when prompted.

## Cleanup
- To clean up and destroy the infrastructure created by this project, run the following command:

```bash
$ terraform destroy
```
Note: Be cautious as this action cannot be undone.

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

License
This project is licensed under the MIT License.

