module SessionHelpers
  def admin_sign_in
    user = FactoryGirl.create(:admin)
    visit '/admin'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end
