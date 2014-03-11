require 'pp'
require 'trollop'
require 'aws-sdk-core'
require 'opsworks'

opts = Trollop::options do
  opt :stackid, "Stack ID to monitor", :type => String, :required => true
end


ops = Aws::OpsWorks.new(region: 'us-east-1')

ops.describe_instances