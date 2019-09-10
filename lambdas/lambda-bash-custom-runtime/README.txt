1) Prepare deployment package
chmod 755 function.sh bootstrap

zip function.zip function.sh bootstrap

2) create lambda (use valid ARN):
aws lambda create-function --function-name bash-runtime --zip-file fileb://function.zip --handler function.handler --runtime provided --role arn:aws:iam::972030193862:role/lambda-role 

3) exacute with sample payload:
aws lambda invoke --function-name bash-runtime --payload '{"text":"Hello"}' response.txt

4) create layer
zip runtime.zip bootstrap
aws lambda publish-layer-version --layer-name bash-runtime --zip-file fileb://runtime.zip

5) Update function configuration (use vailid runtime ARN from step 4) 
aws lambda update-function-configuration --function-name bash-runtime --layers arn:aws:lambda:eu-central-1:972030193862:layer:bash-runtime:1

6) Update function code:
zip function-only.zip function.sh
aws lambda update-function-code --function-name bash-runtime --zip-file fileb://function-only.zip

7) execute lambda
aws lambda invoke --function-name bash-runtime --payload '{"text":"Hello"}' response.txt

8) update runtime
zip runtime.zip bootstrap
aws lambda publish-layer-version --layer-name bash-runtime --zip-file fileb://runtime.zip

9) update function to use new runtime (use vailid runtime ARN from step 8)
aws lambda update-function-configuration --function-name bash-runtime --layers arn:aws:lambda:eu-central-1:972030193862:layer:bash-runtime:2

10) execute lambda
aws lambda invoke --function-name bash-runtime --payload '{"text":"Hello"}' response.txt

11) cleanup
aws lambda delete-layer-version --layer-name bash-runtime --version-number 1
aws lambda delete-layer-version --layer-name bash-runtime --version-number 2
