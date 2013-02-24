# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(100)      not null
#  username           :string(30)       not null
#  email              :string(255)      not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :integer
#

FactoryGirl.define do
  factory :user do |user|
    user.name { generate(:random_name) }
    user.username { generate(:random_username) }
    user.email { generate(:random_email) }
    user.password "secret"
    user.password_confirmation "secret"
  end
end
