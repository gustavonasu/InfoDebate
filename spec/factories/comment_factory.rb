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
    comment.body "Comment Text"
  end
  
  sequence :text_comment do |n|
    "Comment Text #{n}"
  end
  
  factory :complaint do |complaint|
    complaint.body "Complaint Text"
  end
  
  sequence :text_complaint do |n|
    "Complaint Text #{n}"
  end
end
