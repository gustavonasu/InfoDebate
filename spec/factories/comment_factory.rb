FactoryGirl.define do
  factory :comment do |comment|
    comment.body "Comment Text"
  end
  
  sequence :text_comment do |n|
    "Comment Text #{n}"
  end
end