FactoryGirl.define do
  factory :user do
    name 'Foo Bar'
    email 'foo.bar@gmail.com'
    password 'foobar'
    password_confirmation 'foobar'
  end  
end