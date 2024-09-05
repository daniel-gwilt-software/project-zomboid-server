# Project Zomboid Server

Project Zomboid game server

<!-- TODO: The settings file isn't being read. I'll need to investigate. -->

Arcade Mode Server - 30x learning

# Project Zomboid Server Deployment on AWS

This guide outlines the steps to deploy the Project Zomboid server using Docker on an Amazon Linux 2023 instance and Amazon ECR for Docker image management.

## Prerequisites

- An AWS account with AWS CLI installed and configured on your instance.
- Docker installed on your Amazon Linux 2023 instance.

## Setup and Deployment

### Step 1: Authenticate Docker with Amazon ECR

Authenticate your Docker client to the Amazon ECR registry to enable pulling Docker images:

```bash
aws ecr get-login-password --region us-west-2 | sudo docker login --username AWS --password-stdin 754801026832.dkr.ecr.us-west-2.amazonaws.com
```

### Step 2: Pull the Docker Image

Pull your Docker image from the Amazon ECR repository:

    sudo docker pull 754801026832.dkr.ecr.us-west-2.amazonaws.com/zomboid:latest

### Step 3: Run the Docker Container

Start your Docker container, mapping the necessary UDP ports for your server:

    sudo docker run -d --name zomboid -p 16261:16261/udp -p 16262:16262/udp 754801026832.dkr.ecr.us-west-2.amazonaws.com/zomboid:latest

### Step 4: Verify Container Status

Ensure the container is running properly:

    sudo docker ps

This will show all active containers, including your Project Zomboid server.

### Step 5: Open Firewall Ports

Make sure the ports 16261 and 16262 UDP are open in your security group to allow game traffic.

## Monitoring and Troubleshooting

To monitor the container or check logs for troubleshooting:

    sudo docker logs [container_id]

Replace `[container_id]` with the ID of your Docker container.

# Setup AWS Lightsail to Run a Docker Container

This guide provides step-by-step instructions on how to configure an AWS Lightsail instance to run a Docker container. This setup is ideal for running single-container applications like a Project Zomboid server.

## Prerequisites

- An AWS account.
- AWS CLI installed on your local machine.
- Docker installed on your Lightsail instance.

## Step 1: Create a Lightsail Instance

1. Log in to the AWS Management Console.
2. Navigate to the Lightsail service.
3. Click on 'Create instance'.
4. Select your instance location and pick a blueprint (choose 'OS Only' and then 'Amazon Linux').
5. Choose your instance plan (select a plan with at least 2 GB RAM for optimal performance).
6. (Optional) Change your instance's name.
7. Click 'Create instance'.

## Step 2: Set Up SSH Key Pair

1. Under the 'Account' page in Lightsail, go to the 'SSH keys' tab.
2. Click 'Create key pair'.
3. Download the private key file to your local machine.
4. Set the correct permissions for your key file:
   ```bash
   chmod 400 /path/to/your/key.pem
   ```

## Step 3: Connect to Your Instance

From your terminal, use the following command to connect to your instance:
`bash
    ssh -i /path/to/your/key.pem ec2-user@your-instance-ip-address
    `

## Step 4: Install Docker on Lightsail

1. Once connected, update your instance:
   ```bash
   sudo yum update -y
   ```
2. Install Docker:
   ```bash
   sudo yum install docker -y
   ```
3. Start the Docker service:
   ```bash
   sudo systemctl start docker
   ```
4. Enable Docker to start on boot:
   ```bash
   sudo systemctl enable docker
   ```

## Step 5: Authenticate Docker with Amazon ECR

Run the AWS CLI command to get the login password for Docker:
aws ecr get-login-password --region your-region | sudo docker login --username AWS --password-stdin your-aws-account-id.dkr.ecr.your-region.amazonaws.com

## Step 6: Pull the Docker Image

Pull your Docker image using:
sudo docker pull your-aws-account-id.dkr.ecr.your-region.amazonaws.com/your-repo-name:tag

## Step 7: Run Your Docker Container

Start your Docker container with the necessary configurations:
sudo docker run -d -p desired-port:desired-port your-aws-account-id.dkr.ecr.your-region.amazonaws.com/your-repo-name:tag

## Step 8: Verify the Container is Running

Check the status of your Docker containers:
sudo docker ps

## Conclusion

Your AWS Lightsail server should now be correctly configured to run your Docker container. This setup is suitable for hosting applications requiring a stable, scalable environment provided by AWS.
