# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "MyString"
    access_count 1

    factory :category_with_articles do
      after(:build) do |category|
        category.articles = [FactoryGirl.create(:article_with_category,
         :category => category)]
      end
    end
    
  end
end
