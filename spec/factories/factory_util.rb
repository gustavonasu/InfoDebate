require 'faker'

FactoryGirl.define do
  sequence(:random_string) {|n| Faker::Lorem.characters }
  
  sequence(:random_integer) {|n| n }
  
  sequence(:random_url) {|n| Faker::Internet.url }
  
  sequence(:random_email) {|n| Faker::Internet.email }
  
  sequence(:random_username) do |n| 
    username = Faker::Internet.user_name
    username += "_#{username}" if username.length < 3
    "username_#{n}"
  end
  
  sequence(:random_name) {|n| Faker::Name.name }
end