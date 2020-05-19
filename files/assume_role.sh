#! /bin/bash
#
# Dependencies:
#   must source login_iam.sh first to obtain AWS Credentials
# Have
#
# Execute:
#   source ./assume_role.sh [acct] [role]
#
# Description:
#   Makes assuming an AWS IAM role (+ exporting new temp keys) easier

AWS_ASSUME_ROLE_ACCOUNT_NUMBER=$1
AWS_ASSUME_ROLE_NAME=$2
ROLE_SESSION_FILE=~/.aws/role_session
USER_SESSION_FILE=~/.aws/user_session
BASEDIR=$(dirname $0)
AWS_ACCOUNTS_FILE=${BASEDIR}/aws_accounts.json

if [ -z "$USER_SESSION_FILE" ]
then
      echo "User Session Missing, please run 'source login_iam.sh' first"
else
      echo "User Session Exists"
fi

if [ -z "$AWS_ASSUME_ROLE_ACCOUNT_NUMBER" ]
then
      echo "Known AWS Accounts:"
      cat $AWS_ACCOUNTS_FILE | jq .
      echo "==="
      echo -n "Assume Role Account (12digit): "
      read AWS_ASSUME_ROLE_ACCOUNT_NUMBER
fi

if [ -z "$AWS_ASSUME_ROLE_NAME" ]
then
      echo "Preset AWS Roles:"
      echo "readonly-role"
      echo "devops-role"
      echo "admin-role"
      echo "==="
      echo -n "Assume Role Name: "
      read AWS_ASSUME_ROLE_NAME
fi

AWS_ASSUME_ROLE_ARN="arn:aws:iam::${AWS_ASSUME_ROLE_ACCOUNT_NUMBER}:role/${AWS_ASSUME_ROLE_NAME}"
echo "Assume Role ARN: $AWS_ASSUME_ROLE_ARN"

AWS_ACCESS_KEY_ID=$(cat $USER_SESSION_FILE      | jq -r .Credentials.AccessKeyId )
AWS_SECRET_ACCESS_KEY=$(cat $USER_SESSION_FILE  | jq -r .Credentials.SecretAccessKey )
AWS_SESSION_TOKEN=$(cat $USER_SESSION_FILE      | jq -r .Credentials.SessionToken )

aws sts assume-role \
    --role-arn "$AWS_ASSUME_ROLE_ARN" \
    --role-session-name "${AWS_CONTROL_ACCOUNT_IAM_USER}AssumedRole" \
    --output json \
    > $ROLE_SESSION_FILE

if [ $? -eq 0 ]
then
  export AWS_ACCESS_KEY_ID=$(cat $ROLE_SESSION_FILE         | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(cat $ROLE_SESSION_FILE     | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(cat $ROLE_SESSION_FILE         | jq -r .Credentials.SessionToken)
  export AWS_ROLE_SESSION_EXPIRY=$(cat $ROLE_SESSION_FILE   | jq -r .Credentials.Expiration)

  echo -n "Role Session Expiry: "
  echo $AWS_ROLE_SESSION_EXPIRY
  echo "Successfully switched role, check env or $ROLE_SESSION_FILE"

else
  echo "ERROR. CANNOT ASSUME ROLE." >&2
fi
