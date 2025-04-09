#!/bin/bash
#######################################################################
#Description: Create vpc in aws
# - create vpc
# - create a public subnet
#
# - verify if user has aws installed, user might be using windows, linux or mac.
# - verify if user has aws cli configured.
##############

# Variables
Vpc_cidr= "10.0.0.0/16"
subnet_cidr= "10.0.3.0/24"
region= "us-east-1"
vpc_name= "demo-vpc"
subnet_name= "demo-subnet"
subnet_az= "us-east-1a"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install it."
    exit
fi
# Check if AWS CLI is configured
if ! aws configure list &> /dev/null
then
    echo "AWS CLI is not configured. Please run 'aws configure' to set it up."
    exit
fi
# Create VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $Vpc_cidr --region $region --query 'Vpc.VpcId' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create VPC"
    exit 1
fi
echo "VPC created with ID: $vpc_id"
# Tag the VPC
aws ec2 create-tags --resources $vpc_id --tags Key=Name,Value=$vpc_name --region $region    

if [ $? -ne 0 ]; then
    echo "Failed to tag VPC"
    exit 1
fi
echo "VPC tagged with Name: $vpc_name"
# Create a public subnet
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block $subnet_cidr --availability-zone $subnet_az --region $region --query 'Subnet.SubnetId' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create subnet"
    exit 1
fi
echo "Subnet created with ID: $subnet_id"
# Tag the subnet
aws ec2 create-tags --resources $subnet_id --tags Key=Name,Value=$subnet_name --region $region
if [ $? -ne 0 ]; then
    echo "Failed to tag subnet"
    exit 1
fi
echo "Subnet tagged with Name: $subnet_name"
# Create an internet gateway
igw_id=$(aws ec2 create-internet-gateway --region $region --query 'InternetGateway.InternetGatewayId' --output text)
if [ $? -ne 0 ]; then
    echo "Failed to create internet gateway"
    exit 1
fi
echo "Internet Gateway created with ID: $igw_id"
# Attach the internet gateway to the VPC






