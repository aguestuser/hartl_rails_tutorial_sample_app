require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do
    before do
      signin FactoryGirl.create(:user)
      FactoryGirl.create(:user, name:'Bob', email: 'bob@example.com')
      FactoryGirl.create(:user, name:'Ben', email: 'ben@example.com')
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }
    it 'should list each user' do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe 'signup page' do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit) { "Create my account" }
    
    describe "with invalid input" do
      
      it "should not create a new user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submisstion" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid input" do
      before do
        fill_in 'Name',         with: 'Foo Bar'
        fill_in 'Email',        with: 'foo.bar@example.com'
        fill_in 'Password',     with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'foo.bar@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      signin user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href:'http://gravatar.com/emails') }
    end

    describe "with invalid input" do
      before { click_button "Save changes" }

      it { should have_an_error_message }
    end

    describe "with valid input" do
      let(:new_name) { 'New Name' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_a_success_message }
      it { should have_signout_link }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

  end

end
