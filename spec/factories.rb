FactoryGirl.define do
  factory :user do
    name 'Austin Guest'
    email 'guest.austin@gmail.com'
    password 'foobar'
    password_confirmation 'foobar'
  end  
end