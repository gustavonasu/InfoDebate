require 'faker'

FactoryGirl.define do
  sequence(:random_integer) {|n| n }
  
  sequence(:random_url) {|n| Faker::Internet.url }
  
  sequence(:random_email) {|n| Faker::Internet.email }
  
  sequence(:random_username) {|n| "#{Faker::Internet.user_name}_#{n}" }
  
  sequence(:random_name) {|n| Faker::Name.name }
  
  sequence(:random_text) {|n| Faker::Lorem.paragraph.truncate(255) }
end