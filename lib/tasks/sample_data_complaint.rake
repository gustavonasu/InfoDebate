namespace :db do
  desc "Fill database with complaints sample data"
  task :populate_complaints => :environment do
    require 'faker'
    if Complaint.count == 0
      make_complaints
    end
  end
end


def make_complaints
  50.times {
      complaint = Complaint.new(:body => Faker::Lorem.paragraph)
      complaint.comment = Comment.first(:offset => rand(Comment.count))
      complaint.user = User.first(:offset => rand(User.count))
      complaint.save!
    }
end