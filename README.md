## Honolulu Answers AWS Scripting Proof of Concept

Hi there. We used this repo to demonstrate how to script the Honolulu Answers app to deploy in Amazon Web Services (AWS). This fork is not intended to be merged back into the original, and we don't plan on keeping it updated with any changes to made to the original. You will incur AWS charges while resources are in use. Use this application at your own risk!

## Setting up the Honolulu Answers application
1. Create a new [AWS IAM user](https://console.aws.amazon.com/iam/) and download the access keys. This user should have Aministrator permissions.
2. Go to the [AWS Account Information page](https://portal.aws.amazon.com/gp/aws/developer/account) and get your account number (it's in the top right hand corner).
2. Launch an Ubuntu 12.04 [EC2](https://console.aws.amazon.com/ec2) instance in AWS
3. SSH into the Ubuntu 12.04 EC2 instance by clicking the chckbox next to the instance in the EC2 console, clicking the **Connect** button and following the instructions. 
4. Export your AWS Access Keys from the AWS IAM user you created in step #1:
```
export AWS_ACCESS_KEY_ID=YOURACCESSKEY
export AWS_SECRET_ACCESS_KEY=YOURSECRETKEY
export AWS_ACCT_NUMBER=YOURACCOUNTNUMBER
```

Here's an example of what your exports might look like:

```
export AWS_ACCESS_KEY_ID=AKIAJ3SRLadsdasdLUNHQ
export AWS_SECRET_ACCESS_KEY=uMPEOmaZ+niixOYjjdP6afasfawfasfsQbsqSup0rb2L+Y
export AWS_ACCT_NUMBER=324322445747
```
Then, run the commands listed below:

```
sudo apt-get -y update
sudo apt-get -y install git postgresql ruby1.9.1-full ruby-bundler rubygems1.9.1 libxslt1-dev libxml2-dev libsasl2-dev libpq-dev sqlite3 memcached build-essential libsqlite3-dev libhunspell-1.3-0 gettext
\curl -sSL https://get.rvm.io | bash
source /home/ubuntu/.rvm/scripts/rvm
rvm install ruby-1.9.3-p484
git clone https://github.com/stelligent/honolulu_answers.git
cd honolulu_answers
bundle install
infrastructure/build_instructure.sh
```

An Opsworks stack will have been created and launching. To get details:

1. Log into the [OpsWorks](http://console.aws.amazon.com/opsworks) console
3. You should see an OpsWorks stack listed named **Honolulu Answers** -- click on it. If you see more than one listed (because you kicked it off a few times), they are listed in alphabetical-then-chronological order. So the last *Honolulu Answers* stack listed will be the most recent one.
4. Click on **Instances** within the OpsWorks stack you selected.
5. Once the Instance turns green and shows its status as *Online*,you can click the IP address link and the Honolulu Answers application will load!

### Deleting provisioned AWS resources
1. Go to the [OpsWorks](http://console.aws.amazon.com/opsworks) console and select the OpsWorks stack that you've launched. Delete the Apps and the Instances of the Stack. Once these are deleted, you can delete the Stack.
2. Go to the [CloudFormation](http://console.aws.amazon.com/cloudformation) console and delete the corresponding CloudFormation stack. You can match the timestamp in the name to the OpsWorks stack.
3. Go to the [EC2 Console](https://console.aws.amazon.com/ec2/) and delete the Ubuntu instance you spun up to launch everything from.

### Changes made to this Github Fork

A majority of the changes made to this github fork were additions in the infrastructure/ directory. Our scripts for building up the different AWS resources were added here. We added a `build_infrastructure.sh` bash script that utilizes several other files from the infrastucture directory for building a Honolulu Answers Opsworks stack. The scripts called consist of:
- `bin/create_database.rb` - Ruby script that calls `config/honolulu_rds.template` CloudFormation template to create a RDS database for the Honolulu Answers application
- `bin/create_honolulu_answers_stack.rb` - This creates and configures the Honolulu Answers Opsworks stack
- `bin/route53switch.rb` - This is currently unused, but is intended for doing blue/green deployments
- `bin/create_cloudformation_stack.rb` - This is currently unused, but is intended for using CloudFormation to launch Opsworks stacks instead of ruby scripts.
- `bin/wait_for_stack.rb` - This currently unused, but will work with CloudFormation
- `config/honolulu.template` - This currently unused, but will be the CloudFormation template for launching a Honolulu Answers Opsworks stack.
- `config/honolulu_rds.template` - CloudFormation template used for creating the RDS database.
- `config/rds_params.json` - Json property file for defining rds parameters

There were some minor changes to the app, moving some configuration out of environment variables into a configuration file. Now there's a `config/config.yml`. We now specify app configuration values in this file rather than relying on environment variables. This file is loaded using the `config/application.rb`. The modified files include:
- `config/initializers/tanker.rb`

### AWS Services Used
#### OpsWorks

AWS OpsWorks is an application management service that let's you model your application infrastructure and then takes care of provisioning Amazon EC2 instances.

#### RDS
Amazon's Relational Database Service takes care of all the DB administration, and let's you just work with the data store. We spun up a postgreSQL RDS instance, and then configure it to work with the Honolulu Answers Application.

#### CloudFormation
AWS CloudFormation is a service for defining your AWS infrastructure requirements in an executable JSON file. AWS CloudFormation gives developers and systems administrators an easy way to create and manage a collection of related AWS resources, provisioning and updating them in an orderly and predictable fashion.

### Other Tools Used
#### Jenkins

Jenkins is a Continuous Integration server that handles facilitating all of our automation.

#### Cucumber

Cucumber is a tool for running automated tests written in a human readable feature format. 
