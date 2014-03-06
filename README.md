## honolulu answers aws scripting poc

Hi there. We used this repo to prove out that we could script the Honolulu Answers app deploy in AWS. This fork is not intended to be merged back into the original, and we don't plan on keeping it updated with any changes to made to the original. Use this application at your own risk!

## Setting up the Honolulu Answers application
1. Create a new [AWS IAM user](https://console.aws.amazon.com/iam/home) and download the access keys. This user should have Aministrator permissions
2. Launch an Ubuntu 12.04 ec2 instance in AWS
3. SSH into the Ubuntu 12.04 ec2 instance
4. Export your AWS Access Keys from the AWS IAM user you created in step #1:
```
export AWS_ACCESS_KEY_ID=YOURACCESSKEY
export AWS_SECRET_ACCESS_KEY=YOURSECRETKEY
```

5. Run the commands listed below:
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
1. Log into the AWS Management Console
2. Go to the OpsWorks control panel
3. You should see an OpsWorks stack listed named "Honolulu Answers" -- click on it. If you see more than one listed (because you kicked it off a few times), they are listed in alphabetical-then-chronological order. So the last "Honolulu Answers" stack listed will be the most recent one.
4. Click on Instances
5. Once the Instance turns green and shows its status as "online" you can click the IP address and the Honolulu Answers application should load!
