#!/bin/bash

# Create the VPC
vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)

# Enable DNS support in the VPC
aws ec2 modify-vpc-attribute --vpc-id $vpc_id --enable-dns-support "{\"Value\":true}"

# Create an Internet Gateway
igw_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)

# Attach the Internet Gateway to the VPC
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id

# Create a public subnet 1
subnet1_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.0.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text)

# Create a public subnet 2
subnet2_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --availability-zone us-east-1b --query 'Subnet.SubnetId' --output text)

# Create a private subnet 1
subnet3_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text)

# Create a private subnet 2
subnet4_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.3.0/24 --availability-zone us-east-1b --query 'Subnet.SubnetId' --output text)

# Create a route table for public subnets
public_rt_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)

# Create a route to the Internet Gateway for public subnets
aws ec2 create-route --route-table-id $public_rt_id --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id

# Associate the public subnets with the public route table
aws ec2 associate-route-table --subnet-id $subnet1_id --route-table-id $public_rt_id
aws ec2 associate-route-table --subnet-id $subnet2_id --route-table-id $public_rt_id

# Create a route table for private subnets
private_rt_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)

# Create a NAT Gateway
nat_gw_id=$(aws ec2 create-nat-gateway --subnet-id $subnet1_id --allocation-id Your_EIP_ID --query 'NatGateway.NatGatewayId' --output text)

# Create a route to the NAT Gateway for private subnets
aws ec2 create-route --route-table-id $private_rt_id --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $nat_gw_id

# Associate the private subnets with the private route table
aws ec2 associate-route-table --subnet-id $subnet3_id --route-table-id $private_rt_id
aws ec2 associate-route-table --subnet-id $subnet4_id --route-table-id $private_rt_id

echo "VPC, subnets, Internet Gateway, NAT Gateway, and route tables created."
