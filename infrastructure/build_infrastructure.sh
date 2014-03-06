#!/bin/bash -e
 aws cloudformation create-stack --stack-name Honolulu-`date +%Y%m%d%H%M%S` --template-body "`cat honolulu.template`"  --disable-rollback 