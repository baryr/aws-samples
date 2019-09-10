Steps
1) create lambda-cli-role with AWSLambdaBasicExecutionRole policy


2) Prepare deployment package
zip function.zip index.js


3) Define lambda:
aws lambda help

aws lambda create-function --function-name my-function --zip-file fileb://function.zip --handler index.handler --runtime nodejs10.x --role arn:aws:iam::972030193862:role/lambda-cli-role --tags "DEPARTMENT=Department A"


3b) Update lambda:
aws lambda update-function-code --function-name my-function --zip-file fileb://function.zip
aws lambda update-function-configuration --function-name my-function --memory-size 128 --environment Variables={S3_BUCKET=Test}

aws lambda put-function-concurrency --function-name my-function --reserved-concurrent-executions 100
aws lambda delete-function-concurrency --function-name my-function
aws lambda get-account-settings


3c) Publish version:
aws lambda publish-version --function-name my-function
aws lambda list-versions-by-function --function-name my-function


3d) Create alias:
aws lambda create-alias --function-name my-function --function-version 1 --name PROD
aws lambda create-alias --function-name my-function --function-version \$LATEST --name DEV
aws lambda delete-alias --function-name my-function --name PROD
aws lambda delete-alias --function-name my-function --name DEV

3e) Routing:
aws lambda update-alias --name alias PROD --function-name my-function --routing-config AdditionalVersionWeights={"2"=0.05}

3f) Layers:
aws lambda update-function-configuration --function-name my-function --layers arn:aws:lambda:us-east-2:123456789012:layer:my-layer:3 arn:aws:lambda:us-east-2:210987654321:layer:their-layer:2

aws lambda publish-layer-version --layer-name my-layer --description "My layer" --license-info "MIT" --content S3Bucket=lambda-layers-us-east-2-123456789012,S3Key=layer.zip --compatible-runtimes python3.6 python3.7

aws lambda list-layers --compatible-runtime python3.7

aws lambda delete-layer-version --layer-name my-layer --version-number 1

3g) subnets:
aws lambda create-function --function-name my-function \
--runtime nodejs10.x --handler index.js --zip-file fileb://function.zip \
--role arn:aws:iam::123456789012:role/lambda-role \
--vpc-config SubnetIds=subnet-071f712345678e7c8,subnet-07fd123456788a036,SecurityGroupIds=sg-085912345678492fb

aws lambda update-function-configuration --function-name my-function \
--vpc-config SubnetIds=subnet-071f712345678e7c8,subnet-07fd123456788a036,SecurityGroupIds=sg-085912345678492fb

aws lambda update-function-configuration --function-name my-function \
--vpc-config SubnetIds=[],SecurityGroupIds=[]

4) Execute lambda:
sync: 
aws lambda invoke --function-name my-function out --log-type Tail

async:
aws lambda invoke --function-name my-function out --invocation-type Event --log-type Tail

aws lambda invoke --function-name my-function out --log-type Tail --query 'LogResult' --output text |  base64 -D


5) Inspect 
aws lambda list-functions --max-items 10

aws lambda list-functions --max-items 10 --starting-token <token>

aws lambda get-function --function-name my-function


6) cleanup
aws lambda delete-function --function-name my-function
aws lambda delete-function --function-name my-function --qualifier 1
