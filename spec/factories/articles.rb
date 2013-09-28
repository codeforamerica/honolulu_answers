FactoryGirl.define do
  # these are required but not yet validated
  factory :article, :class => QuickAnswer do
    title "How can i test Honolulu Answers?"
    preview "Click the link to find out more"
    content_main "It's as easy as **using markdown** and \n\n## running specs"
    category
    contact
    user :factory => :writer

    trait :published do
      published true
    end

    trait :unpublished do
      published false
    end

    trait :pending_review do
      pending_review true
    end

    trait :not_pending_review do
      pending_review false
    end

    trait :draft do
      pending_review false
      published false
    end
  end
end
