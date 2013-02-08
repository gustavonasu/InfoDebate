FactoryGirl.define do
  factory :user do |user|
    user.name "Gustavo Nasu"
    user.username "gustavonasu"
    user.email "mhartl@example.com"
    user.password "secret"
    user.password_confirmation "secret"
  end
  
  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  sequence :username do |n|
    "username#{n}"
  end
  
  sequence :name do |n|
    "Name #{n}"
  end
end