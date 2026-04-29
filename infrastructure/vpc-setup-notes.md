# VPC Setup Notes

## Why I built this

I wanted to understand how real AWS environments are structured 
before moving into more advanced projects. The multi-tier pattern 
comes up constantly in Solutions Architect material and I felt I 
needed to actually build it to properly understand it.

## The VPC

I created a VPC with CIDR block 10.0.0.0/16 which gives me 
65,536 possible IP addresses to work with across all my subnets. 
I named it multi-tier-vpc to keep it separate from the default 
VPC that AWS creates automatically in every account.

## Subnets and availability zones

I created four subnets split across two availability zones. 
Public subnets sit in af-south-1a and af-south-1b. Private 
subnets sit in the same two zones. Spreading across two AZs 
means if one zone has an issue, the other can still serve traffic. 
This is the foundation of high availability on AWS.

## Internet Gateway and routing

The Internet Gateway is what allows traffic from the internet 
to enter the VPC. Attaching it to the VPC alone is not enough 
though. I had to create a route table with a route pointing 
0.0.0.0/0 to the IGW and associate that route table with the 
public subnets only. The private subnets have no route to the 
IGW which means nothing can reach them directly from the internet.

## Security groups

This was the most important part to get right. I set up four 
security groups with a chaining approach:

The ALB security group accepts HTTP and HTTPS from anywhere 
since it is the public entry point.

The EC2 security group only accepts HTTP from the ALB security 
group. Not from the internet, not from an IP range, only from 
the ALB. This means even if someone knew the private IP of an 
EC2 instance they could not reach it directly.

The Bastion security group only accepts SSH from my own IP 
address. This is the only way into the private instances for 
maintenance.

The RDS security group only accepts MySQL connections from the 
EC2 security group. The database has no path to the internet 
and no path from anywhere except the application layer.

## What I would do differently in production

EC2 instances are currently in public subnets because private 
subnets need a NAT Gateway to download packages during setup 
and NAT Gateways have an hourly cost. In a production environment 
I would keep EC2 in private subnets and use a NAT Gateway for 
outbound traffic only.

I would also add an Auto Scaling group so the number of EC2 
instances adjusts based on traffic, and I would enable HTTPS 
on the ALB using an ACM certificate.

## Cost

Everything in this project runs within the AWS Free Tier. 
The only ongoing cost would be a NAT Gateway if I added one, 
which is why I left it out for this build.