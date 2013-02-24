# == Schema Information
#
# Table name: complaints
#
#  id         :integer          not null, primary key
#  comment_id :integer
#  body       :string(4000)
#  status     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :complaint do |complaint|
    complaint.body { generate(:random_text) }
    
    trait :with_user do
      association :user, :factory => :user, :strategy => :create
    end
    
    trait :with_comment do
      association :comment, :factory => [:comment, :with_thread, :with_user], :strategy => :create
    end
    
    factory :full_complaint, traits: [:with_user, :with_comment]
  end
end
