require 'pp'
require 'trollop'
require 'aws-sdk-core'

opts = Trollop::options do
  opt :blue, 'IP address of the old server', :type => String, :required => true
  opt :green, 'IP address of the new server', :type => String, :required => true
  opt :subdomain, "The sub-domain that should be switched to point to the new address (just the subdomain. For example, for demo.stelligent.com, you'd punch in 'demo')", :type => String, :required => true
  opt :hostedzone, "The hosted zone name that should be switched to point to the new address (This is the domain. For example, for demo.stelligent.com, you'd punch in 'stelligent.com')", :type => String, :required => true
end

r53 = Aws::Route53.new(region: 'us-east-1')

zones = r53.list_hosted_zones 
# pp zones
hosted_zone = nil
zones.hosted_zones.each do |zone|
  # pp zone
  if (zone.name == opts[:hostedzone])
    hosted_zone = zone
  end
end

if hosted_zone.nil?
  puts "Couldn't find hosted zone name #{opts[:hostedzone]}"
  exit 1
else
  full_address = "#{opts[:subdomain]}.#{opts[:hostedzone]}"

  r53.change_resource_record_sets hosted_zone_id: hosted_zone.id.split('/')[2], change_batch: 
  { 
    changes: 
    [
      {
        action: "DELETE", 
        resource_record_set: {
          name: full_address, 
          type: "A",
          ttl: 300,
          resource_records: [
            {
              value: "#{opts[:blue]}"
            }
          ]
        } 
      },
      {
        action: "CREATE", 
        resource_record_set: {
          name: full_address, 
          type: "A",
          ttl: 300,
          resource_records: [
            {
              value: "#{opts[:green]}"
            }
          ]
        } 
      }
    ] 
  }
end 