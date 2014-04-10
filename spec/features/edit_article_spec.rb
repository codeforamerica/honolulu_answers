require 'spec_helper'

describe "Edit a quick-answer" do
  it "contains a link to the markdown style guide" do
    admin_sign_in
    answer = FactoryGirl.create(:quick_answer)
    visit edit_admin_quick_answer_path(answer)

    expect(page).to have_selector("a#markdown-cheatsheet")
  end
end
