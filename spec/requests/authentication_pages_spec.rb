require 'spec_helper'

describe "Authentication" do
  
  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }

    describe "with valid input" do
      let(:user) { FactoryGirl.create(:user) }
      before { mock_sign_in user }

      it { should have_title(user.name) }
      it { should have_signed_in_nav_links_for_user(user) }
      it { should_not have_signin_link }

    end

    describe "with invalid input" do
      let(:invalid_user) { FactoryGirl.create(:user, email:'wrong@example.com') }
      before { mock_sign_in invalid_user }

      it { should have_title('Sign in') }
      it { should have_signin_link }
      it { should have_an_error_message }
      it { should_not have_signed_in_nav_links_for_user(invalid_user) }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_an_error_message } #checks to make sure flash only persists for one request
      end
    end
  end

  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "when signing in to access a protected page" do
          before do
            visit edit_user_path(user)
            fill_in 'Email',    with: user.email
            fill_in 'Password', with: user.password
            click_button 'Sign in'
          end

          describe 'after signing in' do
            it 'should render the protected page' do
              expect(page).to have_title('Edit user') 
            end
          end
        end

        describe 'visiting the user index' do 
          before { visit users_path }
          it { should have_title('Sign in') }
        end

      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { mock_sign_in user, no_capybara: true }

      describe "submitting GET request to Users#edit" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response.body).to redirect_to(root_url) }
      end

      describe "submitting PATCH request to Users#update" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { mock_sign_in non_admin, no_capybara: true }

      describe "submitting DELETE request to Users#destroy" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end



