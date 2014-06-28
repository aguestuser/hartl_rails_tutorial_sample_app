require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let!(:user_post) { FactoryGirl.create(:micropost, user: user) }
  let(:user2) { FactoryGirl.create(:user) }
  let!(:user2_post1) { FactoryGirl.create(:micropost, user: user2) }
  let!(:user2_post2) { FactoryGirl.create(:micropost, user: user2) }
  
  before { mock_sign_in user }

  describe "micropost count on homepage" do
    
    describe "user with one post should have single count" do
      before { visit root_path }
      it { should have_selector('span', text: '1 micropost') }
      it { should_not have_selector('span', text: 'microposts') }      
    end

    describe "user with two posts should have plural count" do
      before do
        click_link "Sign out"
        mock_sign_in user2
        visit root_path
      end
        it { should_not have_selector('span', text: '1 micropost') }
        it { should have_selector('span', text: 'microposts') }     
    end
  end

  describe "micropost creation from home page" do
    before { visit root_path }

    describe "with invalid input" do
      it "should not create a micropost" do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button 'Post' }
        it { should have_an_error_message }
      end
    end

    describe "with valid input" do
      before { fill_in 'micropost_content', with: 'Lorem ipsum' }
      it "should create a micropost" do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
    end
  end  

  describe "micropost destruction" do

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost " do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
