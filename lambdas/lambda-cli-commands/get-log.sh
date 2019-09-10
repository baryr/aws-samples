#!/bin/bash

set -euo pipefail

aws lambda invoke --function-name my-function --payload '{"key": "value"}' out
sed -i '' -e 's/"//g' out
sleep 15
LOG_STREAM=$(cat out)
aws logs get-log-events --log-group-name /aws/lambda/my-function --log-stream-name=$LOG_STREAM --limit 5
