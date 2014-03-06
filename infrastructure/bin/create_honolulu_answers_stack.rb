#Copyright (c) 2014 Stelligent Systems LLC
#
#MIT LICENSE
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

STDOUT.sync = true

require 'aws-sdk-core'
require 'trollop'

# we set up a CLoudFormation stack, and we need to know if it's done yet. These are the statuses indicating "not done yet"
PROGRESS_STATUSES = [ "CREATE_IN_PROGRESS",
  "ROLLBACK_IN_PROGRESS",
  "DELETE_IN_PROGRESS",
  "UPDATE_IN_PROGRESS",
  "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS",
  "UPDATE_ROLLBACK_IN_PROGRESS",
  "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS" ]

# checks to see if the cfn stack is done yet
def stack_in_progress cfn_stack_name
  status = @cfn.describe_stacks(stack_name: cfn_stack_name).stacks.first[:stack_status]
  return PROGRESS_STATUSES.include? status
end

# used to print status without newlines
def print_and_flush(str)
  print str
  STDOUT.flush
end

# using trollop to do command line options
opts = Trollop::options do
  opt :region, 'The AWS region to use', :type => String, :default => "us-west-2"
  opt :zone, 'The AWS availability zone to use', :type => String, :default => "us-west-2a"
  opt :source, 'The github repo where the source to build resides (will not work with anything but github!)', :type => String, :default => "https://github.com/stelligent/honolulu_answers.git"
  opt :size, 'The instance size to use', :type => String, :default => "m1.large"
  opt :db, 'Hostname of the DB server', :type => String, :required => true
  opt :accountnumber, 'Account number of your AWS account (no dashes!)', :type => String, :required => true

end

# create the opsworks stack
ops = Aws::OpsWorks.new region: "us-east-1"

# alright, let's do this.
puts "You're creating a Honolulu Answers instance in the #{opts[:region]} region. (size: #{opts[:size]})"
@timestamp = Time.now.strftime "%Y%m%d%H%M%S"

aws_region = opts[:region]
aws_az = opts[:zone]
instance_type = opts[:size]
# curious what the AWS calls look like? set http_wire_trace to true.
Aws.config = { region: aws_region, http_wire_trace: false }

# stelligent prod values
# servicerolearn = "arn:aws:iam::923120264911:role/aws-opsworks-service-role"
# ec2rolearn = "arn:aws:iam::923120264911:instance-profile/aws-opsworks-ec2-role"

# stelligent labs values
servicerolearn = "arn:aws:iam::#{opts[:accountnumber]}:role/aws-opsworks-service-role"
ec2rolearn = "arn:aws:iam::#{opts[:accountnumber]}:instance-profile/aws-opsworks-ec2-role"

# opsworks configuration is passed in as json
custom_json = <<-END
{
      "deploy" : {
        "honoluluanswers" : {
            "database": {
                "reconnect": true,
                "adapter" : "postgresql",
                "password": "password",
                "username": "honolulu",
                "host": "#{opts[:db]}",
                "port": "5432",
                "database": "honoluluanswers"
            },
            "environment_variables" : {
                "NEW_RELIC_LICENSE_KEY": "dunno",
                "NEW_RELIC_APP_NAME": "dunno",
                "S3_BUCKET": "honolulu-test-bucket",
                "S3_KEY" : "YOURACCESSKEY",
                "S3_SECRET" : "YOURSECRETKEY",
                "SEARCHIFY_API_URL" : "http://:oh5H697EC1TRlc@2zqe.api.searchify.com",
                "SEARCHIFY_API_INDEX" : "hnlgovanswers-dev"
            },

          "migrate" : true
        }
      }
    }
END

# create a new opsworks stack
stack_params =     {
      :name => "Honolulu Answers",
      :region => aws_region,
      :default_os => 'Ubuntu 12.04 LTS',
      :default_availability_zone => 'us-west-2c',
      :custom_json => custom_json,
      :use_custom_cookbooks => false,
      # :custom_cookbooks_source => {
      #   :type => 'git',
      #   :url => 'https://github.com/stelligent/canaryboard_chefrepo.git',
      # },
      :service_role_arn => servicerolearn,
      :default_instance_profile_arn => ec2rolearn
    }


# detect whether or not the account has a default VPC set up. If so, use that.
@ec2 = Aws::EC2.new
default_vpc = @ec2.describe_account_attributes(attribute_names: ["default-vpc"]) == "none"
if default_vpc
  stack_params[:vpc_id] = @ec2.describe_account_attributes(attribute_names: ["default-vpc"]).account_attributes.first.attribute_values.first.attribute_value
end

# opsworks is "regionless" but really "only in us-east-1"
Aws.config = { region: "us-east-1", http_wire_trace: false }

puts "creating OpsWorks stack..."
stack = ops.create_stack stack_params


# create layer for CanaryBoard
layer_params = {
      stack_id: stack.stack_id,
      :type => 'rails-app',
      :name => 'rails',
      :shortname => 'rails',
      :packages => %w{git postgresql libxslt1-dev libxml2-dev libsasl2-dev libpq-dev sqlite3 memcached build-essential libsqlite3-dev libhunspell-1.3-0 gettext},
#      :custom_recipes => {
#        :deploy => %w{canaryboard::https-redirect}
#      },
      :attributes => {
        'BundlerVersion' => '1.3.5',
        'PassengerVersion' => '4.0.29',
        'RailsStack' => 'apache_passenger',
        'RubyVersion' => '1.9.3',
        'RubygemsVersion' => '2.1.11'
      }
    }

puts "creating OpsWorks Rails layer..."
layer = ops.create_layer layer_params

# create CanaryBoard app
app_params = {
      stack_id: stack.stack_id,
      :name => 'honoluluanswers',
      :type => 'rails',
      :app_source => {
        :type => 'git',
        :url => 'https://github.com/stelligent/honolulu_answers.git',
      },
      :attributes => {
        'RailsEnv' => 'development',
        'DocumentRoot' => 'public',
        'AutoBundleOnDeploy' => 'true'
      }
    }

puts "creating OpsWorks app..."
app = ops.create_app app_params

# create CanaryBoard instance
instance_params =     {
      stack_id: stack.stack_id,
      layer_ids: [layer.layer_id],
      instance_type: instance_type,
      hostname: "honoluluanswers",
#      ssh_key_name: "jonny-labs-west2",
      :root_device_type => 'ebs',
      :architecture => 'x86_64'
    }


puts "creating OpsWorks Rails instance..."
instance = ops.create_instance instance_params

# start the instance and if the start command succeeds, we're good. It'll take a good while for the instance to boot up, tho.
ops.start_instance instance_id: instance.instance_id

File.open("./ops_stackid", 'w') { |file| file.write(stack.stack_id) }
