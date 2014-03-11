#!/bin/bash -e
gem install cucumber net-ssh
cd infrastructure
cucumber
