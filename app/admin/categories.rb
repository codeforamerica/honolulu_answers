ActiveAdmin.register Category do
  # This will authorize the Foobar class
  # The authorization is done using the AdminAbility class
  controller.authorize_resource
end
