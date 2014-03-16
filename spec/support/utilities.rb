include ApplicationHelper

def sign_in(user, options = {})
  if options[:no_capybara]
    cookies[:remember_token] = user.remember_token
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    cookies[:remember_token] = user.remember_token
  end
end
