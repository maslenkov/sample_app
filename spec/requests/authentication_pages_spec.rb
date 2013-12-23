require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "check content" do
      it { should have_selector('h1', text: 'Sign in') }
      it { should have_full_title_with 'Sign in' }
    end

    describe "with invalid information" do
      before { click_button "Sign in"}

      it { should have_full_title_with 'Sign in' }
      it { should have_error_message 'Invalid' }

      describe "after withitin another page" do
        before { click_link "Home" }

        it { should have_no_selector 'div.alert.alert-error' }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create :user }

      before { valid_signin user }

      it { should have_full_title_with user.name }
      it { should have_link "Profile", href: user_path(user) }
      it { should have_link "Sign out", href: signout_path }
      it { should have_no_link "Sign in", href: signin_path }
    end
  end
end
