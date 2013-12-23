require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_full_title_with page_title }
  end

  describe "Home page" do
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    before { visit root_path }

    it_should_behave_like "all static pages"
    it { should_not have_full_title_with "| Home" }
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
    should have_full_title_with 'About Us'
    click_link 'Help'
    should have_full_title_with 'Help'
    click_link 'Contact'
    should have_full_title_with 'Contact'
    click_link 'Home'
    click_link 'Sign up now!'
    should have_full_title_with 'Sign up'
    click_link 'sample app'
    should have_full_title_with ''
  end
end
