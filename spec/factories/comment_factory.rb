# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string(4000)
#  thread_id  :integer          not null
#  user_id    :integer          not null
#  status     :integer          not null
#  dislike    :integer          default(0)
#  like       :integer          default(0)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :comment do |comment|
    comment.body { generate(:random_text) }
    
    trait :with_user do
      association :user, :factory => :user, :strategy => :create
    end
    
    trait :with_thread do
      association :thread, :factory => [:forum_thread, :with_forum], :strategy => :create
    end
    
    factory :full_comment, traits: [:with_user, :with_thread]
  end
end
