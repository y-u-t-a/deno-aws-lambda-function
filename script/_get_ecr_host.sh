#!/bin/sh

account_number=$(aws sts get-caller-identity --query 'Account' --output text)
region=$(aws configure get region)
echo "$account_number.dkr.ecr.$region.amazonaws.com"