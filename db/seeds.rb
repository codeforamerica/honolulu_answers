# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
#

admin_email = "admin@example.com"
admin_pw = "password"

## only create the user if there aren't any already
if (!User.first)
  user = User.create! :email => admin_email, :password => admin_pw, :password_confirmation => admin_pw, :is_admin => true, :is_moderator => true, :is_editor => true 
  puts 'New user created: ' << user.email
  puts "Admin password has been set to: #{admin_pw}"
else
  puts "User already exists, skipping User.create"
end


# ORDER IS IMPORTANT
Category.create([
                 { :name => "Air Quality" },
                 { :name => "Farming and Gardening" },
                 { :name => "Getting Involved" },
                 { :name => "Green Jobs" },
                 { :name => "Green Living and Home Improvement" },
                 { :name => "Green Space and Canopy" },
                 { :name => "Government" },
                 { :name => "Health" },
                 { :name => "Land Conservation" },
                 { :name => "Recreation" },
                 { :name => "Renewable Energy" },
                 { :name => "Recycling" },
                 { :name => "Sustainable Communities" },
                 { :name => "Transportation and Transit" },
                 { :name => "Water Conservation" },
                 { :name => "Water Quality" },
                 { :name => "Wildlife" },
                 { :name => "Waste" }
                ])

Contact.create([
                { :name => "Friends of Grand Rapids Parks", 
                  :subname => "", 
                  :number => "", 
                  :url => "http://www.friendsofgrparks.org", 
                  :address => "", 
                  :department => "", 
                  :description => "A citizen driven nonprofit, separate from the City, but working closely to protect, enhance and expand our community parks." }
               ])
