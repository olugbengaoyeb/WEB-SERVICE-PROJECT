---

## This README file provides information on how to deploy, access, and monitor the web service. The web service is a sample application that serves a web page and redirects it to the EC2 instances running the service.

1. Description of the web service and its functionality
   The web service is a simple application that serves a web page and redirects it to port 8080 on the EC2 instances where the web service is running. The web page is accessible via HTTPS port 443 on the domain name.

2. Instructions for deploying the infrastructure with Terraform

   - Install Terraform on your local machine.
   - Clone the repository from Github.
   - Navigate to the terraform directory.
   - Run terraform init to initialize the Terraform provider and modules.
   - Create a terraform.tfvars file with the following variables:
     - aws_access_key: AWS access key
     - aws_secret_key: AWS secret key
     - aws_region: AWS region
   - Run terraform plan to preview the infrastructure that will be created.
   - Run terraform apply to deploy the infrastructure.
   - Once the infrastructure is deployed, copy the output web_service_dns_name which will be used to deploy the web service.

3. Instructions for deploying the web service with Ansible

   - Install Ansible on your local machine.
   - Clone the repository from Github.
   - Navigate to the ansible directory.
   - Edit the hosts file to specify the IP address or domain name of the EC2 instances.
   - Edit the group_vars/all.yml file to set the web_service_port variable to 8080.
   - Run ansible-playbook -i hosts playbook.yml to deploy the web service to the EC2 instances.

4. Accessing the Sample Web Page

   - Once the web service is deployed, navigate to the domain name of the load balancer in your web browser.
   - The page will be redirected to port 8080 on the EC2 instances where the web service is running and you should see the sample web page.

5. Monitoring the Web Service with CloudWatch

   - In the AWS Management Console, navigate to CloudWatch.
   - Click on the "Create Alarm" button.
   - Follow the prompts to create a new alarm.
   - Select the appropriate metric(s) to monitor.
   - Set the appropriate threshold(s) for the metric(s).
   - Configure the action(s) to be taken when the alarm is triggered.

6. Making Changes to the Infrastructure or Web Service
   - To make changes to the infrastructure, edit the Terraform configuration files in the terraform directory
     - Run terraform plan to see a preview of the changes.
     - Run terraform apply to apply the changes to the infrastructure.
   - To make changes to the web service, edit the Ansible playbook or role in the ansible directory and run ansible-playbook to deploy the changes to the EC2 instances. Run ansible-playbook -i inventory deploy.yml
