RSpec::Matchers.define :be_published do
  match do |actual|
    actual.published
  end
end

RSpec::Matchers.define :be_pending_review do
  match do |actual|
    actual.pending_review
  end
end

RSpec::Matchers.define :be_draft do
  match do |actual|
    !actual.pending_review && !actual.published
  end
end
