require 'faker'

FactoryGirl.define do
  sequence(:random_string) {|n| Faker::Lorem.characters }
  
  sequence(:random_integer) {|n| n }
  
  sequence(:random_url) {|n| Faker::Internet.url }
end