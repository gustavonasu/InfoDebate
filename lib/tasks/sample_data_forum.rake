namespace :db do
  desc "Fill database with forum and thread sample data"
  task :populate_forums => :environment do
    require 'faker'
    if Forum.count == 0
      make_forums
    end
  end
end

def make_forums
  50.times do |n|
    forum = Forum.create!(:name => Faker::Lorem.sentence(1),
                          :description => Faker::Lorem.sentence)
    make_threads(forum)
  end
end

def make_threads(forum)
  5.times do |variable|
    forum.threads.create!(:name => Faker::Lorem.sentence(Random.rand(8..20)),
                          :description => Faker::Lorem.sentence,
                          :url => Faker::Internet.url,
                          :content_id => Random.rand(50000))
  end
end