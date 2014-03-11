require 'trollop'
require 'aws-sdk-core'

STDOUT.sync = true


# using trollop to do command line options
opts = Trollop::options do
  opt :region, 'The AWS region to use', :type => String, :default => "us-west-2"
  opt :stack, 'name of the stack to monitor', :type => String, :required => true
end


# we set up a CLoudFormation stack, and we need to know if it's done yet. These are the statuses indicating "not done yet"
PROGRESS_STATUSES = [
  "CREATE_IN_PROGRESS",
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

def print_and_flush(str)
  print str
  $stdout.flush
end

# create a cfn stack with all the resources the opsworks stack will need
@cfn = Aws::CloudFormation.new region: "us-west-2"

cfn_stack_name = opts[:stack]

print_and_flush "waiting for stack #{cfn_stack_name} to come up..."
while (stack_in_progress cfn_stack_name)
  print_and_flush "."
  sleep 30
end
puts

status = @cfn.describe_stacks(stack_name: cfn_stack_name).stacks.first[:stack_status]
exit(status == 'CREATE_COMPLETE' ? 0 : 1)
