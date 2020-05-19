#!/bin/bash
export AWS_CONTROL_ACCOUNT_IAM_USER=wallace_tan
AWS_CONTROL_MFA_TOKEN=$(otp-aws-wallace_tan)
echo "--------------------------------------------------------------------------------"
echo "MFA TOKEN : " $AWS_CONTROL_MFA_TOKEN

export AWS_CONTROL_PROFILE=gds-control-plane
export AWS_CONTROL_ACCOUNT_ID=287240919503

export AWS_ASSUME_ROLE_ACCOUNT_NUMBER=529525550972
export AWS_ASSUME_ROLE_NAME=devops-role

rm ~/.aws/user_session
rm ~/.aws/role_session
echo "--------------------------------------------------------------------------------"
echo login_iam.sh $AWS_CONTROL_ACCOUNT_IAM_USER $AWS_CONTROL_MFA_TOKEN
login_iam $AWS_CONTROL_ACCOUNT_IAM_USER $AWS_CONTROL_MFA_TOKEN
echo "--------------------------------------------------------------------------------"
echo assume_role.sh $AWS_ASSUME_ROLE_ACCOUNT_NUMBER $AWS_ASSUME_ROLE_NAME
assume_role $AWS_ASSUME_ROLE_ACCOUNT_NUMBER $AWS_ASSUME_ROLE_NAME
echo "--------------------------------------------------------------------------------"
