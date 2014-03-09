require 'spec_helper'

describe "MicropostPages" do
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error')}
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as non correct user" do
      let(:another_user) { FactoryGirl.create(:user) }
      let!(:micropost)   { FactoryGirl.create(:micropost, user: another_user) }

      before { visit user_path another_user }

      it "should have micropost" do
        page.should have_content micropost.content
      end

      it "should have no delete link" do
        page.should have_no_link 'delete'
      end
    end
  end
end
