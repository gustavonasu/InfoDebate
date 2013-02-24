FactoryGirl.define do
  factory :user do |user|
    user.name { generate(:random_name) }
    user.username { generate(:random_username) }
    user.email { generate(:random_email) }
    user.password "secret"
    user.password_confirmation "secret"
  end
end