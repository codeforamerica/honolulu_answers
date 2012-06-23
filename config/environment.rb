# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Honoluluanswers::Application.initialize!

ENV['LD_LIBRARY_PATH'] ||="/usr/lib"
ENV['LD_LIBRARY_PATH'] +=":/app/lib/native"