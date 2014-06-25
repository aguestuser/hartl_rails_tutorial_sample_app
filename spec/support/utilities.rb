include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
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

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
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


