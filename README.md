# Multi-Tier Cloud Architecture

## What this project is
I built a three-tier architecture on AWS to understand how real 
production systems are structured. The goal was to see how traffic 
flows from the internet through a load balancer, to application 
servers, and down to a managed database — with security controls 
at every layer.

## Architecture
Internet → ALB (public subnets) → EC2 app servers → RDS MySQL

## Services used
- Amazon VPC with public and private subnets across 2 AZs
- EC2 t3.micro instances running Apache
- Application Load Balancer distributing traffic across both instances
- Amazon RDS MySQL (db.t3.micro)
- Security groups enforcing least-privilege access between layers

## What I learned
Setting this up gave me a clear picture of how VPCs, subnets, and 
security groups work together. The security group chaining — where 
the ALB only talks to EC2, and EC2 only talks to RDS — was the most 
valuable thing to understand hands-on.

## A note on the setup
EC2 instances are in public subnets because private subnets require 
a NAT Gateway to install packages, which has an hourly cost. In a 
production environment I would use private subnets with a NAT Gateway.

## Cost
Everything runs within the AWS Free Tier. Total cost: $0.

## What I would add next
Auto Scaling, HTTPS on the ALB using ACM, and moving EC2 into 
private subnets once a NAT Gateway fits the budget.