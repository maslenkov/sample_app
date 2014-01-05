include ApplicationHelper

def sign_in(user)
  fill_in "Email", with: user.email.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
  # for signining without capybara
  cookies[:remember_token] = user.remember_token
end
