#!/bin/bash -e

gem install trollop 
gem install aws-sdk-core --pre
export stack_name=HonoluluAnswers-`date +%Y%m%d%H%M%S`
aws cloudformation create-stack --stack-name $stack_name --template-body "`cat infrastructure/config/honolulu.template`" --region ${region}  --disable-rollback --capabilities="CAPABILITY_IAM"
ruby infrastructure/bin/monitor_stack.rb  --stack $stack_name
echo stack_name=$stack_name > stackname.txt