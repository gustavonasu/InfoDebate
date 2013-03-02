namespace :db do
  desc "Fill database with comments sample data"
  task :populate_comments => :environment do
    require 'faker'
    if Comment.count == 0
      make_comments
    end
  end
end


def make_comments
  ForumThread.all.each do |thread|
    5.times {
      comment = Comment.new(:body => Faker::Lorem.paragraph)
      comment.user = User.first(:offset => rand(User.count))
      comment.thread = thread
      comment.save!
      
      if comment.id % 2 == 0
        rand(10).times {
          comment.children.create(:body => Faker::Lorem.paragraph,
                                  :user => User.first(:offset => rand(User.count)))
        }
      end
    }
  end
end