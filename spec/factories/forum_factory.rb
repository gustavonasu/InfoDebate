# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :forum do |forum|
    forum.name { generate(:forum_name) }
    forum.description { generate(:random_string) }
  end
  
  sequence :forum_name do |n|
    "Forum #{n}"
  end
end
