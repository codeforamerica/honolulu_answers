Chef::Log.info("Running deploy/before_restart.rb")

# map the environment_variables node to ENV
node[:deploy].each do |application, deploy|
  deploy[:environment_variables].each do |key, value|
    Chef::Log.info("Setting ENV[#{key}] to #{value}")
    ENV[key] = value
  end
end