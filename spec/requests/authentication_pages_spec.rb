require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    describe "check content" do
      it { should have_selector('h1', text: 'Sign in') }
      it { should have_selector('title', text: full_title('Sign in')) }

      it { should have_no_link "Users" }
      it { should have_no_link "Profile" }
      it { should have_no_link "Settings" }
      it { should have_no_link "Sign out" }
    end

    describe "with invalid information" do
      before { click_button "Sign in"}

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector 'div.alert.alert-error', text: 'Invalid' }

      describe "after withitin another page" do
        before { click_link "Home" }

        it { should have_no_selector 'div.alert.alert-error' }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create :user }

      before { sign_in user }

      it { should have_selector "title", text: user.name}

      it { should have_link "Users", href: users_path }
      it { should have_link "Profile", href: user_path(user) }
      it { should have_link "Settings", href: edit_user_path(user) }
      it { should have_link "Sign out", href: signout_path }

      it { should have_no_link "Sign in", href: signin_path }
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create :user }

    describe "for non-signed-in users" do

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector 'title', text: 'Sign in' }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path user
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector 'title', text: 'Edit user'
          end

          describe "when signing in again" do
            before do
              delete signout_path
              sign_in user
            end

            it "should render the default (profile) page" do
              page.should have_selector 'title', text: user.name
            end
          end
        end
      end

      describe "visiting the user index" do
        before { visit users_path }
        it { should have_selector 'title', text: 'Sign in' }
      end
    end

    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create :user, email: "wrong@example.com" }

      before {sign_in user}

      describe "visiting User#edit page" do
        before { visit edit_user_path wrong_user }
        it { should have_no_selector 'title', text: full_title('Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path wrong_user }
        specify { response.should redirect_to root_path }
      end
    end

    describe "as non-admin user" do
      let(:non_admin) { FactoryGirl.create :user }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path user }
        specify { response.should redirect_to root_path }
      end

      specify "submitting a PUT request to the Users#update action to toggle admin attribute" do
        expect do
          put user_path(non_admin), user: {admin: 1}
        end.to raise_error ActiveModel::MassAssignmentSecurity::Error, "Can't mass-assign protected attributes: admin"
      end
    end

    describe "as an user" do
      describe "in the Users controller" do
        before { sign_in user }

        describe "visiting the sign up page" do
          before { visit signup_path }

          it { should have_no_selector('h1', text: 'Sign up') }
        end

        describe "submitting to the create action" do
          before { post users_path }

          specify { response.should redirect_to user_path user }
        end
      end
    end
  end
end
