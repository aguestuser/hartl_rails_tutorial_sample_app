include ApplicationHelper

def mock_sign_in(user, options={})
  if options[:no_capybara]
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"    
  end
end

def check_nav_links()
  links = [
    { text: 'About' ,   new_page_title: 'About Us' },
    { text: 'Help',     new_page_title: 'Help' },
    { text: 'Contact',  new_page_title: 'Contact' },
    { text: 'Home',     new_page_title: '' },
    { text: '',         new_page_title: ''}
  ]
  links.each do |link|
    check_nav_link(link[:text], link[:new_page_title])
  end
end

def check_nav_link(link, title)
  click_link link
  expect(page).to have_title(full_title(title))
end

RSpec::Matchers.define :have_an_error_message do
  match do |page|
    expect(page).to have_selector('div.alert.alert-error')
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_a_success_message do
  match do |page|
    expect(page).to have_selector('div.alert.alert-success')
  end
end


RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end


RSpec::Matchers.define :have_heading do |heading|
  match do |page|
    expect(page).to have_selector('h1', text: heading)
  end
end

RSpec::Matchers.define :have_signout_link do
  match do |page|
    expect(page).to have_link('Sign out', href: signout_path)
  end
end

RSpec::Matchers.define :have_a_delete_link do
  match do |page|
    expect(page).to have_link('delete')
  end
end

RSpec::Matchers.define :have_delete_link_for_user do |user|
  match do |page|
    expect(page).to have_link('delete', href: user_path(user))
  end
end

def click_first_delete_link
  click_link('delete', match: :first)
end


