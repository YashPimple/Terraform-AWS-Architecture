## 3-Tier-Architecture Project with Terraform and AWS

This repository showcases the implementation of a scalable and resilient 3-tier architecture using Terraform and AWS. The project aims to provide a hands-on experience in deploying web applications with high availability and fault tolerance by leveraging the power of infrastructure as code.

## Workflow of the Project
<p align="center">
    <img width="884" alt="3-Tier Architecture" src="https://github.com/YashPimple/Terraform-AWS-Architecture/assets/97302447/d90ce939-b16b-4e25-be19-bf71c82c5e92">
</p>

### Features
- **Tier 1: Presentation Tier**
   - The presentation tier serves as the user interface layer, responsible for handling user interactions and displaying information to the users.
   - In this architecture, I have implemented an **Apache Webserver** hosted on EC2 instances.
   - These instances are placed in **public subnets**, allowing them to be accessible from the internet.
   - An **Application Load Balancer** can be set up to distribute incoming traffic across these instances, ensuring scalability and high availability.

- **Tier 2: Logic Tier**
  - The logic tier, also known as the application layer, is responsible for processing user requests, executing business logic, and coordinating data flow between the presentation and data tiers.
  - In this architecture, EC2 instances have been used to host the logic tier. These instances are placed in private subnets, ensuring that they are not directly accessible from the internet.
  - The private subnet setup allows secure communication between the logic tier, presentation tier, and data tier.
  - Security groups can be configured to control inbound and outbound traffic to the logic tier instances, ensuring secure network access.
  - The logic tier interacts with the RDS MySQL instance, which is provisioned in a private subnet, to perform data operations required by the application.
    
- **Tier 3: Database Tier**
   - The data tier is responsible for storing and managing data required by the application.
   - In this architecture, I have made use of **MySQL** can be utilized as the database management system (DBMS).
   - An RDS instance can be provisioned in a **private subnet** to ensure secure access to the database.
   - The logic tier can interact with the MySQL database to perform data operations, such as retrieving, storing, and updating information.
   - The database can be secured using appropriate authentication mechanisms and access controls.


## Prerequisites
To use this project, you need to have the following prerequisites:

- AWS account with necessary permissions
- Terraform installed on your local machine

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.

```bash
$ cd 3-Tier-Architecture
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

8. Confirm the deployment by typing `yes` when prompted.

## Cleanup
- To clean up and destroy the infrastructure created by this project, run the following command:

```bash
$ terraform destroy
```
Note: Be cautious as this action cannot be undone.

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

License
This project is licensed under the MIT License.
