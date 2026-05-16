#!/bin/bash
# User Data script for ec2-app-1 and ec2-app-2
# Runs once at instance launch via EC2 User Data

# Update packages and install Apache
yum update -y
yum install -y httpd

# Start Apache and enable it on boot
systemctl start httpd
systemctl enable httpd

# Create a simple landing page that shows the instance hostname
# When the ALB load-balances requests, the hostname changes between
# ec2-app-1 and ec2-app-2 — proving traffic is reaching both instances
echo "<h1>Multi-Tier App &mdash; $(hostname)</h1>" > /var/www/html/index.html
