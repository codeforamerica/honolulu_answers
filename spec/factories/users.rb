FactoryGirl.define do
  factory :user do
    email
    password "123456abcdef"
    password_confirmation "123456abcdef"

    factory(:writer) { is_writer true }
    factory(:editor) { is_editor true }
    factory(:admin) { is_admin true }
  end

  sequence :email do |n|
    "hnlanswersuser#{n}@example.com"
  end
end
