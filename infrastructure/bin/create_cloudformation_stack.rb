require 'aws-sdk-core'

STDOUT.sync = true

# we set up a CLoudFormation stack, and we need to know if it's done yet. These are the statuses indicating "not done yet"
PROGRESS_STATUSES = [
  'CREATE_IN_PROGRESS',
  'ROLLBACK_IN_PROGRESS',
  'DELETE_IN_PROGRESS',
  'UPDATE_IN_PROGRESS',
  'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS',
  'UPDATE_ROLLBACK_IN_PROGRESS',
  'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS' ]


# Parameterize
dbpassword = 'password'
cfn_stack_name = 'HonoluluAnswers-BSJ4'

# create a cfn stack with all the resources the opsworks stack will need
@cfn = Aws::CloudFormation.new region: 'us-west-2'

@cfn.create_stack(
  stack_name: cfn_stack_name,
  template_body: File.open('./infrastructure/config/honolulu.template', 'rb').read,
  capabilities: ['CAPABILITY_IAM'],
  timeout_in_minutes: 60,
  disable_rollback: true,
  parameters: [
    { parameter_key: 'DBPassword', parameter_value: dbpassword }
  ]
)

# checks to see if the cfn stack is done yet
def stack_in_progress cfn_stack_name
  status = @cfn.describe_stacks(stack_name: cfn_stack_name).stacks.first[:stack_status]
  return PROGRESS_STATUSES.include? status
end

def print_and_flush(str)
  print str
  $stdout.flush
end

print_and_flush 'creating required resources'
while (stack_in_progress cfn_stack_name)
  print_and_flush '.'
  sleep 30
end

# Creates a new line for cmd usability
print "\n"

# get the resource names out of the cfn stack so we can pass themto opsworks
resources = {}
@cfn.describe_stacks(stack_name: cfn_stack_name).stacks.first[:outputs].each do |output|
  resources[output[:output_key]] = output[:output_value]
end
