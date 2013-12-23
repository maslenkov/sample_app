require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    describe "check content" do
      it { should have_selector('h1', text: 'Sign up') }
      it { should have_full_title_with 'Sign up' }
    end

    describe "signup" do
      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_full_title_with 'Sign up' }
          it { should have_content('6 errors'); }
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name", with: 'qw'
          fill_in "Email", with: 'qw@qw.qw'
          fill_in "Password", with: 'password'
          fill_in "Confirmation", with: 'password'
        end

        it "should create user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email 'qw@qw.qw' }

          it { should have_full_title_with user.name }
          it { should have_success_message 'Welcome' }
          it { should have_link('Sign out') }

          describe "followed by sign out" do
            before { click_link 'Sign out' }

            it { should have_link('Sign in')}
          end
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create :user }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_full_title_with user.name }
  end
end
