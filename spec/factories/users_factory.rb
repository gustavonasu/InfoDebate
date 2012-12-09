FactoryGirl.define do
  factory :commenter do |commenter|
    commenter.name "Gustavo Nasu"
    commenter.username "gustavonasu"
    commenter.email "mhartl@example.com"
    commenter.password "secret"
    commenter.password_confirmation "secret"
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