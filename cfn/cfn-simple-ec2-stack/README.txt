1) Validating template:
aws cloudformation validate-template --template-body file://ec2-template.json

2) Creating stack:
aws cloudformation create-stack --stack-name myteststack --template-body file://ec2-template.json --parameters ParameterKey=KeyName,ParameterValue=aws-linux-machine

ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0 ParameterKey=InstanceType,ParameterValue=t2.micro - skipped defaults


3) Login into instance:
ssh -i aws-linux-machine.pem ec2-user@<host>


4) delete stack when done:
aws cloudformation delete-stack --stack-name myteststack
