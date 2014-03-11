## Honolulu Answers AWS Scripting Proof of Concept

Hi there. We used this repo to demonstrate how to script the Honolulu Answers app to deploy in [Amazon Web Services](https://aws.amazon.com/) (AWS). This fork is not intended to be merged back into the original, and we don't plan on keeping it updated with any changes to made to the original. You will incur AWS charges while resources are in use. Use this application at your own risk!

## Setting up the Honolulu Answers application
#### Prereqs:
* [AWS Access Keys](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) ready and enabled.
* [AWS CLI tool](https://aws.amazon.com/cli/) installed and configured. The quickest way to do this is by launching an Amazon Linux EC2 instance (as the AWS CLI is preinstalled), but you can install them on your laptop as well, and then configure the application by using the command:


    ```aws configure```

Once you're AWS CLI tools are set up, clone this repo and this command will build a Honolulu Answers application infrastructure and then deploy the app to it.

    git clone https://github.com/stelligent/honolulu_answers.git
    aws cloudformation create-stack --stack-name HonoluluAnswers --template-body "`cat infrastructure/config/honolulu.template`" --region ${region}  --disable-rollback --capabilities="CAPABILITY_IAM"

NOTE: Alternatively, you can use Jenkins to run through the above steps. After about 50 minutes, an Opsworks stack is created and launched. To get details:

1. Log into the [OpsWorks](http://console.aws.amazon.com/opsworks) console
3. You should see an OpsWorks stack listed named **Honolulu Answers** -- click on it. If you see more than one listed (because you kicked it off a few times), they are listed in alphabetical-then-chronological order. So the last *Honolulu Answers* stack listed will be the most recent one.
4. Click on **Instances** within the OpsWorks stack you selected.
5. Once the Instance turns green and shows its status as *Online*,you can click the IP address link and the Honolulu Answers application will load!

### Deleting provisioned AWS resources
* Go to the [CloudFormation](http://console.aws.amazon.com/cloudformation) console and delete the corresponding CloudFormation stack. 

### Changes made to this Github Fork

A majority of the changes made to this github fork were additions in the [`infrastructure/`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure) directory of this repo. Our scripts for building up the different AWS resources were added here. 
- [`build.sh`](https://github.com/stelligent/honolulu_answers/tree/master/build.sh) - runs the unit tests for the application.
- [`infrastructure/build-and-deploy.sh`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure/build-and-deploy.sh) bash script that builds a Honolulu Answers infrastructure in AWS and then deploys the application to it. It uses other files from the infrastucture directory for building a Honolulu Answers Opsworks stack. 
- [`infrastructure/config/honolulu.template`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure/config/honolulu.template)  - This cloudformation template defines the RDS instances, IAM roles, and OpsWorks stacks that go into the Honolulu Answers infrastructure.
- [`infrastructure/bin/monitor_stack.rb`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure/bin/monitor_stack.rb) This is used by Jenkins to determine if the stack is up yet.
- [`infrastructure/test-application.sh`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure/test-application.sh) - this script is used to run the acceptance stage tests against the application.
- [`infrastructure/terminate-env.sh`](https://github.com/stelligent/honolulu_answers/tree/master/infrastructure/terminate-env.sh) - this script is used to tear down a provisioned Honolulu Answers application.

There were some minor changes to the app, moving some configuration out of environment variables into a configuration file. Now there's a [`config/config.yml`](https://github.com/stelligent/honolulu_answers/tree/master/config/config.yml). We now specify app configuration values in this file rather than relying on environment variables. This file is loaded using the [`config/application.rb`](https://github.com/stelligent/honolulu_answers/tree/master/config/application.rb). The modified files include:
- [`config/initializers/tanker.rb`](https://github.com/stelligent/honolulu_answers/tree/master/config/initializers/tanker.rb)

### AWS Services Used
#### OpsWorks

AWS OpsWorks is an application management service that let's you model your application infrastructure. It manages the provisioning of EC2 instances, integrates with VPC, ELB and Elastic IP and provides Auto Healing and Monitoring. OpsWorks can be configured to make calls to your Chef cookbooks for configuring servers, run deployments, etc.

#### RDS
Amazon's Relational Database Service takes care of all the DB administration, and let's you just work with the data store. We spun up a postgreSQL RDS instance, and then configure it to work with the Honolulu Answers Application.

#### CloudFormation
AWS CloudFormation is a service for defining your AWS infrastructure requirements in an executable JSON file. AWS CloudFormation gives developers and systems administrators an easy way to create and manage a collection of related AWS resources, provisioning and updating them in an orderly and predictable fashion.

### Other Tools Used
#### Jenkins

Jenkins is a Continuous Integration server that runs all of the automation code we've written. 

Stelligent's CI server is running at [demo-ci.elasticoperations.com](http://demo-ci.elasticoperations.com/). It polls multiple Github repos for changes. When a change is discovered, it initiates the pipeline. If the pipeline is successful, it creates an OpsWorks stack. We copy the IP Address of the OpsWorks stack instance and point the demo.elasticoperations.com subdomain to map to this instance (this will be automated) using [Amazon Route 53](https://aws.amazon.com/route53/).

The instruction for running your own Jenkins server and pipeline is located here: [honolulu_jenkins_cookbooks](https://github.com/stelligent/honolulu_jenkins_cookbooks).

#### Cucumber

Cucumber is a tool for running automated tests written in a human readable feature format. 

## Resources 
### Working Systems

* [demo-ci.elasticoperations.com](http://demo-ci.elasticoperations.com/) - Working Continous Integration Server. To setup your own Jenkins server based on our open source scripts, go to [honolulu_jenkins_cookbooks](https://github.com/stelligent/honolulu_jenkins_cookbooks).
* [demo.elasticoperations.com](http://demo.elasticoperations.com/) - Working Honolulu Answers application based on the automation described in this README. 

### Diagrams
![Infrastructure Architecture](https://s3.amazonaws.com/stelligent_casestudies/infrastructure_architecture_honolulu_poc.png "Infrastructure Architecture")

![Infrastructure Scripts](https://s3.amazonaws.com/stelligent_casestudies/infrastructure_scripts_honolulu_poc.png "Infrastructure Scripts")


