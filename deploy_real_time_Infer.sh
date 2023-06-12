#!/bin/bash
: ${ENVIRONMENT:="dev"}
STACK_NAME="mlopsdemo-rtInfer-pipeline"

# Reading tag values
Environment=${ENVIRONMENT}
# Finding parameter store name from export parameters
ModelEndPointXGBoost="MLOPsDemoV1-staging"
# Copying CFN template on to s3
#CFNBucket="vw-cred-datalake-"${ENVIRONMENT}"-s3-mlops-cfn"
#aws s3 cp cloudformation//real_time_Infer_cfn.yml s3://${CFNBucket}/cloudformation/ || true 
#sleep 2 # Sleeping for few seconds to maintain s3 consistency
# Deploy cloudformation template
output=$(aws cloudformation deploy --stack-name $STACK_NAME \
--template-file APIGateway_real_time_Infer_cfn.yml \
--parameter-overrides ModelEndPointXGBoost=$ModelEndPointXGBoost Environment=$Environment \
--capabilities CAPABILITY_NAMED_IAM 2>&1)


# Displaying results as per conditions


RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "$output"
else
  if [[ "$output" == *"No updates are to be performed"* ]]; then
    echo "No cloudformation updates are to be performed."
    exit 0
  else
    echo "$output"
    exit $RESULT
  fi
fi
