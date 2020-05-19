#!/bin/bash

# banner
USER_SESSION_FILE=~/.aws/user_session
# if [ $# -lt 1 ]; then
#   echo "---------------"
#   echo "--- Login and get AWS Session Credentials into the environment for further usage"
#   echo "--- AWS Session Credentials will be written to ($USER_SESSION_FILE)"
#   echo "--- Required params: AWS_CONTROL_ACCOUNT_IAM_USER"
#   echo "--- Optional params: AWS_CONTROL_MFA_TOKEN AWS_CONTROL_PROFILE AWS_CONTROL_ACCOUNT_ID"
#   echo "---------------"
#   echo "---  USAGE  ---"
#   echo "--- # source login_iam.sh $AWS_CONTROL_ACCOUNT_IAM_USER [$AWS_CONTROL_MFA_TOKEN] [$AWS_CONTROL_PROFILE] [$AWS_CONTROL_ACCOUNT_ID]"
#   echo "---------------"
#   echo "--- EXAMPLE 1: USER + MFA"
#   echo "    # source login_iam.sh jia_liao_bee 654321"
#   echo "---------------"
#   echo "--- EXAMPLE 2: USER, then MFA"
#   echo "    # source login_iam.sh jia_liao_bee"
#   echo "    # MFA: 654321"
#   echo ""
#   return
# fi

# read IAM user and MFA
export AWS_CONTROL_ACCOUNT_IAM_USER=$1
AWS_CONTROL_MFA_TOKEN=$2

export AWS_CONTROL_PROFILE=${3:-gds-control-plane}
export AWS_CONTROL_ACCOUNT_ID=${4:-287240919503}

echo "AWS Profile: $AWS_CONTROL_PROFILE ($AWS_CONTROL_ACCOUNT_ID)"

if [ -z "$AWS_CONTROL_ACCOUNT_IAM_USER" ]
then
      echo -n "IAM Username: "
      read AWS_CONTROL_ACCOUNT_IAM_USER
else
      echo "IAM Username: $AWS_CONTROL_ACCOUNT_IAM_USER"
fi

if [ -z "$AWS_CONTROL_MFA_TOKEN" ]
then
      echo -n "MFA: "
      read AWS_CONTROL_MFA_TOKEN
else
      echo "MFA: $AWS_CONTROL_MFA_TOKEN"
fi

AWS_SERIAL_ARN=arn:aws:iam::$AWS_CONTROL_ACCOUNT_ID:mfa/$AWS_CONTROL_ACCOUNT_IAM_USER
echo $AWS_SERIAL_ARN

aws sts get-session-token \
  --profile $AWS_CONTROL_PROFILE \
  --serial-number $AWS_SERIAL_ARN \
  --token-code $AWS_CONTROL_MFA_TOKEN \
  --output json \
  > $USER_SESSION_FILE

if [ $? -eq 0 ]
then
  export AWS_ACCESS_KEY_ID=$(cat $USER_SESSION_FILE           | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(cat $USER_SESSION_FILE       | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(cat $USER_SESSION_FILE           | jq -r .Credentials.SessionToken)
  export AWS_CONTROL_SESSION_EXPIRY=$(cat $USER_SESSION_FILE  | jq -r .Credentials.Expiration)
  echo -n "User Session Expiry: "
  echo $AWS_CONTROL_SESSION_EXPIRY
  echo "Successfully logged in as $AWS_CONTROL_ACCOUNT_IAM_USER, check env or $USER_SESSION_FILE"

else
  echo "ERROR. CANNOT LOGIN." >&2
fi
