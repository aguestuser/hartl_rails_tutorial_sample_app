require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { mock_sign_in user }

  describe "micropost creation from home page" do
    before { visit root_path }

    describe "with valid input" do
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
end
