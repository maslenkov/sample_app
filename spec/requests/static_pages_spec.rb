require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', :text => full_title(page_title)) }
  end

  describe "Home page" do
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    before { visit root_path }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', :text => "| Home") }

    describe "for signed-in user" do
      let(:user) { FactoryGirl.create :user }

      before do
        FactoryGirl.create :micropost, user: user, content: "Lorem ipsum"
        FactoryGirl.create :micropost, user: user, content: "Dolor sit amet"
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "microposts count" do
        describe 'for single micropost' do
          before do
            user.microposts.last.destroy
            visit root_path
          end

          it { page.should have_content '1 micropost' }
          it { page.should have_no_content 'microposts' }
        end

        describe 'if there are no messages' do
          before do
            user.microposts.destroy_all
            visit root_path
          end

          it { page.should have_content '0 microposts' }
        end

        describe 'for several microposts' do
          it { page.should have_content '2 microposts' }
        end
      end
    end
  end

  describe "Help page" do
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    before { visit help_path }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    before { visit about_path }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    before { visit contact_path }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link 'About'
    should have_selector('title', text: full_title('About Us'))
    click_link 'Help'
    should have_selector('title', text: full_title('Help'))
    click_link 'Contact'
    should have_selector('title', text: full_title('Contact'))
    click_link 'Home'
    click_link 'Sign up now!'
    should have_selector('title', text: full_title('Sign up'))
    click_link 'sample app'
    should have_selector('title', text: full_title(''))
  end
end
