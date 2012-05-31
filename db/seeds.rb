# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
#


puts 'SETTING UP DEFAULT USER LOGIN'
print "Enter admin email: "
admin_email = STDIN.gets.to_s

user = User.create! :email => admin_email, :password => 'password123', :password_confirmation => 'password123', :admin => true
puts 'New user created: ' << user.email

Article.create([{title: 'Example 1', content: "Some example content goes here"}, {title: 'Example 2', content: "more example"}] )
puts 'Created example articles'
