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
    forum.name "Forum Name"
    forum.description "Forum Description"
  end
  
  sequence :forum_name do |n|
    "Forum #{n}"
  end
  
  URL_PATTERN = 'http://content.com/content/#{content_id}'
  
  factory :forum_thread do |thread|
    thread.name "Thread Name"
    thread.description "Thread Description"
    content_id = 1
    thread.content_id content_id
    thread.url Kernel.eval("\"" + URL_PATTERN + "\"")
    thread.forum :forum
  end
  
  sequence :thread_name do |n|
    "Thread #{n}"
  end
  
  sequence :content_url do |n|
    "http://infodebate.com/content/#{n}"
  end
end
