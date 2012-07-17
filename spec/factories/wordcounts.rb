# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wordcount do
    article
    keyword
    count 10
  end
end
