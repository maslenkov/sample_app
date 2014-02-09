require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    describe "check content" do
      it { should have_selector('h1', text: 'Sign up') }
      it { should have_selector('title', text: full_title('Sign up')) }
    end

    describe "signup" do
      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
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

          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign out') }

          describe "followed by sign out" do
            before { click_link 'Sign out' }

            it { should have_link('Sign in')}
          end
        end
      end
    end
  end

  context 'user exists' do
    let(:user) { FactoryGirl.create :user }

    describe "edit" do
      before do
        sign_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector('h1', text: "Update your profile") }
        it { should have_selector('title', text: "Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end

      describe "with valid information" do
        let(:new_name) { "New name" }
        let(:new_email) { "new@example.com" }

        before do
          fill_in "Name", with: new_name
          fill_in "Email", with: new_email
          fill_in "Password", with: user.password
          fill_in "Confirmation", with: user.password
          click_button "Save changes"
        end

        it { should have_selector('title', text: new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }

        specify { user.reload.name.should == new_name }
        specify { user.reload.email.should == new_email }
      end
    end

    describe "index" do
      before do
        sign_in user
        visit users_path
      end

      it { should have_selector 'title', text: 'All users' }
      it { should have_selector 'h1', text: 'All users' }

      describe "pagination" do

        before(:all) { 30.times { FactoryGirl.create :user } }
        after(:all)  { User.delete_all }

        it { should have_selector 'div.pagination' }

        it "should list each user" do
          User.paginate(page: 1).each do |user|
            should have_selector 'li', text: user.name
          end
        end
      end

      describe "delete links" do

        it { should have_no_link 'delete' }

        describe "as an admin user" do
          let(:admin) { FactoryGirl.create :admin }
          before do
            sign_in admin
            visit users_path
          end

          it { should have_link 'delete', href: user_path(user) }
          it "should be able to delete another user" do
            expect { click_link 'delete' }.to change(User, :count).by(-1)
          end
          it { should have_no_link 'delete', href: user_path(admin) }

          specify "delete them self" do
            expect { delete user_path(admin) }.not_to change(User, :count)
            response.should redirect_to users_path
            flash[:error].should be_eql "You can not delete them self."
          end
        end
      end
    end

    describe "profile page" do
      let!(:m1) { FactoryGirl.create :micropost, user: user, content: "Foo" }
      let!(:m2) { FactoryGirl.create :micropost, user: user, content: "Bar" }

      before { visit user_path(user) }

      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name) }

      describe "microposts" do
        it { should have_content 'Foo' }
        it { should have_content 'Bar' }
        it { should have_content 2 }
      end
    end
  end
end
