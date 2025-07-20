#!/bin/bash

###########################################
# Author: Mahesh
# Date: 11th
#
# Version: v1
#
# this script will report the AWS resource usage
###########################################

set -x

# AWS S3
# AWS EC2
# AWS LAMBDA
# AWS IAM Users
 
# list s3 buckets
echo "print list of s3 buckets"
aws s3 ls  > resourceTracker

# list EC2 instances
echo "print list of ec2 instances"
aws ec2 describe-instances | jq  '.Reservations[].Instances[].InstanceId' > resourceTracker


# list lambda
echo "print list of lambda functions"
aws lambda list-functions > resourceTracker

#list IAM users
echo "print list of IAM users"
aws iam list-users  > resourceTracker


