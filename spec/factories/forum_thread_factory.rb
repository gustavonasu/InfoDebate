# == Schema Information
#
# Table name: forum_threads
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  url         :string(500)
#  status      :integer          not null
#  content_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  forum_id    :integer          not null
#

FactoryGirl.define do  
  
  factory :forum_thread do |thread|
    thread.name { generate(:thread_name) }
    thread.description { generate(:random_string) }
    thread.content_id { generate(:random_integer) }
    thread.url { generate(:random_url) }
    
    trait :with_forum do
      association :forum, :factory => :forum, :strategy => :create
    end
    
    factory :full_forum_thread, traits: [:with_forum]
  end
  
  sequence :thread_name do |n|
    "Thread #{n}"
  end
end
