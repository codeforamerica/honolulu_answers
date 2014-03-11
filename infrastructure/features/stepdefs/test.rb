require "aws-sdk-core"

Given(/^I have the CloudFormation stack information to query$/) do
  # the name of the cloudformation stack and the region we're operating should be environment variables
  @stackname = ENV["stack_name"]
  expect(@stackname).to be, "$stack_name wasn't set in the local environment"
  region = ENV["region"]
  expect(region).to be, "$region wasn't set in the local environment"

  # poll cfn for instance ID
  cfn = Aws::CloudFormation.new region: region
  instance_ids = cfn.describe_stack_resources(stack_name: @stackname).stack_resources.collect {|rsc| if rsc.resource_type == "AWS::OpsWorks::Instance" then rsc.physical_resource_id end }.compact

  # using the instance ID, get the IP address
  ops = Aws::OpsWorks.new region: "us-east-1"
  @ip_address = ops.describe_instances( instance_ids: instance_ids).instances.first["public_ip"]
  expect(@ip_address).to be, "No IP address associated with stack."
end


When(/^I pull up the Honolulu Answers application$/) do
  @error = nil
  begin
    # the trailing / is important!!
    url = "http://#{@ip_address}/"
    @response = Net::HTTP.get_response(URI.parse(url).host, URI.parse(url).path)
  rescue Exception => e
    @error = e
  end
end

Then(/^I should get data back$/) do
    expect(@failure).to eq(nil), "An error occured when trying to open the application: #{@failure}"
    expect(@response.code).to eql("200"), "Non 200 code returned"
    expect(@response.body.length).to be > 0, "No data receieved"
end
